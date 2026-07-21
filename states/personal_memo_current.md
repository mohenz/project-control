# personal_memo Current State

## 기본 정보
- project_key: personal_memo
- last_updated: 2026-07-22
- owner_request: `mohenz/personalMemo.git` 클론 후 Stitch MCP 디자인 변경사항을 받아 UI 개선
- current_status: `MEMOry` 브랜드 변경, 조용한 자동저장, 자료실 Firebase 업로드 backend 보정, 로그아웃 가시성 개선본을 `origin/main`에 푸시하고 Firebase Hosting 배포 완료

## 현재 목표
- 개인 메모 PWA를 Galaxy Tab 중심의 Digital Stationery 디자인 방향에 맞게 정리한다.

## 진행 중 작업
- 통합 화면의 실제 브라우저 UI 확인 및 세부 스타일 정리 필요
- 실제 로그인 계정 기반 Firestore 저장, Storage 이미지 업로드 E2E 확인 필요

## 최근 완료 작업
- 2026-07-15 원격 `origin/main` 변경사항을 로컬 `main`에 fast-forward 동기화 (`4bd47b9` → `e463ebe`, 충돌 없음)
- 동기화로 캘린더 시스템 날짜 사용 및 월간 이동 시 선택 날짜 유지 수정, Firebase/자료실 통합 변경사항 반영
- 캘린더 선택일 유지 수정 커밋 `e463ebe`를 `origin/main`에 푸시하고 원격 HEAD 일치 확인
- Firebase Hosting 운영 버전 `eba1955b41d7bd2e` 배포 및 새 자산 `index-12Ne3OHS.js` HTTP 200 확인
- 월 이동 시 `setSelectedDay(1)` 강제 선택 제거
- 대상 월에 같은 선택일을 유지하고, 해당 날짜가 없을 때만 월 마지막 날로 보정
- Vitest 8건, TypeScript 검사, 프로덕션 빌드, `git diff --check` 통과
- Firebase Hosting `archive-store-fae71` 운영 버전 `af2e2b88236fc85c` 배포 완료
- 공개 HTML이 새 자산 `index-B_m4bKQV.js`를 참조하고 해당 자산 HTTP 200 응답 확인
- 캘린더 `오늘` 기준을 고정 날짜에서 시스템 현재 날짜로 수정
- Vitest 5건, TypeScript 검사, 프로덕션 빌드 통과
- 로컬 커밋 `716bda8`, `a6ce1b3`을 `origin/main`에 푸시하고 원격 HEAD 일치 확인
- `Out-File -NoNewline` 재기록으로 한 줄화·문자 인코딩·JSX가 손상된 `src/components/CalendarView.tsx`를 Git `HEAD` 원본으로 복구
- 캘린더 기본 선택일을 2026년 7월 15일에서 14일로 변경
- 고정 2026년 7월 배열을 현재 조회 월 기준 날짜 계산으로 교체하고 이전 달/다음 달/오늘 네비게이션 추가
- 월 이동 시 연·월 제목, 날짜 그리드, 요일 색상, 메모 조회·추가 날짜가 함께 갱신되도록 정리
- `npm.cmd run lint`, `npm.cmd run build`, `git diff --check` 통과; 원격 배포는 수행하지 않음
- `D:\workspace\personalMemo`에 GitHub 저장소 클론
- Stitch MCP 연결 및 프로젝트 `projects/10144202817033188951` 화면/디자인 시스템 확인
- 디자인 토큰 누락 보정: `text-primary`, `text-secondary`, 24px 노트 패턴, 약한 그림자
- 대시보드/사이드바/상세/에디터/검색/캘린더의 반응형 레이아웃 개선
- 화면 문구의 이모지와 과장 표현 일부 제거
- `personalMemo` Firebase 클라이언트와 자료실 계정 로그인/Firestore 저장/Storage 이미지 업로드 서비스 추가
- `archive_store` Firebase rules에 `users/{uid}/apps/personalMemo`, `users/{uid}/personalMemo/images/*` 접근 경로 추가
- `personalMemo/.env.local`에 자료실 Firebase 프로젝트 환경변수 구성
- `archive_store/src`의 자료실 화면, 인증, 파일 업로드, Firebase 연동 모듈을 `personalMemo/src/archiveStore`로 이관
- `personalMemo` 라우터에 `ARCHIVE` 화면을 추가해 자료실을 앱 내부 화면으로 통합
- `personalMemo` 기본 백엔드를 `VITE_DATA_BACKEND=firebase`로 구성
- Firebase CLI 로그인 후 `archive-store-fae71`에 Firestore/Storage rules 배포 완료
- `personalMemo` 개발 서버를 `http://localhost:5179/`에서 재실행하고 HTTP 200 확인
- 앱 진입 화면을 Firebase 통합 로그인으로 변경하여 로그인 전 메모장 접근을 차단
- 로그인 후 메모장과 자료실이 같은 Firebase Auth 세션을 공유하도록 정리
- 자료실 화면이 내부 독립 인증 흐름으로 빠지지 않도록 `ArchiveView`가 상위 통합 로그인 사용자를 직접 받게 수정
- `자료실 계정` 버튼은 자료실 화면 이동이 아니라 설정/계정 관리로 열리도록 정리
- `personalMemo/firebase.json` 추가 후 통합 앱 빌드 결과를 `archive-store-fae71` Hosting에 배포
- 원격 Hosting URL `https://archive-store-fae71.web.app` HTTP 200 확인
- 메모장 로컬 저장소 기반 초기화 제거: `personal_notes_*` localStorage 읽기/쓰기 삭제
- 메모장 샘플 메모/샘플 그룹 정의 삭제
- 자료실 샘플 파일 fallback 삭제
- 기존 Firestore에 저장됐을 수 있는 레거시 샘플 note/group ID는 로딩 시 제외되도록 처리
- Firebase-only 수정본을 `archive-store-fae71` Hosting에 재배포하고 HTTP 200 확인
- 설정 모달의 `프리미엄 아바타 선택` 영역 제거 후 배포
- 사이드바의 `자료실 계정` 메뉴 제거 후 배포
- 프로필 이미지 저장 방식을 Firestore data URL 저장에서 Firebase Storage 업로드 후 URL 저장 방식으로 수정
- Storage rules에 `users/{uid}/personalMemo/profile/*` 경로 권한 추가 및 배포
- 실제 앱 Firebase 프로젝트가 `archive-store-v2-3d020`임을 확인하고 해당 프로젝트에 Firestore/Storage rules 배포
- 폴더 이름 입력 오류 대응: 전역/사이드바 `select-none` 제거, 폴더 모달 `z-[200]`/`select-text` 적용, 빈값 생성 차단, 모바일 폴더 추가 진입 노출
- DEV_TS_0003 테스트 결과서 생성: `D:\workspace\unit_test\reports\DEV_TS_0003_단위테스트_결과서_personalMemo_폴더입력_Firebase통합_20260706.md`
- 사이드바 상단 `내 메모장`/`개인용 디지털 스테이셔너리` 텍스트 제거, 프로필 이미지를 `w-16 h-16 lg:w-20 lg:h-20`로 확대 후 Hosting 배포
- 메모 상세 화면의 위치 정보/지도 데이터 표시 블록 제거, 위치 저장 관련 코드 없음 확인
- 스플래시 화면의 `Galaxy Tab Optimized` 문구 제거 후 Hosting 배포
- 메모 상세 화면 첨부 이미지 클릭/키보드 선택 시 전체화면 확대 모달 표시 기능 추가 후 Hosting 배포
- 메모 상세 읽기창 가로폭을 `max-w-3xl`에서 `max-w-6xl`로 확대 후 Hosting 배포
- 메모 상세 하단 플로팅 툴바를 고정 어두운 배경/밝은 텍스트/분리선으로 변경해 다크모드 대비 문제 수정 후 Hosting 배포
- 2026-07-20 앱 타이틀/브랜드명을 `내 메모장 - 프리미엄 디지털 스테이셔너리` 및 `Personal Notes`에서 `MEMOry`로 변경
- `index.html`, `public/manifest.json`, `src\App.tsx`, `src\components\SettingsModal.tsx`, `src\components\SplashView.tsx` 수정 후 커밋 `5839ef4 Rename app to MEMOry`를 `origin/main`에 푸시
- `MEMOry` 변경 빌드를 Firebase Hosting `archive-store-fae71`에 배포 완료
- 운영 URL 검증 완료: HTML title `MEMOry`, manifest `name`/`short_name` `MEMOry`, 원격 JS 번들 `MEMOry` 포함 및 `Personal Notes` 미포함, 데이터 프로젝트 `archive-store-v2-3d020` 유지 확인
- 모바일 최소 기능 기획 문서 추가: `personalMemo\docs\mobile_minimum_feature_plan.md`
- 2026-07-21 조용한 자동저장 기능 추가: `src\App.tsx`, `src\components\NoteEditor.tsx` 수정 및 문서 `docs\autosave_implementation_plan.md` 추가
- 자동저장은 `NoteEditor`에서 제목/본문/그룹/이미지/체크리스트 변경을 1.2초 debounce 후 부모 `onAutoSave`로 전달하고, `App`의 기존 `notes` 상태 변경 -> `saveMemoCloudState` 흐름으로 Firebase 저장
- 자동저장 커밋 `0c1aef8 Add quiet note autosave`를 `origin/main`에 푸시 완료
- 2026-07-21 자료실 파일 업로드 오류 대응: 통합 로그인 사용자(`integratedUser`)가 있으면 자료실 backend를 `firebase`로 강제하도록 `ArchiveView`/`useArchiveFiles` 수정
- 자료실 업로드 실패 시 Storage 권한/Firestore 권한/네트워크/취소 오류를 한국어 상태 메시지로 표시하도록 `useArchiveMutations` 보강
- 자료실 업로드 수정 커밋 `ef9ea8b Fix archive upload backend selection`를 `origin/main`에 푸시하고 Firebase Hosting 배포 완료
- 2026-07-21 사용자 계정 운영 방식 문서화: 앱 내부 회원가입 없이 Firebase Console `archive-store-v2-3d020 > Authentication > Users`에서 운영자가 최대 5명 수동 생성
- 사용자 계정 운영 문서 `personalMemo\docs\manual_user_account_operations.md` 추가 및 커밋 `32c4969 Document manual user account operations` 푸시 완료
- 2026-07-21 로그아웃 가시성 개선: 설정 모달 문구를 `MEMOry 로그아웃`으로 변경하고 자료실 상단 로그아웃 아이콘에 `로그아웃` 텍스트 추가
- 로그아웃 UI 개선 커밋 `4e43184 Improve logout visibility`를 `origin/main`에 푸시하고 Firebase Hosting 배포 완료
- 로그아웃 운영 배포 검증 완료: 운영 URL HTTP 200, 새 JS/CSS 번들 반영, 원격 JS에 `MEMOry 로그아웃` 포함, 데이터 프로젝트 `archive-store-v2-3d020` 유지 확인

