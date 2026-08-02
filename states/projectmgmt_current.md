# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-02`
- owner_request: `로컬 실행 확인 및 D:\workspace\design\bloom_ui_design_standard.md 표준에 맞춘 UI 리뉴얼 — 문서 그대로 완전 준수`
- current_status: `로컬 정상 구동, Bloom UI 디자인 표준 전면 적용 완료(토큰/타이포/아이콘/Radix 기반/접근성 체크리스트) — 13개 주요 라우트 전수 확인, 콘솔·서버 에러 없음`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 최근 완료 작업
- ADC(Application Default Credentials) 로그인으로 로컬 Firebase Admin SDK 인증 문제 해결, `.env.local`에 `GOOGLE_CLOUD_PROJECT=projectmgmt-e7dfd`/`FIRESTORE_DATABASE_ID=projectmgmtdb` 추가.
- `D:\workspace\shadcn-ui`에 shadcn/ui 저장소를 클론해 Bloom 표준이 참조하는 `base-colors.ts`/`themes.ts`/`style-vega.css`의 실제 토큰 값을 확보.
- `app/globals.css`를 shadcn `neutral + blue` 실측 oklch 토큰, Bloom 타이포그래피 스케일(화면 제목 24/34/700 등), radius `0.625rem`으로 전면 교체.
- `lucide-react` 의존성 추가. `AppNavigation`, `ThemeSelector`, `CalendarModal` 닫기 버튼의 문자/이모지 아이콘을 Lucide 아이콘으로 교체.
- Playwright(headless Chromium)로 대시보드/설정(테마)/목록 화면 스크린샷 확인, 서버 에러 없음.
- `@radix-ui/react-dialog` 추가, `CalendarModal`을 수작업 `<div role="dialog">`에서 Radix `Dialog.Root/Portal/Overlay/Content/Title/Close`로 재구현(표준 3장 "기반: Radix UI" 반영). 포커스 트랩·Escape 닫기·오버레이 클릭 닫기를 Radix 기본 동작으로 대체, 실제 클릭 인터랙션으로 렌더링 확인 완료.
- 코드베이스 전수 검색 결과 Dialog 외 커스텀 구현된 복합 UI(Dropdown/Tooltip/Popover)는 없음 — 나머지 `<select>`는 네이티브 브라우저 위젯 사용으로 "직접 재구현" 대상 아님.
- `@radix-ui/react-alert-dialog` 추가, 항목 보관(destructive) 액션을 `window.confirm`에서 라벨링된 AlertDialog(취소/보관 처리 버튼, "확인" 같은 모호한 문구 미사용)로 교체(표준 10.3 반영).
- 전체 화면 14장 체크리스트 감사 완료: `WeekCreateForm`·공통코드 그룹 추가 폼의 placeholder-only 입력에 화면에 보이는 Label 추가(표준 10.2), 공통코드 목록에 시각적 컬럼 헤더 추가, 루트 레이아웃에 "본문 바로가기" 스킵 링크 추가(표준 11장), 날짜 표시는 이미 전부 `Intl.DateTimeFormat("ko-KR", …)` 사용 확인(통화 표시 항목 없음), 확인/계속 같은 모호한 버튼 문구 없음 확인.
- Playwright로 13개 주요 라우트(/, /items, /items/new, /portfolio, /calendar, /weekly-reports, /weekly-progress, /staff-changes, /weeks, /settings/common-codes, /settings/system, /project-settings, /activity-logs) 전수 방문 — 전부 200, 콘솔/페이지 에러 0건.

## 표준 준수 격차 (남은 것)
- 없음. 발견된 격차는 모두 이번 세션에서 조치했다. 향후 새 화면/컴포넌트 추가 시 이 표준을 계속 적용해야 한다.

## 버그 수정 — 다크 모드 텍스트 가독성 (사용자 리포트)
- 증상: `/items` 목록의 고위험(high-risk) 행 등에서 다크 모드 적용 시 텍스트가 배경과 거의 같은 색으로 보이지 않음.
- 원인: `globals.css`에서 destructive 계열 옅은 배경을 전부 `color-mix(in oklch, var(--destructive), white NN%)`로 계산했는데, 이 방식은 라이트/다크 테마와 무관하게 항상 흰색에 가깝게 수렴한다. 다크 테마의 기본 글자색(`--foreground`, 거의 흰색)과 결합되면서 흰 배경에 흰 글자가 되어 대비가 사라졌다(`tbody tr.high-risk-row`, `.danger-zone` 등 다수 셀렉터가 동일 패턴).
- 조치: `--destructive-bg` 테마별 토큰(light `#fbeaea` / dark `#3a2328`, 기존에 있던 `--success-bg`/`--warning-bg`/`--info-bg`와 동일 패턴)을 추가해 배경에 사용되던 모든 `white NN%` 믹스를 이 토큰으로 교체. 테두리·아웃라인처럼 배경이 아닌 곳은 `white NN%` 대신 `transparent NN%`로 믹스하도록 변경해 테마에 무관하게 항상 안전하도록 일반화.
- 검증: 다크 모드로 `/items`, `/`, `/calendar`, `/settings/common-codes`, 항목 상세(위험도 보관 영역) 스크린샷 재확인 — 전부 정상 대비로 렌더링됨.

## 실행 / 검증
- run_command: `npm.cmd run local` (포그라운드, 포트 `3020`)
- verify: `npm.cmd run lint`(tsc --noEmit), `npm.cmd run test`(vitest run)
- 사전 조건: `gcloud auth application-default login` 1회 필요(로컬 ADC), quota project는 `projectmgmt-e7dfd`로 설정됨.

## 참고 자산
- README.md, SYSTEM_DESIGN.md, docs/FIREBASE_FIRESTORE_ARCHITECTURE.md
- `project_control\design\bloom_ui_design_standard.md` (UI 디자인 표준, 필수)
- `D:\workspace\shadcn-ui` (표준 참조용 shadcn/ui 로컬 클론)
