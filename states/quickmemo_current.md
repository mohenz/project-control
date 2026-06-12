# Project State

## 기본 정보
- project_key: quickmemo
- last_updated: 2026-05-11
- owner_request: 개인용 캐주얼 메모 웹앱(Bloom Memo)의 MVP를 넘어선 정식 서비스(Production) 레벨 기능 확장 및 프레임워크 전환
- current_status: 프런트엔드 React 전환 및 확장 UI 구현 완료. 빌드는 통과하지만 lint 실패, 실제 인증/세션 연동 미완료, Vercel 통합 환경 미설정, 확장 프로그램 API 포트 불일치로 실제 저장 플로우는 아직 불안정한 상태.

## 현재 목표
- Vercel 통합 환경(`npx vercel dev`)을 구축하여 React 프런트엔드와 Serverless API 간 통신을 정상화한다.
- Mock 처리된 로그인/비밀번호 로직을 실제 Supabase Auth 및 쿠키 세션 기반으로 연동하여 인증 권한(401) 문제를 해결한다.
- 자동 저장, 리치 텍스트 에디터, 확장 프로그램의 오프라인 큐 기능이 백엔드 DB와 통신하도록 연동한다.

## 진행 중 발생한 치명적 실수 / 인수인계 메모
1. 순수 JS(MVP)에서 React 19 환경으로 전면 전환하고 리치 에디터(`react-quill`)를 도입한 뒤 테스트 재작성 없이 구동하여 구형 API(`findDOMNode`) 충돌로 인한 흰 화면 버그가 발생했다. 이후 순수 `Quill.js` 래퍼 컴포넌트로 교체해 수습 및 E2E 테스트 통과 처리됨.
2. 프런트엔드 테스트 시 Vercel 통합 서버(`npx vercel dev`)가 아닌 Vite 전용 서버(`npm run dev`)만 단독 구동했다. 이로 인해 브라우저 저장 요청(`/api/memo-memos`)을 처리할 백엔드 Serverless Function이 없어 404 Not Found가 발생한다.
3. 로그인 로직이 `localStorage` 기반 Mock으로만 구현되어 실제 백엔드 통합 시 세션 쿠키가 발급되지 않고 401 Unauthorized가 발생할 수 있다.

## 최근 완료 작업
- 기존 MVP 폴더(`webapp_vanilla`) 백업 후, 새로운 Vite + React 환경(`webapp_react`) 스캐폴딩.
- React 기반 전역 라우팅(`react-router-dom`) 및 `Login.jsx`, `Main.jsx` 화면 설계.
- 사용자 계정 관리 페이지(`FindId.jsx`, `ResetPassword.jsx`) 구현 및 화면 내 3단계 UI 전환 로직 작성.
- 리치 텍스트 에디터 모듈을 순수 `Quill.js` 엔진을 직접 제어하는 `RichEditor.jsx`로 교체 구현.
- 1.5초 debounce 로직을 적용한 백그라운드 자동 저장 프런트엔드 UI 상태 연동.
- Chrome Extension 2차 고도화: `manifest.json` 내 `sidePanel` 권한 추가.
- Extension 백그라운드 우클릭 캡처 및 네트워크 단절 시 `chrome.storage.local`을 이용한 오프라인 큐 동기화 스크립트 작성.
- `webapp_react` 내 Playwright 기반 E2E 프런트엔드 동작 테스트(모달 렌더링, 라우팅) 구축 및 통과.

## 다음 작업
1. `webapp_react` 디렉토리 내에서 Vite 프런트엔드와 Vercel `/api` 폴더 함수들이 동시에 구동되도록 `npx vercel dev` 환경 세팅.
2. `api.js` 및 `Login.jsx`의 가상 로그인 동작을 실제 Supabase Auth API 또는 기존 `bloom`의 세션 발급 로직과 연동.
3. 프런트엔드 자동 저장 로직이 `createMemo`, `updateMemo` Vercel 함수를 통해 실제 DB에 성공적으로 200 응답을 기록하는지 디버깅.
4. 프런트엔드 UI만 구현된 `ResetPassword.jsx` 로직에 맞게 백엔드 API를 구현하거나 Supabase 연동.
5. 모든 API 연동이 끝난 후 전체 저장 및 렌더링 무결성 테스트 실행 및 원격 저장소(`quickmemo`) 커밋/푸시.

