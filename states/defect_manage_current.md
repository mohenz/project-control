# defect_manage Current State

## 기본 정보
- project_key: `defect_manage`
- last_updated: `2026-04-30`
- owner_request: 대시보드 테스트 구분별 전체 건수와 결함목록 검색 건수 불일치 원인 확인 및 수정
- current_status: 활성 운영 프로젝트

## 현재 목표
- 결함 관리 웹앱의 개선 작업을 빠르게 이어갈 수 있도록 현재 상태를 유지한다.

## 진행 중 작업
- 실행 파일 경량화 및 `js/app.js` 구조 분해를 위한 현황 분석과 단계별 작업계획 정리 완료
- 실제 구조 분해 구현은 아직 시작하지 않음

## 최근 완료 작업
- 2026-04-30: 대시보드 `결함 조치 현황 (테스트 구분별)`의 최종테스트 전체 건수가 결함목록보다 적게 보이는 원인을 확인하고 수정
- 2026-04-30: 원인은 `getDefectsSummaryForStats()`가 Supabase 기본 반환 제한에 걸릴 수 있는 단일 조회를 사용해 대시보드 집계 대상이 일부 행으로 잘릴 수 있었던 점으로 확인
- 2026-04-30: `js/storage.js`에서 대시보드 요약 데이터를 `defect_id` 기준 1000건 단위 `.range()` 페이지 조회로 끝까지 수집하도록 변경하고 타임아웃을 10초로 조정
- 2026-04-30: `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과
- 2026-04-30: 수정분을 커밋 `1b7b5e8` (`fix: load full dashboard summary data`)로 `origin/main`에 push하여 배포 트리거
- 2026-04-30: GitHub commit status 기준 커밋 `1b7b5e8`의 `Vercel` 배포 `success` 확인
- 2026-04-09: `조치 미완료` 카드 안내 문구 제거 수정분을 커밋 `16b553d` (`chore: remove dashboard helper text`)으로 `origin/main`에 push하여 배포
- 2026-04-09: GitHub commit status 기준 커밋 `16b553d`의 `Vercel` 배포 `success` 확인
- 2026-04-09: 대시보드 `조치 미완료` 카드 하단의 `숫자 클릭 시 목록 조회` 안내 문구를 제거하는 로컬 UI 조정 반영
- 2026-04-09: 위 UI 조정 후 `node --check js/app.js` 검증 통과
- 2026-04-09: `조치 미완료` 대시보드/목록 연동 수정분을 커밋 `db41656` (`feat: add not-completed dashboard filter`)으로 `origin/main`에 push하여 배포
- 2026-04-09: GitHub commit status 기준 커밋 `db41656`의 `Vercel` 배포 `success` 확인
- 2026-04-09: 로컬 로딩 화면이 오래 유지되던 원인이 `storage.js`, `app.js` 간 전역 상수명 충돌(`LIST_STATUS_PRESET_NOT_COMPLETED`)로 확인되어 `storage.js` 상수명을 분리해 초기화 실패를 수정
- 2026-04-09: 위 충돌 수정 후 `npm.cmd run check:syntax` 재검증 통과
- 2026-04-09: 대시보드 상단 통계 카드에 `조치 미완료` 패널과 비율 표시를 추가하고, 숫자 클릭 시 결함 목록의 `조치 미완료` 필터로 바로 조회되도록 연결
- 2026-04-09: 상단 `진행 중` 카드를 실제 `In Progress` 상태 기준 건수/비율로 정리하고, 결함 목록 상태 필터에 `조치 미완료` 옵션 추가
- 2026-04-09: 위 변경 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과
- 2026-04-09: 조치완료율 셀의 건수 표기 제거 변경을 커밋 `5f4ff33`으로 `origin/main`에 push하여 배포 트리거
- 2026-04-09: commit `5f4ff33` 기준 배포 상태 확인 시 `Vercel pending`
- 2026-04-09: 대시보드 `결함 조치 현황 (테스트 구분별)`, `심각도별 조치 현황` 표의 `조치완료율` 셀에서 완료건수 표기를 제거하고 퍼센트만 표시하도록 조정
- 2026-04-09: 위 조정 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- 2026-04-09: 테스트 구분별 조치완료율 표시 변경을 커밋 `0445498`로 `origin/main`에 push하여 배포 트리거
- 2026-04-09: GitHub commit status 기준 `Vercel` 배포 `success` 확인
- 2026-04-07: GitHub Pages workflow action 버전을 `checkout@v5`, `configure-pages@v5`, `upload-pages-artifact@v4`로 올리고 커밋 `ba70acf`로 `origin/main` 반영
- 2026-04-09: 대시보드 `결함 조치 현황 (테스트 구분별)` 표의 오른쪽 마지막 열에 `조치완료율` 추가
- 2026-04-09: 테스트 구분별 상태 집계에 완료 상태(`Resolved`, `Staging`, `Closed`) 기준 완료 건수/완료율 계산과 합계 행 표시 반영
- 2026-04-09: `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과
- 2026-04-07: GitHub Actions `Deploy static content to Pages #158`가 커밋 `109e576` 기준 `Success`로 완료되어 GitHub Pages 배포 성공 확인
- 2026-04-07: `action_due_date` 반영분을 커밋 `109e576` (`feat: 조치예정일 필드 추가`)으로 `origin/main`에 push하여 GitHub Pages 배포 트리거
- 2026-04-07: `defects.action_due_date`를 `js/app.js`, `js/storage.js`에 반영해 목록/상세/조치결과 입력/엑셀 다운로드에서 조치예정일을 조회·저장하도록 구현
- 2026-04-07: 조치예정일 반영 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과
- 2026-04-07: `docs/action_due_date_column_ddl.md`에 `defects.action_due_date` 컬럼 추가용 Supabase DDL 문서 정리
- 2026-04-07: 원격 저장소 `origin/main` fetch 확인 결과 로컬 `main`과 HEAD가 동일하여 추가 pull 없이 동기화 상태 확인 완료
- 2026-04-03: 결함 등록/수정 폼에 '결함관리번호' 표시 영역 및 클릭 복사 기능 추가 (75번 항목)
- 2026-04-02: 담당자 관리 화면 페이징 처리 추가 (15명 단위, 74번 항목)
- 2026-04-02: 결함 목록 페이징 처리 고도화 (10개 그룹 노출, 첫/마지막 이동 추가, 73번 항목) - **로컬 테스트 검증 완료**
- 실행 파일 경량화 및 구조 개선 작업계획서를 `docs/executable_size_structure_improvement_plan.md`로 저장
- 실행 산출물 기준 용량 분석 완료: 전체 작업 디렉터리 약 `57.99MB`, 개발/테스트 산출물 제외 lean 후보 약 `0.68MB`, 제외 가능 비중 약 `98.8%`
- 구조 분석 완료: `js/app.js` 약 `3783` lines / `208.85KB`, 메서드 `99`개, 화면 렌더 계열 메서드 `19`개로 책임 집중 확인
- 구조 분해 시 우선 분리 후보를 `app shell`, `auth/session`, `dashboard`, `list`, `register/action form`, `image/upload`, `standalone bridge` 축으로 정리
- 현황 분석 기준 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `결함 조치 현황` 하단의 `결함조치재확인` 현황 패널 보강을 커밋 `8eb6cdd`로 `origin/main` 배포
- 배포 직전 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- `결함 조치 현황` 화면 하단에 `결함조치재확인` 현황 패널 추가 및 화면 진입 시 재확인 목록 자동 새로고침 연결
- 이번 보강 후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- 관리자 화면 `결함조치재확인` 탭 및 `defect_id` 목록 연동 기능을 커밋 `f8d624b`로 `origin/main` 배포
- 배포 직전 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- 관리자 화면에 `결함조치재확인` 탭 추가 및 완료 상태(`Closed`, `Resolved`, `Staging`) 중 `defect_identification`, `action_comment` 미입력 건 조회 기능 반영
- 결함 관리 목록에 `defect_id` 정확 검색 추가 및 재확인 탭의 `defect_id` 클릭 시 목록 자동 조회 동선 연결
- 이번 변경 기준 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 재검증 통과
- 로컬 작업본과 GitHub `origin/main` 비교 후 원격 최신 커밋 `4d04027` 기준으로 fast-forward 동기화 완료
- 동기화 직후 `npm.cmd run check:syntax`, `npm.cmd run test:unit` 검증 통과
- Chrome extension 전용 거미 아이콘 세트를 생성하고 manifest에 연결
- 최신 위젯과 테스트 벤치의 캡처 엔진을 `html2canvas-pro 2.0.2`로 교체하고 기존 CORS 회피 보정 로직 유지
- 세션이 있는 상태에서 신규 결함 등록 실행 시 로그인 화면이 먼저 보이는 깜빡임 보정
- 모바일 등록 화면 문구를 `모바일 결함 등록`, `결함 발생 화면` 기준으로 정리
- 신규 결함 등록 시 `심각도=Minor`, `우선순위=Medium` 기본 선택값 보정
- `standalone/mobile` 신규 결함 등록 진입 시 로그인 검증 강화 및 세션 복구 보강
- `docs/defectflow_report_widget_latest.js` 캡처 품질 보정 로직 추가
- `docs/bug-reporter.js` 대안 버그 리포터 스크립트 추가
- 모바일 테스트용 연동 메뉴얼과 사용자 메뉴얼 작성
- 테스트 페이지 상품 목록 100건 확장
- 신규 결함 등록의 이미지 직접 업로드 기능 복구 및 이미지 최적화 처리 추가
- 외부 위젯/연동 스크립트의 화면 캡처 품질 개선
- `결함 조치 현황`의 완료율 신호등 표시 반영
- 조치 결과 저장 후 결함 목록 자동 이동 반영
- `결함 조치 현황`에서 미배정 결함 클릭 동선 추가
- 검색 패널의 `미배정만 조회` 체크박스 제거
- 카드 라벨을 `집계 대상 결함 수`로 변경
- 대시보드 진입 시 불필요한 `defects select(*)` 조회 제거
- 목록 조회에서 `screenshot` 제외 명시 컬럼 조회로 튜닝
- CHANGELOG 기록 및 GitHub Pages 배포 완료
- PC 결함 등록 화면의 `모바일 전용 화면 열기` 버튼을 새 탭 대신 크기 지정 팝업 창으로 열리도록 조정
- 신규 결함 등록 화면 하단에 Chrome 확장프로그램 `설치하기` 링크와 전용 설치 안내 화면 추가
- 대시보드 `심각도별 결함 현황` 표를 상태/조치완료율이 보이는 `심각도별 조치 현황`으로 확장
- 신규 결함 등록 하단 안내 문구 오타 수정 및 `설치하기` 클릭 시 설치안내 화면을 같은 모달 안에서 바로 열리도록 보강
- standalone 신규 결함 등록 초기 진입에서 대시보드 선렌더를 제거해 확장프로그램/외부 연동 시 화면 깜박임을 완화
- PC 신규 결함 등록 화면의 `모바일 전용 화면 열기` 버튼을 관리자에게만 노출하도록 조정
- 외부 사이트 연동 등록 실패 추적을 위해 중앙 DB 기반 결함 저장 오류 로그와 관리자용 로그 확인 탭 추가
- 대시보드 `결함 상태별 비중` 차트 범례 텍스트 색상을 더 진하게 조정해 가독성 개선
- 대시보드 `심각도별 비중` 차트 범례 텍스트 색상도 동일하게 더 진하게 조정

