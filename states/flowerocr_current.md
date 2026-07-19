# FlowerOCR Project State

## 기본 정보
- project_key: `flowerocr`
- last_updated: `2026-07-19`
- current_status: `PC Web 운영 개선 및 심플 전표관리 설계 완료 / Firestore App Check 접근 차단 확인 중`
- firebase_project: `Flower-OCR`
- firebase_project_id: `gen-lang-client-0981139133`
- hosting_url: `https://gen-lang-client-0981139133.web.app`

## 현재 목표
- 모바일 앱은 Google AI Studio 개발 범위로 유지한다.
- PC Web에서 Firebase에 저장된 꽃 주문 전표를 조회·검토·수정하고, 다른 브라우저 창의 외부 전표 입력화면으로 최종 전송하는 운영 시스템을 구현한다.

## 확정 데이터 계약
- Firestore Database ID: `ai-studio-flowerocr-8c4ed0ea-d5cc-4c23-9094-4b56362a40bd`
- Firestore 문서: `documents/{documentId}`
- 원본 이미지: `documents/{documentId}/original.jpg`
- 보정 이미지: `documents/{documentId}/corrected.jpg`
- 썸네일: `documents/{documentId}/thumbnail.jpg`
- 상태값: `REVIEW_REQUIRED`, `READY_TO_SEND`, `SENDING`, `SENT`, `SEND_FAILED`
- 거래처는 `회사명 + 담당자명`을 한 세트로 관리하고 `partnerId`와 함께 전송한다.

## 최근 완료 작업
- Stitch 신규 디자인 검토 및 전 화면 한글화 원칙 반영
- 의존성 없는 모듈형 PC Web 프로토타입 구현
- 대시보드, 전표 검색, 작성 완료·완료 전 구분, 상태별 목록 구현
- 전표 원본 대조와 OCR 필드 수정 화면 구현
- 약어사전과 거래처·담당자 관리 화면 구현
- Google Firebase Authentication 로그인·로그아웃 연결
- Firestore REST 조회 서비스와 Firebase ID 토큰 전달 구현
- Firebase Hosting 설정 및 운영 배포 완료
- 이름 있는 Firestore 데이터베이스에 조회 전용 규칙 배포
- 외부 전표 입력 프로그램 모의 화면과 최종 전송 테스트 구현
- 최종 전송 데이터 계약 버전 `1.0` 및 수신 확인(ACK) 흐름 구현
- PC 약어사전을 모바일 계약인 `dictionary/{abbreviation}`로 통일
- PC 전표 저장을 Firestore 부분 업데이트로 변경하여 모바일 고유 필드와 원본 OCR 데이터 보존
- 원본 전표 이미지 표시·확대·축소·회전·다운로드 연결
- 전표 처리 상태 필터 연결 및 Firebase 오류 원문 표시
- 이름 있는 Firestore DB의 `documents`, `dictionary`, `partners`, `transferHistory` 운영자 규칙 배포
- 프로토타입 전표·약어·거래처 및 고정 대시보드 수치 제거
- Firebase 접근 오류를 컬렉션별로 분리하고 로그인 계정 진단 표시 추가
- 심플 전표관리 타당성 분석 및 설계 완료

## 현재 확인된 문제
- 로컬 `mobile` 소스는 모바일 개발 측 최신 개선본과 아직 동기화되지 않았다.
- 모바일 Google 로그인 오류는 모바일 개발 측에서 확인·개선 중이다.
- PC와 모바일의 공동 DB 최종 확인은 모바일 최신본에서 실제 전표 1건 생성 후 수행해야 한다.
- PC Web은 `smallville71@gmail.com`으로 정상 로그인했지만 `documents`, `dictionary`, `partners` 모두 `Missing or insufficient permissions`를 반환한다.
- 대상 명명 DB 규칙은 해당 운영자 이메일 조건으로 정상 컴파일·릴리스되었으므로 Cloud Firestore App Check 적용이 가장 유력한 원인이다.
- Firebase Console에서 App Check의 Cloud Firestore 적용 상태를 확인하고, 공동 DB 검증 동안 일시 해제하거나 PC Web App Check를 구성해야 한다.

