# memorybook Current State

## 기본 정보
- project_key: memorybook
- last_updated: 2026-08-14
- project_root: `D:\workspace\memorybook`
- owner_request: `personalMemo` 복제 소스를 Supabase 데이터 환경과 Vercel 배포 환경을 사용하는 독립 프로그램으로 리뉴얼
- current_status: 신규 PC에 워크스페이스를 재구성하고 저장소를 클론·기동. 캘린더 보기 전환 UI를 드롭다운에서 버튼 그룹으로 교체해 프로덕션 배포까지 완료. 로컬·GitHub·프로덕션이 모두 `e4b27df`로 일치.

## 현재 목표
- 운영 중인 캘린더·메모·독립 TO-DO 기능의 데이터 동기화 안정성을 점검하고 모바일 카메라 촬영 기능을 후속 구현.

## 완료 상태
- Firebase SDK·Auth·Firestore·Storage 호출 제거.
- Supabase Auth 통합 로그인과 비밀번호 재설정 적용.
- `memo_states` JSONB 상태 저장과 `archive_files` 자료실 메타데이터 적용.
- 비공개 Storage `memorybook-files`와 서명 URL 흐름 적용.
- RLS 테이블 2개, 정책 11개, Storage 50MB 제한, `archive_files` Realtime 검증.
- 초기 Auth 계정 1개 생성·이메일 확인·로그인 검증.
- 데스크톱·모바일 동시 마운트 Realtime 채널 충돌 수정.
- TypeScript, Vitest 91건, Jest 13건, Playwright 4건, 실제 자료실 진입, Vite build 통과.
- GitHub `main` 최초 커밋 `8ac7ef8` 푸시 및 upstream 연결.
- Vercel 사전검증 통과, Secret/Pooler 번들 미포함 확인.
- Vercel 프로덕션 `https://memorybook-theta.vercel.app` 배포 완료.
- 2026-08-11 원격 `main` 11커밋 fast-forward 동기화 완료. 기존 로컬 Sidebar 스크롤 변경 의도는 원격 최신 구현에 포함되어 작업 트리 clean 유지.

### 2026-08-11 추가 작업 (Claude Code)
- `8b7544a` 모바일 하단 탭바 이동 불가 버그 수정. 첫 화면이 `CALENDAR`인데 모바일 레이아웃은
  `screen === 'DASHBOARD'`일 때만 `MobileAppShell`을 렌더링해, 사이드바(`hidden md:flex`)도
  하단 탭바도 없는 상태로 사용자가 갇혔다. `SCREEN_TO_MOBILE_TAB` 매핑을 도입해 탭이 있는 모든
  화면에서 셸을 렌더링하고 오버레이 분기를 `SEARCH`로 좁혔다. 도달 불가였던 `MobileCalendarScreen`이
  이제 실제로 사용된다.
- `fa049fb` 일정 목록(agenda) 오늘 날짜 자동 포커싱. 날짜 섹션에 `data-agenda-date` 앵커를 부여하고
  진입 시 오늘 위치로 스크롤. 오늘 일정이 없으면 이후 가장 가까운 일정으로 이동하고, 과거 달은 맨 위 유지.
  오늘 섹션에 테두리·배경 강조와 `오늘` 배지, `aria-current="date"` 적용.
- `1f0de88` 배포 사후검증을 번들 해시 비교에서 커밋 리비전 비교로 교체. Vercel은 의존성을 새로 설치해
  빌드하므로 산출 번들이 로컬과 바이트 단위로 달라져(로컬 659,599 / 원격 661,893 bytes) 정상 배포에도
  검증이 실패했다. `vite.config.ts`의 `build-commit-meta` 플러그인이 `<meta name="build-commit">`를
  주입하고, 배포 전후로 HEAD와 대조한다.
- `efcfb53` Windows에서 배포 스크립트가 Vercel CLI를 실행하지 못하던 문제 수정. Node가 보안상 `.cmd`
  셸 심을 직접 spawn하지 않아 `npx.cmd`가 EINVAL로 실패하고 출력 없이 종료 코드 1만 반환했다.
- Vercel 프로덕션 2회 배포 완료(`dpl_5brauR8...` → `8b7544a`, `dpl_5mNkcZ9...` → `efcfb53`).
- 사후검증 통과: `Vercel 운영 배포 검증 통과: HTTP 200, commit=efcfb53...`.

### 2026-08-14 추가 작업 (Claude Code)
- **신규 PC 환경 구성**: `workspace_installer`로 워크스페이스 이관 후 이 저장소를 클론(`204d2a3` 기준),
  `npm ci` 509개 설치, 타입 체크·Vitest 123건·Jest 13건 통과 확인. 취약점 0건.
