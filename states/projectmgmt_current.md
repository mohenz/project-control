# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-14`
- owner_request: `회의실 예약 모달의 참석자 선택을 제거하고 비고란(최대 500자)으로 대체`
- current_status: `⚠️ 작업 미완결. 참석자→비고 전환 코드는 전부 완료(타입 체크·테스트 통과, 미커밋)이나 DB 마이그레이션 미적용. 로컬 PostgreSQL 미설치로 막힘. 이로 인해 로컬 dev(3020)의 /meetrooms가 스키마 불일치로 깨진 상태. 프로덕션 DB·배포본은 변경 없음.`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 현재 목표
- **참석자→비고 전환 마무리**: 로컬 PostgreSQL 18 설치 → 클러스터 구성 → 마이그레이션 적용 → `/meetrooms` 실동작 검증 → 커밋·배포.

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
- deploy_method: **GitHub `mohenz/projectmgmt` main push → Vercel 자동 프로덕션 배포** (별도 CLI 배포 불필요). Vercel 프로젝트 `mohenzs-projects/projectmgmt`, 브랜치 push 시 Preview 자동배포. 전제조건: `package.json`의 `postinstall: prisma generate` — 이게 없으면 빌드가 모듈 해석 단계에서 실패한다(2026-08-09 복구).
- deploy_check_command: `curl https://<vercel-domain>/api/health`
- deploy_post_check: 로그인(`pmo.admin`) → `/portfolio`, `/calendar`, `/settings/users` 등 핵심 라우트 200 확인
- deploy_invariants: Supabase 연결 정상, Auth.js 로그인 가능, RLS로 anon 키 접근 차단 유지
- deploy_abort_condition: Prisma/Postgres 연결 실패, 로그인 불가
- latest_deployment: `https://projectmgmt-tau.vercel.app` (2026-08-09, main `30949f6` GitHub 트리거 자동배포) — `/api/health` postgres 연결 ok, 인증 리다이렉트 정상, 시드 관리자 로그인 후 items/calendar/weekly-progress/admin-users 조회 결과가 로컬과 완전 일치.
- 이전 배포: 2026-08-07 `vercel deploy --prod` CLI 수동 배포(당시 GitHub 트리거 배포는 실패 상태였음). 배포 직후 `AUTH_SECRET` 미등록으로 로그인 500 → `vercel env add AUTH_SECRET`(production/preview/development) 등록 후 해결.
- 사전 조건: 로컬 Supabase 연결값은 `vercel env pull .env.local`로 받거나 `.env.example` 참고해 `.env.local` 구성. 최초 로그인 계정은 `prisma/seed.ts` 참고(**비밀번호를 이 파일에 기록하지 않는다 — 상태 파일 규칙**).

## 핵심 경로
- project_root: `D:\workspace\projectmgmt`
- key_docs: `README.md`, `docs\PMS_캘린더기반_재개발계획서.md`(현재 기준, Phase 0~7 진행현황 기록), `docs\FIREBASE_FIRESTORE_ARCHITECTURE.md`/`SYSTEM_DESIGN.md`(보관 문서, 상단 배너로 구분), `project_control\design\bloom_ui_design_standard.md`
- key_files: `prisma/schema.prisma`, `lib/server/db-pg.ts`, `lib/server/auth.ts`, `lib/server/calendar.ts`, `lib/domain/recurrence.ts`, `lib/domain/crypto.ts`, `middleware.ts`

