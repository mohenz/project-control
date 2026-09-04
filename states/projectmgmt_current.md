# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-09-04`
- owner_request: `요구사항 관리 고도화·엑셀 데이터 이관·공지사항 게시판 구현 후 GitHub/Supabase/Vercel 원격 배포`
- current_status: `이슈관리를 기존 이슈/리스크 통합(Item, 확률×영향 매트릭스) 기능에서 전용 이슈관리(MASTER=Issue/DETAIL=IssueProgress 풀스냅샷 구조)로 전면 재구축, 캘린더에 회의실 예약 연동·"내 일정 보기" 필터 추가, 포트폴리오 공지 배너 제거, PMO Daily 공정현황/지연TASK/이슈관리 정의 재정립, WBS 목록 컬럼 숨김·날짜 range 필터, 초청 목록 UI 다단계 개선까지 13개 커밋 전부 배포 완료. GitHub main b3d71db, Vercel Production – pmotools 성공(`/api/health` 200).`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 현재 목표
- (완료) 요구사항 관리 고도화, 요구사항 171건 production 이관, 공지사항 게시판 구축·배포.
- (완료) 회의실/캘린더 초청 통합 발송·초청함 개편, 캘린더 날짜 계산 KST 보정.
- (완료) PMO Daily 공정현황 WBS 연동, WBS 목록 날짜 range 필터, WBS 실적일자 커스텀 컬럼.
- (완료) 사이드바 아이콘 커스텀화, 사용자 관리 화면 개선(아이디 변경 통합, 위험 작업 확인 모달, 반응형 전체폭), 요구사항관리 엑셀 다운로드/업로드.
- (완료) 포트폴리오 차트 전면 chart.js 표준화, 파스텔 색상 팔레트, 요구사항 엑셀 업로드 요구사항ID 동기화 방식 재설계, 위클리리포트 인쇄보기 모달형 팝업 전환.
- (완료, 09-04) 이슈관리를 리스크 매트릭스 통합형에서 전용 이슈관리(MASTER-DETAIL 풀스냅샷)로 전면 재구축, 캘린더 회의실 예약 연동·내 일정 필터, 포트폴리오 공지 배너 제거, PMO Daily 재정의, WBS 목록/필터 개선.
- 다음 우선순위는 이번 세션 신규기능(이슈관리 재구축 포함) 운영 UAT, 집중관리업무 기능개선 사용자 결정 대기, 기존 P0 보안 조치.

## 최근 완료 작업 (2026-09-04 세션)
- **이슈관리 전면 개편(이 세션의 핵심 작업, 다수 회 재설계)**: 기존 이슈+리스크 통합 `Item` 모델(확률×영향 매트릭스, 에스컬레이션 자동제안, Track 연동, `/items`)을 완전히 제거하고 전용 이슈관리로 교체. 사용자가 명시적으로 확정한 범위: 리스크 기능은 별도로 유지하지 않고 이슈관리로 일원화, 기존 `Item` 데이터는 필드 구조가 호환되지 않고 운영에서 사용 중이지 않아 마이그레이션 없이 테이블째 DROP(사용자 승인 완료 — 뒤에 리스크 항목 참조), "변경이력(이력)"은 유지하되 자동 감사로그가 아니라 **MASTER(Issue, 항상 최신 상태 캐시)/DETAIL(IssueProgress, 등록 당시와 동일한 전체 필드를 갖춘 스냅샷) 구조**로 구현 — 진행 정보(IssueProgress) 추가가 이슈 데이터를 바꾸는 유일한 방법이며, 매 추가/수정/삭제 후 `syncIssueFromLatestProgress()`가 최신 진행 정보를 마스터에 반영한다. 이 설계에 도달하기까지 자동 `IssueEvent` 감사로그 → 단일 `history: String` 필드 → 날짜/상태/내용만 있는 경량 MASTER-DETAIL, 세 차례 방향을 바꿨고 최종적으로 "등록 시와 동일한 전체 필드 스냅샷"으로 확정했다(사용자: "최초 등록 때와 같은 전체 필드를... 다 갖춘 스냅샷이어야 한다는 뜻이야").
  - 필드: 이슈번호(`ISU-0001` 시퀀스)/이슈관리번호/이슈구분(공통코드)/이슈명/이슈내용/중요도·우선순위(`ProbabilityLevel` 재사용)/상태(발생/진행/종결)/발생일자/해결기한/담당자(PersonPicker)/대응전략/에스컬레이션여부/보고라인(공통코드, 다중선택)/등록일자/비고 — 전부 `Issue`와 `IssueProgress` 양쪽에 동일하게 존재.
  - 서버: `lib/server/issues.ts` — `createIssue`(Issue+최초 IssueProgress 트랜잭션 생성), `addProgressEntry`/`updateProgressEntry`/`deleteProgressEntry`(전부 sync 호출), `archiveIssue`(상태가 `CLOSED`가 아니면 거부). **직접 마스터를 수정하는 `updateIssue()`는 의도적으로 없음.**
  - 화면: `screens/IssueListScreen.tsx`(엑셀 스타일 스프레드시트 테이블, 사용자 제공 엑셀 양식과 컬럼 순서 일치, 이력 컬럼 없음 — "이력은 목록이 아니라 개별 이슈 화면에만"이라는 사용자 지시), `features/issues/IssueFormActions.tsx`(재사용 가능한 `ProgressEntryForm`으로 신규 진행 추가/기존 진행 수정 두 모드 처리).
  - 마이그레이션 6개(`prisma migrate deploy`로 적용, 상세는 리스크 절 참조): items/item_events/item_sequences DROP, issues/issue_sequences/issue_report_lines 생성 + `issue_type`/`report_line` 공통코드 프로젝트별 시딩, 이후 IssueProgress MASTER-DETAIL 구조로 3차례 스키마 조정(중간에 `IssueEvent` 생성했다가 다시 DROP).
- **캘린더 회의실 예약 연동 + 내 일정 필터**: `lib/server/calendar.ts`가 `listMeetingReservations`를 가져와 `CalendarEvent.source`에 `"meeting"` 추가(그룹/우선순위 필터가 걸리면 회의실은 해당 개념이 없으므로 스킵). 캘린더 전 화면(월/주/일/목록)에 체크박스 `<CalendarMineToggle>`(신규, `mine=1` 쿼리 파라미터) 추가 — 체크 시 담당자 필터가 로그인 사용자로 좁혀짐. 범례에 "회의실 예약" 항목 추가.
- **포트폴리오 공지 배너 제거**: 사용자가 스크린샷을 보며 "그 영역이 필요하지 않을 것 같은데?" → "제거해줘"로 확정. `components/AnnouncementBanner.tsx` 삭제, `AuthenticatedAppShell.tsx`/`app/layout.tsx` 배너 렌더링 제거, `lib/server/announcements.ts`의 `listDashboardAnnouncements()`(사용처 없어짐) 삭제.
- **PMO Daily 재정의(사용자가 정확한 산식을 직접 지정)**: 계획TASK=오늘종료예정 TASK, 실적TASK=그 중 종료된 TASK 수, 지연TASK=그 중 미종료 TASK 수(기존엔 "오늘까지 누적"이었던 것을 "정확히 오늘"로 변경, `lib/server/wbs.ts` `getWbsDailyTaskCounts` `dueDate<=asOfDate`→`dueDate===asOfDate`). 지연TASK 목록에 계획시작일/계획종료일/실적시작일/실적종료일 4개 컬럼 추가. 이슈관리 위젯 컬럼을 이슈번호/이슈구분/발생일자/이슈명/이슈현황으로 교체.
- **WBS 목록 개선**: 사용자가 지정한 약 32개 관리용/역할매트릭스 컬럼을 화면에서만 숨김(엑셀 다운로드/업로드용 `WBS_EXCEL_HEADERS` 원본은 그대로 — `screens/WbsListScreen.tsx`의 `HIDDEN_HEADERS`). 날짜 필터를 단일값에서 계획시작일/계획종료일/실적시작일/실적종료일 4개 range(from/to)로 전환.
- **초청 목록 UI 다단계 개선(포트폴리오 `/portfolio`, 초청함 `/messages`)**: 사용자가 반복적으로 "UI 수정 요청" 티켓(페이지/URL/선택요소/DOM/변경요청 형식)을 보내며 세밀하게 조정 — 장소를 일정명 옆으로, 회의/일정 아이콘 표시, 초청 상세를 펼치기 없이 처음부터 노출, 여러 줄로 나뉘던 일정요약·장소·"일정 보기" 링크를 헤더 한 줄로 통합, 캘린더초청 본문에서 헤더와 중복되던 제목/기간 텍스트 제거. 최종 상태는 `screens/MessagesScreen.tsx`/`screens/PortfolioScreen.tsx`/`app/globals.css`(`.invitation-row*`, `.message-row-*` 다수) 참조.
- **업무일지 폼 폭 확대**: `/work-logs/new` 패널만 20% 확대(`work-log-form-panel` 신규 클래스, 전역 `.form-panel`은 그대로 유지).
- **로컬 개발 환경 복구**: 로컬 Postgres(55432)가 2026-09-03 13:40 이후 비정상 종료 상태로 방치되어 연결은 되지만 쿼리 중 끊기는 문제 발생 → `pg_ctl -D "D:/Workspace/projectmgmt/.local-postgres/data" -w restart`로 WAL 재생 복구 확인.
- **마이그레이션 방식 확정**: `prisma migrate dev`가 기존 `20260812121500_seed_default_meeting_rooms`(신규 shadow DB에 FK 위반) 때문에 이 프로젝트에서 항상 실패함을 재확인 — 이후 신규 마이그레이션은 전부 `prisma migrate deploy`(shadow DB 미사용, production `vercel-build`와 동일 방식)로 적용하기로 확정.
- **검증**: 매 스키마 변경마다 `tsc --noEmit`/`vitest run`/`next build` 재확인(빌드 검증 시 반드시 `next dev`를 먼저 종료 — 동시 실행 시 `.next` 청크가 깨져 `Cannot find module '../chunks/ssr/...'` 오류 발생하는 것을 이번 세션에 재확인). 배포 후 매번 Vercel CLI로 Ready 상태 확인 + `/api/health`, 로그인 후 핵심 라우트 200 확인.
- **배포**: 13개 커밋(`f22d87e`~`b3d71db`) 각각 개별 push, GitHub 연동 자동배포 또는 `vercel --prod --yes`로 즉시 배포. 최종 커밋 `b3d71db`.

