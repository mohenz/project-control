# archive_store Current State

## 기본 정보
- project_key: `archive_store`
- last_updated: `2026-07-03`
- owner_request: `archive_store` 프로젝트를 다른 PC로 이관할 수 있도록 project-control 기준으로 정리
- current_status: React/Vite 기반 개인용 아카이브 저장소 로컬 MVP가 구현되어 있고, GitHub 원격 저장소 `mohenz/archive-store.git`의 `main` 브랜치에 푸시 완료됨. 새 PC 이관용 `docs\transfer_guide.md`를 추가했고, 민감 입력 파일은 Git 추적에서 제외함.

## 현재 목표
- 다른 PC에서 Git clone 후 로컬 PostgreSQL/API 기반 개발 환경을 재현할 수 있는 상태를 유지한다.

## 진행 중 작업
- Firebase Web App config 입력 대기
- Firebase Auth/Firestore/Storage 실연동 전 로컬 PostgreSQL/API 기준 검증 완료 상태 유지
- Stitch MCP hosted image/code URL 수집은 인증 문제로 대기
- Vercel 배포 설정은 미착수

## 최근 완료 작업
- `archive_store` 폴더 파일 확인 및 프로젝트 등록
- `project_control/project_registry.md`에 신규 프로젝트 항목 추가
- `project_control/states/archive_store_current.md` 상태 파일 생성 및 갱신
- React/Vite/Firebase-ready 앱 기본 구조 생성
- Firebase Hosting, Firestore Rules, Storage Rules 초안 생성
- 로컬 PostgreSQL 클러스터 구성: `127.0.0.1:54324/archive_store`
- 로컬 API 구성: `http://127.0.0.1:5175`
- Windows 실행/종료 스크립트 생성: `start.cmd`, `end.cmd`
- 업로드 smoke test 완료: `README.md` 업로드 및 DB row 확인
- UI 개선 반영: 좌우 레이아웃, 좌측 아카이브 현황/업로드, 우측 필터/검색/목록/페이지네이션
- UI 개선 반영: 업로드 영역 강조, 카테고리 버튼 동일 크기/아이콘 적용, 파일 목록 텍스트 배지 아이콘화
- 민감정보 정리: PIN은 `VITE_ARCHIVE_PIN` 환경변수로 이동, `.env.local` 및 `docs\required_user_inputs.md`는 Git 제외
- GitHub 원격 저장소 연결 및 푸시 완료: `https://github.com/mohenz/archive-store.git`
- PC 이관 가이드 추가: `docs\transfer_guide.md`

## Git / 원격 상태
- repository: `https://github.com/mohenz/archive-store.git`
- branch: `main`
- latest_commits:
  - `1ed1f86 Add PC transfer guide`
  - `9bb551e Initial archive store app`
- local_status: `main...origin/main`, 추적 대상 변경 없음
- ignored_local_only:
  - `.env.local`
  - `docs\required_user_inputs.md`
  - `local\postgres-data\`
  - `local\uploads\`
  - `local\*.log`
  - `dev-server.log`
  - `node_modules\`
  - `dist\`

## 다음 작업
- 새 PC에서 `git clone https://github.com/mohenz/archive-store.git`
- `.env.example`을 복사해 `.env.local` 생성
- `.env.local`에 `VITE_ARCHIVE_PIN`, `VITE_DATA_BACKEND=local-api`, `VITE_LOCAL_API_URL=http://127.0.0.1:5175` 설정
- `npm install` 후 `start.cmd` 실행
- PostgreSQL 설치 경로가 `C:\Program Files\PostgreSQL\18\bin`과 다르면 `scripts\start-local-db.ps1`, `scripts\stop-local-db.ps1` 수정
- 실제 업로드 파일/DB 데이터까지 이관해야 하면 `local\uploads\`와 PostgreSQL 데이터는 별도 백업/복원
- Firebase config 제공 시 Auth/Firestore/Storage 실연동 검증
- 로컬 API 파일 삭제/태그 수정/미리보기 고도화
- Vercel 배포 설정

## 실행 / 검증
- run_command: `start.cmd`
- stop_command: `end.cmd`
- verify_command: `npm.cmd run build`, `npm.cmd run check:syntax`, `curl.exe -s http://127.0.0.1:5175/api/health`
- port_or_runtime: app `http://127.0.0.1:5174/`, api `http://127.0.0.1:5175`, db `127.0.0.1:54324`
- deploy_method: Vercel + Git TBD

