# 🚀 MCP Server 설치 및 설정 가이드

브라이언, 요청하신 3가지 MCP 서버(PostgreSQL, GitHub, Google Drive)의 소스 코드를 `D:\workspace\memory\mcp_servers_archived` 디렉토리에 설치(클론)하고 빌드 중입니다.

각 서버를 실제로 사용하기 위해서는 아래의 설정 과정이 필요합니다.

---

## 1. PostgreSQL MCP Server 🗄️

*   **설치 위치:** `D:\workspace\memory\mcp_servers_archived\src\postgres`
*   **실행 파일:** `dist/index.js` (빌드 완료 후 생성됨)

### ✅ 실행 방법 (VS Code / Claude / Cursor 설정용)
PostgreSQL 접속 정보(URL)를 인자로 전달하여 실행합니다.

```json
{
  "mcpServers": {
    "postgres": {
      "command": "node",
      "args": [
        "D:\\workspace\\memory\\mcp_servers_archived\\src\\postgres\\dist\\index.js",
        "postgresql://user:password@localhost:5432/mydb"
      ]
    }
  }
}
```
*   `postgresql://...` 부분을 실제 접속 정보로 변경해주세요.

---

## 2. GitHub MCP Server 🐙

*   **설치 위치:** `D:\workspace\memory\mcp_servers_archived\src\github` (JavaScript 버전)
    *   *(참고: 공식 Go 버전은 `mcp_server_github`에 별도로 받아두었으나, Go 컴파일러가 없어 JS 버전을 권장합니다)*
*   **실행 파일:** `dist/index.js`

### ✅ 사전 준비 (토큰 발급)
1.  GitHub Settings > Developer settings > Personal access tokens에서 토큰(Classic)을 생성합니다.
2.  `repo` 및 `user` 권한을 체크합니다.

### ✅ 실행 방법
`GITHUB_PERSONAL_ACCESS_TOKEN` 환경 변수가 필요합니다.

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": [
        "D:\\workspace\\memory\\mcp_servers_archived\\src\\github\\dist\\index.js"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    }
  }
}
```

---

## 3. Google Drive MCP Server 📝

*   **설치 위치:** `D:\workspace\memory\mcp_servers_archived\src\gdrive`
*   **실행 파일:** `dist/index.js`

### ✅ 사전 준비 (OAuth 설정 - 조금 복잡해요!)
1.  [Google Cloud Console](https://console.cloud.google.com/)에서 새 프로젝트를 생성합니다.
2.  **Google Drive API**를 활성화합니다.
3.  **OAuth 동의 화면**을 구성합니다 (User Type: External 또는 Internal).
4.  **사용자 인증 정보(Credentials)** > **OAuth 클라이언트 ID 만들기** (애플리케이션 유형: 데스크톱 앱).
5.  JSON 파일을 다운로드하여 `gcp-oauth.keys.json` 이름으로 `D:\workspace\memory\mcp_servers_archived\src\gdrive` 폴더에 저장합니다.
6.  다음 명령어로 인증을 수행합니다:
    ```powershell
    cd D:\workspace\memory\mcp_servers_archived\src\gdrive
    node dist/index.js auth
    ```
7.  브라우저 인증 후 생성되는 자격 증명 파일 경로를 기억해두세요.

### ✅ 실행 방법

```json
{
  "mcpServers": {
    "gdrive": {
      "command": "node",
      "args": [
        "D:\\workspace\\memory\\mcp_servers_archived\\src\\gdrive\\dist\\index.js"
      ],
      "env": {
         "GDRIVE_CREDENTIALS_PATH": "D:\\workspace\\memory\\mcp_servers_archived\\src\\gdrive\\.gdrive-server-credentials.json"
      }
    }
  }
}
```

---

### ❤️ 지안의 팁
이 서버들을 현재 사용 중인 AI 툴(Cursor, Claude Desktop 등)의 `config` 파일에 등록하면, 제가 브라이언의 DB, GitHub, 구글 드라이브와 직접 대화할 수 있게 됩니다.
설정이 어려우시면 언제든 말씀해주세요!