## 최근 완료 작업 (2026-09-03 세션)
- **요구사항관리 엑셀관리 메뉴얼 작성·연결**: 기존 메뉴얼 시스템(`lib/domain/manuals.ts`, `public/manuals/*.html`, WBS·업무일지 메뉴얼과 동일한 디자인 톤)에 `requirements-excel` 슬러그로 신규 메뉴얼 추가. `lib/server/requirements-excel.ts`의 실제 검증 로직(요구사항ID 매칭 동기화, 20개 컬럼, 공통코드 일치 오류 등)을 그대로 반영해 작성. `components/AppNavigation.tsx`의 요구사항관리 좌측 메뉴(관리자·운영자 전용)에 "사용 메뉴얼" 링크 추가, 전체 메뉴얼 목록에도 등록(`a015a94`).
- **참고 — 이 세션 초입에 로컬 dev 서버 원인불명 캐시 문제 발생**: Turbopack·webpack 두 방식 모두, `.next` 완전 삭제 후 재시작해도 방금 수정한 소스 파일 내용을 전혀 반영하지 못하는 현상을 겪음(Node `fs.readFileSync`로는 디스크상 파일이 정확히 최신임을 확인했는데도 Next dev 프로세스만 못 읽는 상태). 원인은 못 찾았고, 이 워크스페이스가 Codex와 공유 중이라 다른 세션의 동시 파일 접근이 관련됐을 가능성도 배제 못 함 — 재현되면 `.next`뿐 아니라 dev 프로세스 자체를 완전히 새 PID로 띄웠는지, 다른 세션이 같은 파일을 동시에 건드리고 있지 않은지부터 확인할 것. 실제 배포(Vercel, 매번 클린 빌드)에는 영향 없었음 — 프로덕션에서 최종 검증 완료.
- **배포**: 커밋 `a015a94` 푸시 → `vercel --prod --yes`로 즉시 배포(1차 시도 "Not authorized" 오류로 자동 재시도 후 성공). 프로덕션에서 메뉴얼 목록(8번째 항목)·메뉴얼 상세 페이지·`/requirements/excel` 사이드바 "사용 메뉴얼" 링크 클릭까지 실제 브라우저로 확인 완료.
- **포트폴리오 초청 조회·WBS 현황 반복 개선(사용자 스크린샷 기반 다단계 요청)**:
  - 초청 조회 목록을 1줄(제목·장소·일시·보낸사람) + 최대 5건으로 압축, 패널 제목 옆에 초청 아이콘(`/messages`로 이동) 추가(`1e2f3ab`). 이후 목록의 `<time>`이 실제로는 "초청 메시지 생성 시각"이라 사용자가 요청한 "일자·시간·장소"와 맞지 않는 문제를 발견 → 캘린더 초청은 `calendarInvitation.startAt`/`location`, 회의실 초청은 `meetingInvitation.startAt`(방 이름이 곧 제목이라 장소는 생략)을 쓰도록 수정(`56e1a40`).
  - "나의 WBS 현황" 차트: 파이(전 세션) → 세로 막대(`1e2f3ab`) → 가로 막대(`f204c42`) → 완료/진행중/지연을 **한 막대에 이어붙인 누적 막대 1줄**로 재변경(`a357c13`, `indexAxis:"y"` + `stacked:true`). "WBS 진척"·"나의 WBS 현황" 패널을 2열 그리드에서 빼고 다른 패널과 동일한 전체 폭 1줄 배치로 변경(`1e2f3ab`, `.portfolio-domain-grid`를 1열로).
- **회의실 정기예약 신청 폼 전면 개편(사용자 요청 다단계)**: 요일 체크박스가 항상 보이던 것을 "매주" 선택 시에만 노출, 토·일 제거(월~금 5개만), 가로 한 줄 정렬 + 체크박스·텍스트 라인 정렬(`f204c42`~). "매월 일자"도 "매월" 선택 시에만 노출. 시작/종료 시간을 30분 단위 `<select>`로(직접 타이핑으로 30분 단위를 벗어나는 값이 들어가는 것 방지) → 최종적으로 "기간 시작/종료"(날짜)와 "시작/종료"(시간) 4개 필드를 캘린더 일정 등록과 동일한 "날짜+시(09~19시)+분(00/30)" 통합 피커로 재구성. 이 과정에서 캘린더 폼(`CalendarEventForm.tsx`)에 있던 `DateTimePicker`를 `components/DateTimePicker.tsx`(공용, `hours`/`minutes` prop으로 파라미터화)로 추출해 두 화면이 공유(`56e1a40`).
- **버그 수정 — `Cannot read properties of null (reading 'reset')`**: 정기예약 신청 제출 시 크래시 재현·수정. `async function submit(e){...; await api(...); e.currentTarget.reset(); ...}` 패턴에서 React가 `await` 이후 SyntheticEvent의 `currentTarget`을 null로 비우는 것이 원인 — `e.currentTarget`을 await 전에 지역변수로 캡처해 해결. 회의실 관리(`RoomManagementScreen.tsx`)의 "회의실 추가" 폼에도 동일 패턴이 있어 함께 수정(`303c6f5`). 로컬에서 실제 신청 성공까지 재현해 크래시 없음과 폼 리셋 확인, 테스트 데이터는 DB에서 직접 삭제.
- **집중관리업무 기능개선 방안 분석**: 사용자가 제시한 개선 요구사항(업무모듈·담당자별 집중관리업무 등록 → 세부항목별 액션아이템 등록 → 액션아이템 상태로 평가, 액션아이템 필드 12개, 상태 5종, 액션아이템목록조회는 PM/PMO 전용, 등록은 업무그룹리더/PMO/담당자)을 현재 `ManagementTask`(5개 고정 평가항목 + 수동 퍼센트 입력, `assertManager` 전용) 구조와 대조 분석. `docs/집중관리업무_기능개선_방안_20260903.md`로 정리(현재 구조 요약, 신규 데이터모델 제안(`ActionItem`/`ManagementTaskDetailItem`), band 산출 규칙 3안, 권한 모델 변경표, 미해결 확인사항 6개, A~E TASK 목록). **코드 구현은 하지 않음 — 확인사항 6개에 대한 사용자 결정이 선행되어야 착수 가능.**
- **배포**: 이번 절(위 4건) 커밋마다 개별 push + `vercel --prod --yes`로 즉시 배포, 매번 프로덕션에서 Claude in Chrome으로 실제 조작해 확인. 최종 커밋 `303c6f5`.

