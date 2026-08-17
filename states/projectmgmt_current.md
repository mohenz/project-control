# PMOTOOLS(projectmgmt) 프로젝트 현재 상태

## 기본 정보
- project_key: `projectmgmt`
- last_updated: `2026-08-17`
- owner_request: `Git 원격 저장소 이전(github.com/mohenz/projectmgmt → github.com/mohenz/pmotools) 및 Vercel 신규 배포, 밀린 로컬 변경사항 전체 커밋/배포`
- current_status: `백엔드가 Firebase/Firestore에서 Prisma + PostgreSQL(Supabase)로 전환된 상태에서, Git 원격/GitHub 저장소를 새 이름(pmotools)으로 이전하고 Vercel에 신규 배포까지 완료. 브랜딩도 "PMO CONTROL" → "PMOTOOLS"로 변경.`

## ⚠️ 아키텍처 대전환 (이전 상태 파일 기준과 다름, 주의)
이전 기록(2026-08-06)은 Firebase Admin SDK/Cloud Firestore + Firebase App Hosting 기준으로 작성되어 있었으나, 그 사이 세션에서 **Prisma + PostgreSQL(로컬은 Docker, 프로덕션은 Supabase) 스택으로 전면 전환**되었다. `lib/server/db-pg.ts`, `prisma/schema.prisma`, `prisma.config.ts`(Prisma 7, `@prisma/adapter-pg`)가 현재 기준이며, Firebase 관련 문서(`docs/FIREBASE_FIRESTORE_ARCHITECTURE.md`)는 더 이상 실제 아키텍처를 반영하지 않는 과거 자료로 취급해야 한다.

## 저장소 / 원격 (이번 세션에서 변경됨)
- GitHub 저장소가 `mohenz/projectmgmt` → **`mohenz/pmotools`**로 신규 생성/이전됨 (사용자가 GitHub에서 직접 이름 변경 시도 후 최종적으로 새 레포로 재생성).
- 로컬 `origin` remote URL을 `https://github.com/mohenz/pmotools.git`로 갱신 완료.
- `main` 브랜치 로컬↔원격 완전 동기화 (`HEAD: 0fd28e8`). 다른 로컬 브랜치(`agent/firebase-runtime-config`, `agent/supabase-preparation`, `backup/local-ant-design-before-origin-sync-20260813`, `mohenz/explore-ant-design-pro`)는 새 레포에 아직 푸시되지 않음(필요 시 추가 푸시 필요).
- 참고: `vercel link` 과정에서 실수로 빈 Vercel 프로젝트 `projectmgmt`가 하나 더 생성됨 — 사용자가 직접 정리하기로 함(에이전트가 삭제하지 않음).

## 배포 (Vercel, 신규)
- Vercel 프로젝트: `mohenzs-projects/pmotools`
- 서비스 URL: `https://pmotools.vercel.app` (200 확인, 로그인/신규 기능 API까지 curl로 검증 완료)
- GitHub `mohenz/pmotools`의 `main`과 연동되어 push 시 자동 재배포.
- DB: Vercel Marketplace를 통해 신규 Supabase 프로젝트(`supabase-beige-blanket`) 연결. `POSTGRES_PRISMA_URL`/`POSTGRES_URL_NON_POOLING` 등은 Vercel이 "Sensitive" 타입으로 관리해 `vercel env pull`로도 평문이 노출되지 않음(로컬에서 직접 마이그레이션 불가능한 구조).
- `AUTH_SECRET`을 신규 생성해 Production 환경변수로 별도 등록 완료(Supabase 연동으로는 채워지지 않는 값).
- `next.config.ts`의 `output: "standalone"`을 제거함 — 이 옵션이 Vercel 배포 시 "No Output Directory named public" 빌드 오류의 원인이었음(Vercel은 자체 서버리스 패키징을 쓰므로 self-host/Docker 전용인 이 옵션이 불필요·유해).
- `package.json`에 `"vercel-build": "prisma migrate deploy && next build"` 추가 — Sensitive 환경변수는 로컬로 못 꺼내오므로, 마이그레이션을 Vercel 빌드 컨테이너 내부에서 실행하도록 구조를 바꿈. **매 배포마다 자동으로 `prisma migrate deploy`가 실행되니, 향후 위험한/파괴적인 마이그레이션 파일을 만들 때는 이 점을 반드시 감안해야 한다.**
- 최초 1회에 한해 `vercel-build`에 `prisma db seed`를 임시로 추가해 실행 후 다시 제거함(시드 스크립트는 이미 데이터가 있으면 스킵하는 멱등 구조 — 이번 실행 시 "이미 존재함"으로 스킵됨. 즉 이 Supabase DB에는 이전부터 동일 고정 UUID의 데모 프로젝트/관리자 계정이 있었던 것으로 보임).