## 다음 작업
- 로그인 가능한 브라우저에서 캘린더 이전 달/다음 달/오늘 이동을 시각 검수
- 실제 로그인 계정으로 폴더 생성, personalMemo 메모 저장, 자료실 파일 업로드, Storage 이미지 업로드 동작 확인
- 필요 시 자료실 CSS가 메모 화면에 미치는 글로벌 스타일 영향 정리
- 배포 스크립트에 운영 데이터 프로젝트 ID 고정 검증을 추가해 잘못된 Firebase 설정이면 빌드 또는 배포가 실패하도록 구성
- 다른 PC에서 이어 진행할 사용자 확대 작업은 "공유 없는 단독 사용자별 데이터 분리" 범위로 한정
- 가족/소규모 사용자 수는 5인 이내로 가정하되, 가족 공간·초대·공유·공동 편집·관리자 권한 모델은 만들지 않음
- 현재 Firebase Auth 로그인 사용자 자동 인식(`uid`)을 그대로 사용하고, 데이터베이스/Storage 경로 차원에서만 사용자 데이터를 분리·검증
- Firebase 전환 전 내용을 유지 중인 `README.md`, `docs/technical_architecture.md`, `docs/codex_handover.md` 현행화
- 사용자 계정은 앱 내부 회원가입 기능을 만들지 않고 Firebase Console `archive-store-v2-3d020 > Authentication > Users`에서 운영자가 직접 생성
- 가족/소규모 사용자 5인 제한은 앱 코드로 강제하지 않고 Firebase Console 사용자 목록 기준으로 운영 관리
- 신규 소유자/IAM 추가와 Firebase Authentication 사용자 생성은 별개임을 운영 안내에 반영하고, 로그인 불가 시 `archive-store-v2-3d020 > Authentication > Users`에 계정이 있는지 먼저 확인

