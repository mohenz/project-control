# memorybook Current State

## 기본 정보
- project_key: memorybook
- last_updated: 2026-08-15
- project_root: `D:\workspace\memorybook`
- owner_request: `personalMemo` 복제 소스를 Supabase 데이터 환경과 Vercel 배포 환경을 사용하는 독립 프로그램으로 리뉴얼
- current_status: 인증 상태 중복 갱신 방지, 설정·사이드바 UX 개선, 로그아웃 중앙 확인 모달, 아젠다 중요 일정 색상 강조를 커밋 `6d2462c`~`1977d7c`로 순차 배포하고 운영 커밋 검증 완료.

## 현재 목표
- 배포된 인증·설정·사이드바·아젠다 UX를 안정 운영하고 다중 클라이언트 상태 저장 경합의 데이터 보호 방안을 검토.

## 사건 기록 — 2026-08-09 personal_memo에 작업이 잘못 적용됨
- **문제**: `memorybook-theta.vercel.app` 화면 기준으로 들어온 UI 수정 요청 2건(설정 탭 이름 잘림, 그룹 선택형 변경)이 `memorybook`이 아니라 `personalMemo` 저장소에 적용되거나 잘못 회신됨.
- **원인**: 두 프로젝트가 공통 조상에서 갈라진 별개 운영 대상이라는 점을 인지하지 못하고, URL을 `project_registry.md`에서 project_key로 매핑하지 않은 채 작업 디렉토리를 대상으로 가정함.
- **부수 오판**: 라이브 번들 대조에서 나온 차이(upstream 커밋 부재, 칩 UI 존재, Firebase 데이터 프로젝트 마커 부재)를 "유령 배포"로 해석해 Vercel 연결 해제를 권고함. 실제로는 Supabase 기반 독립 배포로 정상.
- **확인된 사실**: `memorybook-theta.vercel.app`은 HTTP 200으로 서비스 중이며 번들은 `assets/index-CUnD03HE.js`. 상태 파일의 `production_url: 없음` 기재는 실제와 어긋나므로 아래 Vercel 섹션에서 갱신함.
- **재발 방지**: UI 요청은 URL로 프로젝트를 먼저 판별한다. `memorybook-theta.vercel.app` → memorybook, `archive-store-fae71.web.app` → personal_memo. 로컬은 포트로 구분(memorybook 3030, personalMemo 3000).
- **남은 작업**: memorybook에서 설정 탭 잘림 수정과 그룹 칩 → 선택형 변경을 수행.

## 완료 상태
- 2026-08-15 아젠다에서 중요도 `높음` 일정을 오류색 계열 배경·왼쪽 테두리·텍스트로 구분하고 커밋 `1977d7c`로 Vercel 프로덕션 배포. TypeScript, Vitest 135건, Jest 13건, Playwright 4건, Vite 빌드 및 운영 커밋 마커 검증 통과.
- 2026-08-15 사이드바 하단의 넓은 새 폴더 버튼을 제거하고 도움말·설정·로그아웃을 아이콘 전용 버튼으로 정리. 로그아웃은 화면 중앙 확인 모달에서 확인 시에만 처리하도록 개선해 커밋 `b788f79`로 배포.
- 2026-08-15 설정의 `확인 및 저장` 버튼이 모달을 닫지 않도록 변경하고 커밋 `d648103`으로 배포.
- 2026-08-15 Supabase 토큰 갱신·동일 사용자 인증 이벤트가 클라우드 상태를 중복 로드하지 않도록 필터링하고 테스트를 추가해 커밋 `6d2462c`로 배포.
- 2026-08-15 Supabase Auth를 읽기 전용 확인한 결과 이메일 인증 완료·비차단 상태의 사용자 계정 1개를 확인했으며 비밀번호·토큰은 조회하지 않음.
- 2026-08-12 커밋 `b2a492e`를 `origin/main`에 푸시하고 Vercel Git 연동으로 프로덕션 배포. HTTP 200·운영 커밋 마커·모바일 검색 화면을 검증했으며 운영 자산은 `assets/index-Cjf-ZKvB.js`, `assets/index-C8bm6qRT.css`.
- 2026-08-12 모바일 검색 화면 컨테이너를 축소 가능한 flex 구조로 수정해 하단바가 뷰포트 안에 항상 노출되도록 개선. Vitest 123건, Vite 빌드, 390×844 로컬 렌더링 검증 통과.
- 2026-08-12 검색 화면의 그룹·이미지·즐겨찾기·정렬 필터 버튼 영역을 제거하고 검색어 기반 최신순 결과만 유지. Vitest 123건, Vite 빌드, 로컬 렌더링 검증 통과.
- 2026-08-12 데스크톱 `태그 및 검색` 메뉴를 `검색`과 돋보기 아이콘으로 변경하고, 모바일 하단바의 `휴지통`을 `검색` 탭으로 교체해 기존 검색 화면을 연결. Vitest 123건 및 Vite 프로덕션 빌드 통과.
- 2026-08-11 원격 변경 4개 커밋(`8b7544a`~`efcfb53`)을 clean 상태의 `main`에 fast-forward 반영하고 `origin/main` 동기화를 확인.
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
- latest_commit: `1977d7c 중요 일정 아젠다 색상 강조`
- status_before_state_record: `main...origin/main`, 기능 변경은 동기화 완료. 별도 미추적 문서 1개는 배포에서 제외.
- ignored_sensitive_paths: `.env.local`, `config/*.cfg`, `backups/`, `node_modules/`, `dist/`, `test-results/`