## 핵심 경로
- project_root: `D:\Workspace\archive_store`
- key_docs:
  - `README.md`
  - `.env.example`
  - `docs\transfer_guide.md`
  - `docs\firebase_setup.md`
  - `docs\requirements\개인용_아카이브_저장소_기능검토보고서.md`
  - `docs\requirements\프로젝트_아키텍처_및_개발계획서.md`
  - `docs\requirements\디자인_작업_명세서_Stitch.md`
- key_files:
  - `package.json`
  - `src\config\archivePolicy.js`
  - `src\core\fileValidation.js`
  - `src\App.jsx`
  - `src\views\ArchiveView.jsx`
  - `src\features\archive\archiveService.js`
  - `src\features\archive\localArchiveApi.js`
  - `src\firebase\client.js`
  - `server\local-api.js`
  - `local\schema.sql`
  - `scripts\start-local-db.ps1`
  - `scripts\stop-local-db.ps1`
  - `start.cmd`
  - `end.cmd`
  - `firestore.rules`
  - `storage.rules`
  - `integrations\stitch\stitch-manifest.json`
  - `integrations\stitch\scripts\download-stitch-assets.ps1`

## 리스크 / 주의사항
- `.env.local`과 `docs\required_user_inputs.md`는 Git에 포함하지 않는다.
- 기존 PC의 실제 업로드 파일과 DB 데이터는 GitHub로 이관되지 않는다.
- 로컬 PostgreSQL 스크립트는 PostgreSQL 18 Windows 기본 설치 경로를 전제로 한다.
- 클라이언트 PIN은 편의용 잠금이며 강한 인증이 아니므로 외부 공개 범위가 생기면 Firebase Auth 적용이 필요하다.
- Stitch MCP는 문서상 인증 완료로 기록되어 있으나 도구 호출은 `Auth required`로 차단되어 실제 이미지/코드 URL 다운로드가 아직 불가하다.
- Firebase Storage Outbound 트래픽 증가 시 예기치 않은 과금이 발생할 수 있으므로 예산 알림과 캐싱 정책이 필요하다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `archive_store/docs/transfer_guide.md`, `archive_store/README.md`, `archive_store/docs/firebase_setup.md`
- 새 PC 재현 최소 절차: clone -> `npm install` -> `.env.local` 생성 -> `start.cmd`
- 확인이 필요한 미결사항: Firebase Web App config 6개 값, Stitch hosted image/code URL, Vercel 배포 대상 설정

## Handoff
- current_goal: `archive_store`를 다른 PC에서 재현 가능한 GitHub/project-control 기준 상태로 정리
- done_latest: archive_store GitHub push 완료, 이관 가이드 추가 및 push 완료, project-control registry/state 최신화
- key_findings: GitHub에는 코드/문서/설정 예시만 포함되며 실제 PIN, 사용자 입력 문서, 업로드 파일, 로컬 DB 데이터는 제외됨.
- changed_files: `archive_store/README.md`, `archive_store/docs/transfer_guide.md`, `project_control/project_registry.md`, `project_control/states/archive_store_current.md`
- verification: `npm.cmd run build`, `npm.cmd run check:syntax`, `git status --short --branch`, GitHub push
- next_action: 새 PC에서 `docs\transfer_guide.md` 기준으로 clone 및 로컬 실행 검증
- risks_or_blockers: 실제 업로드 파일/DB 데이터 이관 필요 여부는 별도 결정 필요