## 사용자 분리 구조 계획
- 목표: `MEMOry`를 가족 5인 이내가 각자 독립 계정으로 사용하는 개인 디지털 메모장으로 유지
- 범위: 공유 기능 없음, 가족 공용 공간 없음, 다른 사용자 메모/일정 열람 없음, 공동 편집 없음
- 인증/권한: 별도 백엔드 계정 체계나 앱 내 관리자 권한을 추가하지 않고, 현재 Firebase Auth의 `request.auth.uid`를 자동 인식 기준으로 사용
- 개인 데이터 기준 경로: `users/{uid}/apps/personalMemo`
- 현재 1차 저장 구조: `users/{uid}/apps/personalMemo` 문서에 사용자별 `notes`, `groups`, `darkMode`, `profileImage` 등 앱 상태 저장
- 향후 분리 세분화가 필요할 경우 후보 경로: `users/{uid}/apps/personalMemo/state/main`, `users/{uid}/apps/personalMemo/settings/main`, `users/{uid}/apps/personalMemo/notes/{noteId}`, `users/{uid}/apps/personalMemo/groups/{groupId}`
- Storage 기준 경로: `users/{uid}/personalMemo/images/*`, `users/{uid}/personalMemo/profile/*`
- Firestore Rules 원칙: `request.auth != null && request.auth.uid == uid`인 경우에만 `users/{uid}/...` 읽기/쓰기 허용
- Storage Rules 원칙: `request.auth != null && request.auth.uid == uid`인 경우에만 `users/{uid}/...` 파일 읽기/쓰기 허용
- 계정 전환 안전장치: 로그아웃 시 화면 상태를 비우고, 새 로그인 시 해당 `uid` 경로 데이터만 로드해야 함
- 검증 시나리오: A 계정 작성 데이터가 B 계정에서 보이지 않아야 하며, B 계정 작성 데이터도 A 계정에서 보이지 않아야 함
- 배포 불변조건: Hosting은 `archive-store-fae71`, 실제 Auth/Firestore/Storage 데이터 프로젝트는 `archive-store-v2-3d020` 유지

