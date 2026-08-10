# FlowerOCR Project State

## 기본 정보
- project_key: `flowerocr`
- last_updated: `2026-08-10`
- current_status: `FlowerNT3 실제 입력화면 분석 및 Chrome 확장 프로그램 연동 설계 완료 / 확장 구현 대기`
- legacy_firebase_project: `Flower-OCR`
- legacy_firebase_project_id: `gen-lang-client-0981139133`
- legacy_hosting_url: `https://gen-lang-client-0981139133.web.app`

## 현재 목표
- Google AI Studio 모바일 시뮬레이터를 실제 React Native Android 앱으로 재구현한다.
- Firebase Auth·Firestore·Storage·Hosting 의존성을 제거한다.
- Supabase Auth·Postgres·Storage와 Vercel Hosting·Functions 구조로 전환한다.
- PC Web과 React Native 앱이 동일 데이터와 revision을 사용하도록 통합한다.

## 기존 Firebase 계약 (이관 원본)
- Firestore Database ID: `ai-studio-flowerocr-8c4ed0ea-d5cc-4c23-9094-4b56362a40bd`
- Firestore 문서: `documents/{documentId}`
- 원본 이미지: `documents/{documentId}/original.jpg`
- 보정 이미지: `documents/{documentId}/corrected.jpg`
- 썸네일: `documents/{documentId}/thumbnail.jpg`
- 상태값: `REVIEW_REQUIRED`, `READY_TO_SEND`, `SENDING`, `SENT`, `SEND_FAILED`
- 거래처는 `회사명 + 담당자명`을 한 세트로 관리하고 `partnerId`와 함께 전송한다.

## 목표 데이터 계약
- 인증: Supabase Auth 단일 운영 계정, 공개 회원가입 비활성화
- 데이터: Supabase Postgres `documents`, `ocr_fields`, `product_aliases`, `partners`, `transfer_history`
- 이미지: Supabase Storage 비공개 버킷 `flower-documents`
- 서버: Vercel Functions에서 OCR·외부 전송·서버 전용 작업 수행
- 동시성: `revision` 기반 낙관적 잠금
- 상세 설계: `docs\13_Supabase_Vercel_React_Native_전환_설계서.md`

