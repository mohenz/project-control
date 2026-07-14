# archive_store (자료실 관리 서비스)

## 개요
- Firebase Auth/Firestore/Storage 기반의 개인용 자료실 웹 서비스
- 로컬 개발 환경용 PostgreSQL 및 Express API 병행 지원

## 마일스톤 및 상태
- status: `GREEN` (정상 작동 중, 핵심 기능 구현 완료 및 Vercel 배포 완료)
- goal: 로컬 개발 환경 보존 상태에서 Firebase 인증 및 실서버 배포 완결
- details:
  - 1단계: PostgreSQL/로컬 API 및 파일 삭제 정합성 강화 (완료)
  - 2단계: 모바일 Spacing 최적화, 목록 도구 통합 및 브랜딩 명칭("자료실") 통일 (완료)
  - 3단계: 리스트/카드 보기 모드 토글 기능 및 CSS 레이아웃 최적화 (완료)
  - 4단계: 밝게/어둡게 보기(테마 토글 기능, 다크 네이비 테마) 구현 및 Vercel 상용 배포 완결 (완료)
- 다른 PC에서 Git clone 후 로컬 PostgreSQL/API 기반 개발 환경을 재현할 수 있는 상태를 유지한다.

## 진행 중 작업
- Firebase Authentication 실계정 생성 대기 및 로그인 연동 테스트
- Stitch MCP hosted image/code URL 수집은 인증 문제로 대기

## 최근 완료 작업
- 2026-07-05: 다크모드 리스트 뷰에서 파일 목록 로우(.file-row)의 배경색 미지정으로 인해 파일명 텍스트(흰색 계열)와 배경이 겹쳐 파일명이 보이지 않던 버그 수정 및 재배포 완료.
- 2026-07-05: 어둡게/밝게 보기(테마 토글 기능)를 다크 네이비(Dark Navy) 전용 오버라이드 스타일과 함께 추가 구현하고, Git 원격 푸시 및 Vercel 실서버 상용 릴리즈 배포(`npx vercel --prod`) 최종 완료.
- 2026-07-05: 이미지/파일 미리보기 모달창(.modal-backdrop)에 z-index(1000)를 추가하여, 바탕 화면에 있는 파일 목록 선택 체크박스들이 모달 레이어 위로 노출되는 겹침 현상 해결.
- 2026-07-05: 카드형 보기 모드에서 이미지 썸네일이 노출되지 않던 현상 수정. 데이터 필드 구조상 `publicUrl` 대신 `downloadUrl`을 참조하도록 경로 정정.
- 2026-07-05: 파일 목록의 보기 방식을 리스트형과 카드형(그리드)으로 전환할 수 있는 카드 뷰 토글(Card View Mode) UI 및 CSS 스타일 최적화 구현 완료.
- 2026-07-05: 카테고리 필터 탭 영역의 텍스트 라벨들을 전부 제거하고 정사각의 HSL 액센트 컬러풀 아이콘 형태로 개편. 가로폭이 매우 좁은 모바일 규격 하에서도 1열 flex 정렬 흐름이 개행 없이 고정 배치되도록 CSS 오버라이드.
- 2026-07-05: 아카이브 목록 제어 도구(모두선택 체크박스, 선택 개수 텍스트, 선택/전체삭제 버튼, 총 개수, 목록 드롭다운)를 단일 컨테이너인 `.list-tools`로 최종 통합하여 단 하나의 행(Single Row)에 정렬하고, 모바일 500px 뷰포트에서도 수평 정렬을 유지하도록 Spacing 최적화 완료.
- 2026-07-05: 메인 툴바의 타이틀 and 인증 폼의 eyebrow 텍스트 등에서 "Archive Store"와 "아카이브" 용어를 완전히 제거하고, 이를 대표 한글 텍스트인 `"자료실"`로 일괄 명칭 변경 완료.
- 2026-07-04: Archive Store 기능 단위 분리 최종 반영. `useArchiveAuth.js`는 Firebase/PIN 인증과 비밀번호 재설정, `useArchiveListControls.js`는 필터/검색/페이지네이션/선택 상태, `useArchiveMutations.js`는 업로드/삭제/드롭/붙여넣기 처리를 담당하도록 분리. `ArchiveView.jsx`는 데이터/화면 조립만 담당하도록 축소.
- 2026-07-04: 로그인 화면과 작업 화면을 같은 `ArchiveView.jsx`에 두던 구조를 분리. `ArchiveAuthScreen.jsx`는 로그인/PIN/비밀번호 재설정 화면 전용, `ArchiveWorkspaceScreen.jsx`는 파일 작업 화면 전용, `ArchiveView.jsx`는 인증/데이터 상태 연결 컨테이너로 역할을 제한.
- 2026-07-04: project-control 중앙 작업룰에 기능 단위 및 화면 단위 소스 분리 규칙을 추가. 다른 목적의 화면을 같은 파일에 섞지 않고, 화면 컴포넌트와 프로그램 로직 책임을 분리하도록 명문화.
- 2026-07-04: Archive Store 파일 관리 UI에서 화면 물리적 분리 규칙을 반영. 필터/검색 영역, 선택/삭제 영역, 목록 표시 설정 영역, 파일 목록 영역을 각각 별도 `section`으로 분리하고 삭제 액션 영역에 상하 경계선을 적용해 조작 영역이 섞이지 않도록 수정.
- 2026-07-04: 로컬 변경사항(선택삭제/전체삭제 기능 개선 및 API)을 GitHub 원격 저장소(`main` 브랜치)에 최종 커밋 및 푸시 완료.
- 2026-07-04: 로컬 개발 환경 종속성 설치 및 빌드 검증을 완료하고, `scripts\start.cmd`를 기동해 로컬 DB(PostgreSQL 18.4), API(5175), Web App(5174) 프로세스 활성화 완료.
- 2026-07-04: Archive Store 파일 목록에 체크박스 기반 선택삭제와 현재 목록 전체삭제 기능 추가. Firebase 모드에서는 Storage 객체 삭제가 성공했거나 객체가 이미 없는 경우에만 Firestore 문서를 삭제해 실제 스토리지와 화면 목록 정합성을 유지. 로컬 API 모드에서는 실제 업로드 파일 삭제 후 PostgreSQL row를 삭제하도록 구현. 삭제 전 확인창을 표시하며, 삭제 실패 시 권한 오류를 명확히 표시.

