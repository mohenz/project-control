# defect_manage2 Current State

## 기본 정보
- project_key: `defect_manage2`
- last_updated: `2026-09-26`
- owner_request: `defect_manage` 운영본의 개선 및 추가 기능을 분석해 `defect_manage2`에 반영
- current_status: Local PostgreSQL 18 + Node API 운영 유지. Vercel/Supabase 배포 준비 및 내부 서버 포팅 가이드 작성 완료; defect_manage 저장소 Preview 브랜치 push 완료.

## 현재 목표
- 내부 서버 포팅·운영을 준비하고 Supabase/Vercel Preview 연결을 검증한다.
- 실제 내부 서버 설치는 OS·DNS/TLS·DB 위치·데이터 원본을 정한 뒤 진행한다.

## 진행 중 작업
- Supabase 자격 증명 교체 및 Vercel Preview용 `DATABASE_URL` 등록 후 배포 확인
- 내부 서버 대상 OS, 주소, PostgreSQL 위치와 데이터 이관 범위 확정

## 최근 완료 작업
- 2026-09-26: 내부 서버 포팅·운영 가이드 `docs/internal_server_porting_guide.md` 작성. Node.js 22/PostgreSQL 18, 네트워크 경계, 제한 DB 권한, 데이터 이관, 환경 변수/비밀 관리, Linux systemd·Windows 서비스, HTTPS 프록시, 백업·복구·인수 점검을 정리하고 README 인덱스에 연결.
- 2026-09-26: Supabase/GitHub/Vercel 구현 검증: syntax 통과, unit 22건, PostgreSQL 통합 3건, Vercel assets build 통과. 로컬 `/api/health` 정상, `auth_sessions`를 비파괴 적용.
- 2026-09-26: `mohenz/defect_manage`의 `codex/vercel-supabase-deploy` 브랜치 push 완료. 커밋 `bf340255a88eae0b7249756267491f8ae96b2184`; 운영 `main` 미변경, Vercel Preview 상태 미확인.

