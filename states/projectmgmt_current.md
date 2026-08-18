# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-18`
- owner_request: `요구사항 관리 고도화·엑셀 데이터 이관·공지사항 게시판 구현 후 GitHub/Supabase/Vercel 원격 배포`
- current_status: `요구사항 관리·통계·페이징, 사용자 삭제, 공지사항 게시판 구현 완료. GitHub main(cfe0962), Supabase 19개 마이그레이션, Vercel production(https://pmotools.vercel.app) 배포 및 DB 헬스 체크 완료.`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 현재 목표
- (완료) 요구사항 관리 고도화, 요구사항 171건 production 이관, 공지사항 게시판 구축·배포.
- 다음 우선순위는 공지사항 운영 데이터 등록·사용자 인수 테스트와 기존 P0 보안 조치.

## 최근 완료 작업 (2026-08-18 세션)
- **요구사항 관리 고도화**: 업무 대·중·소분류, 확정후추가, 비고, 수기 요구사항 ID 추가. 기존 ID는 시스템발행 ID로 역할을 정리하고 화면에서는 숨김 처리, 수기 요구사항 ID를 강조 표시.
- **명칭·상태·공통코드**: 요구사항근거→요구사항출처, 요구사항선결사항→사전확인사항 변경. `부분수용` 상태와 요구사항 구분(기능/비기능), 분류(신규/기능개선) 공통코드 추가.
- **목록·통계 UI**: 검색 패널 아웃라인, 20/40/80/100/전체 페이지 크기, 번호 페이지네이션, Sheet2 피벗 기준 요구사항 통계 화면 추가.
- **엑셀 이관**: `요구사항리스트_등록용.xlsx` Sheet1을 검증 후 production Supabase에 171건 등록. 수용 161, 부분수용 4, 미수용 6, 기능 131/비기능 40, 신규 118/기능개선 53, 확정후추가 전체 NULL. production DB에서 171건을 재검증.
- **사용자 관리**: 사용자 계정 소프트 삭제 기능과 관리자 API 추가.
- **공지사항 게시판**: 목록·검색·페이징, 중요 공지 상단 고정, 상세·조회수, 관리자/운영자 등록·수정·삭제, 전체/관리자·운영자 대상, 게시 기간, 메인 노출 기간과 배너 구현.
- **DB/배포**: 신규 마이그레이션 5개 적용, production 기준 총 19개 마이그레이션 정상. GitHub `mohenz/pmotools` main 최신 `cfe0962`, Vercel `pmotools` production READY, `/api/health` 200 및 PostgreSQL 연결 확인.
- **검증**: `tsc --noEmit`, Vitest 26건, Next.js production build 통과. 로컬 서버 `3020` 재시작 후 `/api/health` 200 확인.

## 최근 완료 작업 (2026-08-09 세션)
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
- **[P1] 공지사항 UAT**: 운영 계정으로 공지 등록→중요 상단 고정→메인 배너→수정·삭제 흐름 확인. production 공지 테이블은 신규 생성 상태이며 운영 공지는 별도 등록 필요.
- **[P1] 요구사항 UAT**: 운영 화면에서 171건 목록·필터·통계·페이지 크기와 상세 화면을 사용자 기준으로 최종 확인.
- **[P0 보안]** 저장소가 public인데 `prisma/seed.ts`에 프로덕션 ADMIN 비밀번호가 평문 커밋되어 있고 프로덕션 URL에 접근 보호가 없음 → ① 해당 계정 비밀번호 변경 ② seed 비밀번호를 환경변수로 분리 ③ 저장소 private 전환 검토 ④ Vercel Deployment Protection 정책 결정.
- **[P1]** 미검증 2건 확인 — ① 다중 페이지 이동(`skip`/`take` 경계, 데이터 10건 초과 환경 필요) ② 쓰기 경로(이슈 등록 시 활동 이력에 로그인 사용자명이 기록되는지).
- **[P1]** `updateProgress()`가 `writeAuditLog`에 actor를 `null`로 넘겨 주간실적 수정자가 기록되지 않음(`lib/server/work-management.ts`) — 함수에 `userId` 전달로 해결.
- **[P2]** `Item.ownerUserId`가 어디서도 채워지지 않아 항상 null(권한 체크에서만 읽힘) — 담당자를 사용자 FK로 갈지 자유 텍스트로 둘지 제품 결정 필요.
- (범위 밖으로 보류) 조직그룹 멤버 추가/제거 UI, Supabase PITR 백업 활성화(플랜 업그레이드 필요할 수 있음), Vercel/Supabase 모니터링 대시보드 구성.