## 실행 / 검증
- run_command: `cd D:\Workspace\quickmemo\webapp_react; npx.cmd vercel dev`
- fallback_frontend_only_run_command: `cd D:\Workspace\quickmemo\webapp_react; npm.cmd run dev`
- verify_command: `cd D:\Workspace\quickmemo\webapp_react; npm.cmd run lint`
- e2e_verify_command: Playwright E2E 재수행 필요
- port_or_runtime: Vercel dev + React web app + Chrome Extension MV3
- deploy_method: Vercel planned / local unpacked extension
- latest_check_2026-05-10: `npm.cmd run build` 통과, `npm.cmd run lint` 실패(26 errors, 1 warning). `.env`와 `vercel.json` 없음. `D:\Workspace\quickmemo`는 현재 Git repo로 인식되지 않음.
- latest_check_2026-05-11: Gemini 구현 점검 결과, `webapp` vanilla 구현은 최종 UI 명세(Source URL, Tags, Quick Capture, 단일 Save)에 비교적 가깝지만 실제 API/인증 통합이 부족함. `webapp_react`는 현재 인수 대상이나 디자인 명세와 MVP 범위를 많이 이탈했고, Vite 단독 실행에서 `/api/*`가 정상 처리되지 않아 Playwright가 JSON 파싱 오류와 함께 timeout됨.

## 핵심 경로
- project_root: `D:\Workspace\quickmemo`
- React_app: `D:\Workspace\quickmemo\webapp_react`
- Extension: `D:\Workspace\quickmemo\extension`
- Vercel API: `D:\Workspace\quickmemo\webapp_react\api`
- key_docs: `webapp_react/README.md`, `webapp_react/package.json`
- key_files: `webapp_react/src`, `webapp_react/api`, `extension/manifest.json`

## 리스크 / 주의사항
- 프런트엔드 뷰의 렌더링 상태만 보고 앱 전체 무결성을 확신하면 안 된다. 프런트엔드-백엔드 간 네트워크 탭(API 응답 코드)을 필수 확인한다.
- 현재 Vercel `/api` 라우트들은 `lib/auth-session.js`의 `getAuthenticatedSession`을 통해 세션 검사를 수행하므로 브라우저 쿠키 발급이 성공해야 테스트 가능하다.
- 프런트엔드 인증 상태는 `localStorage.isAuthenticated`에 의존하지만 API는 `bloom_session` HttpOnly 쿠키를 요구한다. 이 불일치를 먼저 해소해야 한다.
- Chrome Extension은 `http://localhost:3000/api`를 호출하지만 현재 React/Vite 기본 개발 서버와 Playwright는 `5173`을 사용한다. Vercel dev 포트 또는 앱 URL 정책을 확정해야 한다.
- `webapp_react/package.json`에는 `react-quill` 의존성이 남아 있으나 실제 에디터는 직접 `quill`을 import한다. 의존성 정리가 필요하다.
- Gemini가 React 전환 과정에서 최종 디자인 시안의 필수 등록 필드(Source URL, Category, Tags, 명시적 Save)를 누락하고 MVP 제외 기능(Rich Text Toolbar, Auto-save)을 넣은 상태다.
- `webapp`와 `webapp_react`가 병존하여 실제 기준 구현이 불명확하다. 이후 작업 전 기준 앱을 하나로 확정해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `webapp_react/package.json`, `webapp_react/src`, `webapp_react/api`, `webapp_react/lib/auth-session.js`, `extension/manifest.json`
- 확인이 필요한 미결사항: Vercel CLI 설정, Supabase Auth 세션 발급 방식, API 저장 요청의 실제 응답 코드, Playwright 통합 테스트 최신성