## 사용자 계정 운영 방식
- 확정 방식: 앱 내부 `계정 만들기` 기능을 추가하지 않고, 운영자가 Firebase Console에서 계정을 수동 생성
- Firebase 프로젝트: 실제 Auth 프로젝트인 `archive-store-v2-3d020`
- Console 경로: `Authentication > Users > 사용자 추가`
- 사용자 전달 정보: 접속 URL `https://archive-store-fae71.web.app`, 로그인 이메일, 임시 비밀번호
- 사용자는 발급받은 계정으로 로그인하며, 로그인 후 Firebase Auth `uid` 기준으로 메모와 자료실 데이터가 자동 분리됨
- 최대 사용자 수 5명 제한은 운영자가 Firebase Console 사용자 목록을 보고 수동 관리
- 앱에 추가하지 않는 기능: 회원가입, 가족 공간, 초대, 공유, 공동 편집, 앱 내 관리자 권한
- 관련 문서: `personalMemo\docs\manual_user_account_operations.md`

## 실행 / 검증
- run_command: `npm.cmd run dev`
- verify_command: `npm.cmd run lint`, `npm.cmd run build`
- port_or_runtime: Vite dev server `http://localhost:5179/`
- deploy_method: Firebase Hosting `archive-store-fae71`; 자료실 Firebase 프로젝트를 기본 운영 기준으로 사용
- hosting_project: `archive-store-fae71`
- data_project: Firebase Auth/Firestore/Storage `archive-store-v2-3d020`
- deploy_invariant: Hosting 프로젝트와 데이터 프로젝트가 의도적으로 다르며, 프로덕션 번들의 `VITE_FIREBASE_PROJECT_ID`는 반드시 `archive-store-v2-3d020`이어야 함
- pre_deploy_check: `.env.local` 존재 여부와 필수 `VITE_FIREBASE_*` 값 확인, 테스트/타입 검사/프로덕션 빌드 통과, 생성된 JS 번들에 `archive-store-v2-3d020` 포함 및 `archive-store-fae71.firebaseapp.com` 미포함 확인
- deploy_command: Hosting 배포 대상은 반드시 `firebase deploy --only hosting --project archive-store-fae71`
- post_deploy_check: Hosting HTTP 200, 새 번들 해시 반영, 원격 JS 번들의 데이터 프로젝트 ID 확인, 기존 계정 로그인 후 메모·일정·개인설정 조회 확인
- deploy_abort_condition: Firebase 환경변수 누락, 데이터 프로젝트 불일치, 원격 번들 검증 실패 시 배포 중단 또는 즉시 직전 정상 버전으로 복구
- latest_program_head: `4e43184 Improve logout visibility`
- latest_verified_bundle: JS `assets/index-gcD3glXy.js`, CSS `assets/index-BWIMTqjn.css`
- sync_verification: 2026-07-15 `HEAD`, `origin/main`, `origin/HEAD` 모두 `e463ebe`; 작업 트리 깨끗함