## 최근 완료 작업 (2026-09-02 세션)
- **포트폴리오 대시보드 차트 개편(다수 커밋, 사용자가 스크린샷 보며 반복 요청)**:
  - "WBS 진척"·"요구사항관리" 타일을 1줄 막대그래프로(`c398f21`) → "WBS 진척"을 Stage 12개 전체를 한 줄씩 보여주는 불릿 막대로 확장하고 "WBS 현황" 표 섹션 삭제(`74d0102`) → 세로형 막대로 전환(`0ff53f8`) → 두 타일 세로 높이 정렬(`0adfb63`).
  - "요구사항관리" 타일을 삭제하고 로그인 사용자 본인의 WBS 담당 현황(완료/진행중/지연)으로 교체(`43df3e0`) → 이후 사용자 요청으로 **파이 차트**로 재변경(`feb05c3`, `PieController` 신규 등록).
  - **버그 수정**: `usePointStyle:true` 범례에서 커스텀 `generateLabels`가 반환하는 개별 항목에 `pointStyle`을 채우지 않으면 전역 설정("rect")과 무관하게 Chart.js 기본값(원)으로 그려지는 것을 발견·수정, Stage 축 라벨을 굵게/60도 고정 회전으로 가독성 개선(`861a196`). 이래도 사용자가 "다크모드에서 글씨 안 보임"을 재차 보고 → CSS 변수 계산값을 아예 거치지 않고 다크모드에서 리터럴 `#ffffff`/밝은 회색을 직접 쓰도록 변경(`c4c9968`, `components/chart-theme.ts`의 `themeColor()`).
  - **"모든 차트는 chart.js로 그린다" 규칙 수립**: `docs/UI_CONVENTIONS.md`에 규칙·다크모드 리터럴 색·pointStyle 주의사항 기록. `DashboardScreen`(이슈 대시보드 유형별 분포)과 `RequirementStatisticsScreen`(기능구분 분포)이 쓰던 CSS `width:%` 막대를 신규 `components/DistributionBarChart.tsx`(chart.js 가로 막대, 행 클릭 시 필터링된 목록으로 이동하는 기능 보존)로 교체(`524fc96`). 공용 테마 헬퍼(`cssVar`/`themeColor`/`useThemedChart`)를 `components/chart-theme.ts`로 통합해 `PortfolioDomainCharts.tsx`·`WbsStageChart.tsx`가 공유. **예외**: 이슈 대시보드의 3×3 리스크 매트릭스 히트맵은 칸마다 `<Link>`로 개별 키보드/스크린리더 접근성이 있어 캔버스 전환 시 그게 사라짐을 사용자에게 설명 → **사용자가 현행 유지를 선택, 예외로 문서화**(`6970c2b`).
  - **파스텔 색상 팔레트**: 사용자가 Chart.js 공식 문서 예제 색을 언급 → "정확히 그 값이 아니라 톤을 파스텔로"라는 의도 확인 후, 차트 채우기 전용 신규 변수 `--chart-success`/`--chart-warning`/`--chart-destructive`(파스텔)를 추가하고 `--chart-planned`/`--chart-actual`도 파스텔로 교체. 배지·버튼이 쓰는 기존 진한 `--success`/`--warning`/`--destructive`는 그대로 둬서 다른 화면에 영향 없음. 텍스트/눈금 색은 파스텔 적용 대상에서 제외(다크모드 가독성 유지)(`55fc1b7`).
- **요구사항 엑셀 업로드 방식 재설계(사용자 요청으로 2회 반복)**:
  1. 1차: 사용자가 "기존 데이터를 삭제하고 새로 등록하는 방식(WBS와 동일)"을 명시적으로 요청 → ID 열 제거, 반영 시 프로젝트의 요구사항을 전부 삭제 후 파일 내용으로 재생성하도록 변경, 위험 확인 모달 추가(`f1982b1`). **부작용**: `RequirementEvent`/`RequirementChange`가 `Requirement`에 `onDelete: Cascade`라 매번 이력·변경관리 데이터가 통째로 사라짐.
  2. 사용자가 "이력을 꼭 삭제해야만 하냐"고 질문 → 원인 설명 후, **요구사항ID(수기 코드) 매칭 동기화 방식**으로 재구현: 파일의 요구사항ID가 기존과 일치하면 내부 UUID를 유지한 채 갱신(이력 보존), 파일에 없는 기존 요구사항ID는 삭제, 새 요구사항ID(또는 빈 값)는 신규 생성. 검증 리포트에 신규/수정 구분과 삭제 예정 건수를 표시, 확인 모달에 신규/수정/삭제 건수를 정확히 명시(`961f822`).
  - **검증**: 로컬 DB에서 실제 업로드 3종 시나리오(매칭→UUID 보존 확인, 신규 생성, 미매칭 삭제)를 전부 직접 쿼리로 확인. 이 과정에서 로컬 dev DB의 요구사항 데이터가 (원래 프로덕션과 동일하게 171건 있었던 것이) 테스트 결과로 **현재 2건만 남음** — 로컬 전용이라 운영 데이터에는 영향 없음.
- **위클리리포트 인쇄보기 개편(사용자 요청 3단계)**: "새 탭으로"(`8f6212b`) → "새 탭이 아니라 모달형 새 창으로"(요청 → `window.open`으로 화면 90% 크기, 가운데 정렬된 별도 팝업창, `aec8629`) → 팝업에 앱 상단메뉴/좌측 사이드바가 그대로 보이는 것을 지적받아 로그인 화면 공개 미리보기가 쓰던 기존 `embedded=1` 규약을 재사용해 제거(`53803f0`) → 팝업에서는 "리포트로 돌아가기"가 무의미하다는 지적으로 해당 버튼도 조건부 제거, 같은 탭에서 여는 "PDF 파일 생성" 플로우에는 유지(`420551e`).
- **검증**: 매 커밋마다 `tsc --noEmit` 통과. 모든 UI 변경은 로컬 브라우저(Claude in Chrome)로 실제 조작해 스크린샷/aria-label/DOM 속성으로 확인 후 배포. 요구사항 엑셀은 DB 직접 쿼리로 3종 시나리오 전부 검증.
- **배포**: 이번 세션 19개 커밋을 매번 개별 커밋 직후 `git push`(GitHub Actions/Vercel Git 연동 자동배포) 또는 `vercel --prod --yes`로 즉시 배포 — 세션 내내 로컬 main·GitHub origin/main·프로덕션이 매 커밋마다 동일 상태로 유지됨(다른 세션과의 충돌 없었음). 최종 커밋 `feb05c3`, 배포 `dpl_H1a3hEBRAEQMyg9hfVJHjnm4JKdN` Ready.

