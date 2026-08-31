# Windows 재설치 복구 키트

이 폴더는 현재 PC의 작업환경을 재설치 전 수집하고, Windows 재설치 후 다시 구성하기 위한 도구입니다.

Windows 재설치 후 Codex에 복구를 맡길 때는 `재설치_후_Codex_복구요청.md`의 프롬프트를 그대로 사용하십시오.

## 현재 확인된 핵심 환경

- Windows 11 계열 빌드 26200, 64비트 (일부 API는 제품명을 Windows 10 Pro로 잘못 표시할 수 있음)
- Git, GitHub CLI, GitHub Desktop
- Node.js 25, npm, pnpm 및 Codex/Claude/Gemini 등 전역 npm CLI
- Python 3.10.11, Python 3.12.10, Python Launcher, uv
- PostgreSQL 18 (`psql` 설치), 프로젝트별 로컬 DB 포트 54323~54325 사용
- VS Code 및 한국어 팩, Python, PowerShell, Playwright, Claude, Gemini, Codex 확장
- Android Studio/OpenJDK 17, DBeaver, Obsidian, Orca, Chrome/Whale
- Google Drive, OneDrive, Tailscale, Chrome Remote Desktop, Cloudflare WARP
- WSL 배포판과 Docker CLI는 현재 설치·활성화되어 있지 않음

## 전제: D 드라이브는 포맷하지 않음

- Windows 설치 화면에서 반드시 기존 Windows가 있는 C 파티션만 포맷하십시오.
- 용량과 볼륨 레이블을 확인하고 D 파티션을 삭제하거나 포맷하지 마십시오.
- `D:\Workspace`는 그대로 유지하므로 기본 수집 명령은 작업공간 전체를 중복 복사하지 않습니다.
- 파티션 선택 실수나 디스크 장애까지 대비하려면 외장 디스크에 한 번 더 복사해야 합니다. 이 경우 `-CopyWorkspace`를 사용합니다.

## 가장 중요한 보존 대상

1. `D:\Workspace`: D 드라이브에 그대로 보존합니다. 현재 루트 Git 저장소에 미추적 파일과 변경사항이 있으므로 D 파티션을 절대 포맷하면 안 됩니다.
2. PostgreSQL 데이터: 프로젝트 소스 폴더와 별도입니다. 사용하는 각 DB를 SQL 덤프로 내보내야 합니다.
3. `%USERPROFILE%\.ssh`, `.gitconfig`, 프로젝트 `.env*`: 비밀정보가 포함될 수 있어 자동 수집하지 않습니다. BitLocker가 적용된 외장 저장소에 별도로 복사하십시오.
4. 브라우저/Google Drive/OneDrive/Obsidian 동기화 상태와 GitHub, Vercel, Firebase, Supabase, npm, Claude, Gemini, Codex 로그인은 재인증이 필요합니다.
5. Android SDK/에뮬레이터, PostgreSQL 데이터 디렉터리, 개인 폰트 및 유료 앱 라이선스도 필요하면 별도 보존하십시오.

## 권장 실행 순서

관리자 PowerShell을 열고 D 드라이브에 수집합니다:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
cd D:\Workspace\project_control\scripts\windows-reinstall
.\reinstall-toolkit.ps1 -Mode Capture -BackupRoot D:\PC-Reinstall-Backup -WorkspaceSource D:\Workspace
```

DB도 수집하려면 PostgreSQL 서비스가 실행 중인지 확인한 후 다음을 추가합니다. 암호는 환경이나 프롬프트로 전달하고 스크립트에 적지 마십시오.

```powershell
.\reinstall-toolkit.ps1 -Mode Capture -BackupRoot D:\PC-Reinstall-Backup -WorkspaceSource D:\Workspace -IncludeDatabases
```

수집이 끝나면 `D:\PC-Reinstall-Backup\capture-report.txt`에서 `FAIL`이 없는지 확인하고 DB 덤프 파일이 실제로 생성되었는지 확인하십시오. 그 뒤 Windows를 재설치합니다.

외장 디스크에도 작업공간을 이중 백업하려면:

```powershell
.\reinstall-toolkit.ps1 -Mode Capture -BackupRoot E:\PC-Reinstall-Backup -WorkspaceSource D:\Workspace -CopyWorkspace -IncludeDatabases
```

새 Windows에서 먼저 Windows Update와 Lenovo Vantage를 실행해 펌웨어·드라이버를 설치한 다음:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
cd D:\PC-Reinstall-Backup\toolkit
.\reinstall-toolkit.ps1 -Mode Restore -BackupRoot D:\PC-Reinstall-Backup -WorkspaceDestination D:\Workspace
.\reinstall-toolkit.ps1 -Mode Verify -BackupRoot D:\PC-Reinstall-Backup -WorkspaceDestination D:\Workspace
```

`Restore`는 패키지 설치와 VS Code/npm 도구 복구를 수행합니다. 작업공간은 기존 대상 파일을 강제로 삭제하지 않고 복사합니다. 데이터베이스 SQL은 자동 주입하지 않습니다. 새 PostgreSQL 인스턴스와 프로젝트별 DB/역할을 확인한 뒤 수동 복원해야 데이터 손상 위험을 줄일 수 있습니다.

## 수동 재인증 체크리스트

- Microsoft/Windows 활성화 및 Microsoft 365
- Chrome/Whale, Google Drive, OneDrive, Obsidian Sync
- GitHub CLI: `gh auth login`; Git 자격 증명 관리자 확인
- npm, Vercel, Firebase, Supabase, Claude, Gemini, Codex/ChatGPT
- Tailscale, Cloudflare WARP, Chrome Remote Desktop
- SSH 키를 안전 저장소에서 `%USERPROFILE%\.ssh`로 복원하고 ACL 확인
- PostgreSQL DB 복원 후 각 프로젝트 `.env` 연결 문자열 확인
- Android Studio SDK/JDK/에뮬레이터 재구성

## 설계상 제한

- 암호, 토큰, 쿠키, 개인키, Windows 자격 증명은 수집하지 않습니다.
- Microsoft Store 전용 앱과 하드웨어/OEM 앱은 `winget export`가 완전히 복원하지 못할 수 있습니다.
- 앱 설정은 제품별 클라우드 동기화를 우선합니다. 설정 폴더 전체를 무차별 복사하면 새 버전과 충돌할 수 있습니다.
- `packages.curated.json`은 즉시 필요한 핵심 앱만 설치합니다. 캡처 시 생성되는 `winget-export.json`은 전체 참고 목록입니다.