## 이번 세션에 커밋/배포된 내용
로컬에 오래 쌓여있던 미커밋 변경사항 90개 파일을 전부 커밋 후 푸시함:
- 요구사항(변경) 관리 화면·API·도메인 로직 신규 추가 (`app/requirements`, `features/requirements`, `lib/domain/requirements.ts` 등)
- 비밀번호 재설정 요청 플로우 신규 추가 (`app/reset-password`, `app/api/auth/reset-password-request`, `lib/server/password-reset-requests.ts`)
- 사이드바 메뉴 개인화(menu-preferences) 기능 신규 추가
- 마이페이지(프로필) 화면 및 API 신규 추가
- 회의실 예약/정기회의 승인 화면 리팩터링 (`RecurringApprovalScreen`, `RoomManagementScreen` 등)
- 캘린더 이벤트 첨부파일 기능 제거 (Supabase storage 연동 `lib/server/storage.ts` 및 관련 라우트 삭제 — 의도된 기능 축소로 보이며 별도 재확인은 안 함)
- 브랜딩 변경: "PMO CONTROL" → "PMOTOOLS" (`app/layout.tsx` 타이틀/사이드바, `components/ThemeSelector.tsx`, `app/settings/system/page.tsx`). `docs/*.md` 등 내부 문서는 의도적으로 그대로 둠(범위 밖으로 판단).
- 사이드바 라벨 "통합 일정" → "캘린더"로 변경 (`components/AppNavigation.tsx`)
- Prisma 마이그레이션 8건 추가 및 `schema.prisma` 갱신 — 전부 프로덕션 DB에 정상 적용 확인(`prisma migrate status`/빌드 로그로 확인)

## 검증 결과 (curl 기반, 브라우저 확장 미설치 상태라 API 레벨로 검증)
- NextAuth credentials 플로우(csrf → callback/credentials → session)로 로그인 성공 확인: `pmo.admin`(ADMIN 권한) 세션 정상 생성.
- 200 확인된 신규 API: `/api/v1/requirements`, `/api/v1/settings/menu-preferences`, `/api/v1/admin/password-reset-requests`.
- 200 확인된 신규 화면: `/requirements`, `/settings/profile`, `/settings/menu`, `/reset-password`, `/settings/recurring-meetings`, `/settings/meeting-rooms`.
- 실제 쓰기(요구사항 등록 등) 테스트는 프로덕션에 더미 데이터가 남는 것을 피하기 위해 진행하지 않음 — 필요 시 후속 세션에서 수행.

## ⚠️ 후속 조치 필요 (사용자 확인 대기)
- 시드된 관리자 계정 비밀번호가 코드에 평문으로 존재(`pmo.admin` / `ChangeMe!2026`, `prisma/seed.ts`) — 실사용 전 반드시 변경 필요.
- 실수로 생성된 빈 Vercel 프로젝트 `projectmgmt`(mohenzs-projects) 정리는 사용자가 직접 처리하기로 함 — 진행 여부 미확인.
- 새 레포(`pmotools`)에 아직 안 옮겨진 로컬 브랜치 4개(`agent/firebase-runtime-config`, `agent/supabase-preparation`, `backup/local-ant-design-before-origin-sync-20260813`, `mohenz/explore-ant-design-pro`) — 필요 여부 확인 후 푸시할지 결정 필요.
- `docs/FIREBASE_FIRESTORE_ARCHITECTURE.md` 등 Firebase 시절 문서가 현재 아키텍처(Prisma/Supabase)와 맞지 않음 — 문서 정리 필요 시 별도 작업.

## 실행 / 검증 (로컬)
- run_command: `npm run local` 또는 `npm run dev` (포그라운드, 포트 `3020`, Turbopack)
- 로컬 DB: `npm run db:local:start` / `stop` / `status` (Docker 기반 로컬 PostgreSQL, `localhost:55432`)
- verify: `npm run lint`(tsc --noEmit), `npm run test`(vitest run)

## 참고 자산
- README.md, `docs/UI_RENEWAL.MD`
- `project_control\design\bloom_ui_design_standard.md` (UI 디자인 표준, 필수 — 이번 세션 작업은 텍스트/설정 변경 위주라 별도 저촉 없음)
- (과거 자료, 현재 아키텍처와 불일치) `docs/FIREBASE_FIRESTORE_ARCHITECTURE.md`, `SYSTEM_DESIGN.md`