## 다음 작업
- 배포 후 운영 URL `https://mohenz.github.io/defect_manage/#dashboard`에서 최종테스트 전체 건수가 결함목록의 최종테스트 조회 총건수와 일치하는지 확인
- 브라우저에서 대시보드 상단 `조치 미완료` 카드 숫자 클릭 시 결함 목록이 `조치 미완료` 필터 상태로 정상 조회되는지 실동작 확인
- 다음 GitHub Pages workflow 실행 로그에서 `Node.js 20 actions deprecated` 경고 해소 여부 확인
- 브라우저에서 대시보드 `결함 조치 현황 (테스트 구분별)` 표의 `조치완료율` 열이 마지막 열에 정상 표시되는지 실동작 확인
- 브라우저에서 결함 목록, 결함 정보 관리, 조치 결과 입력, 엑셀 다운로드에 `조치예정일`이 정상 노출/저장되는지 실동작 확인
- 1단계: 배포/패키징 대상에서 `node_modules`, `test-results`, `playwright-report`, `test_view`, `docs`, 디버그 로그 제외 규칙 확정
- 2단계: `js/app.js`에서 공통 유틸과 이미지 처리, 인증/세션, 라우팅, 화면별 렌더러를 분리하는 최소 리팩토링 착수
- 3단계: `pending_defect` / `postMessage` 기반 외부 연동 흐름을 공용 브리지 모듈로 추출해 확장프로그램/위젯/테스트벤치 중복 축소
- 4단계: 구조 분해 후 최소 단위 테스트와 주요 E2E 시나리오를 보강해 회귀 방지
- `결함 조치 현황` 하단 패널의 실제 운영 데이터 노출 및 클릭 동선 확인 가능
- 배포본에서 관리자 로그인 후 `결함조치재확인` 탭의 실제 조회 결과를 한 번 더 확인 가능
- 관리자 화면 `결함조치재확인` 탭의 실제 운영 데이터 노출 여부를 브라우저에서 한 번 더 점검 가능
- Chrome extension reload 후 브라우저 툴바와 확장 목록에서 새 아이콘 표시 확인
- 운영 페이지에서 `html2canvas-pro` 적용 후 최신 CSS/외부 이미지 캡처 품질 회귀 확인
- 배포본에서 세션 유지 상태로 신규 등록 실행 시 로그인 화면 생략 여부 확인
- 배포본에서 모바일 등록 문구 변경과 신규 등록 기본 선택값 반영 여부 확인
- Chrome 확장 오버레이에서 비로그인 진입 → 로그인 → 등록 화면 자동 복귀 흐름 실기기 확인
- `bug-reporter.js` 적용 범위와 기존 최신 위젯 병행 전략 정리 필요
- `screenshot` 컬럼에 과거 base64 데이터가 남아 있는지 점검 가능
- 완료율 신호등 색상 기준에 대한 사용자 피드백 반영 가능
- 외부 사이트 이미지 미표시 시 CORS 제약 여부 확인 필요