## 리스크 / 주의사항
- **🔴 [열림] 저장소가 public이고 `prisma/seed.ts`에 프로덕션 ADMIN 계정 비밀번호가 평문 커밋되어 있다. 프로덕션 URL에 Vercel Deployment Protection도 없어 누구나 관리자로 로그인 가능한 상태다** — "다음 작업" P0 참조. 2026-08-14 운영 DB 대조 결과 해당 계정은 **여전히 시드 초기 비밀번호로 로그인 가능**하다.
- **🔴 [열림] 로컬 `.env.local`이 프로덕션 Supabase를 가리킨다.** `vercel env pull` 결과를 그대로 쓰면 로컬 개발이 운영 DB에 직접 붙는다. 테스트 데이터 입력·삭제 시 운영 데이터가 바뀐다. 로컬 PostgreSQL(55432) 구성 후 `DATABASE_URL`로 덮어쓸 것.
- **🟠 [열림] 작업 트리에 미커밋 변경 6개가 있고 로컬 스키마와 운영 DB 스키마가 어긋나 있다.** `/meetrooms`는 마이그레이션 적용 전까지 동작하지 않는다.
- `lib/generated/prisma`는 `.gitignore` 대상 — 빌드 환경에서는 반드시 `prisma generate`가 선행돼야 한다(`postinstall`로 보장 중). **이 스크립트를 지우면 자동배포가 다시 깨진다.**
- 이슈·리스크 키워드 검색이 필드별 검색으로 바뀌었다(기존: 제목+설명+담당자를 이어붙인 문자열 검색). 필드 경계를 걸치는 검색어는 매치되지 않는다.
- 주간보고/실적/인력변동의 `areaLabel`이 비활성 업무모듈일 때 `"-"` 대신 실제 라벨로 표시된다.
- Firebase 프로젝트(`projectmgmt-e7dfd`)가 삭제되어 기존 GitHub App Hosting 자동배포 연결도 함께 사라짐 — 배포 경로는 이제 Vercel이 유일하다.
- RLS는 활성화했지만 정책(policy)은 만들지 않았다(anon/authenticated 기본 거부, 앱은 Postgres 소유자 커넥션으로 우회) — 향후 Supabase Auth 기반 클라이언트 접근을 추가한다면 RLS 정책을 별도로 설계해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs\작업기록_20260809_Firestore잔재정리.md`(이번 작업 전체 기록 + 후속 조치 우선순위).
- 배포는 이제 **main push만으로** 된다. CLI 배포 절차를 다시 만들지 말 것.

## Handoff
- current_goal: 회의실 예약의 참석자 선택을 비고란(최대 500자)으로 전환 — **코드 완료, DB 미적용 상태로 중단**
- done_latest: 신규 PC 환경 구성(클론·`npm ci`·`vercel env pull`·dev 3020 기동 확인). 참석자 기능 완전 제거 후 `remark` 필드로 대체하는 스키마·서버·UI·CSS 변경 전부 완료. 마이그레이션 SQL 수동 작성.
- key_findings: **로컬 `.env.local`이 프로덕션 Supabase를 가리킨다** — 로컬 dev의 데이터 조작이 곧 운영 데이터 조작이다. / **`pmo.admin`에 시드 초기 비밀번호가 운영 DB에서 아직 유효**하다(P0 미조치). / 이 PC엔 PostgreSQL·Docker가 없고 winget 설치는 UAC 승격 때문에 비대화형으로 불가하다.
- changed_files: 6개 — `prisma/schema.prisma`, `prisma/migrations/20260814043000_replace_attendees_with_remark/migration.sql`(신규), `lib/server/meeting-rooms.ts`, `features/meetrooms/MeetingRoomScreen.tsx`, `app/meetrooms/page.tsx`, `app/globals.css` (**전부 미커밋**)
- verification: `tsc --noEmit` 통과, `vitest run` 26건 통과. **런타임 검증 미실시** — DB에 `remark` 컬럼이 없어 `/meetrooms` 실행 불가.
- next_action: 관리자 PowerShell로 PostgreSQL 18 설치 → 로컬 클러스터(55432) 구성 → `prisma migrate deploy` → `/meetrooms` 검증 → 커밋·배포. "다음 작업" P0 항목의 8단계 참조.
- risks_or_blockers: `blocked_by` — PostgreSQL 18 미설치(관리자 권한 필요, 사용자 실행 대기). / `do_not_do` — **프로덕션 DB에 마이그레이션을 임의 적용하지 말 것**(사용자가 로컬 우선을 선택했고, 적용 시 참석자 데이터가 영구 삭제된다). / `do_not_do` — **코드만 먼저 push하지 말 것**(운영 DB에 `remark` 컬럼이 없어 회의실 화면이 깨진다). / `required_decision` — 저장소 public 유지 여부, 프로덕션 접근 보호 적용 여부, `Item.ownerUserId` 담당자 모델
- do_not_do: `package.json`의 `postinstall` 제거 금지(자동배포 즉시 중단됨)
