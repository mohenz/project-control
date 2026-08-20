# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-20`
- owner_request: `요구사항 관리 고도화·엑셀 데이터 이관·공지사항 게시판 구현 후 GitHub/Supabase/Vercel 원격 배포`
- current_status: `요구사항·공지사항·회의실/캘린더 초청함 통합·사용자 프로필 정비 완료. 캘린더 날짜 계산을 한국시간(KST) 기준으로 수정. GitHub main(0c3fa2b), Vercel production(https://pmotools.vercel.app) 배포 및 origin과 동기화 완료.`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 현재 목표
- (완료) 요구사항 관리 고도화, 요구사항 171건 production 이관, 공지사항 게시판 구축·배포.
- (완료) 회의실/캘린더 초청 통합 발송·초청함 개편, 캘린더 날짜 계산 KST 보정.
- 다음 우선순위는 공지사항·요구사항 운영 UAT, 기존 P0 보안 조치, 8월 14일 회의실 참석자→비고 전환 작업의 현재 소스 반영 여부 재확인.

## 최근 완료 작업 (2026-08-20 세션)
- **캘린더 날짜 KST 보정**: `app/calendar/page.tsx`·`lib/domain/calendar-layout.ts`의 "오늘" 계산이 서버 UTC 기준으로 어긋나던 문제를 한국시간 기준으로 수정(`5943ffd`). 이어서 주요 이벤트(마일스톤) 날짜와 D-Day 계산도 동일하게 KST 기준으로 보정(`lib/server/calendar.ts`, `0c3fa2b`).
- **검증**: `lib/domain/calendar-layout.test.ts`에 경계 케이스 추가, Vitest 12개 테스트 파일 65건 전체 통과.
- **원격 동기화**: GitHub `mohenz/pmotools` main이 origin과 완전히 동기화된 상태(`git status` clean, up to date).

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
- deploy_check_command: `curl https://<vercel-domain>/api/health`
- deploy_post_check: 로그인(`pmo.admin`) → `/portfolio`, `/calendar`, `/settings/users` 등 핵심 라우트 200 확인
- deploy_invariants: Supabase 연결 정상, Auth.js 로그인 가능, RLS로 anon 키 접근 차단 유지
- deploy_abort_condition: Prisma/Postgres 연결 실패, 로그인 불가
- latest_deployment: `https://pmotools.vercel.app` — GitHub main `0c3fa2b` push 기준 자동 배포(2026-08-20). 이전 확인 배포: `dpl_EkJhktWg5fZ9dvTrT6x29346qHfL`(2026-08-18, main `cfe0962`) `/api/health` 200, PostgreSQL 연결 정상. 이전 `projectmgmt-tau.vercel.app`은 운영 기준 주소가 아님.
- 이전 배포: 2026-08-07 `vercel deploy --prod` CLI 수동 배포(당시 GitHub 트리거 배포는 실패 상태였음). 배포 직후 `AUTH_SECRET` 미등록으로 로그인 500 → `vercel env add AUTH_SECRET`(production/preview/development) 등록 후 해결.
- 사전 조건: 로컬 Supabase 연결값은 `vercel env pull .env.local`로 받거나 `.env.example` 참고해 `.env.local` 구성. 최초 로그인 계정은 `prisma/seed.ts` 참고(**비밀번호를 이 파일에 기록하지 않는다 — 상태 파일 규칙**).

## 핵심 경로
- project_root: `D:\workspace\projectmgmt`
- key_docs: `README.md`, `docs\PMS_캘린더기반_재개발계획서.md`(현재 기준, Phase 0~7 진행현황 기록), `docs\FIREBASE_FIRESTORE_ARCHITECTURE.md`/`SYSTEM_DESIGN.md`(보관 문서, 상단 배너로 구분), `project_control\design\bloom_ui_design_standard.md`
- key_files: `prisma/schema.prisma`, `lib/server/db-pg.ts`, `lib/server/auth.ts`, `lib/server/calendar.ts`, `lib/domain/recurrence.ts`, `lib/domain/crypto.ts`, `lib/server/calendar-invitations.ts`, `lib/server/meeting-invitations.ts`, `middleware.ts`

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
- 다음 시작 시 먼저 볼 것: 요구사항 `app/requirements`, `lib/server/requirements.ts`; 공지사항 `app/announcements`, `lib/server/announcements.ts`; 초청함 `components/InvitationPopup.tsx`, `lib/server/calendar-invitations.ts`, `lib/server/meeting-invitations.ts`; 최신 migration `20260819180000_add_meeting_invitations`.
- 운영 기준은 GitHub `mohenz/pmotools`, Vercel `mohenzs-projects/pmotools`, URL `https://pmotools.vercel.app`이다.

## Handoff
- current_goal: 요구사항 관리·171건 이관·공지사항 게시판·회의실/캘린더 초청함 production 배포 완료. 다음은 운영 UAT와 P0 보안 조치.
- done_latest: (08-19) 캘린더/회의실 초청 자동 발송과 통합 초청 팝업, 초청 전용 쪽지 화면 개편, 사용자 프로필 링크 추가. (08-20) 캘린더 오늘 날짜·주요 이벤트 D-Day 계산을 한국시간(KST) 기준으로 수정.
- key_findings: 캘린더 "오늘"·D-Day 계산이 서버 UTC 기준이라 자정 전후 한국 사용자 화면과 어긋나는 문제가 있었음 — `lib/domain/calendar-layout.ts`, `lib/server/calendar.ts`에서 KST 오프셋을 명시적으로 적용해 해결. 원격 이관에서 로컬 `DATABASE_URL` 우선 문제를 발견해 `POSTGRES_PRISMA_URL` 우선으로 수정(`a4f82db`). 8월 14일 회의실 비고 전환 기록은 현재 소스 반영 여부 재확인 필요.
- changed_files: `app/calendar/page.tsx`, `lib/domain/calendar-layout.ts`(+test), `lib/server/calendar.ts`, `lib/domain/calendar-invitations.ts`, `lib/domain/meeting-invitations.ts`, `lib/server/calendar-invitations.ts`, `lib/server/meeting-invitations.ts`, `lib/server/meeting-rooms.ts`, `lib/server/messages.ts`, `components/InvitationPopup.tsx`(신규, `CalendarInvitationPopup.tsx` 대체), `screens/MessagesScreen.tsx`, `screens/MyProfileScreen.tsx`, `components/UserMenu.tsx`, `prisma/schema.prisma`, migration 2개(`20260819152000_add_calendar_invitations`, `20260819180000_add_meeting_invitations`).
- verification: `tsc --noEmit`, Vitest 12개 파일 65건 전체 통과. GitHub main `0c3fa2b`가 origin과 완전히 동기화(clean, up to date).
- next_action: ① 초청함 UAT(캘린더/회의실 자동 발송·통합 팝업) ② 공지사항 UAT ③ 요구사항 UAT ④ 8월 14일 회의실 작업 반영 여부 확인 ⑤ P0 관리자 비밀번호/seed 평문 문제 조치 ⑥ 감사로그 actor 누락 점검.
- risks_or_blockers: `required_decision` — 저장소 public 유지 여부 / production 접근 보호 / `Item.ownerUserId` 모델. `do_not_do` — 8월 14일 참석자 삭제 migration은 현재 상태 확인 없이 임의 적용 금지.
- do_not_do: `package.json`의 `postinstall` 제거 금지(자동배포 즉시 중단됨)