- 2026-06-24: 사용자메뉴얼에 화면 이미지 추가. Playwright로 로컬 앱 화면을 캡처해 `docs/images/user-manual/login.png`, `dashboard.png`, `defect-list.png`, `defect-register.png`, `user-manual.png` 생성. `docs/user_manual.md`에 섹션별 이미지를 삽입하고 섹션 번호 및 최종 수정일을 갱신. `js/app.js`의 간단 Markdown 렌더러가 이미지 문법 `![alt](path)`을 처리하도록 보강하고, `css/style.css`에 매뉴얼 이미지/캡션 스타일 추가. `.gitignore`에서 `docs/images/user-manual/*.png`는 추적 가능하도록 예외 추가. 검증 결과 `npm.cmd run check:syntax` 통과, Playwright 검증에서 매뉴얼 이미지 5개 로드 및 깨진 이미지 0건 확인.
- 2026-06-24: 좌측 메뉴 최하단에 `사용자메뉴얼` 메뉴 추가. `index.html`에 `data-view="user-manual"` 메뉴를 추가하고, `js/app.js` 라우터에 `user-manual` 화면을 연결. 기존 `docs/user_manual.md`를 fetch로 불러와 앱 내부 화면에 렌더링하는 `renderUserManual()`/간단 Markdown 렌더러를 추가. `css/style.css`에는 좌측 최하단 배치와 매뉴얼 화면 스타일을 추가. 검증 결과 `npm.cmd run check:syntax` 통과, `http://127.0.0.1:3000/docs/user_manual.md` 200, `http://127.0.0.1:3000/#user-manual` 200, Playwright 세션 주입 검증으로 메뉴 텍스트 `사용자메뉴얼` 및 화면 제목 `DefectFlow 사용자 매뉴얼 (User Manual)` 렌더 확인.
- 2026-06-24: `defect_manage2` 루트 정리 수행. 레거시/지원성 파일을 `support/`와 `local/` 하위로 이동해 루트에는 런타임/패키지/배포 진입점 중심으로 유지
- 2026-06-24: `database/`를 `support/database/`로, `eclub_memuList.txt`를 `support/screen-paths/eclub_memuList.txt`로 이동하고 관련 문서 및 `scripts/import-screen-path-codes.js` 참조 경로 수정
- 2026-06-24: 로그, 레거시 이미지, 테스트 산출물은 각각 `local/logs/`, `local/legacy-images/`, `local/test-artifacts/`로 이동하고 `.gitignore` 제외 규칙 추가
- 2026-06-24: 레거시 unit test fixture를 `support/legacy-data/`로 정리하고 `tests/unit/db.test.js` 참조 경로 수정
- 2026-06-24: 루트 정리 커밋 `585647e Organize root support files`를 `origin/main`에 push 완료
- 2026-06-24: `playwright.config.js`, `vitest.config.js`를 `config/` 하위로 이동하고 `package.json` 스크립트에 `--config config/...` 명시
- 2026-06-24: `scripts/check-syntax.js` 검사 대상을 `config/playwright.config.js`, `config/vitest.config.js`로 변경하고 관련 문서 링크 수정
- 2026-06-24: config 이동 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과. Playwright 설정 로딩은 `npx.cmd playwright test --config config/playwright.config.js --list`로 확인
- 2026-06-24: `project_control/docs/defect_manage2_local_postgres_cutover_plan_20260624.md`에 로컬 PostgreSQL 전환 작업계획 기록
- 2026-06-24: `defect_manage2` 로컬 PostgreSQL 스키마, start/stop 스크립트, Supabase REST 이관 스크립트 추가
- 2026-06-24: `server.js`를 JSON 파일 API에서 PostgreSQL 기반 `/api/*` 서버로 교체하고 `pg` 의존성 추가
- 2026-06-24: 프론트 `js/storage.js`를 Supabase SDK 직접 호출에서 로컬 API fetch 기반으로 전환, `index.html`에서 Supabase CDN 제거, `js/config.js`를 `API_BASE_URL: "/api"`로 변경
- 2026-06-24: Supabase 운영 데이터 이관 완료. 이관 결과 `users=43`, `common_codes=163`, `app_settings=1`, `defect_save_error_logs=21`, `defect_history=0`, `defects=328`
- 2026-06-24: `defects` 이관 범위는 테스트 구분별 최근 데이터 기준 최대 100건으로 적용. 결과: 최종테스트 19, 백오피스 5, 통합테스트 100, 선오픈 30, 3자테스트(W2) 100, 3자테스트(I&C) 73, 단위테스트 1
- 2026-06-24: 로컬 API `GET /api/health`, `GET /api/defects?page=1&pageSize=5`, `GET /api/common-codes` 응답 확인
- 2026-06-24: `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과 (`6`개 파일, `13`개 테스트)
- 2026-06-24: `project_control` 기준 `defect_manage`, `defect_manage2` 상태 확인
- 2026-06-24: 공통 파일 차이 및 기능 키워드(`action_due_date`, `조치 미완료`, `결함조치재확인`, `defect_id`, 페이징, 결함관리번호 복사)를 재점검해 `defect_manage2`에 구현 누락이 없음을 확인
- 2026-06-24: `defect_manage`의 2026-04-02 변경 이력(결함 목록 10페이지 단위 페이징, 담당자 15명 단위 페이징, 결함관리번호 표시/복사)이 `defect_manage2/docs/CHANGELOG.md`에 누락되어 있어 개선본 구조 기준 파일명으로 문서 보강
- 2026-06-24: `defect_manage2`에서 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과 (`6`개 파일, `13`개 테스트)
- 2026-05-21: `defect_manage`와 `defect_manage2`의 최근 운영 기능 키워드 및 코드 구조를 비교해 기능 차이 확인
- 2026-05-21: 대시보드 전체 페이지 조회, 조치 미완료 카드/필터, 조치완료율 표시, 결함조치재확인, 결함관리번호 복사 기능은 `defect_manage2`에 이미 반영되어 있음을 확인
- 2026-05-21: `defect_manage`의 2026-04-07 기능인 `조치예정일(action_due_date)`이 `defect_manage2`에 누락된 것을 확인하고 반영
- 2026-05-21: `js/storage.js`의 목록/export 조회 컬럼에 `action_due_date` 추가
- 2026-05-21: `js/modules/list-module.js` 결함 목록 표에 `조치예정일` 컬럼 추가
- 2026-05-21: `js/modules/form-module.js` 일반 결함 수정 폼과 조치 결과 입력 폼에 `조치 예정일` date 입력 추가, 모바일 퀵 등록에는 hidden 값을 추가해 신규 등록 흐름 유지
- 2026-05-21: `js/app.js` CSV 다운로드 헤더/행 및 `buildDefectPayload()`에 `action_due_date` 저장 반영
- 2026-05-21: `docs/db_schema.md`, `docs/program_design.md`, `docs/CHANGELOG.md`, `docs/action_due_date_column_ddl.md`에 조치예정일 문서 반영
- 2026-05-21: `defect_manage`의 GitHub Pages workflow action 버전(`checkout@v5`, `configure-pages@v5`, `upload-pages-artifact@v4`)을 `defect_manage2/.github/workflows/static.yml`에 반영
- 2026-05-21: `npm.cmd run check:syntax` 통과
- 2026-05-21: `npm.cmd run test:unit` 통과 (`6`개 파일, `13`개 테스트)
- 2026-05-21: Playwright E2E `tests/e2e/defect.spec.js tests/e2e/simple.spec.js` 실행 결과 `simple.spec.js` 1건은 통과, `defect.spec.js`의 로그인 화면 제목 기대값(`환영합니다`)에서 기존 화면이 `Loading...`에 머물러 실패하고 두 번째 시나리오는 장시간 대기되어 중단함
- 2026-04-30: `defect_manage` 운영본 최근 변경 분석 결과, 2026-04-09까지의 대시보드/목록 개선사항은 `defect_manage2`에 이미 반영되어 있고, 2026-04-30 대시보드 요약 전체 조회 수정만 미반영으로 확인
- 2026-04-30: 운영본 `js/storage.js`의 `getDefectsSummaryForStats()` 전체 페이지 조회 수정사항을 개선본 구조에 맞춰 `js/services/storage/defect-storage-service.js`에 반영
- 2026-04-30: 대시보드 요약 데이터가 1000건 단위로 끝까지 조회되는지 검증하는 단위 테스트를 `tests/unit/storage-defect-service.test.js`에 추가
- 2026-04-30: `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npx.cmd playwright test tests/e2e/defect.spec.js tests/e2e/simple.spec.js` 검증 통과
- 2026-04-09: `defect_manage`의 현재 대시보드 기준에 맞춰 `defect_manage2`에도 상단 `조치 미완료` 카드와 숫자 클릭 시 목록 조회 동선을 반영
- 2026-04-09: `진행 중` 카드를 실제 `In Progress` 기준 건수/비율로 정리하고, 결함목록 상태 필터에 `조치 미완료` 옵션 및 상태군 프리셋 조회 로직 추가
- 2026-04-09: `js/utils/storage-query-utils.js`, `tests/unit/storage-query-utils.test.js`에 `조치 미완료` 상태군(`Open`, `In Progress`, `Reopened`) 필터 적용과 단위 테스트 추가
- 2026-04-09: 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `defect_manage` 2026-04-09 수정사항 2건을 `defect_manage2`에 동기화
- `js/modules/dashboard-module.js`에 `결함 조치 현황 (테스트 구분별)` 표의 마지막 열 `조치완료율` 추가
- `js/modules/dashboard-module.js`에 `결함 조치 현황 (테스트 구분별)`, `심각도별 조치 현황` 표의 `조치완료율` 셀을 퍼센트만 표시하도록 정리
- 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npx.cmd playwright test tests/e2e/defect.spec.js tests/e2e/simple.spec.js` 재검증 통과
- `D:\Workspace\defect_manage`를 기준으로 `D:\Workspace\defect_manage2` lean 복사본 생성
- 복사 시 `.git`, `node_modules`, `test-results`, `playwright-report`, 서버 로그, `e2e_debug_final_*.txt` 제외
- `defect_manage2`에서 `npm.cmd install` 수행 완료
- `npm.cmd run check:syntax` 검증 통과
- `npm.cmd run test:unit` 검증 통과
- Git 저장소 초기화 완료 (`main`)
- 원격 저장소 `origin=https://github.com/mohenz/defect_manage2.git` 연결 완료
- 개선 계획서 `docs/executable_size_structure_improvement_plan.md`를 기준 문서로 확보
- 개선 완료 후 현재 `defect_manage` 운영 서비스를 `defect_manage2`로 교체하는 GitHub Pages / Vercel cutover 계획을 작업계획서에 반영
- 파악된 내용 전체를 `docs/project_bootstrap_record_2026-04-02.md`에 기록
- 패키징 기준 문서 `docs/runtime_artifact_packaging_rules.md` 추가
- `js/utils/app-utils.js`, `js/services/image-service.js`, `js/services/bridge-service.js` 추가
- `js/app.js`에서 util / image / bridge 공통 모듈 위임 적용
- `js/storage.js`에서 `applyDefectFilters()` 공통화, `getUsers()` 중복 제거, export 컬럼 상수 분리, insert 중복 spread 제거
- `scripts/check-syntax.js`가 `js/` 하위 재귀 스캔을 지원하도록 확장
- 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `js/modules/dashboard-module.js`, `js/modules/assignee-status-module.js` 추가
- `js/app.js`에서 `renderDashboard()`, `renderAssigneeStatusScreen()`, `renderAssigneeStatusPanel()`을 화면 모듈 위임 구조로 축소
- `index.html`에 화면 모듈 로딩 추가
- 변경 반영 후 `npm.cmd run check:syntax` 재검증 통과
- `js/modules/auth-module.js`, `js/modules/list-module.js`, `js/modules/admin-module.js`, `js/modules/form-module.js` 추가
- `js/app.js`에서 auth/list/admin/register/mobile/action 계열 렌더 함수를 모듈 위임 구조로 축소
- `js/storage.js`에 `history/commonCodes/defects/logs/usersApi/settingsApi` 도메인 별칭 추가
- `js/app.js`가 약 `1751` lines / `80.96KB` 수준으로 축소
- 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `js/utils/storage-query-utils.js` 추가로 결함 필터 및 screen path 정규화 로직 분리
- `js/storage.js`가 `users/settings` 도메인 접근점을 사용하도록 정리되고 `usersApi/settingsApi`는 호환 별칭으로 유지
- `js/app.js`, `js/modules/auth-module.js`가 `StorageService.users`, `StorageService.settings`를 사용하도록 치환
- `tests/unit/storage-query-utils.test.js` 추가로 unit test가 `3`개 파일 `6`개 테스트로 확대
- 현재 `js/app.js`는 약 `1860` lines / `68.54KB`
- 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `tests/e2e/defect.spec.js`의 홈 진입 기대값을 현재 로그인 기본 흐름에 맞게 수정
- 비파괴 E2E smoke로 `tests/e2e/simple.spec.js`, 홈 진입 로그인 화면 검증 1건 통과
- `js/services/storage/` 하위에 `common code`, `오류 로그`, `사용자`, `설정` 도메인 서비스 추가
- `js/storage.js`가 서비스 팩토리 결합 구조로 바뀌며 약 `451` lines / `17.28KB` 수준으로 축소
- `tests/unit/storage-error-log-service.test.js` 추가로 unit test가 `4`개 파일 `7`개 테스트로 확대
- 변경 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit`, 홈 진입 E2E smoke 재검증 통과
- `js/services/storage/history-storage-service.js`, `js/services/storage/defect-storage-service.js` 추가
- `js/storage.js`가 storage 조립 레이어 중심 구조로 바뀌며 약 `219` lines / `9.59KB` 수준으로 축소
- `tests/unit/storage-defect-service.test.js` 추가로 unit test가 `5`개 파일 `9`개 테스트로 확대
- `tests/e2e/defect.spec.js`가 홈 진입과 테스트벤치 standalone 로그인 복귀 흐름 2건 모두 통과
- `js/modules/admin-settings-module.js` 추가
- `js/modules/admin-module.js`가 관리자 설정/공통코드/저장 오류 로그/재확인 패널 위임 레이어로 유지되며 약 `146` lines / `9.55KB` 수준으로 정리
- `docs/local_test_execution_checklist.md` 추가로 로컬 수동 테스트 준비, 자동 검증, 수동 점검 순서, 종료 기준 문서화
- `server.js`가 `PORT` 환경변수를 지원하도록 바뀌어 수동 실행은 `3000`, Playwright 자동 검증은 `3001` 포트를 사용하도록 분리
- `playwright.config.js`가 `3001` 전용 포트와 `reuseExistingServer: false` 기준으로 정리되어 다른 프로젝트 로컬 서버 재사용 충돌을 방지
- `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npx.cmd playwright test tests/e2e/defect.spec.js tests/e2e/simple.spec.js` 재검증 통과
- 결함목록 화면 페이지 번호가 현재 구간 기준 `10페이지` 단위로만 보이도록 페이징 개선
- 담당자관리 화면이 `15명` 단위 페이징을 사용하도록 개선
- `js/utils/app-utils.js`에 공통 페이징 범위 계산 유틸 추가, `tests/unit/app-utils.test.js` 추가
- 일반 수정 폼에 결함관리번호 표시 영역 추가
- 기존 결함 수정 시에만 `#ID`를 강조색/굵은 글씨의 읽기 전용 입력창으로 노출하고, 신규 등록 및 모바일 퀵 등록에서는 숨김 처리한다. `(클릭하여 복사)` 텍스트 또는 입력창 클릭 시 ID 숫자를 클립보드에 복사하도록 개선
- 현재 자동 검증 결과는 unit test `6`개 파일 `11`개 테스트, 비파괴 E2E `3`개 시나리오 통과
- 현재 `js/app.js`는 약 `1610` lines / `69.09KB`

