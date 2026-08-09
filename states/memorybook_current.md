# memorybook Current State

## 기본 정보
- project_key: memorybook
- last_updated: 2026-08-10
- project_root: `D:\workspace\memorybook`
- owner_request: `personalMemo` 복제 소스를 Supabase 데이터 환경과 Vercel 배포 환경을 사용하는 독립 프로그램으로 리뉴얼
- current_status: 캘린더 선택 날짜 패널의 TO-DO·지연 상태 개선과 메인 화면 전체 일정 고정을 커밋 `8bed2c9`로 게시하고 Vercel 프로덕션 배포 완료. 배포 결과 기록 커밋 `3b549c1`까지 `origin/main` 동기화.

## 현재 목표
- GitHub의 `mohenz/memorybook`을 Vercel에 연결하고 Supabase 공개 환경변수를 등록하여 프로덕션 배포 완료.

## 사건 기록 — 2026-08-09 personal_memo에 작업이 잘못 적용됨
- **문제**: `memorybook-theta.vercel.app` 화면 기준으로 들어온 UI 수정 요청 2건(설정 탭 이름 잘림, 그룹 선택형 변경)이 `memorybook`이 아니라 `personalMemo` 저장소에 적용되거나 잘못 회신됨.
- **원인**: 두 프로젝트가 공통 조상에서 갈라진 별개 운영 대상이라는 점을 인지하지 못하고, URL을 `project_registry.md`에서 project_key로 매핑하지 않은 채 작업 디렉토리를 대상으로 가정함.
- **부수 오판**: 라이브 번들 대조에서 나온 차이(upstream 커밋 부재, 칩 UI 존재, Firebase 데이터 프로젝트 마커 부재)를 "유령 배포"로 해석해 Vercel 연결 해제를 권고함. 실제로는 Supabase 기반 독립 배포로 정상.
- **확인된 사실**: `memorybook-theta.vercel.app`은 HTTP 200으로 서비스 중이며 번들은 `assets/index-CUnD03HE.js`. 상태 파일의 `production_url: 없음` 기재는 실제와 어긋나므로 아래 Vercel 섹션에서 갱신함.
- **재발 방지**: UI 요청은 URL로 프로젝트를 먼저 판별한다. `memorybook-theta.vercel.app` → memorybook, `archive-store-fae71.web.app` → personal_memo. 로컬은 포트로 구분(memorybook 3030, personalMemo 3000).
- **남은 작업**: memorybook에서 설정 탭 잘림 수정과 그룹 칩 → 선택형 변경을 수행.

## 완료 상태
- 2026-08-10 독립 `TodoItem` 데이터, 목표일·잔여일, 수정·삭제·상태 변경, 기존 체크리스트 자동 이전과 Supabase JSON 상태 저장을 구현.
- 2026-08-10 캘린더 `일정` 보기, 날짜별 일정·TO-DO 게시, 리마인드 발생 날짜 표시, 선택 날짜의 일정·메모 추가 버튼을 구현.
- 2026-08-10 커밋 `cd509af`, `0943797`을 `origin/main`에 푸시하고 `https://memorybook-theta.vercel.app` 프로덕션 배포 및 신규 기능 번들 포함을 검증.
- 2026-08-10 선택 날짜 패널에 TO-DO 영역을 추가하고 미래 미완료·과거 지연 항목 표시를 구현. TypeScript 및 Vitest 121건 통과 후 커밋 `8bed2c9`에 포함해 배포.
- 2026-08-10 메인 진입 화면과 데스크톱 프로필 사진 이동 대상을 전체 일정 화면으로 변경하고, 캘린더 첫 보기를 `일정` 모드로 지정했으며 모바일 기본 탭도 캘린더로 변경.
- 2026-08-10 후속 캘린더 TO-DO 개선과 메인 일정 화면 변경을 커밋 `8bed2c9`로 `origin/main`에 푸시하고 Vercel 프로덕션 배포 완료. 운영 번들 `assets/index-mqHRxSNv.js`에서 변경 문구와 Supabase 프로젝트 식별자 포함을 확인.
- 2026-08-08 원격 변경 4개 커밋(`6a5102a`~`1b397a2`) fast-forward 반영.
- 최근 변경: UI 컴팩트화·그룹 선택 개선, 메모 목록 정렬 및 동률 정렬 수정, TO-DO LIST 추가, 그룹 폴더 우선순위 및 캘린더 시간축 라벨 색상 개선.
- Firebase SDK·Auth·Firestore·Storage 호출 제거.
- Supabase Auth 통합 로그인과 비밀번호 재설정 적용.
- `memo_states` JSONB 상태 저장과 `archive_files` 자료실 메타데이터 적용.
- 비공개 Storage `memorybook-files`와 서명 URL 흐름 적용.
- RLS 테이블 2개, 정책 11개, Storage 50MB 제한, `archive_files` Realtime 검증.
- 초기 Auth 계정 1개 생성·이메일 확인·로그인 검증.
- 데스크톱·모바일 동시 마운트 Realtime 채널 충돌 수정.
- TypeScript, Vitest 121건, Jest 13건, Playwright 4건, 실제 자료실 진입, Vite build 통과.
- GitHub `main` 최초 커밋 `8ac7ef8` 푸시 및 upstream 연결.
- Vercel 사전검증 통과, Secret/Pooler 번들 미포함 확인.

