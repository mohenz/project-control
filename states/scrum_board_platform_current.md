# scrum_board_platform Current State

## 기본 정보
- project_key: `scrum_board_platform`
- last_updated: `2026-04-10`
- owner_request: GitHub 저장소 연결과 GitHub Pages 배포 진행
- current_status: `main` push 완료, GitHub Pages 배포 성공, 서비스 응답 확인 완료

## 현재 목표
- 데일리 미팅 관리 앱을 `defect_manage`와 유사한 이메일+비밀번호 기반 내부 사용자 관리 구조로 정리한다.

## 진행 중 작업
- 기존 스크럼보드 구현은 참고용으로 유지
- 데일리 미팅 관리 앱 UI를 Supabase 연동 구조로 전환 완료
- 이름+이메일 기반 간편 가입, 날짜 목록, 작업자 리스트, 메모 등록/수정, 관리자용 작업자/세션 관리 MVP 구현 중
- Supabase 프로젝트 `pmo_menagement`에 테이블 생성 완료
- Supabase RLS 정책 초안 작성 완료
- 기능명세를 디자인 제외 기준으로 재정리 완료
- ElevenLabs 디자인 MD 기준으로 UI 톤 재정렬 진행 완료
- 사용자 요청에 맞춰 카드, 버튼, 배지, 입력, 아이콘 박스의 곡선형 반경을 제거하고 직선형 사각 구조로 재조정
- Supabase Auth + RLS 기반 보안은 플랫폼 확대 시점의 2단계 계획으로 분리 정리
- 익명 세션 기반 PoC를 제거하고 앱 내부 사용자 관리 구조로 전환 진행

