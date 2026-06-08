# bloom Current State

## 기본 정보
- project_key: `bloom`
- last_updated: `2026-06-08`
- owner_request: bloom 환경변수 보안 점검 및 개선 테스트
- current_status: Prompt History 기능 구현 및 Supabase 실CRUD 검증 완료, 배포 반영 진행 상태

## 현재 목표
- Prompt Builder의 한글/영문 프롬프트 생성 흐름을 확장하고 사용성을 보강한다.

## 진행 중 작업
- 환경변수 보안 점검 1차 반영 완료, Vercel 환경 변수/배포 검증 대기
- Prompt History 배포 반영 및 보호된 Vercel 환경 확인 대기

## 최근 완료 작업
- 2026-06-08: Story 화면 1차 구현 결과가 사용자가 원하는 화면 출력/기능 방식과 맞지 않아 재진행 대상으로 전환. 현재 `bloom` 작업트리의 Story 관련 코드 변경(`index.html`, `prompt-generator/ui/app.js`, `prompt-generator/styles/app.css`, `prompt-generator/data/story-manifest.js`)은 커밋 대상에서 제외하고, 원본 `story/` 디렉터리는 보존한다.
- 2026-06-08: Bloom 메인 대시보드에 `Story` 메뉴 추가 및 story 파일 보기 화면 구현. `story/` 디렉터리의 현재 Markdown 파일 29개를 `prompt-generator/data/story-manifest.js`로 등록하고, `index.html`에 Story 화면과 편집 모달 DOM을 추가. `prompt-generator/ui/app.js`에서 Story 화면 전환, 파일 검색, 파일 fetch 로딩, 모달 편집, 복사, 원본 복원, 브라우저 localStorage 기반 수정본 저장 기능을 구현. `prompt-generator/styles/app.css`에 Story 리스트/모달/모바일 스타일 추가. 정적 실행에서는 디스크 직접 저장이 불가하므로 편집 저장은 브라우저 로컬 저장소 기준으로 동작.
- 2026-06-08: Story 화면 로컬 브라우저 검증 완료. `node --check prompt-generator/ui/app.js`, `node --check prompt-generator/data/story-manifest.js` 통과. `http://localhost:8081/index.html?story=1`에서 게스트 모드 진입 후 Story 메뉴 표시, Story 화면 29개 파일 리스트업, `bookstore.md` 모달 열기, 편집 저장 표시, 원본 복원 동작 확인. 정적 실행 특성상 `/api/auth/me` 404는 게스트 모드 기준 허용 범위.
- 2026-06-08: `bloom` 원격 변경 확인 및 업데이트 점검. `git fetch origin` 후 로컬 `main`과 `origin/main` 해시가 모두 `ccfff026fe5720666a43fa97f476d36ac4784a31`로 동일함을 확인. `git pull --ff-only origin main` 결과 `Already up to date`. 로컬 작업트리에는 기존 미커밋 변경 다수와 `story/` 신규 디렉터리가 남아 있어 별도 선별 확인 필요.
- 2026-04-28: Prompt Builder 키워드 그룹 순서를 장소/배경, 무드/환경 우선으로 변경
- 2026-04-28: 날씨/계절 그룹을 날씨와 계절로 분리하고 `season` 키워드 그룹을 생성
- 2026-04-28: 나이 키워드에서 `20대 초반`, `20대 후반`을 제거하고 `20대`, `초반`, `중반`, `후반` 구조로 변경
- 2026-04-28: `node --check`로 `prompt-generator/data/prompt-data.js`, `prompt-generator/core/build-prompt.js`, `prompt-generator/ui/app.js` 문법 검증 통과
- 2026-04-28: 커밋 `f8fc41d` 생성 후 `origin/main` 푸시 완료
- 2026-04-28: GitHub Pages `https://mohenz.github.io/bloom/?nocache=20260428prompt` 응답 `200` 및 `season`, `Prompt Builder` 포함 확인
- 2026-04-28: Vercel `https://bloom-rouge-zeta.vercel.app/` 응답 `200` 및 `Prompt Builder` 포함 확인
- 2026-04-20: `.gitignore` 추가로 `.env*` 및 `.vercel` 로컬 파일의 저장소 커밋 방지
- 2026-04-20: `lib/translate-prompt.js`, `api/translate.js`, `server/translate-api.mjs`에서 번역 API CORS 기본값을 `*`에서 same-origin 제한으로 변경하고, 로컬 `localhost`에서는 `file://` 미리보기용 `Origin: null`만 예외 허용
- 2026-04-20: `api/healthz.js`, `server/translate-api.mjs /healthz` 응답에서 `hasApiKey`, `authConfigured` 등 설정 노출 제거
- 2026-04-20: 번역 API 공개 오류 메시지를 일반화해 `ANTHROPIC_API_KEY` 누락 여부와 업스트림 상세 오류를 외부 응답에 직접 노출하지 않도록 조정
- 2026-04-20: `.env.example`, `README.md`에 same-origin 기본 정책과 `.env.example` 전용 관리 원칙 반영
- 2026-04-20: `node --check`로 `lib/translate-prompt.js`, `api/translate.js`, `server/translate-api.mjs`, `api/healthz.js` 문법 검증 통과
- 2026-04-20: `node --input-type=module -e ...`로 hosted origin 허용/외부 origin 차단/local `Origin: null` 허용 계산 확인
- 프로젝트 구조, 실행 방식, 핵심 문서 확인
- 중앙 프로젝트 관리 레지스트리에 프로젝트 등록
- 프롬프트 결과 박스를 하단 고정 오버레이에서 반응형 패널 구조로 변경
- 데스크톱에서는 우측 sticky 패널, 좁은 화면에서는 본문 하단 패널로 분리
- 브라우저에서 태그 선택 후 프롬프트 갱신과 비중첩 레이아웃 확인
- `EN 문장` 버튼, 영문 문장 결과 박스, 영문 문장 복사 기능 추가
- 선택값 기반 `buildEnglishSentencePrompt` 로직 추가 및 localStorage 상태 저장 연동
- 브라우저에서 영문 문장 생성 동작 확인, `node --check`로 주요 스크립트 문법 확인
- 커밋 `a156f9b` 생성 후 `origin/main` 푸시 완료
- GitHub Pages `https://mohenz.github.io/bloom/` 에서 `EN 문장` 반영 확인
- Vercel 배포 성공 상태 확인: `https://bloom-on90avxk3-mohenzs-projects.vercel.app`
- 대시보드 상단 `topbar-kicker` 문구를 `Bloom Universe`로 변경
- 커밋 `f8917d2` 생성 후 `origin/main` 푸시 완료
- GitHub Pages `https://mohenz.github.io/bloom/` 에서 `Bloom Universe` 반영 확인
- 프런트를 `/api/auth/login`, `/api/auth/me`, `/api/auth/logout` 기반 일반 로그인 구조로 전환
- `lib/auth-utils.js`, `lib/auth-store.js` 추가로 인증 공통 로직과 Supabase 저장소 어댑터 분리
- `docs/general_login_auth_schema.sql` 에 Supabase용 사용자/세션 테이블 생성 스크립트 추가
- `scripts/generate-password-hash.mjs` 로 초기 사용자 비밀번호 해시 생성 스크립트 추가
- `node --check` 와 해시 생성 실행으로 인증 관련 스크립트 동작 확인
- Supabase `public.app_users` 에 초기 관리자 계정 `admin@bloom.local` 생성 완료
- 초기 관리자 표시명 `Bloom Admin` 설정 완료
- 사용자 측 Vercel 환경 변수 설정 완료 확인
- 커밋 `6601f86` 생성 후 `origin/main` 푸시 완료
- GitHub 커밋 상태에서 Vercel 배포 `success` 확인
- Vercel URL 직접 응답은 Deployment Protection 때문에 `401 Authentication Required` 로 보호됨 확인
- Dashboard 의 Prompt History 카드를 활성화하고 전용 History 화면 추가
- Prompt Builder 에 History 저장 버튼과 새 저장 모드 전환 버튼 추가
- `api/prompt-history.js`, `lib/prompt-history-store.js`, `lib/auth-session.js`, `lib/supabase-rest.js` 추가로 히스토리 API와 세션 공통 처리 분리
- `docs/prompt_history_schema.sql` 에 Prompt History 테이블 생성 스크립트 추가
- `prompt-generator/features/prompt-history.js` 추가로 프런트 History API 호출과 레코드 정규화 로직 분리
- `node --check` 로 Prompt History 관련 프런트/서버 스크립트 문법 확인
- 로컬 정적 페이지에서 Prompt History 화면 요소 존재 및 콘솔 오류 없음 확인
- 사용자가 Supabase `public.prompt_histories` 테이블 생성 완료
- 초기 관리자 계정 기준으로 Prompt History 생성, 목록 조회, 수정, 삭제 실CRUD 검증 완료
- Prompt History 화면 상단 `topbar-kicker` 문구를 `Bloom Universe`로 변경
- 커밋 `b9b2bf6` 생성 후 `origin/main` 푸시 완료
- `https://bloom-rouge-zeta.vercel.app/` 응답 `200` 및 Prompt History 헤더 반영 확인
- 메인 화면 카드 보조 문구 3건 제거
- 커밋 `cd7a911` 생성 후 `origin/main` 푸시 완료
- `https://bloom-rouge-zeta.vercel.app/` 에서 제거 대상 문구 미노출 확인
- 메인 히어로 제목을 `Bloom Universe 창조공간` 으로 변경하고 기존 설명 문구 2건 제거
- 커밋 `25df39c` 생성 후 `origin/main` 푸시 완료
- `https://bloom-rouge-zeta.vercel.app/` 에서 새 문구 노출 및 기존 문구 미노출 확인
- GitHub Pages 로그인 화면에 `정식 앱 열기`, `게스트로 둘러보기` 버튼 추가 및 미리보기 전용 안내 문구 적용
- 커밋 `919f3a7` 생성 후 `origin/main` 푸시 완료
- 정적 자산 캐시 우회를 위해 CSS/JS 버전 쿼리 추가
- 커밋 `da9d203`, `569a504` 생성 후 `origin/main` 푸시 완료
- `https://mohenz.github.io/bloom/?nocache=20260413b` 기준으로 GitHub Pages 미리보기 문구/버튼 반영 및 콘솔 오류 없음 확인

