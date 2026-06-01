# defect_manage2 Current State

## 기본 정보
- project_key: `defect_manage2`
- last_updated: `2026-05-21`
- owner_request: `defect_manage` 운영본의 개선 및 추가 기능을 분석해 `defect_manage2`에 반영
- current_status: `defect_manage` 운영본과 기능 차이 재점검 후 누락된 `조치예정일(action_due_date)` 기능 및 GitHub Pages workflow action 버전 차이를 `defect_manage2`에 반영 완료

## 현재 목표
- `defect_manage` 원본은 유지하고 `defect_manage2`에서 실행 파일 경량화와 프론트엔드 구조 분해를 안전하게 진행한다.
- 개선 완료 후 기존 `defect_manage` 소스는 `defect_manage_old` 기준으로 보관하고, 현재 `defect_manage` 저장소 파일을 정리한 뒤 `defect_manage2` 소스를 업로드하는 방식으로 GitHub Pages / Vercel 운영 대상을 교체한다.
- 사전 배포 전략안으로는 GitHub Pages는 기존 `defect_manage`를 유지하고, Vercel은 `defect_manage2`를 테스트 운영 대상으로 연결해 검증 후 cutover 한다.

## 진행 중 작업
- `defect_manage` 운영본 최신 개선사항 분석 및 `defect_manage2` 반영 진행
- `defect_manage` / `defect_manage2` 기능 차이 비교 및 누락 기능 보정 완료
- 개선 범위와 초기 작업 기준 정리 완료
- 파악된 사실과 운영 결정사항 문서 기록 완료
- 1차 구조 개선 배치 완료
- 2차 화면 분리 배치 완료
- 3차 화면 분리 배치 완료
- 4차 storage/query 유틸 정리 배치 완료
- 5차 storage 도메인 서비스 분리 배치 완료
- 6차 defect/history 도메인 분리 배치 완료
- 7차 로컬 테스트 준비 배치 완료

## 최근 완료 작업
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
- 브라우저 수동 테스트에서 대시보드 `최종테스트` 전체 건수가 운영본과 동일하게 표시되는지 확인
- Playwright E2E 실패 원인 분리: 홈 진입 시 로그인 heading 대신 `Loading...`이 유지되는 원인이 테스트 기대값 문제인지 초기화/라우팅 문제인지 확인
- 브라우저에서 결함 목록, 일반 수정 폼, 조치 결과 입력, 엑셀 다운로드에 `조치예정일`이 정상 노출/저장되는지 수동 확인
- `docs/local_test_execution_checklist.md` 기준으로 실제 수동 로컬 테스트 수행
- 대시보드 상단 `조치 미완료` 카드 숫자 클릭 시 결함목록이 `조치 미완료` 필터 상태로 정상 조회되는지 수동 확인
- 대시보드의 `결함 조치 현황 (테스트 구분별)` 조치완료율 열과 `심각도별 조치 현황` 완료율 표기를 브라우저에서 수동 확인
- 결함목록 `10페이지` 단위 페이징과 담당자관리 `15명` 단위 페이징 수동 확인
- 일반 수정 폼의 결함관리번호 표시/클릭 복사와 신규 등록·모바일 퀵 등록의 숨김 동작 수동 확인
- 수동 테스트 중 발견 이슈 기록 및 정리
- 특이사항이 없으면 `git` 반영 준비
- Vercel 테스트 운영 방식을 별도 프로젝트로 둘지 기존 프로젝트 staged 배포로 둘지 확정
- 이후 GitHub Pages / Vercel 서비스 전환 체크리스트 작성 및 cutover 준비
- cutover 시 기존 `defect_manage`는 `defect_manage_old` 기준으로 보관하고, 운영 저장소에는 `defect_manage2` 소스를 업로드하는 전환 절차 반영
- 커밋은 개선 작업 완료 및 로컬 테스트 검증 완료 후 수행

## 실행 / 검증
- run_command: `npm.cmd start`
- verify_command: `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npx.cmd playwright test tests/e2e/defect.spec.js tests/e2e/simple.spec.js`
- port_or_runtime: `manual localhost:3000`, `automated e2e localhost:3001`
- deploy_method: `git push origin main` 기준, 실제 배포 방식은 별도 확정 예정

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
  - `playwright.config.js`
  - `server.js`
  - `index.html`

## 리스크 / 주의사항
- 이번 개선 프로젝트 범위에는 데이터베이스 테이블 구조 변경, 컬럼 추가/삭제, 마이그레이션 적용이 포함되지 않음
- DB 구조를 바꾸지 않는 전제이므로 개선은 프론트엔드 구조 분리, 패키징, 테스트 보강 중심으로 진행
- 원격 저장소는 연결 완료 상태이나 첫 커밋과 실제 배포 연결은 아직 수행 전
- GitHub Pages / Vercel 운영 교체 전에는 경로, 외부 연동 URL, rewrite 동작을 별도 점검해야 함
- 수동 테스트는 `3000` 포트를 사용하므로 기존 `defect_manage` 서버가 떠 있으면 먼저 종료해야 함
- cutover 방식은 기존 `defect_manage` 저장소명을 유지한 채 파일을 교체하는 방식이므로, `defect_manage_old` 보관본 확보와 업로드 순서 관리가 중요함
- Vercel 테스트 운영을 위해 저장소를 바꿀 경우, 자동 프로덕션 반영을 피하도록 별도 프로젝트 또는 staged deployment 여부를 먼저 정해야 함

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/executable_size_structure_improvement_plan.md`, `docs/project_bootstrap_record_2026-04-02.md`, `js/app.js`, `js/storage.js`
- 확인이 필요한 미결사항: 서비스 전환 시 URL 및 외부 연동 주소 점검, `defect_manage_old` 보관 및 운영 저장소 교체 순서 최종 점검