## 최근 완료 작업
- FlowerOCR 전환 전체 변경을 GitHub 브랜치 `agent/supabase-react-native-flowernt3-design`, 커밋 `ab2328a`, Draft PR `#1`로 원격 저장
- FlowerNT3 `order_form2` 필드·ASP 등록 흐름·`window.external` 의존성을 분석하고 Chrome Manifest V3 확장 연동 설계 완료
- 입력 완료와 실제 등록 성공을 분리하고, 등록 성공 전 Supabase 문서를 `SENT`로 변경하지 않는 상태 계약 확정
- `docs\16_FlowerNT3_Chrome_확장프로그램_연동_설계서.md`와 개발 체크리스트 갱신
- 실제 전송 대기 전표로 PC Web 최종 전송 → 등록화면 전체 필드 수신 → ACK → Supabase `SENT`·성공 전송이력 저장 E2E 검증 완료
- 데스크톱·Android Chrome 반응형 증빙과 DEV_TS_0003 테스트 결과서 생성, 테스트용 거래처는 검증 후 보관 처리
- 동일 `transferId` 재수신 방어 결함을 발견해 Set 기반 중복 처리 차단 후 Vitest 17건 회귀 검증 성공
- 전표 메타정보·거래처·주문·상품·배송·이미지 정보를 수신하는 `voucher-registration.html` 등록화면 구현
- PC Web `최종 전송` 버튼을 동일 출처 `window.postMessage` 전송과 수신 ACK 흐름으로 연결하고 최신 폼 값을 저장·전송하도록 수정
- 전표 전체 payload 테스트 추가 후 Vitest 16건, JavaScript 문법 검사, Production 빌드 검증 성공
- 모바일·PC Web·OCR API에서 주문일을 자유 텍스트로 저장하도록 변경하고 Supabase `documents.order_date`를 `date`에서 `text`로 전환
- 운영 Supabase 스키마에서 `order_date=text` 확인 후 React Native Jest 8건, TypeScript, PC/Vercel Vitest 14건, Production 빌드 검증 성공
- 로컬 Vite API의 Supabase 사용자 검증을 Auth REST 조회로 교체하고 FlowerOCR `.env` 우선 적용 및 외부 통신 권한 실행으로 `UNAUTHENTICATED` 오류 해결
- 신규 로그인 토큰으로 로컬 OCR API 호출 시 인증 단계를 통과하고 `DOCUMENT_NOT_FOUND` 응답까지 도달하는 실연결 검증 완료
- 모바일·PC Web·Vercel API의 객체형 오류를 공통 해석하여 `[object Object]` 대신 코드·메시지·상세내용·요청 ID를 표시하도록 수정
- 오류 표시 단위테스트 추가 후 React Native Jest 8건, TypeScript, PC/Vercel Vitest 13건, Production 빌드 검증 성공
- 모바일·PC Web·OCR API에서 배송일시 날짜 형식 검증과 ISO 변환을 제거하고 자유 텍스트로 저장하도록 변경
- Supabase `documents.delivery_at`을 `timestamptz`에서 `text`로 변경하고 운영 스키마에서 `text` 타입 확인
- 배송일시 자유 텍스트 테스트를 포함해 React Native Jest 6건, TypeScript, PC/Vercel Vitest 13건, Production 빌드 검증 성공
- Vite 로컬 서버에 `/api/documents/{id}/finalize-upload`, `/api/ocr` 연결 및 Supabase 인증 컨텍스트 적용
- 갤러리 업로드 완료 요청 404와 보정 이미지 검색 결함 수정, 실패 전표 `86d4b0a7-9e5a-4f9b-9eb5-af77f9beee60`을 `UPLOADED`로 복구
- Android 기기 `SM-S921N`에 Development APK 설치 및 앱 프로세스 실행 확인
- Android Studio, SDK 36, Platform Tools, NDK, CMake 3.22.1, JDK 17 설치 및 사용자 환경변수 구성
- arm64 Development APK 빌드 성공: `mobile-rn\android\app\build\outputs\apk\debug\app-debug.apk`
- Expo Development Client 의존성, `flowerocr` URI 스킴, LAN Metro 실행 설정 및 `192.168.0.10:8081` 접근 검증
- Supabase 프로젝트 `epadgzydpvtqyfkiwquf`에 초기 마이그레이션 적용
- 5개 업무 테이블의 RLS 활성화, 정책 6개, 비공개 `flower-documents` 버킷(10MB) 생성 검증
- 운영 계정으로 PC Web 로그인 및 `Supabase 0건 조회` 정상 동작 확인
- Firebase 기반 구형 `mobile/` 시뮬레이터, SDK, 설정, 규칙 제거(클라우드 데이터 삭제 없음)
- Expo 57 React Native 앱에 로그인, 촬영, 앨범, 회전·압축, 원본·보정본 업로드, OCR, 검토, 보관함, 약어사전, 오프라인 대기열 구현
- Supabase Postgres 마이그레이션에 5개 업무 테이블, RLS, Storage 정책, 상태 전이 검증, 인덱스 구현
- Vercel Functions에 health, JWT 검증, 업로드 완료, Gemini OCR API 구현
- PC Web을 Supabase Auth·Postgres·Storage로 전환하고 안전한 렌더링·revision 충돌 처리 적용
- PC/Vercel Vitest 6건, React Native Jest 6건, TypeScript, Vite Production 빌드, Android Hermes 번들 검증 성공
- `mohenz/flowerOCR_PCweb`를 `D:\Workspace\flowerOCR_PCweb`에 클론하고 실제 PC Web·모바일·설계 소스 확인
- `docs\13_Supabase_Vercel_React_Native_전환_설계서.md` 작성
- 사용자 제공 모바일 캡처 4종을 기준으로 `docs\14_React_Native_UI_디자인_명세서.md` 작성
- 개발 순서와 지속 갱신 체크리스트 `docs\15_개발_작업순서_체크리스트.md` 작성
- Supabase RLS, Storage 비공개 경로, Vercel OCR Function, 커서 페이지네이션, revision 충돌 구조 확정
- project-control 레지스트리 경로를 실제 저장소로 정정
- GitHub `mohenz/FlowerOCR`를 `D:\Workspace\FlowerOCR`에 재클론
- `main` HEAD `f352774c8de888bb22a4d6fb3e6ce7809242ab82`, `origin/main` 일치 및 clean worktree 확인
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
- FlowerNT3 실제 운영 URL과 ASP 등록 성공 응답 신호가 아직 확인되지 않았다.
- FlowerOCR의 자유 텍스트 주문일·배송일시를 FlowerNT3 날짜 필드로 변환할 수 없는 경우 사용자 확인이 필요하다.
- Vercel 팀·프로젝트·환경변수가 없어 Preview 배포는 실행하지 못했다.
- Gemini 모델·사용량 한도가 미확정이어서 실제 OCR 정확도 검증을 수행하지 못했다.
- Android 실제 기기에서 카메라·권한·네트워크 단절 복구를 검증하지 못했다.
- 네 모서리 자르기와 원근 보정, 업로드 진행률·취소는 아직 구현되지 않았다.
- Expo 57/Metro의 `image-size@1.2.1` 전이 의존성 보안 경고 11건이 잔존한다.
- 실제 외부 전표 프로그램 연동은 구현되지 않았고 동일 출처 테스트 화면만 존재한다.