## 최종 전송 테스트
- 설정 화면의 `전송 테스트` 버튼으로 별도 브라우저 창을 연다.
- 모의 외부 입력화면에 거래처와 전표 필드를 자동 입력한다.
- `BroadcastChannel`로 송신, 수신 준비, 수신 확인 응답을 테스트한다.
- 테스트 화면: `https://gen-lang-client-0981139133.web.app/target-test`
- 실제 타사 입력 사이트는 일반 웹페이지에서 직접 DOM 조작할 수 없으므로 Chrome 확장 프로그램 또는 로컬 자동입력 브리지가 필요하다.
- 실제 연동 시 `js/features/final-transfer.js`의 송신 어댑터만 교체하고 데이터 계약은 유지한다.

## 다음 작업
- Firebase Console에서 Cloud Firestore App Check 적용 상태 확인
- 적용 중이면 일시 해제 후 PC Web 조회 재검증
- 모바일 최신 소스를 로컬 `mobile` 폴더에 동기화
- 모바일에서 전표 1건을 생성하고 PC 조회·수정·재조회로 공동 DB 왕복 검증
- 실제 모바일 문서 스키마에 맞춘 최종 필드 매핑 보정
- revision 충돌 감지와 동시 수정 경고 구현
- 심플 전표관리 1단계 구현: 모바일 이미지 업로드, 임시전표 생성, PC 접수함, 모바일 처리상태
- 실제 외부 입력 프로그램의 URL, 필드 선택자, 화면 전환 방식 조사
- Chrome 확장 프로그램 또는 로컬 브리지 방식 확정 및 최종 전송 어댑터 구현

## 실행 / 검증
- local_run: `cd D:\Workspace\FlowerOCR\src; python -m http.server 8091`
- local_url: `http://localhost:8091`
- syntax_check: `node --check`로 `src\js` 하위 전체 JavaScript 검사
- deploy_command: `npx.cmd --yes firebase-tools deploy --only hosting --project gen-lang-client-0981139133 --non-interactive`
- rules_deploy: `npx.cmd --yes firebase-tools deploy --only firestore:rules --project gen-lang-client-0981139133 --non-interactive`
- hosting_verification: 메인 화면과 최종 전송 테스트 화면 `HTTP 200` 확인

## 핵심 경로
- project_root: `D:\Workspace\FlowerOCR`
- source_root: `D:\Workspace\FlowerOCR\src`
- app_entry: `src\index.html`
- firebase_auth: `src\js\auth-service.js`
- firestore_reader: `src\js\firebase-service.js`
- final_transfer: `src\js\features\final-transfer.js`
- target_test: `src\target-test.html`, `target-test.js`, `target-test.css`
- firestore_rules: `firestore.rules`
- firebase_config: `firebase.json`, `.firebaserc`
- design_source: `design\stitch_new`

## 리스크 / 주의사항
- Firebase API 키는 클라이언트 식별자이며 보안은 Authentication, Firestore Rules, App Check 조합으로 보장해야 한다.
- Firestore 읽기·쓰기는 현재 `smallville71@gmail.com` 운영자 계정으로 제한되어 있다.
- 외부 사이트 자동입력은 동일 출처 테스트 방식과 실제 운영 방식이 다르다.
- 실제 전송 전 사용자 확인, 필드 매핑 검증, 중복 전송 방지, ACK와 실패 재처리를 구현해야 한다.
- 모든 사용자 노출 UI와 디자인 의뢰는 한글화를 필수로 한다.

## Handoff
- current_goal: `Firestore 접근 정상화 후 심플 전표관리 공동 데이터 왕복 구현`
- done_latest: `프로토타입 데이터 제거, Firebase 컬렉션별 진단 배포, 심플 전표관리 타당성 설계`
- verification: `JavaScript 문법 검사, Hosting 배포 성공, 메인·테스트 화면 HTTP 응답 확인, Firestore 규칙 컴파일·릴리스 확인`
- next_action: `Firebase Console에서 Cloud Firestore App Check 적용 상태 확인 및 PC 조회 재검증`
- primary_blocker: `운영자 로그인은 정상이나 Firestore 세 컬렉션 모두 권한 거부`
- architecture_decision: `PC Web 송신 데이터 계약과 실제 브라우저 자동입력 어댑터를 분리`