## 최근 완료 작업
- 2026-04-10: `scripts/run-authenticated-lighthouse.mjs` 추가와 `package.json`/`package-lock.json` 갱신으로 환경변수 기반 자동 로그인 후 Lighthouse 측정 스크립트 구성
- 2026-04-10: `scripts/check-syntax.mjs`를 `.mjs`까지 검사하도록 확장하고, 새 측정 스크립트 `--help` 출력 및 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: 커밋 `3617f9b` (`fix: default signup accounts to non-admin`)를 `origin/main`에 push 완료
- 2026-04-10: GitHub Actions `Deploy to GitHub Pages` run `24220396918` 성공 확인
- 2026-04-10: 커밋 `fa0d6b3` (`feat: link daily meet with defect manage users`)를 `origin/main`에 push 완료
- 2026-04-10: GitHub Actions `Deploy to GitHub Pages` run `24219913547` 성공 확인
- 2026-04-10: `js/services/defect-manage-user-service.js`, `js/config/linked-apps-config.js` 추가로 `defect_manage.users`를 보조 인증원으로 조회하는 연동 서비스 구성
- 2026-04-10: `js/services/auth-service.js`, `js/services/daily-meeting-service.js`를 수정해 `defect_manage` 계정 로그인 성공 시 `worker_profiles`로 동기화하고, 링크된 이메일은 `daily meet` 자체 회원가입을 차단
- 2026-04-10: 위 `defect_manage` 연동 추가 후 `npm.cmd run check:syntax` 통과, `users?select=email,role,status&limit=1` 조회 HTTP 200 확인
- 2026-04-10: 커밋 `9febccf` (`feat: polish daily meet workspace ux`)를 `origin/main`에 push 완료
- 2026-04-10: GitHub Actions `Deploy to GitHub Pages` run `24219478538` 성공 확인
- 2026-04-10: Pages URL `https://mohenz.github.io/daily_meeting/`에서 HTTP 200, `<title>Daily Meet</title>` 응답 확인
- 2026-04-10: 신규 작업자 순위를 `현재 최대 sort_order + 1`로 자동 제안/저장하도록 `js/services/daily-meeting-service.js`, `js/services/auth-service.js`, `js/app.js`, `js/modals/worker-modal.js` 수정
- 2026-04-10: 위 작업자 순위 자동 증가 적용 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: `js/core/utils.js`의 `todayKey()`를 UTC `toISOString()` 절단에서 로컬 날짜 계산으로 수정해 KST 오전 시간대 전일 표기 버그 보정
- 2026-04-10: `js/state/app-state.js`, `js/views/sidebar-view.js`, `js/views/workspace-view.js`를 수정해 관리자 기준 날짜 목록에 오늘 날짜를 우선 노출하고 기준일/기본 미팅 생성 버튼도 로컬 날짜 기준으로 통일
- 2026-04-10: 위 날짜 기준 보정 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: `js/core/worker-emoji.js` 추가로 작업자별 이모지 옵션, 랜덤 기본 배정, 로컬 저장소 매핑 로직 분리
- 2026-04-10: `js/modals/worker-modal.js`, `js/views/workspace-view.js`, `js/app.js`, `js/services/auth-service.js`, `css/style.css`를 수정해 작업자 등록 시 이모지 선택과 카드 이모지 표시 연결
- 2026-04-10: 위 작업자 이모지 기능 추가 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: 세션 카드 전체를 클릭하거나 키보드 Enter/Space로 열 수 있는 읽기 전용 상세 모달(`js/modals/note-preview-modal.js`) 추가
- 2026-04-10: `js/views/workspace-view.js`, `js/app.js`, `css/style.css`를 수정해 세션 카드 클릭 데이터 연결, 모달 이벤트 바인딩, 미리보기 전용 스타일 적용
- 2026-04-10: 위 세션 상세 모달 추가 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: `작업자 관리` 섹션이 별도 칼럼이 아니라 선택 작업자 상세 카드 아래에 쌓이도록 `workspace-stack` 배치로 정정
- 2026-04-10: 위 배치 정정 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: 작업영역 전체 3열이 아니라 `worker-card-strip`이 한 줄에 3개씩 보이도록 작업자 카드 레이아웃을 정정
- 2026-04-10: 위 카드 3열 정정 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: 작업공간 본문 `workspace-grid wide`를 3열 레이아웃으로 조정하고, 상세 섹션 내부 세션 카드도 단일 열로 정리
- 2026-04-10: 위 레이아웃 조정 후 `npm.cmd run check:syntax` 검증 통과
- 2026-04-10: 작업공간 헤더에서 `Daily Meeting Memo` eyebrow와 작업자명 배지(`초기 관리자`)를 제거해 상단 텍스트를 축약
- 2026-04-10: 위 헤더 축약 후 `node --check js/views/workspace-view.js` 검증 통과
- 2026-04-10: 세션 패널에서 `세션` 헤더, 이메일, 로그인 시각, 새로고침 버튼을 제거하고 `로그아웃`을 상태 문구 옆 텍스트 버튼으로 축약
- 2026-04-10: 위 세션 패널 축약 후 `node --check js/views/auth-view.js` 검증 통과
- `index.html`, `css/style.css`를 데일리 미팅 메모 앱 기준 레이아웃으로 전면 교체
- `js/config/supabase-config.js`, `js/services/supabase-client.js`, `js/services/auth-service.js` 추가로 Supabase 브라우저 클라이언트 연결
- `js/services/daily-meeting-service.js`에 작업자/미팅/메모 조회와 등록/수정/삭제 로직 구현
- `js/state/app-state.js`에 날짜 그룹, 작업자 선택, Emergency 순번 selector 구현
- `js/views/`와 `js/modals/`를 새 앱 구조에 맞춰 재구성
- `js/app.js`에서 로그인, 세션 연결, 데이터 로드, 이벤트 처리, 모달 오케스트레이션 구현
- 로컬 서버에서 로그인 전 화면 렌더링 및 콘솔 오류 없음 확인
- `npm.cmd run check:syntax` 통과
- `docs/daily_meeting_memo_app_spec.md`에 데일리 미팅 메모 앱의 사용자, 화면, 권한, 데이터 규칙 정의
- `docs/daily_meeting_supabase_schema.sql`에 Supabase용 `worker_profiles`, `meeting_sessions`, `meeting_notes` 스키마 초안 작성
- `docs/daily_meeting_rls.sql`에 작업자/관리자 권한 분리 기준 RLS 정책 초안 작성
- 기본 미팅 2종 자동 생성을 위한 선택 함수 `create_default_daily_meetings()` 초안 추가
- `docs/README.md`에 신규 설계 문서 등록
- 이메일 OTP와 매직링크 UI를 제거하고 이름+이메일 기반 간편 가입 UI로 전환
- `js/services/auth-service.js`를 익명 세션 기반으로 재구성하고 `detectSessionInUrl` 제거
- `docs/daily_meeting_simple_signup_migration.sql`에 이메일 컬럼, 간편 가입 RPC, 인덱스 추가 마이그레이션 작성
- `docs/daily_meeting_supabase_schema.sql`, `docs/daily_meeting_rls.sql`를 간편 가입 구조 기준으로 갱신
- 관리자 작업자 모달에 이메일 필드를 추가하고 auth_user_id 직접 입력을 제거
- `docs/daily_meeting_memo_app_spec.md`를 기능명세 중심 문서로 전면 재작성하고 디자인 범위를 명시적으로 제외
- `docs/platform_security_roadmap.md`에 현재 단계 단순 사용자 관리와 향후 Supabase Auth + RLS 도입 계획 정리
- `docs/daily_meeting_memo_app_spec.md`, `README.md`에 보안 단계 계획과 전환 방향 반영
- `docs/daily_meeting_supabase_schema.sql`을 이메일+비밀번호 기반 사용자 관리 구조로 재작성
- `docs/daily_meeting_password_auth_migration.sql` 추가로 기존 DB 전환 SQL 작성
- `docs/daily_meeting_admin_seed.sql` 추가로 초기 관리자 등록 SQL 작성
- `docs/daily_meeting_rls.sql`을 현재 단계 비적용 참고 문서로 정리
- `js/services/auth-service.js`를 로컬 세션 + bcrypt 기반 로그인/회원가입 서비스로 교체
- `js/app.js`, `js/views/auth-view.js`, `js/views/workspace-view.js`, `js/views/sidebar-view.js`를 로그인/회원가입 흐름으로 갱신
- `js/modals/worker-modal.js`, `js/services/daily-meeting-service.js`를 초기 비밀번호/비밀번호 재설정 지원 구조로 수정
- `index.html`에 bcryptjs 로더 추가
- `.github/workflows/deploy-pages.yml` 추가로 GitHub Pages Actions 배포 구성
- `.gitignore` 추가
- Git 저장소 초기화, `origin` 연결, `main` push 완료
- GitHub Pages 워크플로를 공식 권장 2-job 구조로 정리 후 재push 완료
- `index.html`에서 브랜드 타이틀을 `Daily Meet`로 변경하고 설명/커맨드 박스 제거
- `css/style.css`에서 관리자 작업자 관리 패널에 가로 스크롤과 최소 너비 제약을 추가해 카드 밖으로 테이블이 밀리는 문제 보정
- `js/views/workspace-view.js`, `css/style.css`에서 작업자 리스트를 상단 전체폭 가로 카드 나열 구조로 전환
- `index.html`, `css/style.css`를 ElevenLabs 디자인 MD 기준으로 수정해 밝은 캔버스, 웜 스톤 액센트, 라이트 디스플레이 타이포, 다층 그림자 체계 적용
- `css/style.css`, `js/views/auth-view.js`, `js/views/workspace-view.js`를 수정해 rounded/pill 형태를 제거하고 직선형 사각 UI로 통일
- `npm.cmd run check:syntax` 통과, `http://localhost:4173` 렌더링 확인
- `관리` 화면 분기와 `PM/관리자 전용` 문구를 제거하고 팀 조직원 협업 보드로 전환
- `js/store.js`에 `updateWorkstream`, `updateDelayedWbs`, `updatePerson`, `updateProjectIssue` 추가
- `js/modals/board-modal-config.js`, `js/core/modal-manager.js`를 수정해 등록/수정 공용 모달과 값 프리필 지원
- `js/views/board-view.js`에서 주요 진행업무, 지연 WBS, 인력/개인업무, 프로젝트 이슈별 `수정` 액션 추가
- `js/core/sidebar.js`, `js/core/header.js`, `index.html`을 단일 보드 기준 문구와 구조로 정리
- 카드, 버튼, 배지, 입력, 아이콘 박스의 `border-radius`를 제거해 전체 UI를 직선형 구조로 통일
- 기존 과도한 스프린트/리소스/회의 로그 기능을 제거하고 4개 핵심 항목만 남기는 데이터 모델로 재구성
- `js/seed-data.js`, `js/store.js`를 `workstreams`, `delayedWbs`, `people`, `projectIssues` 중심 스키마로 재작성
- `js/views/board-view.js`를 4개 핵심 섹션 전용 보드로 교체
- `js/modals/board-modal-config.js`를 4개 핵심 입력 모달 전용으로 재작성
- `awesome-design-md/design-md/mintlify/DESIGN.md`를 참고해 Inter/Geist Mono, 그린 포인트, 16px 카드, pill 액션 중심의 Mintlify 스타일 적용
- `index.html`, `css/style.css`, `js/app.js`를 캐주얼 스크럼보드 MVP 구조에 맞게 전면 정리
- `server.js`, `package.json`, `scripts/check-syntax.mjs` 추가로 로컬 실행과 기본 문법 검증 체계 구성
- `npm.cmd run check:syntax` 통과
- 로컬 서버 `http://localhost:4173`에서 브라우저 기본 렌더링 및 콘솔 오류 없음 확인

