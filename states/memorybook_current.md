# memorybook Current State

## 기본 정보
- project_key: memorybook
- last_updated: 2026-08-05
- project_root: `D:\workspace\memorybook`
- owner_request: `personalMemo` 복제 소스를 Supabase 데이터 환경과 Vercel 배포 환경을 사용하는 독립 프로그램으로 리뉴얼
- current_status: Supabase Auth/Postgres/비공개 Storage 전환, 원격 DB 스키마 적용, 초기 계정 생성, 자료실 흰 화면 수정, 전체 테스트·빌드, GitHub `main` 게시 완료. Vercel 프로덕션 배포만 남음.

## 현재 목표
- GitHub의 `mohenz/memorybook`을 Vercel에 연결하고 Supabase 공개 환경변수를 등록하여 프로덕션 배포 완료.

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
- latest_commit: `8ac7ef8 Supabase와 Vercel 기반 memorybook 전환`
- status_before_state_record: clean
- ignored_sensitive_paths: `.env.local`, `config/*.cfg`, `backups/`, `node_modules/`, `dist/`, `test-results/`

## Vercel
- config: `vercel.json` 준비 완료
- output: `dist`
- SPA rewrite: 설정 완료
- `.vercel/`: 없음
- global_vercel_cli: 미설치
- production_url: 없음
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
1. Vercel 프로젝트와 GitHub 저장소 연결.
2. Supabase 공개 환경변수 3개를 Production/Preview/Development에 등록.
3. Vercel 프로덕션 배포와 운영 URL 검증.
4. 선택 작업: Transaction Pooler 비밀번호 교정, Supabase MCP 독립 저장소 범위 재등록.

## 리스크 / 중단 조건
- Vercel 프로젝트와 운영 URL이 아직 없음.
- CLI DB 작업은 Pooler 인증 복구 전 실행 불가.
- 비밀값은 `.env.local`과 `config/memorybook.cfg` 밖에 기록 금지.
- DB 스키마·데이터 변경은 사용자 명시 승인 전 실행 금지.
- 테스트 실패, 환경변수 누락, Git dirty/divergent/no-upstream이면 배포 중단.

## Handoff
- current_goal: Vercel 프로덕션 배포 완료
- done_latest: 전체 프로젝트 상태 재검증 및 중앙/저장소 인수인계 문서 갱신
- next_action: Vercel 프로젝트 연결과 공개 환경변수 등록
- blockers: Vercel 미연결; 선택적 DB CLI/MCP 연결 미복구