## Vercel
- config: `vercel.json` 준비 완료
- output: `dist`
- SPA rewrite: 설정 완료
- `.vercel/`: 로컬 연결 완료, `.gitignore` 제외
- global_vercel_cli: `npx.cmd --yes vercel` 사용
- production_url: `https://memorybook-theta.vercel.app` (2026-08-15 HTTP 200, commit `1977d7c9e5adae5dd0978356e286ac899cb96147`, 중요 일정 색상 강조 포함 확인)
- required_env: `VITE_DATA_BACKEND`, `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`
- deploy_command: `npm.cmd run deploy:vercel`
- precheck_command: `npm.cmd run deploy:check`
- postcheck_command: `VERCEL_PRODUCTION_URL=https://...` 설정 후 `node scripts/verify-deployment.mjs`

## 핵심 경로
- docs: `README.md`, `docs/technical_architecture.md`, `docs/deployment_runbook.md`, `docs/codex_handover.md`
- app: `src/App.tsx`, `src/supabase/client.ts`, `src/services/archiveIntegration.ts`
- archive: `src/archiveStore/features/archive/archiveService.js`, `src/archiveStore/views/ArchiveView.jsx`
- database: `supabase/migrations/202608050001_initial_memorybook.sql`, `scripts/supabase-db.mjs`
- deployment: `vercel.json`, `scripts/check-deployment.mjs`, `scripts/deploy-vercel.mjs`, `scripts/verify-deployment.mjs`

## 남은 작업
1. TO-DO가 일시적으로 0건 저장된 동기화 경합 가능성을 재현하고 비파괴 저장 보호 로직 검토.
2. 메모 사진 촬영·첨부 기능 작업계획에 따른 구현 여부 결정.
3. 선택 작업: Transaction Pooler 비밀번호 교정, Supabase MCP 독립 저장소 범위 재등록.

## 리스크 / 중단 조건
- 2026-08-10 진단 중 Supabase 상태가 `notes=30`, `todos=0`, 기존 체크리스트 `0`으로 관찰됐으나 이후 새 브라우저 세션에서 TO-DO 7개가 다시 로딩됨. 다중 클라이언트의 마지막 쓰기 우선 저장 또는 초기 로딩 경합 가능성이 있어 데이터 보호 로직 확인 전 대규모 상태 변경을 주의한다.
- CLI DB 작업은 Pooler 인증 복구 전 실행 불가.
- 비밀값은 `.env.local`과 `config/memorybook.cfg` 밖에 기록 금지.
- DB 스키마·데이터 변경은 사용자 명시 승인 전 실행 금지.
- 테스트 실패, 환경변수 누락, Git dirty/divergent/no-upstream이면 배포 중단.

## Handoff
- current_goal: 배포된 인증·설정·사이드바·아젠다 UX를 안정 운영하고 동기화 데이터 보호 확인
- done_latest: 중요 일정 색상 강조 커밋 `1977d7c`까지 `origin/main`과 Vercel 프로덕션에 배포하고 HTTP 200·운영 커밋 일치 검증 완료
- next_action: 다중 클라이언트 TO-DO 상태 저장 경합 재현 및 비파괴 저장 보호 로직 검토
- blockers: 기능 배포 블로커 없음. DB CLI/MCP 연결은 선택적으로 미복구