## 다음 작업
- Supabase 비밀번호/비밀 키 교체 후 Vercel Preview 환경에 Transaction pooler `DATABASE_URL`, `PG_POOL_MAX=1` 등록
- Vercel에서 `codex/vercel-supabase-deploy` Preview와 `/api/health`, 로그인, Test Bench, 모바일 등록 확인
- Production `main` 반영 전 PR 검토, DB 데이터 원본·마이그레이션·복구 계획과 환경 변수 확정
- 내부 서버 OS, DNS/TLS, DB·데이터 원본을 확정한 뒤 포팅 가이드로 스테이징 설치

## 실행 / 검증
- run_command: `npm.cmd start`
- verify_command: `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npm.cmd run test:integration`, `node scripts/build-vercel-assets.cjs`
- latest_verification: [2026-09-26] syntax 통과, unit 22/22, PostgreSQL integration 3/3, Vercel asset build 통과, `/api/health` 정상. E2E 종료 결과는 미확정.
- port_or_runtime: 로컬 API `127.0.0.1:3000`, PostgreSQL 18 `127.0.0.1:54323`
- deploy_method: GitHub `mohenz/defect_manage`의 `codex/vercel-supabase-deploy` Preview 브랜치 push 완료; Vercel Preview 상태 확인 전. Production main 미변경.