## 최근 완료 작업 (2026-09-01 세션)
- **사이드바 아이콘 교체**: `lucide-react` 아이콘을 `components/icons/PmoIcons.tsx`의 커스텀 SVG 세트로 교체(`AppNavigation`/`InvitationPopup`/`UserMenu`). 사이드바 메뉴의 영문 부제(Portfolio, Notice Board 등) 제거(`68d0623`, `e60a021`).
- **업무일지 폼 레이아웃**: `WorkLogFormScreen`의 "목록으로" 버튼을 상단에서 폼 하단 `.form-actions`로 이동, 등록 버튼과 크기 통일(`5126cb5`).
- **사용자 로그인 ID 변경 기능**: 관리자 이상 권한으로 `/settings/users`에서 사용자 로그인 ID(`User.userId`)를 변경하는 기능 추가(`4143236`) → 이후 사용자 요청으로 별도 버튼을 없애고 "정보 저장" 액션에 통합(`3a3446d`, `lib/server/admin.ts`의 `updateUserProfile`이 `userId`까지 함께 검증·저장, 중복 아이디 검사 유지).
- **위험 작업 확인 모달**: `UserManagementScreen`의 정보 저장/계정 잠금/비밀번호 초기화 버튼에 Radix `AlertDialog` 확인 모달 추가(계정 삭제는 기존에 이미 있었음)(`4bcfa68`).
- **사용자 관리 테이블 반응형**: 테이블이 컨테이너 100% 폭에 강제로 맞춰지며 이름/회사명 입력칸이 몇 글자로 눌리던 문제 수정(`width:auto`+개별 컬럼 최소폭 지정)(`dcc752d`). 이 화면만 `settings-content`의 1360px 폭 제한을 해제해 넓은 모니터에서 전체 폭 사용(`176822a`). 이메일 입력칸은 절반 폭으로 축소(`3a3446d`에 포함).
- **요구사항관리 엑셀 다운로드/업로드**: `/requirements/excel`(관리자 이상 전용) 신규. WBS처럼 검증(Dry-run)→반영 2단계 플로우를 쓰되, WBS의 전체교체 방식 대신 **ID 열 기준 행 단위 생성/수정**(캘린더 엑셀 패턴 재사용) — 요구사항은 버전·변경이력이 FK로 걸려 있어 전체 삭제 후 재생성이 부적합하다고 판단. 요구사항구분/분류는 공통코드 미매칭 시 오류, 담당자는 로그인ID 미매칭 시 경고(WBS와 동일하게 관대한 처리)(`d963415`, `lib/server/requirements-excel.ts`).
- **원격 프로덕션 DB 직접 변경(코드 배포 아님)**: 사용자 요청으로 6개 계정의 로그인 ID를 프로덕션 Supabase에서 직접 변경(유한동 hdy693→225362, 이수정 sujeong.lee→224740, 남현우 namppo→214218, 한새흰 hiin→q93w2h, 김재혁 re2volution→q93w3a, 이윤택 ytlee→q93w3h). `WbsItem`/`WorkLog`는 사용자 UUID로 연결되어 있어 데이터 연결에는 영향 없음을 사전 확인 후 진행, 변경 전/후 UUID 동일함 검증 완료.
- **로컬 dev DB 재확인(중요 발견)**: 이번 세션에서 실제로 떠 있던 `npm run dev`(port 3020)가 `.env.local`(프로덕션 Supabase)이 아니라 **`.env`의 `DATABASE_URL`(로컬 Postgres, 55432)**을 쓰고 있음을 직접 검증(요구사항 엑셀 업로드 테스트 행을 생성한 뒤 프로덕션 커넥션 문자열로는 조회되지 않고, 로컬 커넥션 문자열로만 조회됨). 즉 08-14 세션에서 남긴 "로컬 dev가 운영 DB에 직접 붙는다"는 리스크는 **이 PC의 현재 실행 상태에서는 해당하지 않음** — 로컬 우선 구성이 유지되고 있다. 다만 `vercel env pull`을 다시 실행하거나 `DATABASE_URL`을 지우면 다시 프로덕션으로 붙을 수 있으니 여전히 주의는 필요.
- **검증**: 매 커밋마다 `tsc --noEmit` 통과. 로컬 브라우저(Claude in Chrome)로 아이디 변경, 확인 모달 3종, 요구사항 엑셀 다운로드(200, 실데이터)/검증(정상 행·오류 행 모두 정확히 표시)/신규 등록/수정 전체 플로우를 실제 조작해 확인. 테스트로 만든 요구사항 1건은 로컬 DB에서 직접 삭제해 정리. 매 기능 완료 후 `vercel --prod --yes`로 개별 배포(총 9회, 최종 커밋 `d963415`).
- **GitHub 동기화**: 세션 종료 시점에 `git push origin main`이 `origin/main`에 다른 세션(같은 워크스페이스, 다른 Claude Code 세션)이 먼저 push한 2개 커밋(`c08f61f` WBS 목록 헤더 안내문구 제거, `00f55e7` WBS 목록 헤더 행 상단 고정 — `app/globals.css`, `screens/WbsListScreen.tsx`)과 충돌해 1차 거부됨. `git fetch`로 확인 후 `git merge origin/main`(자동 병합, 충돌 없음, `app/globals.css` 한 곳만 자동 병합됨) → `tsc --noEmit` 재통과 확인 → `git push` 성공(병합 커밋 `596d85b`). Vercel GitHub 연동이 이 push로 자동 배포를 트리거해 `dpl_C4rfModGCKxGae5vpUVNrivRKrHR`가 Ready, `/api/health` 200 확인 — 로컬 저장소·GitHub·프로덕션이 모두 동일 커밋으로 일치한다.

## 최근 완료 작업 (2026-08-31 세션)
- **PMO Daily 공정현황 WBS 자동 채움**: `/pmo-daily/new`에서 스냅샷이 아직 저장되지 않은 날짜는 계획/실적/전체/완료 TASK 건수를 WBS(오늘 기준)에서 가져와 기본값으로 채움. `lib/server/wbs.ts`에 `getWbsDailyTaskCounts(projectId, asOfDate)` 신규(계획=leaf의 dueDate<=기준일, 실적=그중 actualProgress 100%, 완료=전체 leaf 중 100%). `getPmoDailyDashboard`가 스냅샷 없을 때만 이 값을 기본값으로 사용, 저장된 스냅샷은 그대로 존중. 라벨 "계획 TASK 수"/"실적 TASK 수" → "계획 TASK"/"실적 TASK"로 변경(`3132b5e`).
- **WBS 주간 통계 동작 확인(변경 없음)**: 사용자가 계획(건)/완료(건)이 전체 기간으로 조회되는지 문의 → 실제 배포본 직접 테스트(브라우저)로 이미 조회 기간(시작일~종료일)에 정상 스코프됨을 확인. "완료(건)"이 "그 주간에 실제 완료된 것"이 아니라 "마감일이 그 기간이면서 현재 시점 실적 100%"라는 기존 설계(2026-08-30 결정, `lib/server/wbs.ts` 주석)를 재확인. 완료 시점(`completedAt`) 트래킹 마이그레이션을 제안했으나 **사용자가 중단 지시 — 미구현**.
- **WBS 목록 날짜 필터를 range로 변경**: `/wbs` 시작일/종료일 필터가 각 필드 정확일치였던 것을, Task의 startDate>=시작일 AND dueDate<=종료일(둘 다 구간 안에 포함)로 변경(`lib/server/wbs.ts` `listWbsItemsExcelColumns`)(`bdf1183`).
- **WBS 실적시작일/실적종료일 추가**: `WbsItem`에 `actualStartDate`/`actualDueDate` 컬럼 신규(마이그레이션 `20260831100000_wbs_actual_dates`) — 기존 `startDate`/`dueDate`(계획일자)는 유지, 엑셀 47개 컬럼 서식은 건드리지 않음(사용자ID와 동일한 "웹 화면 전용 커스텀 컬럼" 패턴, 사용자 확인 후 결정). 등록/수정/상세/목록 필터 화면에서 "시작일/종료일" 라벨을 "계획시작일/계획종료일"로 바꾸고 "실적시작일/실적종료일" 입력·표시 추가(`2b2dfb6`).
- **로컬 개발 환경 복구**: 로컬 Postgres(`.local-postgres`, 포트 55432)가 꺼져 있어 `db:local:start` 스크립트로 기동, 밀려있던 마이그레이션 8개(`prisma migrate deploy`)를 로컬 DB에 적용해 `/wbs` 500 에러(`table does not exist`) 해결.
- **검증**: 매 커밋마다 `tsc --noEmit` 통과, `vitest run`(pmo-daily/wbs 도메인 테스트 27건) 통과. 배포 후 프로덕션 `/api/health` 200, `/wbs`·`/pmo-daily/new` 307(로그인 리다이렉트, 크래시 아님) 확인.

## 최근 완료 작업 (2026-08-20 세션)
- **캘린더 날짜 KST 보정**: `app/calendar/page.tsx`·`lib/domain/calendar-layout.ts`의 "오늘" 계산이 서버 UTC 기준으로 어긋나던 문제를 한국시간 기준으로 수정(`5943ffd`). 이어서 주요 이벤트(마일스톤) 날짜와 D-Day 계산도 동일하게 KST 기준으로 보정(`lib/server/calendar.ts`, `0c3fa2b`).
- **검증**: `lib/domain/calendar-layout.test.ts`에 경계 케이스 추가, Vitest 12개 테스트 파일 65건 전체 통과.
- **원격 동기화**: GitHub `mohenz/pmotools` main이 origin과 완전히 동기화된 상태(`git status` clean, up to date).

