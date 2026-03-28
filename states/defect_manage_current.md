# defect_manage Current State

## 기본 정보
- project_key: `defect_manage`
- last_updated: `2026-03-28`
- owner_request: defect manage 기능 개선 및 배포 반영
- current_status: 활성 운영 프로젝트

## 현재 목표
- 결함 관리 웹앱의 개선 작업을 빠르게 이어갈 수 있도록 현재 상태를 유지한다.

## 진행 중 작업
- 현재 세션 기준 긴급 미완료 작업은 없음

## 최근 완료 작업
- 모바일 테스트용 연동 메뉴얼과 사용자 메뉴얼 작성
- 테스트 페이지 상품 목록 100건 확장
- 신규 결함 등록의 이미지 직접 업로드 기능 복구 및 이미지 최적화 처리 추가
- 외부 위젯/연동 스크립트의 화면 캡처 품질 개선
- `결함 조치 현황`의 완료율 신호등 표시 반영
- 조치 결과 저장 후 결함 목록 자동 이동 반영
- `결함 조치 현황`에서 미배정 결함 클릭 동선 추가
- 검색 패널의 `미배정만 조회` 체크박스 제거
- 카드 라벨을 `집계 대상 결함 수`로 변경
- 대시보드 진입 시 불필요한 `defects select(*)` 조회 제거
- 목록 조회에서 `screenshot` 제외 명시 컬럼 조회로 튜닝
- CHANGELOG 기록 및 GitHub Pages 배포 완료

## 다음 작업
- `screenshot` 컬럼에 과거 base64 데이터가 남아 있는지 점검 가능
- 대시보드 체감 성능을 실측하고 필요 시 추가 쿼리 분리 검토
- 완료율 신호등 색상 기준에 대한 사용자 피드백 반영 가능
- 외부 사이트 이미지 미표시 시 CORS 제약 여부 확인 필요
- 모바일 공통 위젯의 cross-origin 데이터 전달 보완 필요 여부 검토

## 실행 / 검증
- run_command: `npm.cmd start`
- verify_command: `npm.cmd run check:syntax`, `npm.cmd run test:unit`
- port_or_runtime: `localhost:3000`
- deploy_method: `git push origin main` 후 GitHub Pages Actions
- vercel_base_url: `https://defect-manage.vercel.app`
- vercel_test_page_url: `https://defect-manage.vercel.app/test_page`

## 핵심 경로
- project_root: `D:\Workspace\defect_manage`
- key_docs:
  - `README.md`
  - `docs/README_ko.md`
  - `docs/CHANGELOG.md`
- key_files:
  - `js/app.js`
  - `js/storage.js`
  - `index.html`

## 리스크 / 주의사항
- 로컬 `server.js` 실행은 세션 환경에 따라 백그라운드 유지가 불안정할 수 있음
- GitHub Pages 배포본과 로컬 Node 서버 동작은 별도로 확인 필요

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/CHANGELOG.md`, `docs/모바일테스트_연동가이드.md`, `docs/모바일테스트_사용가이드.md`, `js/app.js`, `js/storage.js`
- 확인이 필요한 미결사항: 대시보드와 목록의 실제 쿼리 시간 비교, 모바일 위젯 cross-origin 연동 필요 여부
