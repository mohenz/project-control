# bloom Current State

## 기본 정보
- project_key: `bloom`
- last_updated: `2026-06-24`
- owner_request: bloom UI 개선, 로그아웃 버그 수정, 계정 이메일 변경, 데이터베이스 및 에이전트 연동의 Firebase 마이그레이션
- current_status: Supabase/PostgreSQL에서 Firebase(Firestore, Auth, Emulators) 환경으로 전면 마이그레이션 및 검증 완료

## 현재 목표
- Prompt Builder의 한글/영문 프롬프트 생성 흐름을 확장하고 사용성을 보강하며, 리뉴얼된 UI 검증을 완료한다.

## 진행 중 작업
- 없음. 금일 요청 사항 전체 완료.

## 최근 완료 작업
- 2026-06-24: Supabase 내 20개 전체 테이블(소설, 일기, 메모, 세션, 에이전트 기억 등 총 249개 데이터)의 Firebase Firestore 실서버 이관 성공 및 소유권 자동 매핑(Dynamic UID Mapping) 연동 완료.
- 2026-06-24: Supabase 및 PostgreSQL(persona-online) 아키텍처를 Cloud Firestore, Firebase Auth, 및 Firebase Local Emulator Suite 환경으로 완벽 마이그레이션 완료.
- 2026-06-09: `api/download.js` 신규 생성 — `/files` 디렉토리 내 zip 등 파일을 스트리밍 다운로드하는 API 엔드포인트. 경로 탐색 방지 및 허용 확장자 화이트리스트 보안 처리 포함.
- 2026-06-09: 대시보드 UI Code Helper 카드에 `확장 프로그램 다운로드` 버튼 추가 (`/api/download?name=ui_code_helper.zip` 연결).
- 2026-06-09: 전체 페이지(index, builder, history, story, login)에서 사용자 뱃지(`UserBadge` span) 제거 및 `common.js` badges 배열 바인딩 로직 삭제.
- 2026-06-09: 전체 페이지 배경색 `#f9f9fc` → `#e8e8ea` 변경 (눈부심 완화).
- 2026-06-09: 로그아웃 후 백색 화면 멈춤 버그 수정 — `handleLogout()`에서 `login.html?logout=1` 플래그 리다이렉트, `login.js`에서 `?logout=1` 감지 시 자동 리다이렉트 차단으로 무한 루프 방지.
- 2026-06-09: PowerShell `Set-Content` 인코딩 손상으로 깨진 `login.html` / `history.html` 한글 텍스트를 git 복원 후 재적용으로 수정.
- 2026-06-09: 운영 계정 이메일 `admin@example.com` → `mohenz@hotmail.com` 변경 (`app_users` 테이블 직접 UPDATE).
- 2026-06-09: 모든 UI 스크립트 버전 `story1` → `story2` 로 일괄 업데이트 (브라우저 캐시 무효화).
- 2026-06-08: 로컬 PostgreSQL 하이브리드 드라이버 연동 레이어 구현 및 `persona-online` DB 스키마/역할 초기화(`init-local-db.mjs`) 완료. `start-bloom.cmd`, `stop-bloom.cmd` 통합 스크립트 작성 완료.
- 2026-06-08: Story 모달 properties 사이드바 접기/펼치기 토글 기능 추가, 기본 너비 70/30 개선.
- 2026-06-08: Bloom Universe UI 전 페이지 Tailwind CSS Institutional Brutalist 테마 리뉴얼 완료.

## 다음 작업
- Prompt Builder의 한글/영문 프롬프트 생성 흐름 확장 및 사용성 보강.
- Vercel 환경 변수에서 `ALLOWED_ORIGINS` allowlist 확인.

## 실행 / 검증
- run_command: `firebase emulators:start` (로컬 에뮬레이터 구동), `npx vercel dev` (포트 3000)
- seed_command: `node scripts/seed-firebase.mjs` (개발 관리자 계정 시딩)
- verify_command: `node --check prompt-generator/ui/builder.js`, `node --check api/auth/login.js`, `node --check api/auth/me.js`, `node --check lib/firebase-store.js`
- port_or_runtime: `npx vercel dev` (포트 3000), Firebase Local Emulator Suite (Auth: 9099, Firestore: 8080, UI: 4000)
- deploy_method: `main` 브랜치 푸시 기반 Vercel 자동 배포 / 인증은 Vercel API + Cloud Firestore/Auth 사용

## 핵심 경로
- project_root: `D:\Workspace\bloom`
- key_docs:
  - `README.md`
  - `.env.example`
  - `docs/database_emulator_setup.md`
  - `project_docs/FIREBASE_MIGRATION_PLAN.md`
  - `project_docs/FIREBASE_MIGRATION_WALKTHROUGH.md`
- key_files:
  - `index.html`
  - `builder.html`
  - `firebase.json`
  - `firestore.rules`
  - `api/auth/login.js`
  - `api/auth/logout.js`
  - `api/auth/me.js`
  - `api/auth/reset-password.js`
  - `lib/firebase-store.js`
  - `lib/auth-session.js`
  - `lib/auth-store.js`

## 데이터베이스 접속 정보 (실서버 및 로컬)
- **접속 모드**: 프로덕션 실서버 (Google Cloud Firebase) 연결 완료
- **실서버 정보**:
  - 프로젝트 ID: `persona-online`
  - 인증 제공업체: 이메일/비밀번호 활성화 완료 (`mohenz@hotmail.com` 계정 생성 완료)
  - 컬렉션 (총 20개): `users`, `app_users`, `memories`, `persona_rules`, `story_groups`, `story_documents`, `story_references`, `prompt_histories`, `diaries`, `novels`, `chapters`, `scenes`, `memo_categories`, `memo_memos`, `memo_user_roles`, `api_telemetry_events`, `auth_sessions`, `app_secrets` 등
- **로컬 에뮬레이터 정보**:
  - host: `localhost`
  - ports: `Auth: 9099`, `Firestore: 8080`, `UI Dashboard: 4000`
  - database (Project ID): `bloom-universe` (환경 변수 활성화 시 자동 연동)

## 리스크 / 주의사항
- Firebase Local Emulator 구동을 위해 Java Development Kit (JDK) 11 이상이 시스템에 설치되어 있어야 합니다.
- PowerShell `Set-Content`로 한글 포함 파일을 저장하면 인코딩이 손상됩니다. 반드시 편집 도구를 사용하세요.