## 주요 마일스톤 요약
- Firebase 연동 준비: Firebase CLI 도구 설정, `.firebaserc` 활성화, deploy 환경 준비 완료.
- Firebase project id 반영: 로컬 `.firebaserc`와 `firebase\.firebaserc.example` 기본 프로젝트를 `archive-store-fae71`로 설정.
- Firebase env 예시 추가: `config\.env.firebase.example`에 `VITE_FIREBASE_PROJECT_ID=archive-store-fae71`, `VITE_DATA_BACKEND=firebase` 기준 예시 추가.
- Firebase 연결 문서 추가: `docs\firebase_infra_setup.md`에 로그인, 프로젝트 선택, emulator, deploy 명령 정리.

## Git / 원격 상태
- repository: `https://github.com/mohenz/archive-store.git`
- branch: `main`
- latest_commits:
  - `9dc84d3 fix: resolve invisible file names in dark mode list view`
  - `af908de feat: add light/dark theme toggle and darknavy mode overrides`
  - `d933bcc fix: add z-index to modal backdrop to prevent background checkbox overlap`
  - `eb6559b fix: correct image thumbnail preview url to downloadUrl`
  - `d80caff feat: add card view mode toggle UI and styles`
  - `f1f6161 fix: resolve refresh auth flickering by isolating loading screen state`
  - `ed8e3bb style: rename archive terminology to data-room and remove remaining Archive Store labels`
- local_status: `main...origin/main`, 추적 대상 변경 없음
- ignored_local_only:
  - `.env.local`
  - `docs\required_user_inputs.md`
  - `local\postgres-data\`
  - `local\uploads\`
  - `local\*.log`
  - `dev-server.log`
  - `node_modules\`
  - `dist\`

## 다음 작업
- 새 PC에서 `git clone https://github.com/mohenz/archive-store.git`
- `config\.env.example`을 복사해 `.env.local` 생성
- `.env.local`에 `VITE_ARCHIVE_PIN`, `VITE_DATA_BACKEND=local-api`, `VITE_LOCAL_API_URL=http://127.0.0.1:5175` 설정
- `npm install` 후 `scripts\start.cmd` 실행
- PostgreSQL 설치 경로가 `C:\Program Files\PostgreSQL\18\bin`과 다르면 `scripts\start-local-db.ps1`, `scripts\stop-local-db.ps1` 수정
- 실제 업로드 파일/DB 데이터까지 이관해야 하면 `local\uploads\`와 PostgreSQL 데이터는 별도 백업/복원
- Firebase Web App config 6개 값 입력, Email/Password Auth 운영 계정 생성 후 Auth/Firestore/Storage 실연동 검증
- 로컬 API 태그 수정/미리보기 고도화
- Vercel 배포 설정

## 실행 / 검증
- run_command: `scripts\start.cmd`
- stop_command: `scripts\end.cmd`
- verify_command: `npm.cmd run build`, `npm.cmd run check:syntax`, `curl.exe -s http://127.0.0.1:5175/api/health`
- port_or_runtime: app `http://127.0.0.1:5174/`, api `http://127.0.0.1:5175`, db `127.0.0.1:54324`
- deploy_method: Firebase Hosting/Firestore/Storage project `archive-store-fae71`