## 최종 전송 테스트
- 전표 상세 화면의 `최종 전송` 버튼으로 `voucher-registration.html`을 별도 창에 연다.
- 전표 메타정보·거래처·주문·상품·배송·이미지 필드를 자동 입력한다.
- 동일 출처 `window.postMessage`로 송신, 수신 준비, 수신 확인 응답을 처리한다.
- 로컬 등록화면: `http://localhost:5173/voucher-registration.html`
- 실제 타사 입력 사이트는 일반 웹페이지에서 직접 DOM 조작할 수 없으므로 Chrome 확장 프로그램 또는 로컬 자동입력 브리지가 필요하다.
- 실제 연동 시 `js/features/final-transfer.js`의 송신 어댑터만 교체하고 데이터 계약은 유지한다.

## 다음 작업
- Chrome 확장 프로그램 기본 구조, 메시지 검증, 필드 매퍼와 FlowerNT3 자동 입력 상태 패널 구현
- 실제 FlowerNT3 운영 URL과 등록 성공 응답을 확인하여 Manifest 허용 범위와 완료 판정 연결
- 운영 계정의 Supabase CRUD·Storage 업로드 통합 검증
- Vercel 프로젝트 환경변수 구성 후 Preview 배포와 실제 Gemini OCR 검증
- Android 실제 기기 테스트와 네 모서리 자르기·원근 보정 구현
- 필요 시 기존 Firebase 데이터·이미지 이관 및 무결성 검증
- 실제 외부 입력 프로그램의 URL, 필드 선택자, 화면 전환 방식 조사
- Chrome 확장 프로그램 또는 로컬 브리지 방식 확정 및 최종 전송 어댑터 구현

## 실행 / 검증
- pc_local_run: `cd D:\Workspace\flowerOCR_PCweb; npm.cmd run dev`
- mobile_run: `cd D:\Workspace\flowerOCR_PCweb\mobile-rn; npm.cmd run start`
- pc_verify: `npm.cmd run deploy:check`
- mobile_verify: `npm.cmd run lint`, `npm.cmd test -- --watch=false`, `npm.cmd run build:check`
- target_deploy: Vercel Hosting·Functions + Supabase Auth·Postgres·Storage
- deploy_status: Supabase 스키마 적용 완료 / GitHub Draft PR `mohenz/FlowerOCR_PCweb#1` 생성 / Vercel Preview 미구성

## 핵심 경로
- project_root: `D:\Workspace\flowerOCR_PCweb`
- source_root: `D:\Workspace\flowerOCR_PCweb\src`
- app_entry: `src\index.html`
- react_native_root: `mobile-rn`
- supabase_migration: `supabase\migrations\202608100001_initial_flowerocr.sql`, `supabase\migrations\202608100002_delivery_at_text.sql`, `supabase\migrations\202608100003_order_date_text.sql`
- vercel_api: `api`
- final_transfer: `src\js\features\final-transfer.js`
- voucher_registration: `src\voucher-registration.html`, `voucher-registration.js`, `voucher-registration.css`
- target_test: `src\target-test.html`, `target-test.js`, `target-test.css`
- target_architecture: `docs\13_Supabase_Vercel_React_Native_전환_설계서.md`
- react_native_ui_spec: `docs\14_React_Native_UI_디자인_명세서.md`
- development_checklist: `docs\15_개발_작업순서_체크리스트.md`
- design_source: `design\stitch_new`

## 리스크 / 주의사항
- Firebase 클라우드 데이터는 Supabase 건수·이미지 해시 검증과 롤백 기간 완료 전 삭제 금지
- Vercel Function 요청에는 이미지 Base64를 보내지 않고 Supabase Storage 직접 업로드 사용
- 외부 사이트 자동입력은 동일 출처 테스트 방식과 실제 운영 방식이 다르다.
- 실제 전송 전 사용자 확인, 필드 매핑 검증, 중복 전송 방지, ACK와 실패 재처리를 구현해야 한다.
- 모든 사용자 노출 UI와 디자인 의뢰는 한글화를 필수로 한다.

## Handoff
- current_goal: `Firebase를 제거하고 Supabase·Vercel·React Native 구조로 전환`
- done_latest: `주문일·배송일시 자유 텍스트 전환 및 Supabase 운영 스키마 적용`
- verification: `Vitest 17/17, Jest 8/8, TypeScript, Vite Production 빌드, 최종 전송 E2E·DB SENT·SUCCESS 이력 확인`
- next_action: `Supabase CRUD·Storage 통합 검증 후 Vercel Preview·실기기 검증`
- primary_blocker: `Vercel 프로젝트·Gemini 환경변수 미구성`
- architecture_decision: `이미지는 Supabase Storage 직접 업로드, OCR·외부 전송만 Vercel Function 수행`
