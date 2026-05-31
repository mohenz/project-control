# ui_code_helper Current State

## 기본 정보
- project_key: `ui_code_helper`
- last_updated: `2026-03-31`
- owner_request: `ui_code_helper`를 `project_control`에 등록하고 프로젝트 명칭을 `ui code helper`로 통일
- current_status: `project_control` 등록 완료, 프로젝트 명칭을 `UI Code Helper` 기준으로 정리했고 문법 검증 통과

## 현재 목표
- `ui_code_helper`를 `project_control` 기준으로 바로 전환 가능한 Chrome 확장 프로젝트로 유지한다.

## 진행 중 작업
- 현재 세션 기준 긴급 미완료 작업은 없음

## 최근 완료 작업
- `D:\Workspace\ui_code_helper` 경로 확인
- `README.md`, `package.json`, `manifest.json`, `docs/mvp_spec.md` 확인
- `npm.cmd run check:syntax` 통과
- `project_registry.md`에 `ui_code_helper` 프로젝트 등록
- `scripts/switch-project.ps1` 헬퍼 목록에 `ui_code_helper` 포함
- 현재 상태 파일 신규 생성
- `README.md`, `docs/*`, `manifest.json`, `package.json`, `sidepanel/*`의 표시명을 `UI Code Helper`로 통일
- 내부 식별자와 런타임 키를 `ui-code-helper`, `UICODEHELPER_*` 기준으로 정리
- 문자열 정리 후 `npm.cmd run check:syntax` 재검증 통과

## 다음 작업
- Chrome `chrome://extensions`에서 압축해제 확장 로드 기준 실제 동작 확인
- Side Panel 열기, 선택 모드, Markdown 생성, 복사 흐름 실기능 점검
- 이미 로드된 확장 프로그램이 있다면 새 manifest 이름 반영을 위해 `새로고침` 필요

## 실행 / 검증
- run_command: `Chrome에서 압축해제된 확장 프로그램 로드`
- verify_command: `npm.cmd run check:syntax`
- port_or_runtime: `Chrome Extension MV3 / Side Panel`
- deploy_method: `local unpacked extension / zip sync`

## 핵심 경로
- project_root: `D:\Workspace\ui_code_helper`
- key_docs:
  - `D:\Workspace\ui_code_helper\README.md`
  - `D:\Workspace\ui_code_helper\docs\mvp_spec.md`
  - `D:\Workspace\ui_code_helper\docs\사용자_매뉴얼.md`
  - `D:\Workspace\ui_code_helper\docs\다중선택_UX_설계안.md`
- key_files:
  - `D:\Workspace\ui_code_helper\manifest.json`
  - `D:\Workspace\ui_code_helper\background.js`
  - `D:\Workspace\ui_code_helper\content\select-mode.js`
  - `D:\Workspace\ui_code_helper\sidepanel\sidepanel.html`
  - `D:\Workspace\ui_code_helper\sidepanel\sidepanel.js`
  - `D:\Workspace\ui_code_helper\scripts\check-syntax.js`

## 리스크 / 주의사항
- 현재 폴더는 Git 저장소가 아니다.
- 현재 폴더는 Git 저장소가 아니므로 변경 이력 추적은 별도 관리가 필요하다.
- 자동 테스트 러너는 없고, 실제 검증은 Chrome 확장 로드 후 수동 확인이 필요하다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `manifest.json`, `content/select-mode.js`, `sidepanel/sidepanel.js`
- 확인이 필요한 미결사항: 실제 Chrome Side Panel 동작 여부, 다중 선택 UX 설계안 반영 범위
