# CineTube Current State

## 기본 정보
- project_key: cinetube
- last_updated: 2026-06-02
- owner_request: `D:\workspace\cinetube\docs\requirements\cinetube 기본요구사항.txt`와 `docs\reference\stitch_cinetube_movie_hub` 디자인을 기준으로 PC 우선, 모바일 반응형 영화정보 관리 웹사이트 제작. bloom 프로젝트 계정과 연동되는 완전 폐쇄형(Closed-Access) 프라이빗 아카이브 구축 및 Supabase 데이터베이스 `CineHub` 활용.
- current_status: 로컬 PC 전용 PostgreSQL/API/static 웹서비스 구동 구조로 운영 중. 로그인/세션 보안 기능은 로컬 전용 운영 기준으로 해제. 루트에는 `index.html`만 남기고 공개 서브화면은 `pages/`, 관리자 화면은 `admin/` 하위로 정리 완료. `4806e41 Improve movie people metadata management`까지 원격 `main` push 완료. 이후 루튼토마토 평점 필드, 영화목록 화면, TMDB URL 가져오기, 포스터 카드 반응형 UI, 홈 히어로 높이 조정 작업이 로컬 작업트리에 미커밋 상태로 반영됨.

## 현재 목표
- CineTube 영화정보 허브 웹사이트를 로컬 PC 전용 서비스로 안정 운영.
- 로컬 PostgreSQL/API 기준 관리자 CRUD, 이미지 관리, 공개 페이지 조회 흐름을 유지/검증.

## 프로젝트 고유 운영 규칙
- Supabase 정책(RLS, Supabase Auth, storage policy)을 CineTube의 운영 권한 제어 수단으로 사용하지 않는다.
- 플랫폼 종속성을 피하기 위해 인증/권한 판단은 Bloom/CineTube 자체 API 계층에서 처리한다.
- Supabase는 교체 가능한 저장소로만 취급하며, 프론트엔드가 Supabase에 직접 write/delete/upload하는 구조는 최종 구조로 채택하지 않는다.
- 관리자 등록/수정/삭제/이미지 업로드는 서버 API가 Bloom 계정/권한을 확인한 뒤 저장소에 반영하는 구조로 설계한다.
- Supabase RLS는 운영 권한 모델이 아니라 저장소 측 보조 안전장치가 필요한 경우에만 최소 범위로 둔다.
- 배우 세부 프로필이 Javtiful 등 1차 등록 페이지에서 조회되지 않을 때는 `https://www.avdbs.com/menu/actor_list.php`에서 배우를 검색해 나이, 신장, 신체사이즈, 데뷔년도를 보강한다.

## 진행 중 작업
- 관리자 로컬 CRUD 전체 회귀 테스트 대기.
- TMDB URL 가져오기 기능은 로컬 API `/tmdb/import`와 관리자 화면 패널 구현/기본 검증 완료. 실제 신규 영화 저장까지의 전체 사용자 흐름은 추가 회귀 테스트 필요.
- CineTube 작업트리에 여러 기능 개선 변경이 미커밋 상태로 남아 있음. 커밋/푸시 전 변경 범위 재확인 필요.