- **환경변수 복구 이슈**: `vercel env pull`로는 필수 3개 변수를 받을 수 없다. Vercel에 **Sensitive 타입**으로
  등록돼 있어 값 대신 `"[SENSITIVE]"` 문자열이 내려온다. 또한 세 변수가 Preview/Production 환경에만 있고
  Development에는 없어 `--environment=development` 풀은 빈 결과가 된다.
  `VITE_SUPABASE_URL`·`VITE_SUPABASE_PUBLISHABLE_KEY`는 사용자가 직접 입력, `VITE_DATA_BACKEND=supabase`는
  `.env.example` 값으로 복구했다.
- `c07c87f` `.gitignore`에 `.env*` 추가(`vercel link`가 넣은 `.env.local` 범위를 확장).
- `e4b27df` 캘린더 보기 전환을 드롭다운(`<select>`)에서 버튼 그룹으로 교체. `일`·`주`·`월`·`년` 텍스트 버튼
  4개와 일정 목록(agenda) 아이콘 버튼(lucide `List`)으로 분리했다. 헤더의 검색창·새 일정 버튼과 동일하게
  `h-8 rounded-xl` 규격을 맞추고 선택 상태는 primary 채움으로 표시한다. `select` 제거에 따른 접근성 보완으로
  컨테이너에 `role="group"`+`aria-label`, 각 버튼에 `aria-pressed`, 아이콘 버튼에 `aria-label`을 부여했다.
  툴바 레이아웃 테스트가 `select`/`option` 마크업을 문자열 검증하고 있어 버튼 구조에 맞춰 갱신했다.
- Vercel 프로덕션 자동 배포 완료(`dpl_5Z2DeGkd8a56torMGeQhDTVgcHiw` → `e4b27df`, Ready, 빌드 9초).
  GitHub 배포 기록(`2026-08-14T04:10:58Z`, Production)과 Vercel 배포 생성 시각이 일치함을 확인.

## 현재 런타임
- run_command: `npm.cmd run dev`
- local_url: `http://127.0.0.1:3030`
- observed_status: RUNNING (2026-08-11 세션에서 기동, Vite v6.4.3)
- observed_process: `vite --port=3030 --host=0.0.0.0`
- backend: `supabase`

## Supabase
- project_name: memorybook
- project_ref: `bmvyiwnokuhbkjtimygy`
- API URL: `https://bmvyiwnokuhbkjtimygy.supabase.co`
- tables: `memo_states`, `archive_files`
- RLS: 2개 테이블 활성화
- policy_count: 11
- storage_bucket: `memorybook-files`, private, 50MB
- realtime: `archive_files` 활성화
- data_counts_at_verify: `memo_states=0`, `archive_files=0`
- auth_users_at_current: 1
- migration: `supabase/migrations/202608050001_initial_memorybook.sql`
- local_env: 필수 공개 변수 3개 설정 확인
- db_cli: Transaction Pooler 비밀번호 인증 실패, 대시보드 SQL Editor로 마이그레이션 적용 완료
- mcp: 이전 읽기 전용 연결 기록은 있으나 현재 독립 저장소 컨텍스트의 `codex mcp list`에는 미노출

## Git
- remote: `https://github.com/mohenz/memorybook.git`
- branch: `main`
- upstream: `origin/main`
- latest_commit: `e4b27df 캘린더 보기 전환을 드롭다운에서 버튼 그룹으로 변경`
- status_before_state_record: clean (로컬 `main` = `origin/main` = 프로덕션 리비전)
- local_git_identity: 이 저장소에만 `mohenz <smallville71@gmail.com>` 설정(전역 미설정 PC라 커밋 실패를 막기 위함)
- ignored_sensitive_paths: `.env.local`, `config/*.cfg`, `backups/`, `node_modules/`, `dist/`, `test-results/`

## Vercel
- config: `vercel.json` 준비 완료
- output: `dist`
- SPA rewrite: 설정 완료
- `.vercel/`: 있음 (`vercel link --project memorybook --scope mohenzs-projects`로 생성, gitignore 대상)
- global_vercel_cli: 미설치 (`npx vercel` 사용, 2026-08-14 기준 59.0.0), 인증 계정 `smallville71-3378` / `mohenzs-projects`
- production_url: `https://memorybook-theta.vercel.app`
- deployed_revision: `e4b27df` (Vercel 배포 `dpl_5Z2DeGkd8a56torMGeQhDTVgcHiw` Ready + GitHub 배포 기록 대조로 확인.
  운영 HTML `build-commit` 마커 대조는 2026-08-14 세션에서 미실행)
