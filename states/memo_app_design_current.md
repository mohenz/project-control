# Project State

## 기본 정보
- project_key: quickmemo_service_level_expansion
- last_updated: 2026-05-10
- owner_request: 개인용 캐주얼 메모 웹앱(Bloom Memo)의 MVP를 넘어선 정식 서비스(Production) 레벨 기능 확장 및 프레임워크 전환 (Codex로 인수인계 됨)
- current_status: 프런트엔드 React 전환 및 확장 UI 구현 완료. 단, Vercel 백엔드 API 연동 누락 및 인증 세션 부재로 인해 실제 데이터베이스 저장 불가 상태. 에이전트 교체(JIAN -> Codex).

## 현재 목표
- Vercel 통합 환경(`npx vercel dev`)을 구축하여 React 프런트엔드와 Serverless API 간의 통신을 정상화한다.
- Mock 처리된 로그인/비밀번호 로직을 실제 Supabase Auth 및 쿠키 세션 기반으로 연동하여 인증 권한(401) 문제를 해결한다.
- 자동 저장, 리치 텍스트 에디터, 확장 프로그램의 오프라인 큐 기능이 백엔드 DB와 완벽히 통신하도록 연동한다.

## 진행 중 발생한 치명적 실수 (JIAN's Handoff Note)
다음은 프로젝트 이관의 원인이 된 에이전트(JIAN)의 치명적 판단 미스 및 누락 사항입니다. Codex는 이를 최우선으로 인지하고 해결해야 합니다.
1. **무단 테스트 생략으로 인한 렌더링 장애:** 순수 JS(MVP)에서 React 19 환경으로 프레임워크를 전면 전환하고 리치 에디터(`react-quill`)를 도입한 후, 테스트 코드를 재작성하지 않고 구동하여 구형 API(`findDOMNode`) 충돌로 인한 흰 화면(화면 크래시) 버그를 배포함. (이후 순수 `Quill.js` 래퍼 컴포넌트로 재작성하여 수습 및 E2E 테스트 통과 처리함)
2. **백엔드 구동 환경 누락 (저장 불가 원인):** 프런트엔드를 테스트할 때 Vercel 통합 서버(`npx vercel dev`)가 아닌 Vite 전용 서버(`npm run dev`)만 단독으로 띄움. 이로 인해 브라우저의 저장 요청(`/api/memo-memos`)을 처리할 백엔드 Serverless Function이 없어 **404 Not Found 에러**가 발생함.
3. **가상(Mock) 인증으로 인한 401 권한 거부:** UI 확장 요구사항에 치중하여 로그인 로직을 `localStorage`를 조작하는 Mock으로만 구현함. 실제 백엔드 통합을 하더라도 세션 쿠키가 발급되지 않았으므로 **401 Unauthorized 에러**가 필연적으로 발생하는 아키텍처 결함을 남김.

## 최근 완료 작업
- 기존 MVP 폴더(`webapp_vanilla`) 백업 후, 새로운 Vite + React 환경(`webapp_react`) 스캐폴딩.
- React 기반 전역 라우팅(`react-router-dom`) 및 `Login.jsx`, `Main.jsx` 화면 설계.
- 사용자 계정 관리 페이지(`FindId.jsx`, `ResetPassword.jsx`) 구현 및 화면 내 3단계 UI 전환 로직 작성.
- 리치 텍스트 에디터 모듈을 순수 `Quill.js` 엔진을 직접 제어하는 `RichEditor.jsx`로 안전하게 교체 구현.
- 1.5초 Debounce 로직을 적용한 백그라운드 자동 저장(Auto-save) 프런트엔드 UI 상태 연동.
- Chrome Extension 2차 고도화: `manifest.json` 내 `sidePanel` 권한 추가.
- Extension 백그라운드 우클릭 캡처 및 네트워크 단절 시 `chrome.storage.local`을 이용한 오프라인 큐(Offline Queue) 동기화 스크립트 작성.
- `webapp_react` 내 Playwright 기반 E2E 프런트엔드 동작 테스트(모달 렌더링, 라우팅) 구축 및 통과.

## 다음 작업 (Codex Action Items)
1. **개발 환경 통합:** `webapp_react` 디렉토리 내에서 Vite 프런트엔드와 Vercel `/api` 폴더의 함수들이 동시에 구동되도록 `npx vercel dev` 환경 세팅. (필요 시 `.env` 설정)
2. **실제 인증(Auth) 연동:** `api.js` 및 `Login.jsx`의 가상 로그인 동작을 실제 Supabase Auth API 또는 기존 `bloom`의 세션 발급 로직과 연동. Vercel API 요청 시 쿠키가 전송되도록 처리.
3. **저장 API 정상화:** 프런트엔드의 자동 저장 로직이 `createMemo`, `updateMemo` Vercel 함수를 통해 실제 DB에 성공적으로 200 응답을 기록하는지 디버깅.
4. **비밀번호 재설정 백엔드 구현:** 프런트엔드 UI만 구현된 `ResetPassword.jsx` 로직에 맞게 백엔드 API를 구현하거나 Supabase 연동.
5. **통합 E2E 테스트 재수행:** 모든 API 연동이 끝난 후 전체 저장 및 렌더링 무결성 테스트 실행 및 원격 저장소(`quickmemo`) 커밋/푸시.

## 핵심 경로
- project_root: `D:\Workspace\quickmemo`
- React_app: `D:\Workspace\quickmemo\webapp_react`
- Extension: `D:\Workspace\quickmemo\extension`
- Vercel API: `D:\Workspace\quickmemo\webapp_react\api`

## 리스크 / 주의사항
- 프런트엔드 뷰의 렌더링 상태만 보고 앱 전체의 무결성을 확신해서는 안 됨. 프런트엔드-백엔드 간 네트워크 탭(API 응답 코드)을 필수적으로 확인해야 함.
- 현재의 Vercel `/api` 라우트들은 `lib/auth-session.js`의 `getAuthenticatedSession`을 통해 강력한 세션 검사를 수행하므로, 브라우저 쿠키 발급이 성공해야만 테스트가 가능함.