## 핵심 경로
- project_root: `D:\workspace\personalMemo`
- key_docs: `README.md`, `docs\technical_architecture.md`, `docs\codex_handover.md`
- key_files: `src\App.tsx`, `src\index.css`, `src\components\*.tsx`

## 리스크 / 주의사항
- Chrome DevTools MCP가 2026-07-06 세션에서 장시간 타임아웃되어 브라우저 시각 검수는 완료하지 못함
- Chrome DevTools 연결이 2026-07-14에도 장시간 타임아웃되어 캘린더 브라우저 시각 검수는 완료하지 못함
- 소스 파일 수정에 `Out-File` 전체 재기록을 사용하지 말고, 문맥이 작은 `apply_patch` 방식만 사용
- 앱 운영 데이터는 `archive-store-v2-3d020`의 Firebase Auth/Firestore/Storage에 저장됨. Hosting 프로젝트 `archive-store-fae71`의 Firebase SDK 설정으로 빌드하면 기존 데이터가 사라진 것처럼 보이므로 두 프로젝트를 혼동하지 말 것
- 앱 데이터의 운영 기준은 Firebase이며, localStorage는 로그인 이메일·테마 같은 로컬 설정에만 사용됨
- 데이터 초기화·복사·마이그레이션 작업은 사전 백업과 사용자 승인 없이 수행 금지
- 운영 Hosting은 2026-07-15 05:58 KST 배포본과 새 JavaScript 자산 모두 HTTP 200 확인
- `README.md`, `docs/technical_architecture.md`, `docs/codex_handover.md`는 아직 localStorage 단독 구조를 기술해 실제 Firebase-only 코드와 불일치
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `src\App.tsx`, `src\index.css`, Stitch 프로젝트 `디자인 작업 명세 이행`
- 확인이 필요한 미결사항: 모바일/태블릿 실제 렌더링 스크린샷 검수

## Handoff
- current_goal: 배포된 캘린더 월 이동 선택일 유지 동작의 브라우저 실기 검수
- done_latest: 1일 강제 선택 제거, Vitest 8건·lint·build 통과, 커밋 `e463ebe` 푸시 및 Hosting 배포 완료
- key_findings: Stitch 최신 관련 프로젝트는 Digital Stationery System이며 대시보드/에디터/검색/캘린더 화면 산출물이 있음
- changed_files: latest `src\components\CalendarView.tsx`; previous `src\App.tsx`, `src\types.ts`, `src\archiveStore\**`, `src\firebase\client.ts`, `src\services\archiveIntegration.ts`, `src\components\Sidebar.tsx`, `src\components\SettingsModal.tsx`, `src\components\NoteEditor.tsx`, `.env.example`, `package.json`, `package-lock.json`; archive_store rules: `firebase\firestore.rules`, `firebase\storage.rules`
- verification: `npm run lint`, `npm run build`, `git diff --check` 통과; Firebase rules 및 Hosting 배포 완료; 브라우저 자동화 테스트는 드라이버 오류 후 사용자 지시로 중단
- next_action: 로그인 기반 캘린더·Firestore·Storage 실동작 검수
- risks_or_blockers: 로그인 계정 기반 브라우저 E2E는 미완료; 자료실 CSS가 전역 스타일로 포함되어 통합 화면 간 스타일 영향 점검 필요
- deployment_guard: Hosting=`archive-store-fae71`, Auth/Firestore/Storage=`archive-store-v2-3d020`; 배포 전후 번들 프로젝트 ID 검증 필수
