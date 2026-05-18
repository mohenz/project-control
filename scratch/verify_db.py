import urllib.request
import urllib.error
import json
import uuid

SUPABASE_URL = "https://rxewejtvpbzsoyksvdyr.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4ZXdlanR2cGJ6c295a3N2ZHlyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzQxNjYwNywiZXhwIjoyMDgyOTkyNjA3fQ.jHb-twMDucmbJjAIzJ-pJRSJ-CUv9uxD7yi0J18poaY"

def request_supabase(path, method="GET", body=None):
    url = f"{SUPABASE_URL}/rest/v1/{path}"
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    
    data = json.dumps(body).encode('utf-8') if body else None
    
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    
    try:
        with urllib.request.urlopen(req) as response:
            if response.status in (200, 201):
                return json.loads(response.read().decode('utf-8'))
            else:
                return {"status": response.status}
    except urllib.error.HTTPError as e:
        print(f"HTTPError: {e.code} for {path}")
        return None
    except Exception as e:
        print(f"Error: {e} for {path}")
        return None

def main():
    print("--- DB-001: 테이블 생성 여부 확인 ---")
    tables = ['memo_user_roles', 'memo_categories', 'memo_memos', 'memo_settings']
    all_exist = True
    for t in tables:
        # Request with limit=1 to check if table exists
        res = request_supabase(f"{t}?select=*&limit=1")
        if res is not None and isinstance(res, list):
            print(f"[{t}]: 존재함")
        else:
            print(f"[{t}]: 존재하지 않거나 접근 오류")
            all_exist = False
            
    print("\n--- DB-002: 관리자 사용자 ID 확인 ---")
    users = request_supabase("app_users?select=id,email&limit=5")
    admin_user_id = None
    if users:
        print(f"조회된 app_users 수: {len(users)}")
        for u in users:
            print(f"User ID: {u['id']}, Email: {u.get('email', '')}")
            admin_user_id = u['id'] # pick first as admin
    else:
        print("app_users를 조회할 수 없습니다.")
        
    if not admin_user_id:
        print("테스트를 위한 사용자 ID가 없습니다.")
        return
        
    print("\n--- DB-003: 관리자 role 등록 확인 ---")
    roles = request_supabase(f"memo_user_roles?user_id=eq.{admin_user_id}&select=*")
    if roles:
        print(f"Role 조회 결과: {roles[0]}")
    else:
        print("해당 사용자의 role이 등록되지 않았습니다.")
        
    print("\n--- DB-004: 기본 카테고리 확인 ---")
    categories = request_supabase(f"memo_categories?user_id=eq.{admin_user_id}&select=name")
    if categories:
        names = [c['name'] for c in categories]
        print(f"등록된 카테고리: {names}")
    else:
        print("카테고리가 없습니다.")
        
    print("\n--- DB-005: 테스트 메모 CRUD 확인 ---")
    # Insert
    test_title = f"Test Memo {uuid.uuid4().hex[:6]}"
    cat_id = None
    full_cats = request_supabase(f"memo_categories?user_id=eq.{admin_user_id}&select=id,name&limit=1")
    if full_cats:
        cat_id = full_cats[0]['id']
        
    memo_payload = {
        "user_id": admin_user_id,
        "title": test_title,
        "content": "CRUD 테스트입니다."
    }
    if cat_id:
        memo_payload["category_id"] = cat_id
        
    print("1) Insert 시도...")
    req_url = f"memo_memos"
    inserted = request_supabase(req_url, method="POST", body=memo_payload)
    # The POST to postgREST returns empty list if Prefer header is not set to return=representation.
    # Let's just select the memo by title.
    print("2) Select 시도...")
    title_encoded = urllib.parse.quote(test_title)
    fetch_memo = request_supabase(f"memo_memos?title=eq.{title_encoded}&select=*")
    
    memo_id = None
    if fetch_memo and len(fetch_memo) > 0:
        print(f"조회 성공: {fetch_memo[0]['title']}")
        memo_id = fetch_memo[0]['id']
    else:
        print("Insert 후 조회 실패")
        
    if memo_id:
        print("3) Update 시도...")
        update_payload = {"content": "CRUD 테스트 수정입니다."}
        request_supabase(f"memo_memos?id=eq.{memo_id}", method="PATCH", body=update_payload)
        
        fetch_memo_updated = request_supabase(f"memo_memos?id=eq.{memo_id}&select=*")
        if fetch_memo_updated and fetch_memo_updated[0]['content'] == "CRUD 테스트 수정입니다.":
            print("Update 반영 확인됨")
        else:
            print("Update 반영 실패")
            
        print("4) Delete (Soft Delete) 시도...")
        # Since it's soft delete, update deleted_at
        from datetime import datetime
        del_payload = {"deleted_at": datetime.utcnow().isoformat()}
        request_supabase(f"memo_memos?id=eq.{memo_id}", method="PATCH", body=del_payload)
        
        fetch_memo_deleted = request_supabase(f"memo_memos?id=eq.{memo_id}&select=deleted_at")
        if fetch_memo_deleted and fetch_memo_deleted[0]['deleted_at'] is not None:
            print("Soft Delete (deleted_at 설정) 성공")
        else:
            print("Soft Delete 실패")

if __name__ == '__main__':
    main()
