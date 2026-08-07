# PMO CONTROL(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-07`
- owner_request: `Firebase(Firestore/App Hosting)를 완전히 제거하고 Supabase(PostgreSQL)+Prisma+Auth.js로 전환, docs/calendar 스펙 수준으로 캘린더 고도화(Phase 3~7), 원격(Vercel) 배포`
- current_status: `Firebase→Supabase 전환 및 캘린더 고도화(Phase 0~7) 전부 완료. Firebase 프로젝트(projectmgmt-e7dfd) 삭제됨(사용자 조치, App Hosting URL 404 확인). GitHub main push 완료(commit 0807140) + Vercel 프로덕션 배포 완료 및 검증(https://projectmgmt-tau.vercel.app).`
- design_standard: `project_control\design\bloom_ui_design_standard.md` — 이 프로젝트의 UI는 이 문서를 필수 표준으로 따른다 (임의 해석 금지, 문서 내용 그대로 적용)

## 현재 목표
- GitHub `mohenz/projectmgmt` main에 111개 변경 파일 커밋+push, Vercel 프로덕션 배포, 배포 후 헬스체크.

## 최근 완료 작업 (2026-08-07 세션)
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
- GitHub main commit+push, Vercel `vercel deploy --prod` 실행 및 헬스체크(`/api/health`).
- (범위 밖으로 보류) 조직그룹 멤버 추가/제거 UI, Supabase PITR 백업 활성화(플랜 업그레이드 필요할 수 있음), Vercel/Supabase 모니터링 대시보드 구성.

## 실행 / 검증
- run_command: `npm.cmd run local` (foreground, port `3020`)
- verify_command: `npm.cmd run lint`(tsc --noEmit), `npm.cmd run test`(vitest run), `npm.cmd run build`
- port_or_runtime: web `3020`
- deploy_method: `vercel deploy --prod` (Vercel 프로젝트 `mohenzs-projects/projectmgmt`), GitHub `mohenz/projectmgmt` main과 연동됨(Preview 자동배포)
- deploy_check_command: `curl https://<vercel-domain>/api/health`
- deploy_post_check: 로그인(`pmo.admin`) → `/portfolio`, `/calendar`, `/settings/users` 등 핵심 라우트 200 확인
- deploy_invariants: Supabase 연결 정상, Auth.js 로그인 가능, RLS로 anon 키 접근 차단 유지
- deploy_abort_condition: Prisma/Postgres 연결 실패, 로그인 불가
- latest_deployment: `https://projectmgmt-tau.vercel.app` (2026-08-07, `vercel deploy --prod`) — 헬스체크/로그인/핵심 라우트(portfolio, calendar, items, settings/users, messages) 전부 정상 확인. 배포 직후 `AUTH_SECRET`이 Vercel 환경변수에 없어 로그인 500 에러 발생 → `vercel env add AUTH_SECRET`(production/preview/development)로 등록 후 재배포하여 해결.
- 사전 조건: 로컬 Supabase 연결값은 `vercel env pull .env.local`로 받거나 `.env.example` 참고해 `.env.local` 구성. 최초 로그인 계정은 `prisma/seed.ts` 참고(`pmo.admin` / `ChangeMe!2026`, 최초 로그인 후 변경 필요).

## 핵심 경로
- project_root: `D:\workspace\projectmgmt`
- key_docs: `README.md`, `docs\PMS_캘린더기반_재개발계획서.md`(현재 기준, Phase 0~7 진행현황 기록), `docs\FIREBASE_FIRESTORE_ARCHITECTURE.md`/`SYSTEM_DESIGN.md`(보관 문서, 상단 배너로 구분), `project_control\design\bloom_ui_design_standard.md`
- key_files: `prisma/schema.prisma`, `lib/server/db-pg.ts`, `lib/server/auth.ts`, `lib/server/calendar.ts`, `lib/domain/recurrence.ts`, `lib/domain/crypto.ts`, `middleware.ts`

## 리스크 / 주의사항
- Firebase 프로젝트(`projectmgmt-e7dfd`)가 삭제되어 기존 GitHub App Hosting 자동배포 연결도 함께 사라짐 — 배포 경로는 이제 Vercel이 유일하다.
- RLS는 활성화했지만 정책(policy)은 만들지 않았다(anon/authenticated 기본 거부, 앱은 Postgres 소유자 커넥션으로 우회) — 향후 Supabase Auth 기반 클라이언트 접근을 추가한다면 RLS 정책을 별도로 설계해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs\PMS_캘린더기반_재개발계획서.md`의 "진행 현황" 표(Phase 0~7 전부 완료로 기록됨)와 "남은 것" 절.
- 확인이 필요한 미결사항: Vercel 배포 URL과 결과를 이 상태 파일의 `latest_deployment`에 기록할 것.

## Handoff
- current_goal: GitHub push + Vercel 프로덕션 배포 완료
- done_latest: Firebase→Supabase 전체 전환 + 캘린더 고도화(Phase 0~7) 완료, Firebase 프로젝트 삭제 확인
- key_findings: Supabase RLS 미설정 시 anon 키로 REST API를 통해 민감 테이블이 노출되는 구조적 위험 발견 및 차단
- changed_files: 111개 (신규 Prisma/Auth.js/캘린더 고도화/관리자 화면/쪽지/첨부파일/엑셀 관련 파일, Firebase 관련 파일 삭제)
- verification: tsc/vitest/next build 전부 통과, ADMIN/MEMBER 권한 분리 e2e 확인
- next_action: commit+push, `vercel deploy --prod`, 배포 후 헬스체크
- risks_or_blockers: 없음(Firebase 잔여 리스크 해소됨)