## 핵심 경로
- project_root: `D:\Workspace\archive_store`
- key_docs:
  - `README.md`
  - `config\.env.example`
  - `config\.env.firebase.example`
  - `docs\transfer_guide.md`
  - `docs\firebase_setup.md`
  - `docs\firebase_infra_setup.md`
  - `docs\requirements\개인용_아카이브_저장소_기능검토보고서.md`
  - `docs\requirements\프로젝트_아키텍처_및_개발계획서.md`
  - `docs\requirements\디자인_작업_명세서_Stitch.md`
- key_files:
  - `package.json`
  - `config\vite.config.js`
  - `config\.env.example`
  - `config\.env.firebase.example`
  - `src\config\archivePolicy.js`
  - `src\styles.css`
  - `src\views\ArchiveWorkspaceScreen.jsx`
  - `src\views\ArchiveView.jsx`
  - `src\views\ArchiveAuthScreen.jsx`

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `archive_store/docs/firebase_infra_setup.md`, `archive_store/docs/firebase_setup.md`, `archive_store/README.md`
- 새 PC 재현 최소 절차: clone -> `npm install` -> `.env.local` 생성 -> `scripts\start.cmd`
- 확인이 필요한 미결사항: Firebase Authentication Email/Password 제공업체 활성화 및 운영 계정 생성, Stitch hosted image/code URL

## Handoff
- current_goal: `archive_store`를 Firebase project `archive-store-fae71`에 연결 가능한 준비 상태로 전환
- done_latest: Firebase CLI/dev dependency, Firebase scripts, emulator/deploy 설정, `.firebaserc` 로컬 선택 파일, `.env.firebase.example`, `docs/firebase_infra_setup.md` 준비 완료. 추가적으로 리스트/카드 뷰 모드 토글(Card View Mode) UI, CSS 스타일 최적화, 이미지 썸네일 노출, 모달창 z-index 겹침 버그 패치 및 어둡게/밝게 보기(테마 토글 기능, 다크 네이비 테마) 구현, 다크모드 리스트 뷰 텍스트 겹침 버그 수정 및 배포 완료.
- key_findings: GitHub에는 공개 가능한 project id와 설정 예시만 포함하고, 실제 PIN/Web App config/업로드 파일/로컬 DB 데이터는 제외해야 함.
- changed_files: `archive_store/package.json`, `archive_store/package-lock.json`, `archive_store/.gitignore`, `archive_store/config/.env.firebase.example`, `archive_store/firebase/*`, `archive_store/README.md`, `archive_store/docs/firebase_setup.md`, `archive_store/docs/firebase_infra_setup.md`, `project_control/project_registry.md`, `project_control/project_docs/PROJECT_ARCHITECTURE_MAP.md`, `project_control/states/archive_store_current.md`, `archive_store/src/styles.css`, `archive_store/src/views/ArchiveWorkspaceScreen.jsx`, `archive_store/src/views/ArchiveView.jsx`, `archive_store/src/views/ArchiveAuthScreen.jsx`
- verification: `npm.cmd run check:syntax` 통과, `npm.cmd run build` 통과, Firebase CLI `15.22.4` 출력 확인. CLI update-check 저장소 권한으로 종료 코드는 1이지만 버전 출력은 확인됨. 2026-07-04 refresh 잠금 유지 수정, Firebase Auth 로그인 전환, 로그인 화면/uid 업로드 경로 정리 후 `npm.cmd run check:syntax`, `npm.cmd run build` 재통과. 2026-07-04 파일 선택삭제/전체삭제를 Storage/Firestore 정합성 기준으로 수정하고 삭제 UI 물리적 분리, 로그인/작업 화면 소스 분리, 인증/목록/업로드·삭제 기능 훅 분리 반영 후 `npm.cmd run check:syntax`, `npm.cmd run build` 재통과. 2026-07-05 테마 토글 및 다크 네이비 테마 로컬 검증 완료 후 Git 푸시 및 Vercel 실서버 상용 배포(`npx vercel --prod`) 통과. 다크모드 리스트 뷰의 파일명 텍스트 시인성 개선 후 재배포 완료. 상용 도메인 `https://archive-store-pi.vercel.app/` 정상 운영 확인.
- next_action: Firebase Console에서 Email/Password 제공업체와 운영 계정을 만든 뒤 Vercel에 환경변수를 반영하고 실제 로그인/업로드 검증.
- risks_or_blockers: Firebase Console에서 Email/Password 제공업체 활성화와 운영 계정 생성이 필요함. 실제 업로드 파일/DB 데이터 이관 필요 여부는 별도 결정 필요.
