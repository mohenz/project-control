# web_perf_extension Current State

## 기본 정보
- project_key: `web_perf_extension`
- last_updated: `2026-04-14`
- owner_request: 웹사이트 로딩속도를 측정할 수 있는 확장프로그램 신규 구상 및 MVP 시작
- current_status: GitHub 원격 연결 및 `main` 푸시 완료, Font Awesome 기반 아이콘 세트와 DevTools 스타일 요청 단위 네트워크 분석 기능이 로컬 작업트리에 반영된 상태

## 현재 목표
- 현재 탭의 로딩 성능 지표를 측정하고 최근 기록을 저장하는 Chrome 확장프로그램 MVP를 만든다.

## 진행 중 작업
- Chrome 확장에서 수정된 측정 로직과 아이콘 배지 실동작 확인
- 후속 기능 범위 정리

## 최근 완료 작업
- 중앙 프로젝트 레지스트리에 신규 프로젝트 등록
- 상태 파일 생성 및 초기 작업 범위 정의
- `manifest.json`, `background.js`, `popup/`, `lib/`, `scripts/` 기반 MV3 확장프로그램 구조 생성
- 현재 탭 측정, 새로고침 후 재측정, 최근 기록 저장/삭제/열기 MVP 구현
- `npm.cmd run check:syntax` 검증 스크립트 구성 및 통과
- 로컬 Git 저장소 초기화 완료
- 초기 스캐폴딩 커밋 `4ff0ae9` 생성 완료
- `background.js`에서 페이지 주입 함수가 외부 헬퍼를 참조하던 문제 수정
- 주입 스크립트 내부 자급식 metric 계산과 오류 전달 처리 추가
- 수정 후 `npm.cmd run check:syntax` 재검증 완료
- 현재 탭 활성화 및 페이지 로드 완료 시 확장프로그램 아이콘 배지에 로드 속도 자동 표시 추가
- 배지에 `Load` 우선, 대체 지표 fallback, 속도 구간별 색상 표시 반영
- `README.md`에 배지 동작 방식과 확인 방법 문서화
- GitHub 원격 `https://github.com/mohenz/web_perf_extension.git` 연결 완료
- 커밋 `88dd3be` (`Add action badge speed display`)를 `origin/main`에 푸시 완료
- `CHANGELOG.md` 추가
- `docs/github_release_v0.1.0.md`에 GitHub Release 붙여넣기용 초안 추가
- `Font Awesome fa-gauge-high` 기반 확장프로그램 아이콘 생성 스크립트 추가
- `icons/icon-16.png`, `icon-32.png`, `icon-48.png`, `icon-128.png`, `icon-master-512.png` 생성
- `manifest.json`에 top-level icons 및 action default_icon 연결
- `package.json`에 `generate:icons` 스크립트 추가
- `README.md`에 아이콘 세트 적용 및 재생성 안내 반영
- `manifest.json`에 `debugger` 권한 추가
- `lib/network-capture.js`에 `chrome.debugger` 기반 요청 캡처 모듈 추가
- 팝업에 `새로고침 후 요청 분석` 액션과 네트워크 요약/요청 목록 UI 추가
- 요청별 상태코드, 전송 크기, TTFB, 총 소요시간, waterfall 스타일 표시 추가
- `README.md`에 DevTools 스타일 요청 분석 범위와 주의사항 반영
- 네트워크 분석 화면을 테이블에서 카드형 반응형 레이아웃으로 전환
- 작은 팝업 폭에서도 요청 목록 전체를 확인할 수 있도록 요약 2열, 요청 카드, 폭 자동 줄바꿈 적용

## 다음 작업
- Chrome에서 압축해제된 확장 프로그램 새로고침 후 실제 요청 분석 및 배지 표시 확인
- 아이콘/네트워크 분석 변경분 커밋 및 원격 반영
- 필요 시 CSV 내보내기, 지표 비교, DevTools 패널 확장 검토

## 실행 / 검증
- run_command: `Chrome > chrome://extensions > 압축해제된 확장 프로그램 로드`
- verify_command: `npm.cmd run check:syntax`
- port_or_runtime: `Chrome Extension MV3 Popup + Service Worker`
- deploy_method: `GitHub 원격 저장 + local unpacked extension`

## 핵심 경로
- project_root: `D:\Workspace\web_perf_extension`
- key_docs:
  - `README.md`
  - `docs/mvp_spec.md`
  - `manifest.json`
- key_files:
  - `manifest.json`
- `background.js`
- `popup/popup.html`
- `popup/popup.js`
- `popup/popup-view.js`
- `lib/metric-utils.js`
- `lib/history-store.js`

## 리스크 / 주의사항
- Chrome 확장프로그램은 `chrome://`, `chrome-extension://` 같은 특수 페이지를 측정할 수 없음
- LCP 같은 일부 지표는 페이지 상태와 측정 시점에 따라 비어 있을 수 있음
- 확장 프로그램 수정 후 `chrome://extensions`에서 새로고침하지 않으면 이전 서비스 워커 코드가 남아 있을 수 있음
- 배지 숫자는 Chrome 배지 글자 수 제한 때문에 긴 값에서는 축약 표시될 수 있음
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토
- `debugger` 권한 기반 요청 분석은 같은 탭에 DevTools가 이미 연결돼 있으면 충돌할 수 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `manifest.json`, `background.js`, `popup/popup.js`, `popup/popup-view.js`, `docs/mvp_spec.md`
- 확인이 필요한 미결사항: 실제 브라우저 로드 결과, 측정 기록 보존 범위, 아이콘 추가 여부