## 핵심 경로
- project_root: `D:\Workspace\defect_manage2`
- key_docs:
  - `README.md`
  - `docs/README_ko.md`
  - `docs/executable_size_structure_improvement_plan.md`
  - `docs/project_bootstrap_record_2026-04-02.md`
  - `docs/runtime_artifact_packaging_rules.md`
  - `docs/local_test_execution_checklist.md`
- key_files:
  - `js/app.js`
  - `js/modules/auth-module.js`
  - `js/modules/dashboard-module.js`
  - `js/modules/assignee-status-module.js`
  - `js/modules/list-module.js`
  - `js/modules/admin-module.js`
  - `js/modules/admin-settings-module.js`
  - `js/modules/form-module.js`
  - `js/storage.js`
  - `js/services/storage/common-code-storage-service.js`
  - `js/services/storage/history-storage-service.js`
  - `js/services/storage/defect-storage-service.js`
  - `js/services/storage/error-log-storage-service.js`
  - `js/services/storage/user-storage-service.js`
  - `js/services/storage/settings-storage-service.js`
  - `js/utils/storage-query-utils.js`
  - `tests/unit/storage-query-utils.test.js`
  - `tests/unit/storage-error-log-service.test.js`
  - `tests/unit/storage-defect-service.test.js`
  - `tests/unit/app-utils.test.js`
  - `tests/e2e/defect.spec.js`
  - `tests/e2e/simple.spec.js`
  - `config/playwright.config.js`
  - `config/vitest.config.js`
  - `server.js`
  - `index.html`
  - `support/database/`
  - `support/screen-paths/eclub_memuList.txt`
  - `support/legacy-data/`