## 다음 작업
- 로그인/회원가입 후 실제 CRUD 동작 검증
- 작업자 이모지 선택값을 DB 컬럼으로 승격할지 여부 결정
- 플랫폼 확장 단계용 Supabase Auth + RLS 상세 전환 설계 분리

## 실행 / 검증
- run_command: `npm.cmd start`
- verify_command: `npm.cmd run check:syntax`
- port_or_runtime: `localhost:4173`
- deploy_method: `GitHub Pages Actions`

## 외부 연동 정보
- supabase_project_name: `pmo_menagement`
- supabase_url: `https://gtbnmydtzexqrcgvwygg.supabase.co`
- schema_status: `daily_meeting_supabase_schema.sql 기준 테이블 생성 완료`
- migration_status: `daily_meeting_password_auth_migration.sql 적용 완료`
- repository_url: `https://github.com/mohenz/daily_meeting.git`
- latest_commit: `3617f9b`

## 핵심 경로
- project_root: `D:\Workspace\scrum_board_platform`
- key_docs:
  - `README.md`
  - `docs/README.md`
  - `docs/scrum_board_design.md`
  - `docs/daily_meeting_memo_app_spec.md`
  - `docs/daily_meeting_supabase_schema.sql`
  - `docs/daily_meeting_password_auth_migration.sql`
  - `docs/daily_meeting_admin_seed.sql`
  - `docs/daily_meeting_rls.sql`
  - `docs/platform_security_roadmap.md`