## 실행 / 검증
- run_command: `npm.cmd run local` (foreground, port `3020`)
- verify_command: `npm.cmd run lint`(tsc --noEmit), `npm.cmd run test`(vitest run), `npm.cmd run build`
- port_or_runtime: web `3020`
- deploy_method: **GitHub `mohenz/pmotools` main push + 필요 시 `vercel deploy --prod --yes` → Vercel production 배포**. Vercel 프로젝트 `mohenzs-projects/pmotools`. 전제조건: `package.json`의 `postinstall: prisma generate` 및 Vercel에서 `POSTGRES_URL_NON_POOLING` 우선 사용.
- deploy_check_command: `curl https://<vercel-domain>/api/health`
- deploy_post_check: 로그인(`pmo.admin`) → `/portfolio`, `/calendar`, `/settings/users` 등 핵심 라우트 200 확인
- deploy_invariants: Supabase 연결 정상, Auth.js 로그인 가능, RLS로 anon 키 접근 차단 유지
- deploy_abort_condition: Prisma/Postgres 연결 실패, 로그인 불가
- latest_deployment: `https://pmotools.vercel.app` (2026-08-18, main `cfe0962`, Vercel deployment `dpl_EkJhktWg5fZ9dvTrT6x29346qHfL`) — `/api/health` 200, PostgreSQL 연결 정상, `/announcements` 인증 리다이렉트 정상. 이전 `projectmgmt-tau.vercel.app`은 운영 기준 주소가 아님.
- 이전 배포: 2026-08-07 `vercel deploy --prod` CLI 수동 배포(당시 GitHub 트리거 배포는 실패 상태였음). 배포 직후 `AUTH_SECRET` 미등록으로 로그인 500 → `vercel env add AUTH_SECRET`(production/preview/development) 등록 후 해결.
- 사전 조건: 로컬 Supabase 연결값은 `vercel env pull .env.local`로 받거나 `.env.example` 참고해 `.env.local` 구성. 최초 로그인 계정은 `prisma/seed.ts` 참고(**비밀번호를 이 파일에 기록하지 않는다 — 상태 파일 규칙**).

## 핵심 경로
- project_root: `D:\workspace\projectmgmt`
- key_docs: `README.md`, `docs\PMS_캘린더기반_재개발계획서.md`(현재 기준, Phase 0~7 진행현황 기록), `docs\FIREBASE_FIRESTORE_ARCHITECTURE.md`/`SYSTEM_DESIGN.md`(보관 문서, 상단 배너로 구분), `project_control\design\bloom_ui_design_standard.md`
- key_files: `prisma/schema.prisma`, `lib/server/db-pg.ts`, `lib/server/auth.ts`, `lib/server/calendar.ts`, `lib/domain/recurrence.ts`, `lib/domain/crypto.ts`, `middleware.ts`

## 리스크 / 주의사항
- **🔴 [열림] 저장소가 public이고 `prisma/seed.ts`에 프로덕션 ADMIN 계정 비밀번호가 평문 커밋되어 있다. 프로덕션 URL에 Vercel Deployment Protection도 없어 누구나 관리자로 로그인 가능한 상태다** — "다음 작업" P0 참조.
- `lib/generated/prisma`는 `.gitignore` 대상 — 빌드 환경에서는 반드시 `prisma generate`가 선행돼야 한다(`postinstall`로 보장 중). **이 스크립트를 지우면 자동배포가 다시 깨진다.**
- 이슈·리스크 키워드 검색이 필드별 검색으로 바뀌었다(기존: 제목+설명+담당자를 이어붙인 문자열 검색). 필드 경계를 걸치는 검색어는 매치되지 않는다.
- 주간보고/실적/인력변동의 `areaLabel`이 비활성 업무모듈일 때 `"-"` 대신 실제 라벨로 표시된다.
- Firebase 프로젝트(`projectmgmt-e7dfd`)가 삭제되어 기존 GitHub App Hosting 자동배포 연결도 함께 사라짐 — 배포 경로는 이제 Vercel이 유일하다.
- RLS는 활성화했지만 정책(policy)은 만들지 않았다(anon/authenticated 기본 거부, 앱은 Postgres 소유자 커넥션으로 우회) — 향후 Supabase Auth 기반 클라이언트 접근을 추가한다면 RLS 정책을 별도로 설계해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: 요구사항은 `app/requirements`, `lib/server/requirements.ts`, 공지사항은 `app/announcements`, `lib/server/announcements.ts`, 최신 migration은 `20260818173000_add_announcements`.
- 운영 기준 저장소/서비스는 GitHub `mohenz/pmotools`, Vercel `mohenzs-projects/pmotools`, URL `https://pmotools.vercel.app`이다.

## Handoff
- current_goal: 요구사항 관리·데이터 171건 이관·공지사항 게시판 production 배포 완료. 다음은 운영 UAT와 P0 보안 조치.
- done_latest: 요구사항 필드/상태/공통코드/통계/페이지네이션, 사용자 소프트 삭제, 공지사항 CRUD·중요 고정·대상·게시기간·메인 배너 구현. main `cfe0962`, Supabase 19개 migration, Vercel production 배포 완료.
- key_findings: 원격 이관 검증 시 셸의 로컬 `DATABASE_URL`이 production 환경보다 우선되는 문제가 있었고, `--use-process-env`에서 `POSTGRES_PRISMA_URL`을 우선하도록 수정(`a4f82db`). Vercel 빌드·런타임도 production DB 우선순위로 보정(`0bc88f0`, `0b4b248`).
- changed_files: 요구사항/사용자/공지사항 관련 App Router 페이지·API·screens·server 모듈, `prisma/schema.prisma`, migration 5개, 메뉴·전역 스타일.
- verification: `tsc --noEmit`, Vitest 26/26, Next production build 통과. production `/api/health` 200, PostgreSQL connected. 요구사항 production 171건 확인.
- next_action: ① 공지사항 등록·메인 노출 UAT ② 요구사항 목록·통계 UAT ③ `pmo.admin` 비밀번호/seed 평문 문제 등 P0 보안 조치 ④ 기존 감사로그 actor 누락 점검.
- risks_or_blockers: `required_decision` — 저장소 public 유지 여부 / production 접근 보호 정책 / `Item.ownerUserId` 담당자 모델. 공지사항은 스키마·기능만 배포되어 실제 운영 공지는 관리자가 등록해야 함.
- do_not_do: `package.json`의 `postinstall` 제거 금지(자동배포 즉시 중단됨)