## 실행 / 검증
- run_command: `npm.cmd start`
- verify_command: `npm.cmd run check:syntax`, `npm.cmd run test:unit`
- port_or_runtime: `localhost:3000`
- deploy_method: `git push origin main` 후 GitHub Pages Actions
- latest_deploy: `2026-04-30` / commit `1b7b5e8` pushed to `origin/main` (`Vercel success`)
- vercel_base_url: `https://defect-manage.vercel.app`
- vercel_test_page_url: `https://defect-manage.vercel.app/test_page`

## 핵심 경로
- project_root: `D:\Workspace\defect_manage`
- key_docs:
  - `README.md`
  - `docs/README_ko.md`
  - `docs/CHANGELOG.md`
- key_files:
  - `js/app.js`
  - `js/storage.js`
  - `index.html`

## 리스크 / 주의사항
- 저장소 안에는 네이티브 `.exe` 빌드 스크립트가 없어 실제 실행 파일 크기는 외부 패키징 방식에 따라 달라질 수 있음
- `js/app.js`, `js/storage.js`, 외부 위젯, Chrome 확장프로그램이 `pending_defect` / `postMessage` 흐름으로 강결합되어 있어 구조 분해 시 회귀 위험이 있음
- `js/storage.js`에 `getUsers()` 중복 정의가 있어 서비스 계층 정리 시 우선 점검 필요
- 로컬 `server.js` 실행은 세션 환경에 따라 백그라운드 유지가 불안정할 수 있음
- GitHub Pages 배포본과 로컬 Node 서버 동작은 별도로 확인 필요
- GitHub Pages workflow가 현재 Node.js 20 기반 action 경고를 출력하므로 추후 workflow action 버전 점검 필요
- 샌드박스 환경에서는 `npm.cmd run check:syntax`, `npm.cmd run test:unit`가 하위 프로세스 spawn 제한으로 실패할 수 있어 직접 `node --check` 확인이 필요할 수 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/CHANGELOG.md`, `js/app.js`, `js/storage.js`
- 확인이 필요한 미결사항: 대시보드와 목록의 실제 쿼리 시간 비교
