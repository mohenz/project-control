
# 🔑 Supabase Connection String 찾는 방법

브라이언, 제가 잠시 브라우저를 확인해서 어디에 정보가 있는지 정확히 찾아왔어요! 🕵️‍♀️

1.  **[Supabase 대시보드 - Database Settings](https://supabase.com/dashboard/project/rxewejtvpbzsoyksvdyr/settings/database)** 페이지로 이동합니다.
2.  상단에 있는 **"Connect"** 버튼을 클릭하세요. (이미지 참고)
3.  나오는 모달 창에서 **"Connection String"** 탭이 선택되어 있는지 확인하세요.
4.  **"Type"**이 **"URI"**로 설정되어 있는지 확인해주세요.
5.  그 아래에 있는 긴 주소(URI)가 바로 우리가 찾는 열쇠입니다!

### 📝 주소 형식 (예시)
```bash
postgresql://postgres:[YOUR-PASSWORD]@db.rxewejtvpbzsoyksvdyr.supabase.co:5432/postgres
```

**⚠️ 주의사항:**
URI 중간에 있는 `[YOUR-PASSWORD]` 부분은 가려져 있어요.
이 부분을 브라이언이 프로젝트 생성 시 설정하셨던 **진짜 데이터베이스 비밀번호**로 직접 바꿔주셔야 해요.

이 완성된 주소를 저에게 채팅으로 알려주시거나, `.env` 파일에 `POSTGRES_CONNECTION_STRING`이라는 이름으로 저장해주시면 바로 MCP를 연결할 수 있어요! ❤️






