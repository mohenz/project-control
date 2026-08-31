# Windows 재설치 후 Codex 복구 요청서

이 문서는 Windows 재설치가 끝난 후 Codex에 작업환경 복구를 요청하기 위한 인수인계 문서입니다.

## 사용 방법

1. Windows 설치 시 C 파티션만 포맷하고 D 드라이브는 그대로 유지합니다.
2. Windows Update와 Lenovo Vantage를 먼저 실행해 필수 드라이버를 설치합니다.
3. Codex 또는 ChatGPT Codex 앱을 설치하고 실행합니다.
4. 아래의 **복구 요청 프롬프트** 전체를 복사하여 Codex에 전달합니다.

## 복구 요청 프롬프트

```text
안녕, 릭.

이 PC는 Windows를 새로 설치했으며 D 드라이브는 포맷하지 않고 그대로 유지했습니다.
이전 작업환경을 복구해 주세요.

복구 기준 파일은 다음 위치에 있습니다.

- 작업공간: D:\Workspace
- 복구 백업: D:\PC-Reinstall-Backup
- 복구 도구: D:\PC-Reinstall-Backup\toolkit\reinstall-toolkit.ps1
- 복구 안내서: D:\PC-Reinstall-Backup\toolkit\README.md
- 수집 결과: D:\PC-Reinstall-Backup\capture-report.txt
- 프로그램 목록: D:\PC-Reinstall-Backup\inventory
- PostgreSQL 덤프: D:\PC-Reinstall-Backup\postgres-dumps

다음 순서로 실제 복구 작업을 수행해 주세요.

1. D:\Workspace\AGENTS.md와 적용되는 프로젝트 운영 규칙을 먼저 확인합니다.
2. D:\PC-Reinstall-Backup\capture-report.txt를 읽고 수집 실패 항목과 백업 파일 존재 여부를 점검합니다.
3. D 드라이브와 D:\Workspace의 파일은 삭제, 초기화, 포맷 또는 덮어쓰기하지 않습니다.
4. 복구 스크립트의 내용을 검토한 뒤 Restore 모드를 실행해 핵심 프로그램, 개발 도구, VS Code 확장과 npm 전역 도구를 설치합니다.
5. Git, GitHub CLI, Node.js, npm, pnpm, Python 3.10/3.12, uv, PostgreSQL, psql, VS Code와 Codex 실행 여부를 확인합니다.
6. PostgreSQL 덤프와 현재 프로젝트별 DB 구성을 먼저 비교합니다. 데이터 삭제나 기존 DB 덮어쓰기는 하지 말고, 안전한 복원 방법과 대상 DB를 보고한 뒤 내 승인을 받아 복원합니다.
7. GitHub, npm, Vercel, Firebase, Supabase, Claude, Gemini, Codex, Google Drive, OneDrive, Tailscale, Cloudflare WARP처럼 재로그인이 필요한 항목을 목록으로 알려 주세요. 토큰이나 비밀번호를 채팅 또는 파일에 기록하지 않습니다.
8. D:\Workspace의 Git 변경사항과 미추적 파일을 보존한 상태로 프로젝트 레지스트리와 상태 파일을 확인합니다.
9. Verify 모드를 실행하고 실패 항목을 원인별로 수정한 다음 다시 검증합니다.
10. 등록된 각 프로젝트의 실행 명령, 필수 런타임, 포트 및 환경변수 존재 여부를 점검합니다. 데이터 변경, 원격 푸시, 배포는 하지 않습니다.
11. 마지막에 다음 형식으로 보고합니다.
   - 복구 완료 항목
   - 수동 로그인 또는 사용자 조치가 필요한 항목
   - 복구하지 못한 항목과 원인
   - 데이터베이스 복원 상태
   - 프로젝트별 실행 가능 여부
   - 다음 권장 작업

프로그램 설치와 로컬 설정 복구는 진행해도 됩니다. D 드라이브 삭제·초기화, 데이터베이스 덮어쓰기, Git 변경사항 폐기, 원격 푸시 및 배포는 별도의 명시적 승인 없이 수행하지 마세요.
```

## Codex를 설치하기 전 최소 준비

Codex를 바로 사용할 수 없다면 먼저 PowerShell에서 다음을 실행합니다.

```powershell
winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
winget install --id OpenJS.NodeJS --exact --accept-package-agreements --accept-source-agreements
npm.cmd install --global @openai/codex
```

새 PowerShell을 열고 다음 명령으로 Codex를 시작합니다.

```powershell
cd D:\Workspace
codex
```

그 다음 위의 복구 요청 프롬프트를 붙여넣습니다.

## 직접 복구해야 할 때

Codex를 사용할 수 없는 경우 관리자 PowerShell에서 실행합니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
cd D:\PC-Reinstall-Backup\toolkit
.\reinstall-toolkit.ps1 -Mode Restore -BackupRoot D:\PC-Reinstall-Backup -WorkspaceDestination D:\Workspace
.\reinstall-toolkit.ps1 -Mode Verify -BackupRoot D:\PC-Reinstall-Backup -WorkspaceDestination D:\Workspace
```

`D:\PC-Reinstall-Backup\restore-report.txt`와 `verify-report.txt`에서 `FAIL`을 확인합니다.