- key_files:
  - `index.html`
  - `css/style.css`
  - `js/app.js`
  - `js/config/supabase-config.js`
  - `js/services/`
  - `js/state/app-state.js`
  - `js/core/`
  - `js/views/`
  - `js/modals/`
  - `server.js`
  - `docs/daily_meeting_memo_app_spec.md`
  - `docs/daily_meeting_supabase_schema.sql`
  - `docs/daily_meeting_simple_signup_migration.sql`
  - `docs/daily_meeting_rls.sql`

## 리스크 / 주의사항
- 현재 단계는 publishable key + 앱 서비스 계층 권한 통제 구조라 보안 강도가 높지 않음
- 브라우저 클라이언트 기반이므로 현재 단계는 내부 운영용 신뢰 모델을 전제로 함
- 플랫폼 확장 이전에는 프로젝트 단위 데이터 격리 보안이 충분하지 않음
- 최초 관리자 1명은 `daily_meeting_admin_seed.sql` 또는 직접 SQL로 먼저 등록해야 함
- Auth + RLS는 향후 단계 계획이므로 현재 문서와 실제 적용 범위를 혼동하지 않도록 관리 필요
- 현재 Pages는 응답 중이지만, 정적 배포 특성상 브라우저 캐시 때문에 반영 확인 시 강력 새로고침이 필요할 수 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `docs/daily_meeting_memo_app_spec.md`, `docs/platform_security_roadmap.md`, `docs/daily_meeting_supabase_schema.sql`
- 참고 파일: `js/app.js`, `js/services/`, `js/state/app-state.js`
- 확인이 필요한 미결사항: 로그인 후 CRUD 실사용 검증, 작업자 이모지 영속화 방식(DB 승격 여부), 플랫폼 확장용 Auth + RLS 전환 범위






