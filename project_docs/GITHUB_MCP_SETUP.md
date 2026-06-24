# GitHub MCP 서버 설정 가이드

GitHub를 MCP (Model Context Protocol) 서버로 추가하여 GitHub 리포지토리, 이슈, PR 등을 직접 조회하고 관리하는 방법을 안내합니다.

---

## 📋 개요

GitHub MCP 서버를 설정하면 다음과 같은 작업을 AI 어시스턴트를 통해 직접 수행할 수 있습니다:

- 📂 **리포지토리 조회**: 파일 내용, 구조 확인
- 🔍 **이슈 검색**: 이슈 목록, 상세 정보 조회
- 📝 **PR 관리**: Pull Request 조회 및 생성
- 🌿 **브랜치 관리**: 브랜치 목록 및 정보 확인
- 📊 **커밋 히스토리**: 커밋 로그 조회

---

## 🚀 설정 방법

### 1단계: GitHub MCP 서버 설치

PowerShell에서 다음 명령어를 실행하여 GitHub MCP 서버를 설치합니다:

```powershell
npm install -g @modelcontextprotocol/server-github
```

---

### 2단계: GitHub Personal Access Token 생성

1. **GitHub 웹사이트 접속**
   - https://github.com 로그인

2. **Settings 이동**
   - 우측 상단 프로필 클릭 → Settings

3. **Developer settings 선택**
   - 좌측 메뉴 하단의 "Developer settings" 클릭

4. **Personal access tokens 생성**
   - "Personal access tokens" → "Tokens (classic)" 선택
   - "Generate new token" → "Generate new token (classic)" 클릭

5. **토큰 권한 설정**
   
   다음 권한을 선택하세요:
   
   - ✅ `repo` - 전체 리포지토리 접근
     - `repo:status` - 커밋 상태 접근
     - `repo_deployment` - 배포 상태 접근
     - `public_repo` - 공개 리포지토리 접근
     - `repo:invite` - 리포지토리 초대 접근
   
   - ✅ `read:org` - 조직 정보 읽기
   
   - ✅ `read:user` - 사용자 정보 읽기
   
   - ✅ `user:email` - 이메일 주소 접근 (선택사항)

6. **토큰 생성 및 복사**
   - "Generate token" 클릭
   - 생성된 토큰을 **즉시 복사** (한 번만 표시됩니다!)
   - 안전한 곳에 보관

⚠️ **중요**: 토큰은 한 번만 표시되므로 반드시 복사하여 안전하게 보관하세요!

---

### 3단계: MCP 설정 파일 업데이트

MCP 설정 파일에 GitHub 서버를 추가합니다.

**설정 파일 위치**:
```
C:\Users\mohen\AppData\Roaming\Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json
```

**설정 내용**:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**설정 방법**:

1. 위 파일을 텍스트 에디터로 엽니다
2. `"ghp_your_token_here"` 부분을 2단계에서 생성한 실제 토큰으로 교체합니다
3. 파일을 저장합니다
4. VS Code를 재시작합니다

---

### 4단계: 설정 확인

VS Code를 재시작한 후 다음과 같이 테스트해보세요:

```
"내 GitHub 리포지토리 목록을 보여줘"
```

정상적으로 작동하면 리포지토리 목록이 표시됩니다.

---

## 💡 사용 예시

### 리포지토리 조회
```
"youtube-summarizer 리포지토리의 README.md 파일을 보여줘"
"최근 커밋 5개를 확인해줘"
```

### 이슈 관리
```
"열린 이슈 목록을 보여줘"
"'bug' 라벨이 있는 이슈를 찾아줘"
"새로운 이슈를 생성해줘: 제목은 'Playwright 테스트 추가'"
```

### PR 관리
```
"열린 Pull Request를 보여줘"
"main 브랜치로 PR을 생성해줘"
```

### 브랜치 관리
```
"모든 브랜치 목록을 보여줘"
"feature/new-test 브랜치의 최근 커밋을 확인해줘"
```

---

## 🔒 보안 권장사항

### 1. 토큰 보안
- ❌ **절대 공개하지 마세요**: GitHub 토큰을 코드나 공개 저장소에 포함하지 마세요
- ✅ **환경 변수 사용**: 가능하면 시스템 환경 변수로 관리하세요
- ✅ **최소 권한 원칙**: 필요한 권한만 부여하세요
- ✅ **정기적 갱신**: 토큰을 주기적으로 재생성하세요

### 2. 토큰 유출 시 대처
1. 즉시 GitHub Settings → Developer settings → Personal access tokens로 이동
2. 해당 토큰을 "Delete" 또는 "Revoke"
3. 새 토큰을 생성하여 교체

### 3. 환경 변수로 관리 (선택사항)

**Windows 환경 변수 설정**:

```powershell
# 시스템 환경 변수 설정
[System.Environment]::SetEnvironmentVariable('GITHUB_TOKEN', 'your_token_here', 'User')
```

**MCP 설정 파일에서 환경 변수 사용**:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

---

## 🛠️ 문제 해결

### 문제 1: "command not found" 오류
**원인**: npm 글로벌 패키지가 설치되지 않음  
**해결**: 
```powershell
npm install -g @modelcontextprotocol/server-github
```

### 문제 2: "Authentication failed" 오류
**원인**: 토큰이 잘못되었거나 만료됨  
**해결**: 
1. GitHub에서 새 토큰 생성
2. MCP 설정 파일의 토큰 업데이트
3. VS Code 재시작

### 문제 3: "Permission denied" 오류
**원인**: 토큰 권한이 부족함  
**해결**: 
1. GitHub에서 토큰 권한 확인
2. 필요한 권한 추가 (`repo`, `read:org`, `read:user`)
3. 토큰 재생성 및 업데이트

### 문제 4: MCP 서버가 시작되지 않음
**원인**: 설정 파일 형식 오류  
**해결**: 
1. JSON 형식 확인 (쉼표, 중괄호 등)
2. 토큰 값이 따옴표로 감싸져 있는지 확인
3. VS Code 재시작

---

## 📚 추가 리소스

- **GitHub MCP 서버 공식 문서**: https://github.com/modelcontextprotocol/servers
- **MCP 프로토콜 문서**: https://modelcontextprotocol.io
- **GitHub API 문서**: https://docs.github.com/en/rest

---

## ✅ 체크리스트

설정 완료 확인:

- [ ] GitHub MCP 서버 설치 완료
- [ ] GitHub Personal Access Token 생성
- [ ] 필요한 권한 부여 (repo, read:org, read:user)
- [ ] MCP 설정 파일 업데이트
- [ ] VS Code 재시작
- [ ] 테스트 명령어로 동작 확인
- [ ] 토큰을 안전하게 보관

---

**작성일**: 2026-01-01  
**버전**: 1.0






