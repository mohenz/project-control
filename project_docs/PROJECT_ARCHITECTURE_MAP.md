# Project Architecture Map

## 목적
- `project_control`이 알고 있는 프로젝트의 기술 구성, 실행 환경, 데이터 저장소, 배포 방식을 한곳에서 참조한다.
- 프로젝트 전환 시 `project_registry.md`와 각 `states/*_current.md`를 읽기 전에 전체 지형을 빠르게 파악한다.
- 이 문서는 요약 지도이며, 세부 상태와 다음 작업은 각 상태 파일을 기준으로 한다.

## 참조 순서
1. `project_registry.md`: 등록 프로젝트의 별칭, 경로, 실행/검증 명령 기준
2. `project_docs/PROJECT_ARCHITECTURE_MAP.md`: 전체 프로젝트 아키텍처 요약
3. `states/<project>_current.md`: 현재 상태, 최근 작업, 다음 작업, 리스크
4. 각 프로젝트의 핵심 문서와 코드

## 등록 프로젝트 아키텍처

| project_key | architecture | runtime / ports | data / infra | deploy | state |
|---|---|---|---|---|---|
| `defect_manage` | Supabase 기반 Vanilla JS 결함관리 웹앱 | Node local server, `localhost:3000` | Supabase 직접 연동 | GitHub Pages + local Node server | `states/defect_manage_current.md` |
| `defect_manage2` | Vanilla JS 웹앱 + Node API + Local PostgreSQL 전환형 결함관리 | manual `localhost:3000`, e2e `localhost:3001`, DB `127.0.0.1:54323` | Local PostgreSQL + Node API, Supabase 이관 데이터 | separate repo `mohenz/defect_manage2`, 배포 방식 확정 필요 | `states/defect_manage2_current.md` |
| `n8n_defect_automation` | n8n 기반 결함 리포트 자동화 워크플로우 | n8n Cloud/Desktop runtime | n8n workflow JSON, 외부 자동화 연동 | n8n import / activation | `states/n8n_defect_automation_current.md` |
| `makeyourtoday` | 문서 주도 제품/멀티에이전트 운영체계 기획 프로젝트 | runtime 없음 | 로컬 기획 문서 | local docs / TBD | `states/makeyourtoday_current.md` |
| `trinity_room` | Electron 데스크톱 앱 계획/프로토타입 + Web preview | Web preview `http://127.0.0.1:4317`, Electron skeleton | 로컬 앱 상태/문서 | local desktop prototype / TBD | `states/trinity_room_current.md` |
| `jina_writer` | Python Tkinter 데스크톱 소설 작성 앱 + Gemini 연동 구조 | Tkinter local desktop app | local-first storage, Gemini 2.5 Flash integration | local desktop app / installer TBD | `states/jina_writer_current.md` |
| `ui_code_helper` | Chrome MV3 side panel 확장 프로그램 | Chrome Extension MV3 / Side Panel | 브라우저 DOM 선택/Markdown change request 생성 | local unpacked extension / zip sync | `states/ui_code_helper_current.md` |
| `unit_test` | 중앙 단위테스트 거버넌스/리포트 저장소 + Codex skill | runtime 없음 | 문서/스킬 저장소 | GitHub repo sync | `states/unit_test_current.md` |
| `project_control` | 워크스페이스 중앙 프로젝트 레지스트리, 상태 파일, 전환 워크플로우 | runtime 없음 | `project_registry.md`, `states/*.md`, skill package | GitHub repository sync | `states/project_control_current.md` |
| `archive_store` | React/Vite 개인용 아카이브 웹앱 + local API + Firebase-ready 구조 | app `5174`, API `5175`, DB `54324`, Firebase emulators `5176/9099/8080/9199/4001` | Local PostgreSQL 18.4, local uploads, Firebase project `archive-store-fae71` 준비 | GitHub `mohenz/archive-store`, Firebase Hosting/Firestore/Storage 준비 완료, Web App config 입력 대기 | `states/archive_store_current.md` |
| `personal_memo` | React/Vite 개인 메모 PWA + Tailwind CSS 화면 구조 | Vite dev server `localhost:3000` | localStorage 기반 메모/폴더/설정 저장 | GitHub `mohenz/personalMemo`, 배포 방식 TBD | `states/personal_memo_current.md` |
| `token_tracker` | Zero-dependency Python local server + HTML/JS dashboard | Python server, port `5000` | local JSON/DB tracker 구조 | local Python server | `states/token_tracker_current.md` |
| `cinetube` | Static movie hub + local API + Local PostgreSQL | static `8080`, API `3001`, DB `54322` | Local PostgreSQL/API, 기존 Supabase 구조 참조 | Vercel from GitHub `origin/main` | `states/cinetube_current.md` |
| `bloom` | Static prompt generator + Vercel API + Firebase 전환 구조 | Vercel dev `3000`, Firebase emulators Auth `9099`, Firestore `8080`, UI `4000` | Firebase Auth/Firestore/Emulators, Vercel API | `main` push 기반 Vercel 자동 배포 | `states/bloom_current.md` |
| `jian_soul` | JIAN Unified Soul System & Autonomic Nervous System | Python 3.10+, vitals server port `8000` | persona/memory/state 파일, GCS sync | GCS `JIAN-soul` bucket | `states/jian_soul_current.md` |