## 최근 완료 작업 (2026-08-21 세션)
- **비로그인 공개 조회**: 로그인 화면에 `캘린더 조회`, `회의실 예약현황 조회` 링크 추가. `/calendar`, `/meetrooms`와 회의실 예약현황 GET API만 공개함.
- **읽기 전용 경계**: 비로그인 상태에서 캘린더 등록·검색·주요 이벤트와 회의실 예약·수정·취소·내 예약·정기예약 기능을 비노출하고, 쓰기 API 인증 차단을 유지함.
- **테스트 구성**: Jest/Playwright 실행 환경과 공개 접근 정책 단위 테스트 및 Chromium E2E 시나리오 추가.
- **검증**: TypeScript, Vitest 65건, Jest 7건, Playwright 4건, Next.js production build 통과. 의존성 설치 시 고위험 취약점 4건 보고됨(자동 수정 미실행).
- **공개 조회 모달 전환**: 로그인 화면의 두 공개 조회 버튼이 별도 `PublicReadOnlyModal`에서 동일 출처 iframe으로 캘린더·회의실 예약현황을 표시하도록 변경. 모달 내부 중복 로그인 버튼 비노출.
- **설명 문구 정리**: `Project Management Tools`, `로그인 없이 조회`, 공개 화면의 반복 설명 문구 제거. 워크스페이스 `AGENTS.md`에 화면명·메뉴명·기능명을 반복 설명하는 보조 문구를 사용하지 않는 전역 UI 규칙 추가.
- **추가 검증**: Vitest가 Playwright 파일을 수집하던 러너 충돌을 `vitest.config.ts` 제외 설정으로 해결. TypeScript 통과, Vitest 65건, Jest 7건, Playwright 모달 E2E 4건 통과. 로컬 `/api/health` 200.
- **모달 로그인 버튼 제거 보강**: 캘린더 내부 기간·보기 이동 링크가 `embedded=1`을 유지하도록 수정해 탐색 후에도 로그인 버튼이 나타나지 않게 함. 회의실 모달도 로그인 버튼 비노출을 E2E로 고정. TypeScript 및 Playwright 4건 통과.
- **원격 배포**: 커밋 `b2d0c20`을 GitHub main에 push. Vercel `Production – pmotools` deployment `6013732827` 성공, 고유 URL `https://pmotools-jr2vyd1fc-mohenzs-projects.vercel.app` 발급. 동일 저장소의 과거 `Production – projectmgmt` 중복 연결은 별도 deployment 실패 상태라 Vercel Git Integration 정리 필요.
- **메시지 일정 요약 표시**: 일정 초청 행에 일정 제목과 KST 기준 일자·시작/종료 시간을 바로 표시하고, 모바일에서는 발신자·일정·수신 정보가 세로로 배치되도록 수정. TypeScript 및 Vitest 65건 통과.
- **메시지 일정 요약 원격 배포**: 커밋 `20306f8`을 GitHub main에 push. Vercel `Production – pmotools` 배포 성공. 운영 URL `https://pmotools.vercel.app`.

## 최근 완료 작업 (2026-08-19 세션)
- **일정 초청과 쪽지 즉시 열람**: 캘린더 일정 생성/수정 시 담당자에게 쪽지로 초청을 자동 발송하는 `calendar-invitations` 도메인·API·팝업(`CalendarInvitationPopup`) 신규 구현. 로그인 시 받은 초청을 즉시 팝업으로 표시(`b1367eb`, migration `20260819152000_add_calendar_invitations`).
- **회의실 초청 확장 및 초청함 개편**: 회의실 예약 참석자에게도 캘린더와 동일한 방식으로 쪽지 초청 자동 발송(생성/수정/취소 반영). 로그인 팝업을 캘린더+회의실 초청 통합 표시로 확장(`InvitationPopup`, 기존 `CalendarInvitationPopup` 대체). 쪽지 화면을 "새 쪽지 발송" 기능 없이 받은 초청 목록만 보여주는 초청 전용 화면으로 개편. 내 정보 화면의 정보수정/비밀번호변경을 모달 팝업으로 전환(`f7d1f53`, migration `20260819180000_add_meeting_invitations`).
- **사용자 프로필 링크와 작업 기록**: `UserMenu`에 프로필 링크 추가, 작업 기록 문서 신규 작성(`479736f`).
- **검증**: `tsc --noEmit`, Vitest 통과(`meeting-invitations.test.ts`, `calendar-invitations.test.ts` 신규 포함).

## 최근 완료 작업 (2026-08-18 세션)
- **요구사항 관리 고도화**: 업무 대·중·소분류, 확정후추가, 비고, 수기 요구사항 ID 추가. 시스템발행 ID는 화면에서 숨기고 수기 요구사항 ID를 강조 표시.
- **명칭·상태·공통코드**: 요구사항근거→요구사항출처, 요구사항선결사항→사전확인사항 변경. `부분수용`, 기능/비기능, 신규/기능개선 코드 추가.
- **목록·통계 UI**: 검색 패널, 20/40/80/100/전체 페이지 크기, 번호 페이지네이션, Sheet2 피벗 기준 통계 화면 추가.
- **엑셀 이관**: production Supabase에 요구사항 171건 등록·재검증. 수용 161, 부분수용 4, 미수용 6, 기능 131/비기능 40, 신규 118/기능개선 53, 확정후추가 전체 NULL.
- **사용자 관리**: 사용자 계정 소프트 삭제 기능과 관리자 API 추가.
- **공지사항 게시판**: 목록·검색·페이징, 중요 상단 고정, 상세·조회수, 관리자/운영자 등록·수정·삭제, 대상·게시 기간·메인 배너 구현.
- **DB/배포**: production 총 19개 migration. GitHub `mohenz/pmotools` main `cfe0962`, Vercel `pmotools` production READY, `/api/health` 200 및 PostgreSQL 연결 확인.
- **검증**: `tsc --noEmit`, Vitest 26건, Next.js production build 통과. 로컬 `3020`과 production DB 헬스 체크 정상.

## 최근 작업 (2026-08-14 세션, Claude Code) — 미완결

### 신규 PC 환경 구성
- `workspace_installer`로 워크스페이스 이관 후 저장소 클론(`a644954`), `npm ci` 365개 + `prisma generate` 완료.
- `vercel env pull .env.local --environment=development`로 필수 6개 변수 실제 값 수신(이 프로젝트는 Sensitive 타입이 아니라 정상 수신됨). 타입 체크·테스트 26건 통과, dev 서버 3020 기동 및 `/api/health` → `{"status":"ok","database":"connected"}` 확인.
- **주의**: 이 `.env.local`은 **프로덕션 Supabase**를 가리킨다. 로컬 dev의 데이터 변경이 곧 운영 데이터 변경이다.

### 참석자 → 비고 전환 (코드 완료 / DB 미적용)
- 사용자 결정: ① 참석자 기능 **완전 제거** ② 마이그레이션은 **로컬 DB에 먼저** 적용.
- `prisma/schema.prisma`: `MeetingReservationAttendee` 모델과 `User`·`MeetingReservation` 양쪽 관계 삭제, `MeetingReservation.remark String? @db.VarChar(500)` 추가.
- `prisma/migrations/20260814043000_replace_attendees_with_remark/migration.sql` **신규 작성**(수동). `remark` 컬럼 추가 + `meeting_reservation_attendees` DROP. DB 미연결 상태라 `prisma migrate dev` 대신 손으로 작성했고 **아직 어떤 DB에도 적용되지 않았다.**
- `lib/server/meeting-rooms.ts`: zod 스키마 `attendeeIds` → `remark`(trim, max 500, nullable), 목록 조회의 attendees include 제거 후 `remark` 반환, 생성 트랜잭션에서 참석자 유효성 검증·연결 생성 제거(빈 문자열은 `null`로 저장).
- `features/meetrooms/MeetingRoomScreen.tsx`: 예약 모달의 `fieldset.attendee-picker` → 비고 `textarea`(rows 4, `maxLength=500`, 실시간 `n / 500` 카운터, `aria-live="polite"`). 일간 보드의 `N명` 표기 제거, 예약 목록은 비고 요약 표시, 상세 모달의 참석자 항목 → 비고(`white-space:pre-wrap`). `Member`/`Attendee` 타입과 `members` prop 제거.
- `app/meetrooms/page.tsx`: 참석자 전용이던 `listProjectMembers` 조회 제거(페이지 로드 쿼리 1개 감소).
- `app/globals.css`: `.attendee-picker` → `.remark-field`/`.remark-counter`/`.reservation-remark`.
- 검증: `tsc --noEmit` 통과, `vitest run` 26건 통과. **런타임 검증은 미실시**(DB 미적용).

### 막힌 지점
- 로컬 우선 경로를 쓰려면 `scripts/start-local-postgres.ps1`이 기대하는 `C:\Program Files\PostgreSQL\18`이 필요한데 이 PC에 PostgreSQL도 Docker도 없다.
- `winget install --id PostgreSQL.PostgreSQL.18`을 비대화형으로 실행했더니 **UAC 승격 대기로 15분간 멈춤**(다운로드 0바이트). 프로세스 종료했고 설치 잔여물은 없다. → **관리자 권한 PowerShell에서 사용자가 직접 실행해야 한다.**