## 다음 작업
- Story 기능은 기존 1차 구현을 기준으로 진행하지 않고, 원하는 화면 구조/파일 저장 방식/편집 UX를 다시 정의한 뒤 재구현한다.
- Story 파일 편집 결과를 실제 파일로 저장해야 할 경우, 정적 실행 한계를 넘기 위해 로컬 API 또는 Vercel/Node API 저장 엔드포인트 추가 검토. 현재는 브라우저 localStorage 저장 방식.
- Vercel 환경 변수에서 `ALLOWED_ORIGINS`가 필요한 배포 환경만 명시 allowlist로 설정되어 있는지 확인
- 배포 후 `GET /healthz`, `POST /api/translate`, 로그인, Prompt History 저장/불러오기 동작을 보호된 Vercel 환경에서 실화면 기준으로 재확인
- 필요 시 `SUPABASE_SERVICE_ROLE_KEY`, `AUTH_SESSION_SECRET`, `ANTHROPIC_API_KEY` 회전 여부와 절차 확정
- Prompt History 변경분 커밋 및 배포
- 보호된 Vercel 환경에서 Prompt History 저장/불러오기 UI 실화면 확인
- 필요 시 비밀번호 변경 API 및 UI 추가

## 실행 / 검증
- run_command: `index.html 직접 열기`
- verify_command: `node --check prompt-generator/ui/app.js`, `node --check prompt-generator/features/prompt-history.js`, `node --check api/prompt-history.js`, `node --check api/auth/me.js`, `node --check lib/auth-session.js`, `node --check lib/prompt-history-store.js`, `node --check lib/supabase-rest.js` / 로컬 정적 페이지 콘솔 오류 없음 확인 / 기존 로그인 API 실동작 확인 / Supabase 실CRUD 검증 완료 / GitHub 커밋 상태 `Vercel=success` 확인
- security_verify_command: `node --check lib/translate-prompt.js`, `node --check api/translate.js`, `node --check server/translate-api.mjs`, `node --check api/healthz.js` / `node --input-type=module -e ...` 로 same-origin 허용/외부 origin 차단/local `Origin: null` 허용 계산 확인
- port_or_runtime: `정적 브라우저 실행`, 선택 시 로컬 Node API `8787`
- deploy_method: `main` 브랜치 푸시 기반 GitHub Pages + Vercel 연동 / 인증은 Vercel API + Supabase 저장소 사용

