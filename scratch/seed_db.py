import urllib.request
import urllib.error
import json

SUPABASE_URL = "https://rxewejtvpbzsoyksvdyr.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4ZXdlanR2cGJ6c295a3N2ZHlyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzQxNjYwNywiZXhwIjoyMDgyOTkyNjA3fQ.jHb-twMDucmbJjAIzJ-pJRSJ-CUv9uxD7yi0J18poaY"
USER_ID = "5514eed9-bc4c-4806-9aaa-e134a28143c1"

def request_supabase(path, method="POST", body=None, extra_headers=None):
    url = f"{SUPABASE_URL}/rest/v1/{path}"
    headers = {
        "apikey": SUPABASE_KEY,
        "Authorization": f"Bearer {SUPABASE_KEY}",
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    if extra_headers:
        headers.update(extra_headers)
        
    data = json.dumps(body).encode('utf-8') if body else None
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    
    try:
        with urllib.request.urlopen(req) as response:
            return response.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        print(f"HTTPError: {e.code} for {path}")
        print(e.read().decode())
        return None

def main():
    print("--- 1. 관리자 Role 부여 ---")
    role_payload = {
        "user_id": USER_ID,
        "role": "admin"
    }
    # upsert
    res = request_supabase("memo_user_roles", body=role_payload, extra_headers={"Prefer": "resolution=merge-duplicates"})
    print("Role 부여 완료")

    print("--- 2. 기본 카테고리 등록 ---")
    categories_payload = [
        {"user_id": USER_ID, "name": "취미", "description": "취미와 관심사 메모", "sort_order": 10, "is_system": True},
        {"user_id": USER_ID, "name": "테크", "description": "기술, 개발, 도구 관련 메모", "sort_order": 20, "is_system": True},
        {"user_id": USER_ID, "name": "재테크", "description": "투자, 경제, 자산 관리 메모", "sort_order": 30, "is_system": True},
        {"user_id": USER_ID, "name": "미분류", "description": "카테고리를 정하지 않은 메모", "sort_order": 999, "is_system": True}
    ]
    request_supabase("memo_categories", body=categories_payload, extra_headers={"Prefer": "resolution=merge-duplicates"})
    print("기본 카테고리 등록 완료")

if __name__ == '__main__':
    main()

