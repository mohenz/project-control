# ui_coding_helper Current State

## 기본 정보
- project_key: `ui_coding_helper`
- last_updated: `2026-03-31`
- owner_request: 공용으로 사용할 UI 수정 요청용 크롬 확장프로그램 프로젝트 시작
- current_status: 신규 공용 도구 프로젝트 초기 생성

## 현재 목표
- 웹 화면 요소 선택과 Markdown 생성이 가능한 크롬 확장프로그램 MVP를 준비한다.

## 진행 중 작업
- 초기 MVP 골격 생성 완료, 실제 사용성 보강 항목은 다음 단계에서 확장 가능

## 최근 완료 작업
- 프로젝트 폴더 생성
- 크롬 확장프로그램 Manifest V3 기본 구조 생성
- Side Panel 기반 UI 골격 생성
- 요소 선택 content script 생성
- Markdown 생성 흐름 구현
- 설치/사용 문서와 MVP 명세 작성
- 범용 사용자용 설치/사용 매뉴얼 추가
- `Font Awesome fa-crosshairs` 기반 확장프로그램 아이콘 생성 스크립트 및 아이콘 세트 추가
- 아이콘 클릭 시 Side Panel이 더 안정적으로 열리도록 `openPanelOnActionClick` 기반으로 보강
- `host_permissions` 추가 및 `현재 선택 초기화` 기능 반영
- 선택 모드 중 `ESC` 키로 취소 시 패널 상태까지 즉시 반영되도록 보강
- 상단 공용 툴바를 단계형 흐름 UX로 재구성하고 요청 입력창 `Enter` 생성 동작 추가
- Markdown 결과 textarea를 자동 확장으로 바꿔 내부 스크롤과 패널 전체 스크롤 충돌 버그 수정
- Markdown 결과 영역을 읽기 전용 `pre` 블록으로 교체해 내부 스크롤 구조 자체를 제거하고 패널 하단 스크롤 도달 문제를 추가 완화
- Side Panel 자동 `scrollIntoView`를 제거하고 미리보기 영역 높이를 고정해 상하단 스크롤 튐과 깜박임 현상을 추가 완화
- 화면 캡처/미리보기 기능을 제거하고 흐름을 `선택 -> 수정 요청 -> Markdown`으로 단순화
- 한글 입력기 조합 상태에서도 `Enter` Markdown 생성이 동작하도록 입력 처리 보강
- 다중 선택 UX 설계안 문서 추가 및 권장 선택 개수/Markdown 길이 기준 정리

## 다음 작업
- 실제 페이지에서 요소 선택 정확도와 메시지 흐름 점검
- 다중 요소 선택 필요 여부 검토
- 다중 선택 1차 구현 범위 확정 가능
- Markdown 템플릿 고도화
- 아이콘/브랜딩 자산 추가 가능

## 실행 / 검증
- run_command: `Chrome > chrome://extensions > 개발자 모드 > 압축해제된 확장 프로그램 로드 > D:\Workspace\ui_markdown_capture`
- verify_command: `npm.cmd run check:syntax`
- port_or_runtime: `Chrome Extension Manifest V3 / Side Panel`
- deploy_method: `로컬 unpacked extension`, 필요 시 이후 Chrome Web Store 검토

## 핵심 경로
- project_root: `D:\Workspace\ui_markdown_capture`
- key_docs:
  - `README.md`
  - `docs/사용자_매뉴얼.md`
  - `docs/mvp_spec.md`
- key_files:
  - `manifest.json`
  - `background.js`
  - `content/select-mode.js`
  - `sidepanel/sidepanel.js`
  - `scripts/generate-icons.ps1`

## 리스크 / 주의사항
- `chrome://` 등 특수 페이지에서는 동작하지 않음
- 크로스 오리진 iframe 내부 선택은 제약이 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `docs/mvp_spec.md`, `sidepanel/sidepanel.js`
- 확인이 필요한 미결사항: 실제 작업 흐름에서 Markdown 포맷이 충분한지, 다중 요소 선택이 필요한지