## 최근 완료 작업
- 2026-06-01: 루트의 공개 서브화면 `actor.html`, `actors.html`, `categories.html`, `ratings.html`, `movie.html`을 `pages/` 하위로 이동
- 2026-06-01: 레거시 로그인 화면 `login.html`을 `auth/login.html`로 이동
- 2026-06-01: 요구사항 원문 `cinetube 기본요구사항.txt`를 `docs/requirements/` 하위로 이동
- 2026-06-01: 참조자료 보관 위치 `docs/reference/` 및 안내 문서 추가, Stitch 산출물 제외 경로를 `.gitignore`에 반영
- 2026-06-01: 이동된 화면 기준으로 루트/공개/관리 화면의 상대 링크와 `CineTubeUI` 영화 상세 라우팅 보정
- 2026-06-01: 전체 `assets/js` 20개 파일 `node --check` 통과, HTML 로컬 링크 검사 통과, 주요 HTML 5개 HTTP 200 응답 확인
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
- `Yatsugake Umi` 등록용 일회성 스크립트 `scripts/import_yatsugake_umi.ps1` 추가.
- Supabase SQL Editor에서 바로 실행 가능한 `supabase/import_yatsugake_umi.sql` 추가. 포함 항목: 카테고리 `prestige-exclusive`, 배우 `Yatsugake Umi`, 작품 `ABF-270`, `ABF-260`, `ABF-251`, `ABF-241`, `ABF-231`, `ABF-109`.
- Supabase REST anon 등록 시도 결과 RLS 정책에 의해 `categories` insert가 차단됨을 확인.
- 포스터 카드 클릭 시 영화정보 상세 화면으로 이동하도록 공통 카드 렌더러에 링크 동작 추가.
- `movie.html` 및 `assets/js/pages/movie-detail.js` 신규 추가. `movie.html?code=<movie_code>` 기준으로 영화 상세정보, 배우, 카테고리, 등급, 출시년월, 제작사, 추천점수, 키워드, 원본 링크를 표시.
- UI 수정 커밋/푸시 완료: `d9c16cb Add movie detail navigation`.
- 주연배우 등록 시 `new row violates row-level security policy` 오류 발생. Bloom 로그인은 Supabase Auth 세션이 아니므로 Supabase 요청은 `anon` 역할로 처리되는 것이 원인.
- Supabase RLS/정책을 운영 권한 제어 수단으로 쓰면 안 된다는 프로젝트 규칙 확정.
- 잘못된 방향의 `supabase/allow_anon_admin_writes.sql` 파일 제거.
- `Yatsugake Umi` 등록 데이터의 `video_url`이 배우 페이지로 잘못 들어간 문제 확인.
- Javtiful 배우 페이지 검색 쿼리(`?q=<movie_code>`)로 실제 개별 영상 링크 확인 완료: `ABF-270`, `ABF-260`, `ABF-251`, `ABF-241`, `ABF-231`, `ABF-109`.
- `supabase/import_yatsugake_umi.sql` 및 `scripts/import_yatsugake_umi.ps1`의 `video_url`을 실제 개별 영상 URL로 수정.
- 기존 DB 데이터 보정용 `supabase/update_yatsugake_umi_video_urls.sql` 추가.
- `Yatsugake Umi` 정보도 `Hatsumi Nanoka` 등록 방식처럼 Javtiful 실제 카드 제목과 개별 원본링크 기준으로 보정. Javtiful이 해당 6개 카드의 썸네일을 placeholder로 내려줘서 포스터 URL은 강제 입력하지 않음.
- `supabase/update_yatsugake_umi_video_urls.sql`을 제목/원본링크/설명 보정 SQL로 확장.
- `Yatsugake Umi` 개별 Javtiful 영상 페이지의 메타 이미지 확인 후 `poster_url` 6건 반영.
- `supabase/import_yatsugake_umi.sql`, `scripts/import_yatsugake_umi.ps1`, `supabase/update_yatsugake_umi_video_urls.sql`에 `poster_url` 반영 완료.
- `D:\workspace\std.png` 기준 가로형 영화 썸네일 비율(`312 / 183`)을 CSS 변수 `--movie-image-ratio`로 추가하고, 영화 카드/상세/이미지 스트립/관리 미리보기/관리 테이블 썸네일에 공통 적용.
- 주연배우 화면을 “선택 필터 + 즉시 작품 조회” 구조에서 “전체 배우 리스트 → 배우 상세 화면” 구조로 변경.
- `actors.html`은 전체 배우 카드 목록과 검색/페이지네이션을 표시하고, 각 배우 카드는 `actor.html?id=<actor_id>`로 이동.
- `actor.html` 및 `assets/js/pages/actor-detail.js` 신규 추가. 배우 기본정보와 해당 배우의 출연 작품 목록을 표시.
- 관리자 공통 목록에 삭제 버튼 추가. `assets/js/shared/store.js`에 `remove()` 추가, `assets/js/shared/admin-page.js`에서 삭제 확인 후 레코드 및 연결 이미지 자산 삭제 처리.
- 홈 화면 추천/랭킹 구조 개선. `맞춤추천 8개`는 `click_count` 높은 순으로, `카테고리별 평가등급 상위 8개`는 `ranking_score` 높은 순으로 정렬하도록 변경.
- `movies` 테이블에 `ranking_score`, `click_count` 컬럼을 추가하는 스키마 변경 및 기존 DB용 `supabase/movie_ranking_clicks_migration.sql` 추가.
- 영화 카드 클릭 시 클릭수를 기록하도록 `CineTubeStore.recordMovieClick()` 및 카드 클릭 핸들러 연결. DB 컬럼/쓰기 권한이 없을 때도 브라우저 로컬 클릭 캐시로 정렬 반영.
- 관리자 영화정보 화면에 `랭킹점수`, `클릭수` 입력/표시 컬럼 추가.
- 주연배우 삭제 확인 메시지를 개선해 연결된 영화정보 개수와 삭제 후 영향 안내를 표시.
- `Hatsumi Nanoka` / `https://javtiful.com/kr/actress/hatsumi-nanoka` 기준 reducing-mosaic 작품만 추출.
- `supabase/import_hatsumi_nanoka_reducing.sql` 추가. 포함 항목: 배우 `Hatsumi Nanoka`, 카테고리 `reducing-mosaic`, 작품 `SNOS-242`, `SNOS-201`, `SNOS-173`, `SNOS-121`, `SNOS-101`, `SNOS-042`, `SONE-996`, `SONE-962`.
- `Hatsumi Nanoka` 배우정보 업데이트 SQL `supabase/update_hatsumi_nanoka_actor.sql` 추가. 반영 정보: 나이 20, 신장 157cm, 신체사이즈 `E cup / W57`, 데뷔년도 2025, Javtiful 대표 이미지.
- `supabase/import_hatsumi_nanoka_reducing.sql`의 배우 upsert 정보도 동일한 배우정보로 보강.
- `Koumura Izuki` / `https://javtiful.com/kr/actress/koumura-izuki` 기준 reducing-mosaic 작품만 추출.
- `supabase/import_koumura_izuki_reducing.sql` 추가. 포함 항목: 배우 `Koumura Izuki`, 카테고리 `reducing-mosaic`, 작품 `NACT-132`, `PRED-866`, `MFYD-140`, `APNS-409`, `FTHTD-198`, `CAWD-983`, `PFES-122`, `CAWD-957`, `ADN-762`.
- `Koumura Izuki` 배우정보 업데이트 SQL `supabase/update_koumura_izuki_actor.sql` 추가. 반영 정보: 나이 25, 신장 156cm, 신체사이즈 `B83(D)-W58-H85`, 데뷔년도 2025, Javtiful 대표 이미지.
- `supabase/import_koumura_izuki_reducing.sql`의 배우 upsert 정보도 동일한 배우정보로 보강.
- Supabase SQL Editor에서 `Koumura Izuki` 배우정보 업데이트 SQL 실행 및 조회 검증 완료. 조회 결과: `age=25`, `height_cm=156`, `body_size=B83(D)-W58-H85`, `debut_year=2025`.
- 로컬 PC 전용 PostgreSQL 16 기반 DB 구동 방식으로 전환 완료.
- `scripts/start_local_db.ps1`, `scripts/stop_local_db.ps1`, `scripts/local_api.py`, `local/schema.sql` 추가. 로컬 DB는 `localhost:54322`, 로컬 API는 `localhost:3001` 사용.
- `assets/js/shared/store.js`에 `CINETUBE_LOCAL_API` 우선 모드를 추가하고 전체 HTML 진입점에 `assets/js/local-db-config.js` 로드 추가.
- Supabase 클라우드 데이터 백업 및 로컬 마이그레이션 완료. 로컬 적재 결과: `media_assets=5`, `categories=3`, `actors=8`, `rating_grades=5`, `movies=66`.
- 백업 파일 생성: `local/backups/supabase_export_20260601_051412.json`, `local/backups/supabase_to_local_import_20260601_051412.sql`.
- 마이그레이션 검증 후 Supabase 클라우드 테이블 데이터 초기화 완료. 클라우드 `movies` 조회 결과 `[]`, 기본 `rating_grades` 5건 재생성.
- 로컬 `http://localhost:8080/login.html`에서 `admin/admin` 로그인 후 홈 화면이 `localhost:3001` API를 호출해 데이터를 렌더링하는 것 확인. 브라우저 콘솔 오류 없음.
- 로컬 웹서비스를 더블클릭 또는 짧은 명령으로 실행할 수 있도록 런처 추가 완료. 추가 파일: `start-cinetube.cmd`, `ct.cmd`, `stop-cinetube.cmd`, `scripts/launch_cinetube.ps1`.
- `scripts/start_local_db.ps1`를 idempotent하게 보강해 PostgreSQL이 이미 실행 중이면 재시작하지 않고 통과하도록 수정.
- `scripts/stop_local_db.ps1`가 `python -m http.server 8080` 웹서버도 함께 종료하도록 보강.
- `scripts/launch_cinetube.ps1` 실행 검증 완료. DB/API/웹서버 준비 후 브라우저가 `http://localhost:8080/login.html`로 열림. 콘솔 오류 없음.
- 로컬 전용 운영 기준으로 로그인/세션 보안 기능 해제 완료.
- 전체 공개/관리 HTML의 헤드 인증 가드와 사이드바 로그아웃 버튼 제거.
- `CineTubeStore.load()`의 인증 리다이렉트 제거, `isAuthenticated()`는 항상 true 반환하도록 변경.
- `scripts/launch_cinetube.ps1` 기본 오픈 URL을 `login.html`에서 `index.html`로 변경.
- `http://localhost:8080/index.html?nocache=1`, `http://localhost:8080/admin/actors.html?nocache=1` 직접 접속 검증 완료. 로그인 리다이렉트 없음, 콘솔 오류 없음.
- 2026-06-01: PostgreSQL 18.4 설치 환경 확인 후 `scripts/start_local_db.ps1`, `scripts/local_api.py`가 설치된 최신 PostgreSQL 버전 폴더를 자동 탐색하도록 수정.
- 2026-06-01: 로컬 API `POST/PATCH`가 `insert/update returning` 결과를 JSON으로 감쌀 때 발생하던 SQL 문법 오류를 CTE 방식으로 수정.
- 2026-06-01: TMDB `Blade Runner` 페이지 기준으로 로컬 DB에 카테고리 `SF`, 배우 `해리슨 포드`, 영화 `블레이드 러너`(`TMDB-78`) 등록 완료.
- 2026-06-01: 로컬 검증 완료. `http://localhost:8080/index.html` 200 OK, `http://localhost:3001/movies` 200 OK, PostgreSQL `localhost:54322` 연결 성공, API `POST/PATCH/DELETE` smoke 통과.
- 원격 저장소 구조개선 커밋 `7ab26eb Support local PostgreSQL runtime`을 로컬 `main`에 fast-forward 반영 완료.
- 공개 화면을 `pages/` 하위로 이동한 원격 구조 반영 완료: `pages/actor.html`, `pages/actors.html`, `pages/categories.html`, `pages/movie.html`, `pages/ratings.html`.
- 로그인 파일은 구조상 `auth/login.html`로 이동됐지만 로컬 전용 운영에서는 로그인 진입을 사용하지 않음.
- 요구사항 문서는 `docs/requirements/`, 참고 문서는 `docs/reference/` 구조로 정리됨.
- `assets/js/shared/ui.js`의 `routePath()` 기반 경로 보정, `scripts/start_local_db.ps1`의 PostgreSQL 설치 경로 자동 탐색, `scripts/local_api.py`의 쓰기 응답 처리 개선 반영 완료.
- 반영 후 검증 완료: `node --check assets/js/shared/ui.js`, `node --check assets/js/pages/home.js`, `node --check assets/js/pages/movie-detail.js`, `python -m py_compile scripts/local_api.py`.
- 로컬 런처 실행 및 브라우저 확인 완료: `http://localhost:8080/index.html`, `http://localhost:8080/pages/actors.html`, `http://localhost:8080/admin/actors.html`.
- 2026-06-01: 구조개선 후 기존 루트 URL 404 방지를 위해 `actor.html`, `actors.html`, `categories.html`, `movie.html`, `ratings.html`, `login.html` 호환 리다이렉트 파일 추가. `movie.html?code=...`, `actor.html?id=...` 쿼리 보존 확인. 커밋/푸시 완료: `a4df9e5 Add legacy page redirects`.
- 2026-06-01: `Araki Noa` / `https://javtiful.com/kr/actress/araki-noa` 기준 reducing-mosaic 작품만 추출해 로컬 DB 등록 완료. 페이지 1에서 reducing 11건 확인, 페이지 2에는 reducing 항목 없음. 추가 SQL: `supabase/import_araki_noa_reducing.sql`. 로컬 검증 결과 배우 id `10`, reducing 작품 `11`건. 브라우저 `http://localhost:8080/pages/actor.html?id=10` 표시 및 콘솔 오류 없음. 커밋/푸시 완료: `277debc Add Araki Noa reducing import`.
- 2026-06-01: AVDBS 배우 페이지 `https://www.avdbs.com/menu/actor.php?actor_idx=11244`에서 `Araki Noa` 세부 프로필 확인 후 로컬 DB와 import SQL 보강. 반영값: 나이 21, 신장 162cm, 신체사이즈 `B84(E)-W56-H87`, 데뷔년도 2025. 브라우저 배우 상세 표시 확인. 커밋/푸시 완료: `c6456e0 Fill Araki Noa profile details`.
- 2026-06-01: `Kaede Karen` / `https://javtiful.com/kr/actress/kaede-karen` 기준 reducing-mosaic 작품만 추출해 로컬 DB 등록 완료. 페이지별 reducing 수집 결과: 1페이지 18건, 2페이지 6건, 3페이지 4건, 4페이지 0건. AVDBS 배우 페이지 `https://www.avdbs.com/menu/actor.php?actor_idx=4981`에서 프로필 보강. 반영값: 나이 26, 신장 162cm, 신체사이즈 `B82(D)-W59-H81`, 데뷔년도 2018. 추가 SQL: `supabase/import_kaede_karen_reducing.sql`. 로컬 검증 결과 배우 id `11`, reducing 작품 `28`건. 브라우저 `http://localhost:8080/pages/actor.html?id=11` 표시 및 콘솔 오류 없음. 커밋/푸시 완료: `917db84 Add Kaede Karen reducing import`.
- 2026-06-01: `Tsujimoto An` / `https://javtiful.com/kr/actress/tsujimoto-an` 기준 reducing-mosaic 작품만 추출해 로컬 DB 등록 완료. 페이지별 reducing 수집 결과: 1페이지 3건, 2페이지 1건. AVDBS 배우 페이지 `https://www.avdbs.com/menu/actor.php?actor_idx=1298`에서 프로필 보강. 반영값: 나이 32, 신장 155cm, 신체사이즈 `B82(C)-W57-H80`, 데뷔년도 2013. 추가 SQL: `supabase/import_tsujimoto_an_reducing.sql`. 로컬 검증 결과 배우 id `12`, reducing 작품 `4`건. 브라우저 `http://localhost:8080/pages/actor.html?id=12` 표시 및 콘솔 오류 없음. 커밋/푸시 완료: `e5e4624 Add Tsujimoto An reducing import`.
- 2026-06-01: `Tsujimoto An` / `https://supjav.com/?s=Tsujimoto+An` 기준 Supjav 검색 결과 6페이지를 확인하고 `[Reducing Mosaic]` 라벨 작품만 추출해 로컬 DB 추가 등록 완료. `Ryo Tsujimoto` 등 다른 배우 결과는 제외, 중복 품번은 upsert 처리. Supjav 기준 unique reducing 34건 적용 후 기존 Javtiful-only `TEAM-062` 포함 총 reducing 작품 `35`건. 추가 SQL: `supabase/import_tsujimoto_an_supjav_reducing.sql`. 브라우저 `http://localhost:8080/pages/actor.html?id=12` 표시 및 콘솔 오류 없음. 커밋/푸시 완료: `fba4773 Add Tsujimoto An Supjav reducing import`.
- 2026-06-01: 관리자 영화정보 화면에서 `메인전시 여부` 저장 시 로컬 API가 `UPDATE ... RETURNING`을 일반 서브쿼리로 감싸 PostgreSQL 문법 오류가 발생하던 문제 수정. `scripts/local_api.py`의 쓰기 SQL 응답 래핑을 명시적 CTE 경로로 고정하고 세미콜론 정규화 추가. 로컬 API 재기동 후 `movies.id=138`의 `is_main` PATCH true/false 왕복 검증 완료.
- 2026-06-01: 홈 메인전시 영역이 메인전시 영화의 포스터 이미지를 우선 노출하도록 수정. `CineTubeUI.movieImageUrl()` 공통 헬퍼를 추가해 `poster_url`, `poster_asset.public_url`, `capture_url`, `capture_asset.public_url`, `snapshot_url`, `snapshot_asset.public_url` 순서로 이미지를 선택. 홈 히어로와 관리자 영화 목록 썸네일에 동일 기준 적용. 브라우저 검증 결과 `TEAM-066` 히어로 배경이 포스터 URL로 설정되고 콘솔 오류 없음.
- 2026-06-01: 영화 상세 화면에 `영화정보 삭제` 버튼 추가. 확인창 승인 시 `Store.remove("movies", id)`로 영화정보를 삭제하고 연결된 poster/capture/snapshot media asset도 정리한 뒤 홈으로 이동. 임시 영화 `UI-DELETE-TEST-*` 생성 후 상세 화면 삭제 버튼으로 삭제, 로컬 API 조회에서 미존재 확인, 콘솔 오류 없음.
- 2026-06-01: `Aoi Tsukasa` 요청 작품 3건 등록 완료. 대상: `SSNI-987` Javtiful, `SSNI-346` Javtiful, `SNIS-675` Supjav. 추가 SQL: `supabase/import_aoi_tsukasa_requested_works.sql`. 배우 id `13`, 프로필 반영값: 나이 35, 신장 163cm, 신체사이즈 `B85(D)-W58-H88`, 데뷔년도 2010. 로컬 검증 결과 3개 작품 모두 `reducing-mosaic`, 포스터 있음. 브라우저 `http://localhost:8080/pages/movie.html?code=SSNI-987` 표시 및 콘솔 오류 없음.
- 2026-06-01: `Miyuki Arisaka` 요청 작품 `MIAA-077` / `https://supjav.com/307511.html` 등록 완료. 추가 SQL: `supabase/import_miyuki_arisaka_miaa_077.sql`. 기존 `Arisaka Miyuki` 배우 id `7`을 요청 표기 `Miyuki Arisaka`로 정리하고 프로필 유지. 로컬 검증 결과 `MIAA-077`은 `reducing-mosaic`, 제작사 `MOODYZ`, 포스터 있음. 브라우저 `http://localhost:8080/pages/movie.html?code=MIAA-077` 표시 및 콘솔 오류 없음.
- 2026-06-02: TMDB URL 기반 일반 영화 등록 흐름 테스트. `클라우드 아틀라스`(`TMDB-83542`)와 배우 `톰 행크스` 로컬 DB 등록, 포스터/캡쳐/스냅샷 URL 렌더링 검증 완료.
- 2026-06-02: `블레이드 러너`(`TMDB-78`) 영화정보를 TMDB 현재 포스터/백드롭 중심으로 업데이트. 기존 ORB 실패 포스터 URL을 렌더링 가능한 TMDB 미디어 URL로 교체하고 상세 화면 검증 완료.
- 2026-06-02: 상세 페이지 포스터 세로 크기를 정보 패널 높이에 맞게 확장하고 모바일 1열에서는 자연 비율로 표시되도록 CSS 조정.
- 2026-06-02: 로컬 API가 긴 Data URL 이미지를 `psql -c` 인자로 넘겨 `[WinError 206]`이 발생하던 문제 수정. SQL을 stdin으로 전달하도록 `scripts/local_api.py` 변경, 120KB Data URL 대표이미지 저장 테스트 통과.
- 2026-06-02: 관리자 정보수정/삭제 성공 시 완료 알림을 표시하도록 `assets/js/shared/admin-page.js` 개선.
- 2026-06-02: 영화 메타데이터 확장. 주연배우 최대 4명(`actor_ids`), 감독 최대 2명(`director_names`), 정보출처 URL(`source_url`) 지원 추가. 로컬/Supabase 스키마, 로컬 API, Store enrich, 관리자 폼/목록, 상세 화면, 배우 상세/카탈로그 필터, 샘플 데이터, Supabase 마이그레이션 SQL 반영.
- 2026-06-02: 루트 디렉터리에서 legacy redirect 파일 `actor.html`, `actors.html`, `categories.html`, `login.html`, `movie.html`, `ratings.html` 제거. 루트 HTML은 `index.html`만 남기고 공개 서브화면은 `pages/`, 관리자 화면은 `admin/`에 유지.
- 2026-06-02: 변경사항 커밋/푸시 완료: `4806e41 Improve movie people metadata management`.
- 2026-06-02: `클라우드 아틀라스` 상세 화면의 중복 정보출처 표시 문제를 정리하고 영화 메타데이터에 `rotten_tomatoes_score` 필드 추가. 로컬/Supabase 스키마, 로컬 API, Store enrich, 관리자 영화 폼, 상세 화면, 샘플 데이터, Supabase 마이그레이션 SQL 반영. 상세 화면에서는 추천점수와 별도 항목으로 `루튼 토마토`를 표시.
- 2026-06-02: `클라우드 아틀라스` 로컬 DB에 `rotten_tomatoes_score=66` 반영. 상세 화면에서 추천점수 `88`, 루튼 토마토 `66%` 분리 표시 확인. 관리자 입력값 표시 확인.
- 2026-06-02: `pages/movies.html`, `assets/js/pages/movies.js` 신규 추가. 공개 사이드바/홈 CTA에 `영화목록` 메뉴 추가. 영화목록은 최신영화 순(`release_month` 내림차순)으로 정렬하고 검색/페이지 크기 선택을 지원. 브라우저 검증 결과 `CineTube | 영화목록`, 목록 렌더링 및 콘솔 오류 없음.
- 2026-06-02: TMDB `지옥의 묵시록`(`TMDB-28`) 등록 완료. 새 배우 `마틴 쉰`, 새 카테고리 `전쟁`, 감독 `프란시스 포드 코폴라`, 정보출처 URL, 포스터/캡쳐/스냅샷 TMDB 이미지 등록. 초기 생성 시 API 응답 배열 처리로 `actor_id=null`이 들어간 것을 `id=eq.3` PATCH 방식으로 `actor_id=4`, `actor_ids=[4]`로 보정. 상세/목록 렌더링과 이미지 로드 확인.
- 2026-06-02: CineTube 관리자 영화정보 화면에 `TMDB URL 가져오기` 패널 추가. `scripts/local_api.py`에 `/tmdb/import?url=...` 엔드포인트 추가. TMDB API 키 401 상황에 대비해 공개 TMDB 페이지 HTML 파서 폴백 구현. 자동 추출 항목: 영화코드, 제목, 설명, 장르/카테고리, 주연배우 최대 4명, 감독 최대 2명, 포스터/캡쳐/스냅샷, 출시년월, 키워드, 정보출처 URL.
- 2026-06-02: TMDB 가져오기 시 없는 카테고리/배우는 관리자 폼에서 자동 생성 후 선택값으로 연결하도록 `assets/js/shared/admin-page.js` 개선. `admin/movies.html`의 `admin-page.js`에 캐시 회피 버전 쿼리 추가. 샘플 `블레이드 러너` TMDB URL로 `/tmdb/import` 응답 확인: `SF`, 배우 4명, 감독 `리들리 스콧`, 포스터/배경 이미지 추출 정상. 관리자 화면 패널 노출 및 콘솔 오류 없음.
- 2026-06-02: 영화 포스터 카드 UI 개선. `assets/css/styles.css`에 `--poster-image-ratio: 2 / 3` 추가, `.poster-frame`은 포스터 전용 세로 비율과 `object-fit: contain` 적용. 세로 포스터 전체가 보이도록 수정하고 기존 캡쳐/스냅샷 가로 비율(`--movie-image-ratio`)은 유지. 영화목록/홈 카드에서 포스터 원본 `500x750` 전체 표시 확인.
- 2026-06-02: 포스터 그리드를 디바이스 가로폭에 맞춰 자동 정렬하도록 변경. `.poster-grid`를 `repeat(auto-fit, minmax(...))` 기반으로 조정하고 480px 이하에서는 2열 유지. 검증 결과 데스크톱 1600px 폭에서 4열, 좁은 화면에서 가로폭 기준 재배치, 콘솔 오류 없음.
- 2026-06-02: 메인 홈 `#hero` 세로 크기를 +20px 조정. 데스크톱 `.hero min-height` 430px -> 450px, 모바일 구간 360px -> 380px. 브라우저에서 `#hero` 실제 렌더 높이 450px 확인, 콘솔 오류 없음.

