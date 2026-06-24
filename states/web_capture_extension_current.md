# web_capture_extension Current State

## 기본 정보
- project_key: `web_capture_extension`
- last_updated: `2026-06-22`
- owner_request: 웹사이트 캡처 확장프로그램 프로젝트 생성, 요구사항 문서화, 프로젝트 컨트롤 등록.
- current_status: Manifest V3 기반 Chrome 확장프로그램 MVP 구현 완료. 로컬 압축해제 로드로 실행 가능.

## 현재 목표
- 보이는 영역/전체 페이지/선택 영역 캡처와 기본 편집/저장 기능을 갖춘 MVP를 브라우저에서 검증한다.

## 진행 중 작업
- 브라우저 수동 검증 대기.

## 최근 완료 작업
- `D:\workspace\web_capture_extension` 프로젝트 폴더 생성.
- `docs/requirements.md`에 핵심 요구사항, 추가 검토 기능, MVP/후순위 범위, 보안 요구사항, 수용 기준 정리.
- 프로젝트 컨트롤 레지스트리 등록.
- `manifest.json`, popup, background service worker, content script, editor 화면 구현.
- 보이는 영역 캡처, 전체 페이지 스크롤 캡처, 선택 영역 캡처 구현.
- 편집 기능 구현: 텍스트, 화살표, 사각형, 흐림, 자르기, 실행 취소.
- PNG/JPEG 저장, 클립보드 복사, 인쇄/PDF 저장 흐름 구현.
- `npm.cmd run check:syntax` 검증 통과.
- 선택 영역 캡처 좌표 보정 수정. 선택 좌표를 `devicePixelRatio`로 선환산하지 않고 CSS 픽셀 그대로 전달한 뒤, 편집기에서 실제 캡처 이미지 크기 기준으로 스케일링하도록 변경. `captureVisibleTab`도 대상 탭의 `windowId`를 명시하도록 수정.
- 선택 영역 캡처 재수정. 편집기에서 원본 visible capture를 자르는 방식을 제거하고, background service worker에서 `OffscreenCanvas`로 선택 영역 PNG를 즉시 잘라 편집기로 전달하도록 변경. 이로써 영역 캡처 결과 화면에 전체 visible viewport가 남는 경로를 차단.
- 화면 밖까지 스크롤해 선택하는 영역 캡처 대응. `content.js` 선택 좌표를 viewport 기준에서 문서 전체 좌표 기준으로 변경하고, 드래그 중 화면 가장자리 자동 스크롤을 추가. `background.js`는 선택된 문서 영역을 필요한 viewport 조각만 스크롤 캡처한 뒤 `OffscreenCanvas`에서 합성하도록 변경.

## 다음 작업
- Chrome에서 압축해제된 확장 프로그램으로 로드 후 실제 페이지 캡처 수동 검증.
- 긴 페이지, fixed header, lazy-loaded 이미지, 선택 영역 캡처 UX 재확인.
- 후순위 기능 우선순위 결정: 링크 포함 PDF, Gmail 전송, 모든 탭 PDF, OCR.

## 실행 / 검증
- run_command: `Chrome > chrome://extensions > 개발자 모드 > 압축해제된 확장 프로그램 로드 > D:\workspace\web_capture_extension`
- verify_command: `npm.cmd run check:syntax`
- port_or_runtime: Chrome/Chromium extension runtime.
- deploy_method: local unpacked extension / zip package TBD.

## 핵심 경로
- project_root: `D:\workspace\web_capture_extension`
- key_docs: `README.md`, `docs/requirements.md`
- key_files: `manifest.json`, `src/background.js`, `src/content.js`, `src/popup.html`, `src/popup.js`, `src/editor.html`, `src/editor.js`

## 리스크 / 주의사항
- 링크 포함 PDF, 모든 탭 단일 PDF, Gmail 직접 전송은 MVP 이후로 분리하는 것이 안전함.
- 긴 페이지 캡처는 고정 헤더/푸터 중복, lazy-loaded 이미지, cross-origin iframe, 브라우저 메모리 제한을 고려해야 함.
- Gmail 직접 전송은 사용자 인증/권한/개인정보 동의 흐름이 필요함.
- 현재 PDF 저장은 Chrome 인쇄 대화상자의 `PDF로 저장` 흐름을 사용함.
- 전체 페이지 캡처 데이터는 확장 service worker 메모리에서 편집 탭으로 즉시 전달하므로, 브라우저가 service worker를 너무 빨리 종료하는 예외 케이스는 수동 검증 필요.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/requirements.md`
- 확인이 필요한 미결사항: 제품명, 대상 브라우저 범위, Gmail 전송 방식, 저장 포맷 우선순위.