## 리스크 / 주의사항
- Supabase 자격 증명이 평문 작업 문서에 있었음. 작업 사본에서는 제거했으며 교체 후 새 값을 Vercel에 등록해야 함.
- Preview `DATABASE_URL` 설정 전에는 DB API와 health 확인이 실패할 수 있음.
- defect_manage `main`은 미변경. Preview, 데이터 백업/복구 계획 확인 전 Production 반영 금지.
- 내부 서버 실설치/데이터 이관은 대상 OS·TLS·네트워크·원본 DB가 정해지지 않아 미실행.
- `scripts/start_local_db.ps1 -Reset`은 데이터 삭제 동작이므로 운영에서 실행 금지.

## 인수인계 메모
- current_goal: 내부 서버 포팅 준비 및 Supabase/Vercel Preview 연결 검증
- done_latest: 내부 서버 가이드 작성, defect_manage Preview 브랜치 push, 로컬 DB 세션 스키마 적용·검증
- key_findings: 개발 origin은 `defect_manage2`; 배포 저장소 `mohenz/defect_manage`에 `codex/vercel-supabase-deploy`가 있음. Production main은 유지.
- changed_files: `docs/internal_server_porting_guide.md`, `docs/supabase_github_deployment.md`, `local/schema.sql`, Supabase migration, `server.js`, 인증/API 테스트와 사용자 매뉴얼 관련 변경
- verification: syntax 통과, unit 22건, PostgreSQL 통합 3건, Vercel assets build 통과, 로컬 health 정상
- next_action: credentials rotation → Vercel Preview env 설정 → Preview 기능/로그 확인 → 내부 서버 대상 사양 확정
- risks_or_blockers: Vercel Preview 미확인, Supabase 자격 증명 교체 필요, 내부 서버 구성이 미정
- do_not_do: Preview/복구 검증 전 Production cutover 금지; 운영에서 로컬 DB Reset 금지