## 현재 런타임
- run_command: `npm.cmd run dev`
- local_url: `http://127.0.0.1:3030`
- observed_status: STOPPED (`scripts/check-development-ports.ps1` 기준)
- observed_process: 없음
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
- latest_commit: `3b549c1 배포 결과 기록` (기능 커밋 `8bed2c9`)
- status_before_state_record: clean, `main...origin/main`
- ignored_sensitive_paths: `.env.local`, `config/*.cfg`, `backups/`, `node_modules/`, `dist/`, `test-results/`

## Vercel
- config: `vercel.json` 준비 완료
- output: `dist`
- SPA rewrite: 설정 완료
- `.vercel/`: 로컬 연결 완료, `.gitignore` 제외
- global_vercel_cli: `npx.cmd --yes vercel` 사용
- production_url: `https://memorybook-theta.vercel.app` (2026-08-10 HTTP 200, 번들 `assets/index-mqHRxSNv.js`, 전체 일정 메인 화면·캘린더 TO-DO 개선·Supabase 프로젝트 식별자 포함 확인)
- required_env: `VITE_DATA_BACKEND`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`
- deploy_command: `npm.cmd run deploy:vercel`
- precheck_command: `npm.cmd run deploy:check`
- postcheck_command: `VERCEL_PRODUCTION_URL=https://...` 설정 후 `node scripts/verify-deployment.mjs`

## 핵심 경로
- docs: `README.md`, `docs/technical_architecture.md`, `docs/deployment_runbook.md`, `docs/codex_handover.md`
- app: `src/App.tsx`, `src/supabase/client.ts`, `src/services/archiveIntegration.ts`
- archive: `src/archiveStore/features/archive/archiveService.js`, `src/archiveStore/views/ArchiveView.jsx`
- database: `supabase/migrations/202608050001_initial_memorybook.sql`, `scripts/supabase-db.mjs`
- deployment: `vercel.json`, `scripts/check-deployment.mjs`, `scripts/verify-deployment.mjs`

## 남은 작업
1. TO-DO가 일시적으로 0건 저장된 동기화 경합 가능성을 재현하고 비파괴 저장 보호 로직 검토.
2. 메모 사진 촬영·첨부 기능 작업계획에 따른 구현 여부 결정.
3. 선택 작업: Transaction Pooler 비밀번호 교정, Supabase MCP 독립 저장소 범위 재등록.

## 리스크 / 중단 조건
- 2026-08-10 진단 중 Supabase 상태가 `notes=30`, `todos=0`, 기존 체크리스트 `0`으로 관찰됐으나 이후 새 브라우저 세션에서 TO-DO 7개가 다시 로딩됨. 다중 클라이언트의 마지막 쓰기 우선 저장 또는 초기 로딩 경합 가능성이 있어 데이터 보호 로직 확인 전 대규모 상태 변경을 주의한다.
- 2026-08-08 `npm.cmd run deploy:check`는 로컬 의존성 미설치로 `tsc`를 찾지 못해 lint 단계에서 중단됨. 검증 재개 전 `npm ci`가 필요함.
- Vercel 프로젝트와 운영 URL이 아직 없음.
- CLI DB 작업은 Pooler 인증 복구 전 실행 불가.
- 비밀값은 `.env.local`과 `config/memorybook.cfg` 밖에 기록 금지.
- DB 스키마·데이터 변경은 사용자 명시 승인 전 실행 금지.
- 테스트 실패, 환경변수 누락, Git dirty/divergent/no-upstream이면 배포 중단.

## Handoff
- current_goal: 배포된 전체 일정 메인 화면과 캘린더 TO-DO 표시를 안정 운영하고 동기화 데이터 보호 확인
- done_latest: 커밋 `8bed2c9` 원격 게시 및 Vercel 프로덕션 배포, 운영 번들 직접 검증
- next_action: 다중 클라이언트 TO-DO 상태 저장 경합 재현 및 비파괴 저장 보호 로직 검토
- blockers: 기능 배포 블로커 없음. DB CLI/MCP 연결은 선택적으로 미복구