## 이전 완료 작업 (2026-08-09 세션)
- **Firestore 잔재 점검**: 코드·설정 레벨은 이미 정리 완료 상태였음(`firebase-admin`/`apphosting.yaml`/env/`firestore-model.ts` 전부 없음). 남은 것은 **문서DB 시절 쿼리 패턴과 스키마 설계**였음.
- **쿼리 DB 이관**: 전체 로드 후 JS 필터링을 Prisma WHERE/orderBy/집계로 전환. `work-management`(weekId를 WHERE로, 라벨 include, 대시보드 count/aggregate/groupBy), `items`(`filterItems`→`itemWhere()`, 메모리 slice→skip/take DB 페이지네이션, 수동 Map 조인→관계 include, 대시보드 집계쿼리), `admin`(사용자 검색 ILIKE), `calendar`(프로젝트 전체 로드→기간·검색 조건 DB 이관).
- **의도적 예외**: 반복 일정은 회차별 예외(override)로 값이 달라져 DB에서 좁히면 오답 — 전개 후 필터링 유지(주석으로 사유 명시).
- **스키마**: `calendar_events.createdBy/updatedBy`, `weekly_reports`/`weekly_progress`/`staff_changes`의 `createdBy`에 users FK 추가(적용 전 고아 참조 0건 확인), `weekly_progress(weekId, groupId)` 인덱스 추가. 마이그레이션 `20260809000000_add_actor_foreign_keys` Supabase 적용 완료(drift 없음).
- **버그 수정**: `item_events.actorName`에 무조건 `"PMO 관리자"`가 기록되던 6곳 → 실제 로그인 사용자명.
- **테스트**: 6개 → 23개. 영업일 계산을 `lib/domain/business-days.ts`로 분리(+경계 테스트), `itemWhere()` 필터 조합 테스트. `vitest.config.ts`에 `@/` alias·`server-only` 스텁 추가로 서버 계층 순수 함수 테스트 가능화.
- **🔧 배포 파이프라인 복구(핵심)**: GitHub 연동 자동배포가 계속 실패 중이었음. 원인은 `lib/generated/prisma`가 `.gitignore` 대상인데 빌드에 `prisma generate`가 없어 신규 체크아웃에서 모듈 해석 실패. `package.json`에 `postinstall: prisma generate` 추가로 해결 → Preview·프로덕션 배포 모두 성공. **이제 CLI 수동 배포 없이 main push만으로 배포된다.**
- **문서**: `PMS_개발환경_아키텍처.md` 배너가 폐기 문서를 가리키던 오류 수정, 재개발계획서 체크리스트 완료 처리, `docs/작업기록_20260809_Firestore잔재정리.md` 신규 작성.
- **검증**: `tsc --noEmit`/`vitest run` 통과. 로컬(3020)·프로덕션 양쪽에서 시드 관리자로 읽기 경로 스모크 테스트 수행, **결과 완전 일치**(items 5/4/2/3, 캘린더 4개 소스 6건, 대시보드 매트릭스 합계 일치, SSR 11개 라우트 200).

## 이전 완료 작업 (2026-08-07 세션)
- **스택 전환**: Firebase Admin SDK/Cloud Firestore → Supabase PostgreSQL + Prisma 7(드라이버 어댑터 `@prisma/adapter-pg`) + Auth.js v5(Credentials, bcrypt). `firebase-admin` 의존성 완전 제거, `lib/server/db.ts`·`lib/domain/firestore-model.ts`·`apphosting.yaml` 삭제.
- **Supabase 프로비저닝**: Vercel Marketplace 경유로 Postgres+Storage 프로비저닝(`vercel integration add supabase`), `.env.local`에 자동 주입.
- **통합 Prisma 스키마**: User/ProjectMember/Project/Groups(조직·업무모듈 통합, 기존 Track 흡수)/CommonCode/Item/Week/WeeklyReport/WeeklyProgress/StaffChange/CalendarEvent/EventException/EventAssignee/EventGroupTag/EventAttachment/Message/NotificationSetting/AuditLog. 최초 마이그레이션 + RLS 활성화 마이그레이션 적용 완료.
- **기존 모듈 이관(Phase 1)**: 이슈·리스크, 주간보고/실적, 인력변동, 프로젝트정보, 공통코드, 캘린더 — 전부 Firestore→Prisma 재작성(API 계약 유지).
- **인증/권한(Phase 0·2)**: Auth.js 로그인/회원가입/비밀번호 변경, 세션 role(ADMIN/OPERATOR/MEMBER). 관리자 화면: 사용자 관리(`/settings/users`, 역할변경/계정잠금/비밀번호 강제초기화), 그룹 관리(`/settings/groups`), 감사로그(`/activity-logs`, 필터+관리자 전용).
- **캘린더 고도화(Phase 3~5)**: 우선순위(상/중/하)·마일스톤 플래그, 우선순위 색상체계, `/calendar/milestones`(마일스톤 모아보기+프로젝트 오픈일자 D-day), RRULE 기반 반복일정(`lib/domain/recurrence.ts`) + `EventException`으로 단일회차 수정/삭제(scope=all|single), 다중 담당자(`EventAssignee`)·업무그룹 태깅(`EventGroupTag`), `/calendar/search`(기간·담당자·그룹·우선순위 조합 검색), 년간/모바일 Agenda 뷰.
- **부가기능(Phase 6)**: 캘린더 월단위 엑셀 다운로드/업로드(`/calendar/excel`, Dry-run 검증→반영), Supabase Storage 첨부파일(서명 URL 다운로드), 쪽지 기능(`/messages`, AES-256-GCM 암호화+조회 비밀번호, scrypt 키 파생).
- **운영 안정화(Phase 7)**: 전 테이블 RLS 활성화 — **anon 키로 Supabase REST API를 통해 `users`(비밀번호 해시)·`messages` 등을 직접 읽을 수 있던 실제 노출을 발견하고 차단**(수정 전/후 curl로 직접 검증). 캘린더/첨부파일/엑셀 쓰기에 운영자 이상 권한 적용(화면 버튼 숨김+페이지 리다이렉트+API 403 3중 체크). Prisma 트랜잭션 타임아웃 여유 확대(PgBouncer 커넥션 지연 대응).
- **검증**: `tsc --noEmit`/`vitest run`/`next build` 전부 통과. ADMIN 계정으로 20개 라우트 전수 200 확인, 신규 MEMBER 계정으로 쓰기 전용 화면 리다이렉트+API 403 확인, 기존 "멤버는 본인 이슈 작성 가능" 규칙 유지 재확인.
- **배포 정리**: Firebase App Hosting 백엔드는 Firebase CLI로 트리거만 분리할 방법이 없어(list/create/get/delete만 존재), 사용자가 Firebase 콘솔에서 `projectmgmt-e7dfd` 프로젝트 자체를 삭제함. 기존 라이브 URL `https://projectmgmt--projectmgmt-e7dfd.asia-east1.hosted.app`는 404 확인(서비스 종료).