## 상태 파일 기준 추가 프로젝트

아래 항목은 `states/*_current.md`에는 존재하지만 현재 `project_registry.md` 등록 테이블에는 없거나, 과거/보조 프로젝트로 남아 있는 항목이다. 작업 요청이 들어오면 먼저 레지스트리 등록 필요 여부를 판단한다.

| project_key | architecture | runtime / ports | data / infra | deploy | state |
|---|---|---|---|---|---|
| `auth_pro` | 정적 인증 UI 프로토타입 | 브라우저 정적 실행 | `index.html`, `js/app.js`, `css/style.css` | 미정 | `states/auth_pro_current.md` |
| `bloom_logo_design` | Bloom 로고/디자인 상태 문서 | N/A | 디자인 산출물/참조 문서 | N/A | `states/bloom_logo_design_current.md` |
| `bloom_portable_env` | Bloom portable environment 구성 상태 | N/A | portable 환경/문서 | N/A | `states/bloom_portable_current.md` |
| `quickmemo_service_level_expansion` | QuickMemo React 전환/서비스 확장 설계 상태 | React/Vercel 예정 | API/인증/세션 미완료 | Vercel planned | `states/memo_app_design_current.md` |
| `performance_lab` | Artillery 기반 공통 성능 점검/부하 테스트 툴킷 | 타깃 프로젝트별 상이, 기본 예시 `http://localhost:3000` | `targets/active-target.json`, Artillery smoke/load scripts | 배포 없음, 공용 로컬 툴킷 | `states/performance_lab_current.md` |
| `quickmemo` | React web app + Chrome extension + Vercel dev planned | Vercel dev, React dev server, Chrome Extension MV3 | 인증/세션/API 연동 불안정 | Vercel planned / local unpacked extension | `states/quickmemo_current.md` |
| `scrum_board_platform` | Scrum board / daily meeting web platform | local `localhost:4173` | 정적/프론트엔드 앱 | GitHub Pages Actions | `states/scrum_board_platform_current.md` |
| `security_management` | 보안 점검 운영 문서 프로젝트 | N/A | 보안 점검 문서/체크리스트 | 내부 운영 문서 | `states/security_management_current.md` |
| `ui_coding_helper` | Chrome MV3 side panel 확장 프로그램 계열 | Chrome Extension MV3 / Side Panel | `D:\Workspace\ui_markdown_capture` | local unpacked extension | `states/ui_coding_helper_current.md` |
| `web_capture_extension` | Manifest V3 웹 캡처 확장 프로그램 | Chrome/Chromium extension runtime | local extension files | local unpacked extension / zip TBD | `states/web_capture_extension_current.md` |
| `web_perf_extension` | Chrome MV3 네트워크/성능 분석 확장 프로그램 | Chrome Extension MV3 Popup + Service Worker | GitHub 원격 저장 + local extension | GitHub remote + local unpacked extension | `states/web_perf_extension_current.md` |

## Placeholder / 보류

| project_key | status | reference |
|---|---|---|
| `project_04` | placeholder, path `TBD` | `states/project_04_placeholder.md` |

## 공통 운영 기준

- 레지스트리 등록 프로젝트는 `project_registry.md`의 경로/명령을 우선한다.
- 상태 파일만 있는 프로젝트는 작업 전에 레지스트리 등록 여부를 먼저 결정한다.
- 로컬 DB, 업로드 파일, `.env.local`, 토큰, PIN, 인증정보는 Git에 포함하지 않는다.
- 데이터베이스 이관, 스키마 변경, 데이터 초기화는 사용자 명시 승인 전 실행하지 않는다.
- 배포 방식은 `deploy` 또는 `deploy_method`가 명확한 프로젝트만 자동화한다.
- 이 문서는 아키텍처 지도를 제공하고, 최신 작업 상태는 각 `states/*_current.md`를 기준으로 한다.
