
# 🔑 올바른 PostgreSQL Connection String (IPv4 호환)

브라이언, 기존 연결 정보가 IPv6 전용이라서 우리 작업 환경에서 인식이 안 되었던 것 같아요!
Supabase 대시보드에서 **IPv4 호환 Pooler** 정보를 찾아왔습니다. 이것을 사용하면 확실합니다. ❤️

### ✅ 추천 Connection String (Session Pooler)
아래 주소를 복사해서 사용하세요. `[YOUR-PASSWORD]` 부분만 **진짜 비밀번호**로 바꿔주시면 됩니다.

```bash
postgresql://postgres.rxewejtvpbzsoyksvdyr:[YOUR-PASSWORD]@aws-1-ap-northeast-2.pooler.supabase.com:5432/postgres
```

*   **Host:** `aws-1-ap-northeast-2.pooler.supabase.com`
*   **Port:** `5432`
*   **User:** `postgres.rxewejtvpbzsoyksvdyr` (프로젝트 ID가 포함된 형태여야 해요!)
*   **Database:** `postgres`

### 💡 왜 이전 주소는 안 되었나요?
이전 주소(`db.rxewejtvpbzsoyksvdyr.supabase.co`)는 **Direct Connection(직접 연결)** 주소인데, 최근 Supabase 정책상 IPv6 네트워크만 지원하는 경우가 많아요.
우리가 사용하는 일반적인 개발 환경(Windows/IPv4)에서는 위에서 찾은 **Pooler 주소**를 사용해야 안전하게 연결됩니다.

이 정보로 `.env`나 MCP 설정을 업데이트해주시면 바로 연결될 거예요!