## 다음 작업
- 관리자 화면에서 로컬 DB 기준 등록/삭제/이미지 업로드(data URL 저장) 추가 회귀 테스트.
- 다중 주연배우 2~4명 선택 저장, 감독 2명 저장, 정보출처 URL 저장의 관리자 화면 실사용 회귀 테스트.
- TMDB URL 가져오기 기능의 실제 신규 영화 저장 전체 흐름 회귀 테스트. 특히 자동 생성된 배우/카테고리, 포스터 URL, `actor_ids` 저장값, 상세 화면 이동 확인 필요.
- 미커밋 변경 범위 정리 후 의도한 단위로 CineTube 커밋/푸시 여부 결정.
- `pages/movie.html` 상세 진입, 배우 상세 진입, 홈 카드 클릭 등 이동된 공개 서브화면 브라우저 회귀 확인.
- Vercel 배포를 계속 유지할지, 로컬 전용 운영으로 고정할지 결정.
- 클라우드 Storage 객체(`cinetube-images`)도 비울지 별도 결정. 이번 작업은 테이블 데이터 초기화만 수행.

## 실행 / 검증
- run_command: `start-cinetube.cmd` 또는 `.\ct` (`http://localhost:8080/index.html` 자동 오픈)
- manual_run_command: `.\scripts\start_local_db.ps1`, `python -m http.server 8080`
- stop_command: `.\scripts\stop_local_db.ps1`
- verify_command: `node --check assets/js/shared/store.js`, local API `http://localhost:3001`, browser inspect 주요 페이지
- latest_verification: `http://localhost:8080/admin/movies.html` TMDB 패널 노출 확인, `/tmdb/import` 샘플 응답 확인, `http://localhost:8080/pages/movies.html` 포스터 그리드/목록 확인, `http://localhost:8080/index.html` hero 높이 확인, 브라우저 콘솔 오류 없음.
- port_or_runtime: `8080` static web app, `3001` local API, `54322` local PostgreSQL
- deploy_method: Vercel deployment completed from GitHub `origin/main`

