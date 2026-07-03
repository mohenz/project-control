# archive_store Current State

## 기본 정보
- project_key: `archive_store`
- last_updated: `2026-07-03`
- owner_request: `archive_store` 폴더의 파일을 확인하고 새로운 프로젝트로 등록
- current_status: React/Vite 기반 개인용 아카이브 저장소 로컬 MVP 구현 중. Firebase 연결 전 로컬 PostgreSQL + 로컬 API 선검증 경로를 추가했고, 업로드 smoke test와 주요 UI 개선을 반영함.

## 현재 목표
- Firebase 기반 개인용 아카이브 저장소 MVP를 구현 가능한 상태로 만들고, 필요한 운영/인증/스토리지 정책을 확정한다.

## 진행 중 작업
- React/Vite 앱 스캐폴딩 완료
- Firebase Web App config 입력 대기
- 로컬 PostgreSQL/API 기반 기능 검증 가능 상태
- Stitch 디자인/퍼블리싱 산출물 납품 일정 및 기술 표준 승인 대기
- Stitch MCP 연동 구조 생성 완료, MCP 도구 인증 재확인 또는 hosted URL 수집 대기

## 최근 완료 작업
- `archive_store` 폴더 파일 확인
- 핵심 요구사항 문서 3개 확인
- `project_control/project_registry.md`에 신규 프로젝트 항목 추가
- `project_control/states/archive_store_current.md` 상태 파일 생성
- `archive_store/integrations/stitch/`에 Stitch MCP 산출물 보관 구조와 `curl.exe -L` 다운로드 스크립트 생성
- React/Vite/Firebase 앱 기본 구조 생성
- Firebase Hosting, Firestore Rules, Storage Rules 초안 생성
- `npm install`, `npm run build`, `npm run check:syntax` 완료
- 로컬 개발 서버 `http://127.0.0.1:5174/` HTTP 200 확인
- `required_user_inputs.md` 입력값 확인
- 단일 사용자 PIN `0814`, 외부 사용자 불가 정책 반영
- 단일 파일 200MB 제한, 사용자 총량 1GB, 실행파일 차단 정책 반영
- Firebase Hosting 미사용, Vercel + Git 배포 방향 문서 반영
- 프로젝트 전용 로컬 PostgreSQL 클러스터 생성: `127.0.0.1:54324/archive_store`
- 로컬 API 생성 및 실행: `http://127.0.0.1:5175`
- `archive_files` 테이블 생성 확인
- `README.md` 업로드 smoke test 성공, DB row count `1` 확인
- Windows 실행 스크립트 `start.cmd`, `end.cmd` 생성 및 검증 완료
- UI 개선 반영: 좌우 2영역 레이아웃, 좌측 아카이브 현황/업로드, 우측 필터/검색/목록/페이지네이션
- UI 개선 반영: 카테고리 버튼 동일 크기 및 아이콘 적용, 파일 목록 텍스트 배지를 아이콘으로 교체
- UI 개선 반영: 업로드 영역 크기 확대 및 색상 강조

## 다음 작업
- `.env.local`에 Firebase Web App config 입력
- 실제 Firebase Auth 로그인 흐름 구현
- Firestore/Storage Rules를 운영 정책에 맞춰 강화
- 로컬 API 기준 텍스트/이미지/문서 미리보기 고도화
- 로컬 API 파일 삭제/태그 수정 기능 추가
- Stitch MCP 인증 상태 재확인 후 Design System 화면의 hosted image/code URL 수집
- Stitch 산출물 코드 반영 범위 확정
- Vercel 배포 설정 및 Git 저장소 초기화/연동

## 실행 / 검증
- run_command: `start.cmd` 또는 개별 실행 `npm.cmd run db:start`, `npm.cmd run dev:api`, `npm.cmd run dev`
- verify_command: `npm.cmd run build`, `npm.cmd run check:syntax`, `curl.exe -s http://127.0.0.1:5175/api/health`
- port_or_runtime: app `http://127.0.0.1:5174/`, api `http://127.0.0.1:5175`, db `127.0.0.1:54324`
- deploy_method: Vercel + Git TBD

## 핵심 경로
- project_root: `D:\Workspace\archive_store`
- key_docs:
  - `docs\requirements\개인용_아카이브_저장소_기능검토보고서.md`
  - `docs\requirements\프로젝트_아키텍처_및_개발계획서.md`
  - `docs\requirements\디자인_작업_명세서_Stitch.md`
  - `docs\firebase_setup.md`
  - `docs\required_user_inputs.md`
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
  - `D:\Workspace\project_control\project_registry.md`
  - `D:\Workspace\project_control\states\archive_store_current.md`
  - `integrations\stitch\stitch-manifest.json`
  - `integrations\stitch\scripts\download-stitch-assets.ps1`

## 리스크 / 주의사항
- Firebase Storage Outbound 트래픽 증가 시 예기치 않은 과금이 발생할 수 있으므로 예산 알림과 캐싱 정책이 필요함
- 모바일 브라우저에서는 클립보드 파일 접근이 제한될 수 있으므로 파일 선택기 폴백 UI가 필요함
- Stitch 마크업 납품이 지연되면 프론트엔드 연동 일정이 순연될 수 있음
- 사용자 문서에는 Stitch MCP 인증 완료로 기록되어 있으나, 현재 MCP 도구 호출은 여전히 `Auth required`로 차단되어 실제 이미지/코드 URL 다운로드는 불가함
- 클라이언트 PIN은 편의용 잠금이며 강한 보안 인증이 아니므로 외부 공개 범위가 생기면 Firebase Auth 적용 필요
- 업로드 파일이 개인 민감 자산일 수 있으므로 인증, 경로 격리, HTTPS, XSS 방어가 필수임
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `archive_store/docs/requirements/프로젝트_아키텍처_및_개발계획서.md`, `archive_store/docs/requirements/개인용_아카이브_저장소_기능검토보고서.md`, `archive_store/docs/requirements/디자인_작업_명세서_Stitch.md`
- 확인이 필요한 미결사항: Firebase Web App config 6개 값, Stitch hosted image/code URL, Stitch 산출물 코드 반영 범위, Vercel 배포 대상 Git 저장소

## Handoff
- current_goal: Firebase 기반 `archive_store` MVP 구현 착수
- done_latest: React/Vite/Firebase-ready 스캐폴딩, 기본 UI 및 요청 UI 개선, 사용자 입력 정책 반영, 로컬 PostgreSQL/API 선검증 구조, Firebase 설정 문서, 보안 규칙 초안, Stitch MCP 로컬 연동 구조 생성
- key_findings: Firebase config가 없으면 샘플 데이터 UI만 동작하며 실제 업로드/목록 기능은 `.env.local` 설정 후 가능함. Stitch MCP는 문서상 인증 완료이나 도구 호출은 `Auth required`.
- changed_files: `archive_store/*`, `project_control/project_registry.md`, `project_control/states/archive_store_current.md`
- verification: `npm install`, `npm run build`, `npm run check:syntax`, `npm run db:start`, `start.cmd`, `end.cmd`, `curl.exe -s http://127.0.0.1:5175/api/health`, `POST /api/files` smoke test
- next_action: 로컬 API 기준 삭제/태그/미리보기 구현 후 사용자 제공 Firebase config 입력 시 Auth/Firestore/Storage 실연동 검증
- risks_or_blockers: Firebase 설정값과 운영 정책, Stitch MCP 인증이 필요함