- git_integration: **활성**. `git push origin main`만으로 프로덕션 자동 배포가 생성된다.
  런북 4단계 CLI 배포는 실질적으로 중복이므로 정리 여부 검토 필요.
- required_env: `VITE_DATA_BACKEND`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`
- build_env: `VITE_BUILD_COMMIT` (CLI 배포 시 `scripts/deploy-vercel.mjs`가 전달).
  Git 연동 자동 배포에서는 `VERCEL_GIT_COMMIT_SHA` 폴백이 동작하며 양쪽 모두 검증 완료.
- deploy_command: `npm.cmd run deploy:vercel`
- precheck_command: `npm.cmd run deploy:check`
- postcheck_command: `VERCEL_PRODUCTION_URL=https://...` 설정 후 `node scripts/verify-deployment.mjs`

## 핵심 경로
- docs: `README.md`, `docs/technical_architecture.md`, `docs/deployment_runbook.md`, `docs/codex_handover.md`
- app: `src/App.tsx`, `src/supabase/client.ts`, `src/services/archiveIntegration.ts`
- archive: `src/archiveStore/features/archive/archiveService.js`, `src/archiveStore/views/ArchiveView.jsx`
- database: `supabase/migrations/202608050001_initial_memorybook.sql`, `scripts/supabase-db.mjs`
- mobile: `src/mobile/MobileAppShell.tsx`, `src/mobile/MobileBottomNav.tsx`, `src/mobile/screens/MobileCalendarScreen.tsx`
- calendar: `src/components/CalendarView.tsx`, `src/components/calendar/AgendaCalendarScreen.tsx`
- deployment: `vercel.json`, `vite.config.ts`, `scripts/check-deployment.mjs`, `scripts/deploy-vercel.mjs`, `scripts/verify-deployment.mjs`

## 남은 작업
1. 다중 클라이언트 상태 저장 순서와 독립 TO-DO 동기화 경합 가능성 점검.
2. 모바일 카메라 촬영 기능 후속 구현.
3. Vercel Git 연동 자동 배포와 런북의 CLI 배포 단계 중복 정리 여부 결정.
4. agenda 자동 스크롤은 SSR 단위 테스트로 검증 불가하므로, 필요 시 브라우저 기반 회귀 테스트 추가 검토.
5. 선택 작업: Transaction Pooler 비밀번호 교정, Supabase MCP 독립 저장소 범위 재등록.

## 리스크 / 중단 조건
- CLI DB 작업은 Pooler 인증 복구 전 실행 불가.
- 비밀값은 `.env.local`과 `config/memorybook.cfg` 밖에 기록 금지.
- DB 스키마·데이터 변경은 사용자 명시 승인 전 실행 금지.
- 테스트 실패, 환경변수 누락, Git dirty/divergent/no-upstream이면 배포 중단.

## Handoff
- current_goal: 운영 데이터 동기화 안정성 점검 및 모바일 카메라 촬영 기능 후속 구현
- done_latest: 신규 PC 환경 구성(클론·`npm ci`·환경변수 복구), 캘린더 보기 전환 UI를 버튼 그룹으로 교체(`e4b27df`),
  `.gitignore` 확장(`c07c87f`) 후 GitHub 자동 배포로 프로덕션 반영 완료
- verification: TypeScript, Vitest 123건, Jest 13건 통과. dev 서버 HMR 반영 확인, 사용자가 브라우저에서 데이터
  정상 표시 확인. 로컬 main = origin/main = 프로덕션 = `e4b27df`
- key_finding: **Vercel의 Sensitive 타입 환경변수는 `env pull`로 값을 되받을 수 없다**(`"[SENSITIVE]"` 반환).
  이 프로젝트의 필수 3개 변수가 여기에 해당하며 Development 환경에도 등록돼 있지 않다. 신규 PC 세팅 시
  Supabase 대시보드에서 키를 직접 가져와야 한다.
- next_action: 독립 TO-DO 다중 클라이언트 동기화 경합 점검. 모바일 화면(`MobileCalendarScreen`)은
  이번 보기 전환 UI 변경 대상에서 제외했으므로 동일 적용 여부 결정 필요
- blockers: 선택적 DB CLI/MCP 연결 미복구
- do_not_do: `states/*.md`의 다른 프로젝트 항목(flowerocr, jina_tts, project_registry 등)에는
  2026-08-11 기준 다른 에이전트의 미커밋 변경이 있으므로 임의 커밋 금지
