# CineTube Current State

## 기본 정보
- project_key: cinetube
- last_updated: 2026-05-31
- owner_request: `D:\workspace\cinetube\cinetube 기본요구사항.txt`와 `stitch_cinetube_movie_hub` 디자인을 기준으로 PC 우선, 모바일 반응형 영화정보 관리 웹사이트 제작. bloom 프로젝트 계정과 연동되는 완전 폐쇄형(Closed-Access) 프라이빗 아카이브 구축 및 Supabase 데이터베이스 `CineHub` 활용.
- current_status: 신규 등록, 이미지 관리 및 전 화면 폐쇄형 인증 시스템 구축 완료. bloom 프로젝트 계정 연동 및 루트 경로 login.html을 통한 전원 차단 완료. Vercel 원격 배포 및 Git 동기화 완료.

## 현재 목표
- CineTube 영화정보 허브 웹사이트를 완벽한 비공개(Closed-Access) 개인 사이트로 전면 개편.
- bloom 프로젝트 로그인 API와 연동하여 동일한 계정 정보로 로그인/로그아웃하도록 구현.

## 진행 중 작업
- Vercel 배포 환경 기준 bloom 연동 실데이터 로그인 및 데이터 조회 흐름 검증 대기.

## 최근 완료 작업
- project-control 레지스트리에 `cinetube` 프로젝트 등록.
- 상태 파일 생성.
- 핵심 요구사항 문서와 Stitch 디자인 산출물 확인.
- 단일 앱 파일 구조를 폐기하고 공개/관리 화면을 파일 단위로 분리.
- 공개 화면 구현: `index.html`, `actors.html`, `categories.html`, `ratings.html`.
- 관리 화면 구현: `admin/index.html`, `admin/movies.html`, `admin/categories.html`, `admin/actors.html`, `admin/ratings.html`.
- 공통 데이터/렌더링 로직 구현: `assets/js/shared/*`, 화면별 로직 `assets/js/pages/*`.
- 화면별 JS 1:1 분리 완료: `actors.js`, `categories.js`, `ratings.js`, `admin-movies.js`, `admin-categories.js`, `admin-actors.js`, `admin-ratings.js`.
- 여러 화면을 함께 처리하던 `assets/js/pages/catalog.js`, `assets/js/pages/admin-form.js` 제거.
- `D:\workspace\cinetube`를 별도 Git 저장소로 초기화하고 `origin`을 `https://github.com/mohenz/cinetube.git`로 설정.
- 디자인 산출물 `stitch_cinetube_movie_hub/`를 `.gitignore`로 제외한 뒤 초기 커밋 생성 및 푸시 완료: `9968bf0 Initial CineTube web app`.
- 사용자가 Vercel 배포 진행 완료를 확인.
- 원격 README 변경(`30b7e18`) 통합 완료.
- Supabase 영화 데이터가 비어 있을 때 홈 화면이 중단되는 문제 수정/푸시 완료: `535ef0d Handle empty movie data on home`.
- 영화/배우/카테고리 관리 화면의 이미지 입력을 URL 방식에서 파일 등록/수정/삭제 방식으로 변경.
- 이미지 파일은 Supabase Storage `cinetube-images` 버킷, 메타정보는 `media_assets` 테이블에 저장하도록 구현.
- 기존 DB 적용용 `supabase/media_assets_migration.sql` 추가.
- 이미지 관리 기능 커밋/푸시 완료: `8a52184 Add managed image uploads`.
- 이미지 관리 영역에서 삭제 버튼을 제목 옆에서 파일 선택 하단 작업 영역으로 이동하고, Storage/DB 설명 문구 제거. 커밋/푸시 완료: `5b6f296 Refine image action layout`.
- 추가 UI 요청 기준으로 삭제 버튼을 `fieldset.image-fieldset` 내부에서 완전히 제거하고 저장 버튼과 같은 폼 하단 액션 영역으로 이동. Storage/DB 설명 문구 미노출 상태 유지.
- 기존 개별 컬럼 추가(ALTER) 방식 대신, 기존 테이블을 모두 Drop하고 관계형 참조 구조에 맞춰 한 번에 정교하게 생성하는 통합 클린 `supabase/schema.sql` 신규 설계 및 반영 완료.
- cinetube 전체 사이트를 외부 접근이 원천 차단되는 **폐쇄형(Closed-Access)** 프라이빗 서비스로 개편 완료.
- bloom 프로젝트의 사용자 계정 DB 테이블(`public.app_users`) 및 로그인 API와 완벽하게 연동되도록 `CineTubeStore`의 페더레이션 로그인/로그아웃 구조 설계 및 구현 완료.
- 루트 경로에 [login.html](file:///D:/workspace/cinetube/login.html)을 신규 생성하고, 미인증 사용자 유입 시 전방위 자동 리다이렉트하는 중앙 가드 훅(`Store.load()`)을 `store.js`에 주입 완료.
- 로그인하지 않은 브라우저로 직접 URL 복사 접근 시, 바디 렌더링이 시작되기 전에 HTML 구성을 숨기고 즉시 튕겨내는 **동기식 블로킹 헤드 인증 가드(FOUC 방지)**를 9개 전체 HTML 파일 `<head>`에 전면 설계 및 이식 완료.
- 모든 공개 화면 및 관리자 화면의 사이드바 내에 안전한 로그아웃(Sign Out) 기능을 추가하고 `assets/js/shared/ui.js`에 공통 핸들러 바인딩 완료.
- 변경된 프론트엔드 전방위 가드 UI 및 연동 스키마를 Git에 커밋하고 원격지에 최종 PUSH 완료: `c1ca353 Prevent unauthenticated content flash with blocking head auth guard`.
- 사이드바 하단 데이터베이스 연결 상태 문구 및 ok/off 표시 색상을 제거하고, 가운데 정렬 형태의 세련된 static "Bloom Universe" 브랜드 워터마크로 전면 교체 완료 (9개 HTML 파일, `styles.css`, `ui.js` 수정 및 푸시 완료).
- 공개 화면(홈, 주연배우, 카테고리, 평가등급) 및 관리자 화면(메인, 영화정보, 카테고리, 배우, 등급 관리) 전체의 상단 툴바 주요 액션 링크들을 일괄적으로 세련된 Crimson 레드 액센트 컬러의 프리미엄 입체 버튼 스타일(`primary-button`)로 교체 및 일관된 호버 글로우 섀도우 효과 적용 완료.
- Supabase 설정 예시, `supabase/schema.sql` (익명 쓰기 RLS 지원) 및 대규모 고품질 실존 명작 데이터 입력을 위한 `supabase/seed.sql` 설계 및 작성 완료.
- 모바일 반응형 CSS 및 파비콘 추가.

## 다음 작업
- Vercel 배포 URL 및 로컬 호스트 환경에서 bloom 연동 로그인 및 폐쇄형 전방위 차단 가드 실제 작동 테스트.
- 로그인 완료 후 Supabase 테이블 실 데이터 조회 및 이미지 등록/수정/삭제 연동 최종 검증.
- Vercel 배포 URL 기준 카테고리/배우/영화 데이터 초기 입력.

## 실행 / 검증
- run_command: `python -m http.server 8080`
- verify_command: `node --check assets/js/shared/*.js`, `node --check assets/js/pages/*.js`, browser inspect 주요 페이지, 화면별 script 로드 확인, Vercel URL console error 확인
- port_or_runtime: `8080`, static web app
- deploy_method: Vercel deployment completed from GitHub `origin/main`

## 핵심 경로
- project_root: `D:\Workspace\cinetube`
- key_docs: `cinetube 기본요구사항.txt`, `stitch_cinetube_movie_hub\cinematic_archive_system\DESIGN.md`
- key_files: `index.html`, `actors.html`, `categories.html`, `ratings.html`, `admin/*.html`, `assets/css/styles.css`, `assets/js/shared/*.js`, `assets/js/pages/home.js`, `assets/js/pages/actors.js`, `assets/js/pages/categories.js`, `assets/js/pages/ratings.js`, `assets/js/pages/admin-*.js`, `assets/js/supabase-config.example.js`, `supabase/schema.sql`

## 리스크 / 주의사항
- 사용자가 Supabase 테이블 생성 완료를 확인했다.
- 사용자가 Vercel 배포 완료를 확인했다. 배포 URL: `https://cinetube-gray.vercel.app`
- Supabase URL / anon key는 `D:\workspace\cinetube\assets\js\supabase-config.js`에 등록 완료.
- Vercel URL 확인 결과 Supabase 연결 상태가 표시되며, 영화 데이터가 없는 상태에서도 홈/관리 화면 콘솔 오류 없음.
- `media_assets` 테이블/Storage 정책 미적용 상태에서는 이미지 업로드를 차단하도록 방어 처리됨.
- 관리자 저장 정책은 `authenticated` 쓰기 기준으로 작성했으므로 실제 운영 전 Supabase Auth 연결이 필요하다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `assets/js/shared/store.js`, `assets/js/shared/admin-page.js`, `supabase/schema.sql`
- 확인이 필요한 미결사항: `media_assets` 마이그레이션 적용 여부, Storage 쓰기 정책, 관리자 인증 범위, Vercel 기준 실제 이미지 업로드/수정/삭제 동작