## 핵심 경로
- project_root: `D:\Workspace\cinetube`
- key_docs: `docs\requirements\cinetube 기본요구사항.txt`, `docs\reference\stitch_cinetube_movie_hub\cinematic_archive_system\DESIGN.md`
- key_files: `index.html`, `pages\actors.html`, `pages\actor.html`, `pages\categories.html`, `pages\ratings.html`, `pages\movie.html`, `auth\login.html`, `admin/*.html`, `assets/js/shared/store.js`, `assets/js/shared/ui.js`, `assets/js/local-db-config.js`, `scripts/start_local_db.ps1`, `scripts/local_api.py`, `scripts/migrate_supabase_to_local.ps1`, `local/schema.sql`, `supabase/schema.sql`

## 리스크 / 주의사항
- 사용자가 Supabase 테이블 생성 완료를 확인했다.
- 사용자가 Vercel 배포 완료를 확인했다. 배포 URL: `https://cinetube-gray.vercel.app`
- Supabase URL / anon key는 `D:\workspace\cinetube\assets\js\supabase-config.js`에 등록 완료.
- 로컬 모드에서는 `assets/js/local-db-config.js`가 우선되어 Supabase 대신 `http://localhost:3001`을 사용한다.
- `local/postgres-data/`, `local/backups/`, `local/*.log`, `local/.schema_applied`는 Git 추적 제외.
- 클라우드 테이블 데이터는 초기화 완료했지만 Supabase Storage 객체 삭제는 수행하지 않았다.
- Vercel URL 확인 결과 Supabase 연결 상태가 표시되며, 영화 데이터가 없는 상태에서도 홈/관리 화면 콘솔 오류 없음.
- `media_assets` 테이블/Storage 정책 미적용 상태에서는 이미지 업로드를 차단하도록 방어 처리됨.
- Supabase Auth/RLS 기반 관리자 저장 정책은 사용하지 않는다. 관리자 쓰기는 Bloom/CineTube 자체 API에서 권한 확인 후 처리해야 한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토
- `project_registry.md`에 `cinetube` 항목이 중복 등록되어 있음. 둘 다 `states/cinetube_current.md`를 가리키지만 run/verify 설명이 서로 다르므로 추후 레지스트리 정리 필요.
- 현재 CineTube 작업트리는 `README.md`, `admin/movies.html`, `assets/css/styles.css`, 다수 JS/HTML, 스키마/마이그레이션 파일, 신규 `pages/movies.html`, `assets/js/pages/movies.js` 등이 미커밋 상태임.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `assets/js/shared/store.js`, `scripts/start_local_db.ps1`, `scripts/local_api.py`, `local/schema.sql`
- 확인이 필요한 미결사항: 관리자 로컬 CRUD 전체 회귀, 로컬 이미지 저장 정책(data URL 유지 여부), Vercel/클라우드 운영 지속 여부, Supabase Storage 객체 정리 여부