## 핵심 경로
- project_root: `D:\Workspace\bloom`
- key_docs:
  - `README.md`
  - `.env.example`
  - `docs/general_login_auth_schema.sql`
- key_files:
  - `index.html`
  - `prompt-generator/ui/app.js`
  - `api/auth/login.js`
  - `api/auth/me.js`
  - `api/auth/logout.js`
  - `lib/auth-utils.js`
  - `lib/auth-store.js`

## 리스크 / 주의사항
- 프런트 기본 실행은 정적 파일 기준이라 전용 개발 서버 명령이 정리되어 있지 않음
- `ANTHROPIC_API_KEY` 없이는 번역 API 서버 기능을 사용할 수 없음
- `ALLOWED_ORIGINS`를 명시하지 않으면 번역 API는 same-origin 전용이므로 교차 origin 호출이 필요한 배포에서는 환경 변수 allowlist를 별도 설정해야 함
- Vercel URL은 현재 인증 보호가 걸려 있어 비로그인 외부 접근이 막힐 수 있음
- 일반 로그인은 `SUPABASE_SERVICE_ROLE_KEY` 와 `AUTH_SESSION_SECRET` 설정이 빠지면 동작하지 않음
- Prompt History 는 `public.prompt_histories` 테이블이 생성되기 전까지 서버 API가 정상 동작하지 않음
- 채팅에 노출된 Supabase service role key 는 향후 rotate 권장
- Vercel Deployment Protection 때문에 에이전트 환경에서는 배포 URL의 실제 앱 화면 확인이 제한됨
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/prompt_history_schema.sql`, `api/prompt-history.js`, `prompt-generator/features/prompt-history.js`, `prompt-generator/ui/app.js`
- 확인이 필요한 미결사항: Deployment Protection 우회 방식, 비밀번호 변경 기능 범위