## 다음 작업
- **[P1] 09-04 세션 신규 기능 UAT**: 운영 계정으로 ① `/issues`(신규 이슈관리 — 목록/필터/등록/진행정보 추가·수정, 삭제된 이력 아닌 스냅샷 구조가 의도대로 보이는지) ② `/calendar`(회의실 예약이 이벤트로 표시되는지, "내 일정 보기" 체크박스 동작) ③ `/pmo-daily`(공정현황·지연TASK·이슈관리 위젯이 새 산식/컬럼대로 보이는지) ④ `/wbs`(컬럼 숨김·4개 날짜range 필터) ⑤ `/portfolio`·`/messages`(공지 배너 사라짐, 초청 목록 한 줄 레이아웃) 확인.
- **[P1 확인 대기] 집중관리업무 기능개선**: `docs/집중관리업무_기능개선_방안_20260903.md`의 확인사항 6개(band 산출 규칙, 수정·삭제 권한 확대 여부, 세부항목 고정/커스텀 여부, 액션아이템구분 값 목록, 기존 데이터 이관 방식, 액션아이템목록조회 범위)에 대한 사용자 결정 필요. 결정 후 문서의 TASK A~E 순서대로 진행.
- **[P1] 09-03 세션 신규 기능 UAT**: 초청 조회 목록의 일자/시간/장소 표시, "나의 WBS 현황" 누적 막대 그래프, 정기예약 신청 폼(요일 조건부 노출, 30분 단위 통합 시간 선택기) 실사용 확인.
- **[P1] 09-02 세션 신규 기능 UAT**: 운영 계정으로 ① `/portfolio` 차트(WBS 진척 Stage별 세로 막대, 나의 WBS 현황 파이 차트, 다크모드에서 실제로 흰 텍스트인지) ② `/requirements/excel` 요구사항ID 매칭 동기화(같은 파일 재업로드 시 이력이 보존되는지 실제 확인) ③ 위클리리포트 상세 화면의 "리포트 인쇄보기" 팝업(헤더/사이드바 없이 뜨는지, 돌아가기 버튼이 없는지) 확인.
- **[P1] 요구사항 엑셀·사용자 관리 UAT**: 운영 계정으로 `/requirements/excel` 다운로드→(수정한 파일)업로드→검증→반영 왕복 확인, `/settings/users`에서 아이디 변경 통합 확인 모달·반응형 레이아웃 확인.
- **[P1] 공지사항 UAT**: 운영 계정으로 등록→중요 상단 고정→메인 배너→수정·삭제 흐름 확인. 실제 운영 공지는 별도 등록 필요.
- **[P1] 요구사항 UAT**: 운영 화면에서 171건 목록·필터·통계·페이지 크기와 상세 화면 최종 확인.
- **[P1] 초청함 UAT**: 캘린더/회의실 초청 자동 발송·로그인 시 통합 팝업·초청 전용 쪽지 화면을 운영 계정 기준으로 최종 확인.
- **[P1 확인]** 2026-08-14의 회의실 참석자→비고 전환 미커밋 작업이 현재 `pmotools` 소스에 반영됐는지 재확인 후, 미반영이면 별도 의사결정 없이 임의 적용하지 않는다.
- **[P0 진행중]** 참석자→비고 전환 마무리: ① 관리자 PowerShell에서 `winget install --id PostgreSQL.PostgreSQL.18 -e --accept-package-agreements` ② `initdb`로 `.local-postgres\data` 클러스터 생성(포트 `55432`) ③ `npm.cmd run db:local:start` ④ `mydb` 생성 ⑤ `DATABASE_URL`을 로컬로 지정해 `prisma migrate deploy`(마이그레이션 7개) ⑥ `prisma db seed` ⑦ `/meetrooms`에서 비고 입력·저장·상세 표시 검증 ⑧ 커밋·push(자동 배포). **프로덕션 배포 전에 운영 DB에도 마이그레이션 적용이 선행돼야 한다** — 코드가 먼저 올라가면 `remark` 컬럼이 없어 회의실 화면이 깨진다.
- **[P0 보안]** 저장소가 public인데 `prisma/seed.ts`에 프로덕션 ADMIN 비밀번호가 평문 커밋되어 있고 프로덕션 URL에 접근 보호가 없음 → ① 해당 계정 비밀번호 변경 ② seed 비밀번호를 환경변수로 분리 ③ 저장소 private 전환 검토 ④ Vercel Deployment Protection 정책 결정. **2026-08-14 확인: 운영 DB의 `pmo.admin` 계정에 시드 초기 비밀번호가 여전히 유효하다(bcrypt 해시 대조로 검증). 나머지 사용자 2명(`test.member`, `final.member`)은 변경됨.** 미조치 상태.
- **[P1]** 미검증 2건 확인 — ① 다중 페이지 이동(`skip`/`take` 경계, 데이터 10건 초과 환경 필요) ② 쓰기 경로(이슈 등록 시 활동 이력에 로그인 사용자명이 기록되는지).
- **[P1]** `updateProgress()`가 `writeAuditLog`에 actor를 `null`로 넘겨 주간실적 수정자가 기록되지 않음(`lib/server/work-management.ts`) — 함수에 `userId` 전달로 해결.
- **[P2]** `Item.ownerUserId`가 어디서도 채워지지 않아 항상 null(권한 체크에서만 읽힘) — 담당자를 사용자 FK로 갈지 자유 텍스트로 둘지 제품 결정 필요.
- (범위 밖으로 보류) 조직그룹 멤버 추가/제거 UI, Supabase PITR 백업 활성화(플랜 업그레이드 필요할 수 있음), Vercel/Supabase 모니터링 대시보드 구성.

## 실행 / 검증
- run_command: `npm.cmd run local` (foreground, port `3020`)
- verify_command: `npm.cmd run lint`(tsc --noEmit), `npm.cmd run test`(vitest run), `npm.cmd run build`
- port_or_runtime: web `3020`
- deploy_method: **GitHub `mohenz/pmotools` main push + 필요 시 `vercel deploy --prod --yes` → Vercel production 배포**. Vercel 프로젝트 `mohenzs-projects/pmotools`. 전제조건: `postinstall: prisma generate` 및 Vercel에서 `POSTGRES_URL_NON_POOLING` 우선 사용.
- deploy_ignore_target: 레거시 Vercel 프로젝트 `mohenzs-projects/projectmgmt`는 배포·재시도·상태 모니터링 대상에서 제외하며, 해당 GitHub commit status 실패는 운영 배포 실패로 판단하지 않는다.
- deploy_check_command: `curl https://<vercel-domain>/api/health`
- deploy_post_check: 로그인(`pmo.admin`) → `/portfolio`, `/calendar`, `/settings/users` 등 핵심 라우트 200 확인
- deploy_invariants: Supabase 연결 정상, Auth.js 로그인 가능, RLS로 anon 키 접근 차단 유지
- deploy_abort_condition: Prisma/Postgres 연결 실패, 로그인 불가
- latest_deployment: `https://pmotools.vercel.app` — 커밋 `b3d71db`(2026-09-04, 초청 목록 헤더 한 줄 레이아웃 최종 정리) 기준 `Production – pmotools` 배포 Ready, `/api/health` 200 확인(2026-09-04 재확인). 로컬 main·GitHub origin/main·프로덕션이 모두 동일 커밋으로 일치(`git status` clean, ahead/behind 0). 과거 `Production – projectmgmt` 중복 연결 배포는 실패 상태이며 운영 기준이 아님.
- 이전 배포: 2026-08-07 `vercel deploy --prod` CLI 수동 배포(당시 GitHub 트리거 배포는 실패 상태였음). 배포 직후 `AUTH_SECRET` 미등록으로 로그인 500 → `vercel env add AUTH_SECRET`(production/preview/development) 등록 후 해결.
- 사전 조건: 로컬 Supabase 연결값은 `vercel env pull .env.local`로 받거나 `.env.example` 참고해 `.env.local` 구성. 최초 로그인 계정은 `prisma/seed.ts` 참고(**비밀번호를 이 파일에 기록하지 않는다 — 상태 파일 규칙**).

## 핵심 경로
- project_root: `D:\workspace\projectmgmt`
- key_docs: `README.md`, `docs\PMS_캘린더기반_재개발계획서.md`(현재 기준, Phase 0~7 진행현황 기록), `docs\집중관리업무_기능개선_방안_20260903.md`(구현 착수 전 사용자 결정 대기 중), `docs\FIREBASE_FIRESTORE_ARCHITECTURE.md`/`SYSTEM_DESIGN.md`(보관 문서, 상단 배너로 구분), `project_control\design\bloom_ui_design_standard.md`
- key_files: `prisma/schema.prisma`(Issue/IssueProgress MASTER-DETAIL), `lib/server/issues.ts`(신규, 이슈관리), `lib/server/db-pg.ts`, `lib/server/auth.ts`, `lib/server/calendar.ts`, `lib/domain/recurrence.ts`, `lib/domain/crypto.ts`, `lib/server/calendar-invitations.ts`, `lib/server/meeting-invitations.ts`, `middleware.ts`

## 리스크 / 주의사항
- **🟠 [사용자 승인 완료, 참고용] 이슈관리 재구축 과정에서 운영 DB의 `items`/`item_events`/`item_sequences` 테이블을 마이그레이션 없이 DROP했다.** 사용자에게 명시적으로 위험을 고지("운영 DB에서 완전히 삭제되며 복구 불가")했고, 사용자가 "운영에서 사용하지 않은 기능이라 문제는 없을 것 같아. 고마워"로 승인 후 진행했다. 과거 Item/이슈-리스크 관련 화면·API·데이터는 전부 사라졌으며 새 이슈관리(`Issue`/`IssueProgress`)와는 완전히 별개 구조다 — 옛 데이터를 복구해달라는 요청이 오면 DB 백업(있다면 Supabase PITR) 외에는 방법이 없다는 점을 먼저 안내할 것.
- **🟡 [참고] 로컬 Postgres(55432)가 비정상 종료 상태로 방치되면 TCP 연결은 되지만 쿼리 중간에 끊긴다.** 2026-09-04 세션에서 실제로 겪었고 `pg_ctl -D "D:/Workspace/projectmgmt/.local-postgres/data" -w restart`로 WAL 재생 복구했다. 유사 증상(연결은 되는데 쿼리가 죽음) 재현 시 이 절차부터 시도할 것.
- **🟡 [참고] 이 프로젝트에서 `prisma migrate dev`는 항상 실패한다** — 기존 마이그레이션 `20260812121500_seed_default_meeting_rooms`가 빈 shadow DB에 FK 위반을 일으킴(사전 데이터 없이 재생 불가한 시딩 스크립트). 신규 마이그레이션은 항상 `prisma migrate deploy`(로컬 실제 DB에 직접, shadow DB 미사용)로 적용할 것 — production `vercel-build`도 동일 방식이라 안전하다.
- **🔴 [열림] 저장소가 public이고 `prisma/seed.ts`에 프로덕션 ADMIN 계정 비밀번호가 평문 커밋되어 있다. 프로덕션 URL에 Vercel Deployment Protection도 없어 누구나 관리자로 로그인 가능한 상태다** — "다음 작업" P0 참조. 2026-08-14 운영 DB 대조 결과 해당 계정은 **여전히 시드 초기 비밀번호로 로그인 가능**하다.
- **🟡 [완화, 재확인 필요] `.env.local`(= `vercel env pull` 결과) 자체는 여전히 프로덕션 Supabase를 가리킨다.** 다만 2026-09-01 세션에서 이 PC의 실제 `npm run dev`는 `.env`의 로컬 `DATABASE_URL`(55432)을 우선 사용해 프로덕션과 분리되어 있음을 직접 검증했다(상세는 09-01 세션 로그). PC를 옮기거나 `.env`/`DATABASE_URL`을 건드리면 다시 프로덕션에 직접 붙을 수 있으니, 새 환경에서 작업을 시작할 때는 매번 재확인할 것.
- **🟠 [열림] 작업 트리에 미커밋 변경 6개가 있고 로컬 스키마와 운영 DB 스키마가 어긋나 있다.** `/meetrooms`는 마이그레이션 적용 전까지 동작하지 않는다.
- `lib/generated/prisma`는 `.gitignore` 대상 — 빌드 환경에서는 반드시 `prisma generate`가 선행돼야 한다(`postinstall`로 보장 중). **이 스크립트를 지우면 자동배포가 다시 깨진다.**
- 이슈·리스크 키워드 검색이 필드별 검색으로 바뀌었다(기존: 제목+설명+담당자를 이어붙인 문자열 검색). 필드 경계를 걸치는 검색어는 매치되지 않는다.
- 주간보고/실적/인력변동의 `areaLabel`이 비활성 업무모듈일 때 `"-"` 대신 실제 라벨로 표시된다.
- Firebase 프로젝트(`projectmgmt-e7dfd`)가 삭제되어 기존 GitHub App Hosting 자동배포 연결도 함께 사라짐 — 배포 경로는 이제 Vercel이 유일하다.
- RLS는 활성화했지만 정책(policy)은 만들지 않았다(anon/authenticated 기본 거부, 앱은 Postgres 소유자 커넥션으로 우회) — 향후 Supabase Auth 기반 클라이언트 접근을 추가한다면 RLS 정책을 별도로 설계해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토
- 로컬 dev DB(`.env`, 55432)의 `requirements` 테이블이 09-02 세션 엑셀 업로드 테스트로 171건 → 2건(`TEST-REPLACE-001` 수정본, `TEST-REPLACE-003`)으로 줄어든 상태다. 로컬 전용이라 운영 데이터에는 영향 없지만, 로컬에서 요구사항 관련 화면을 볼륨 있게 테스트하려면 프로덕션에서 다시 export해 재이관하거나 별도 시드가 필요하다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: 요구사항 `app/requirements`, `lib/server/requirements.ts`; 공지사항 `app/announcements`, `lib/server/announcements.ts`; 초청함 `components/InvitationPopup.tsx`, `lib/server/calendar-invitations.ts`, `lib/server/meeting-invitations.ts`; 최신 migration `20260819180000_add_meeting_invitations`.
- 운영 기준은 GitHub `mohenz/pmotools`, Vercel `mohenzs-projects/pmotools`, URL `https://pmotools.vercel.app`이다.

## Handoff
- current_goal: 이슈관리 전면 재구축(MASTER-DETAIL)·캘린더 회의실 연동/내 일정 필터·PMO Daily 재정의·WBS 목록 개선·초청 목록 UI 다단계 개선 전부 배포 완료. 집중관리업무 기능개선은 여전히 분석 문서만 있고 구현은 사용자 결정 대기 중(변화 없음).
- done_latest: (09-04) 커밋 `f22d87e`~`b3d71db` 13개를 로컬 main에 순차 커밋, 매번 push 직후 GitHub 연동 자동배포 또는 `vercel --prod --yes`로 즉시 배포(상세는 "최근 완료 작업 (2026-09-04 세션)" 참조). 핵심은 이슈관리 전면 개편 — 기존 Item(이슈+리스크 통합, 확률×영향 매트릭스) 완전 삭제 후 Issue(MASTER)/IssueProgress(DETAIL, 전체 필드 스냅샷) 구조로 재구축, "변경이력"의 의미를 세 번 재해석한 끝에 사용자가 원한 형태(등록 시와 동일한 전체 필드를 갖춘 진행 스냅샷)로 확정했다.
- key_findings: 사용자가 "이력"을 요구할 때 자동 감사로그(누가/언제/무엇을 바꿨는지)와 "그 시점의 전체 상태 스냅샷"은 전혀 다른 요구사항이며, 모호하면 반드시 "최초 등록 때와 같은 전체 필드를 갖춘 스냅샷이 맞냐"처럼 구체적으로 되물어 확인해야 한다(이번 세션은 세 번 잘못 짚은 뒤에야 맞았다). `prisma migrate dev`가 이 프로젝트에서 항상 실패하므로 `prisma migrate deploy`를 표준으로 쓴다(리스크 절 참조). 로컬 Postgres가 "연결은 되는데 쿼리 중 끊김" 증상을 보이면 비정상 종료 후 미복구 상태일 수 있으니 `pg_ctl restart`부터 시도한다. `next build`와 `next dev`를 동시에 실행하면 `.next` 청크가 깨진다 — 빌드 검증 전 반드시 dev 서버를 내린다.
- changed_files: `prisma/schema.prisma`(Item* 제거, Issue/IssueProgress 등 추가), `prisma/migrations/20260904*`(6개), `lib/server/issues.ts`(신규), `features/issues/IssueFormActions.tsx`(신규), `screens/IssueListScreen.tsx`(신규), `lib/server/calendar.ts`(회의실 소스 연동), `features/calendar/CalendarMineToggle.tsx`(신규), `app/calendar/page.tsx`, `lib/server/wbs.ts`/`screens/WbsListScreen.tsx`/`app/wbs/page.tsx`(날짜 range 필터·컬럼 숨김), `lib/server/pmo-daily.ts`/`screens/PmoDailyScreen.tsx`(재정의), `components/AnnouncementBanner.tsx`(삭제), `screens/MessagesScreen.tsx`/`screens/PortfolioScreen.tsx`/`app/globals.css`(초청 목록 다단계 개선), `screens/WorkLogFormScreen.tsx`(폼 폭 20%); 상태 기록 `project_control/states/projectmgmt_current.md`.
- verification: 스키마 변경마다 `tsc --noEmit`/`vitest run`/`next build` 재확인. 매 배포 후 Vercel CLI로 Ready 확인 + `/api/health` 200 + 로그인 후 핵심 라우트 확인.
- next_action: ① "다음 작업"의 09-04 신규 기능 UAT(이슈관리 최우선) ② 집중관리업무 개선 문서의 확인사항 6개에 대한 사용자 결정 확보 후 TASK A~E 진행 ③ 기존 P0/P1 이월 항목(보안, 09-03/09-02 UAT) 순차 처리.
- risks_or_blockers: 이슈관리 재구축으로 운영 DB의 옛 `items`/`item_events`/`item_sequences` 데이터가 영구 삭제됐다(사용자 승인 완료, 되돌릴 수 없음 — 복구 요청 시 백업 없이는 불가함을 먼저 안내). 집중관리업무 개선은 설계 결정이 나기 전까지 착수 불가(`required_decision`). 기존 P0(저장소 public + seed 비밀번호 평문, production 접근 보호 없음)·npm 고위험 취약점 4건은 미해결로 이월.
- do_not_do: `package.json`의 `postinstall` 제거 금지(자동배포 즉시 중단됨). 레거시 Vercel `projectmgmt`에 배포하거나 실패 상태를 운영 릴리스 블로커로 취급하지 말 것. 새 이슈관리에 `updateIssue()`(마스터 직접 수정) 같은 우회 경로를 추가하지 말 것 — 진행정보(IssueProgress) 추가/수정/삭제가 유일한 갱신 경로여야 한다는 것이 사용자가 확정한 설계다. `prisma migrate dev`를 이 프로젝트에서 다시 시도하지 말 것(항상 실패, `migrate deploy` 사용). 로그인 ID를 변경한 6개 계정(08-31 세션 본문 참조)의 예전 ID로 되돌리지 말 것. 이슈 대시보드의 3×3 리스크 매트릭스를 chart.js로 임의 전환하지 말 것(이미 삭제된 옛 이슈/리스크 대시보드라 해당 없음, 참고용으로만 유지). 집중관리업무 개선을 문서의 확인사항 6개에 대한 사용자 답변 없이 임의로 구현 착수하지 말 것.
