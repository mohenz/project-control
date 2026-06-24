# defect_manage2 Local PostgreSQL Cutover Plan

## 목적
- `defect_manage2`를 Supabase 직접 연결 방식에서 로컬 PostgreSQL + Node API 방식으로 전환한다.
- 전환 후 브라우저는 Supabase SDK를 사용하지 않고 `/api/*` 로컬 API만 호출한다.
- 기존 `StorageService` 공개 인터페이스는 유지해 앱 화면 로직의 변경 범위를 최소화한다.

## 확정 기준
- 로컬 DB: PostgreSQL 18
- DB 포트: `54323`
- DB 이름: `defect_manage2`
- DB 사용자: `postgres`
- 로컬 인증: `trust`
- 웹/API 포트: `3000`
- 전환 방식: 즉시 로컬 전환, 런타임 Supabase/Local 토글 없음

## 구현 작업
1. 로컬 PostgreSQL 구성
   - `defect_manage2/local/schema.sql` 작성
   - `defect_manage2/scripts/start_local_db.ps1` 작성
   - `defect_manage2/scripts/stop_local_db.ps1` 작성
   - `.gitignore`에 로컬 DB 데이터/백업/로그 제외 규칙 추가

2. Supabase 데이터 이관 스크립트
   - `defect_manage2/scripts/migrate_supabase_to_local.ps1` 작성
   - `js/config.js`의 기존 Supabase URL/key를 읽어 REST export 수행
   - 대상 테이블: `users`, `common_codes`, `app_settings`, `defect_save_error_logs`, `defect_history`
   - `defects`는 전체가 아니라 최근 데이터 기준 테스트 구분별 최대 100건씩 이관
   - JSON 백업 및 import SQL 생성 후 로컬 DB에 적재
   - 테이블 접근 실패 시 즉시 실패하고 조치 메시지 출력

3. Node API 전환
   - `server.js`를 JSON 파일 기반 API에서 PostgreSQL 기반 API로 교체
   - `pg` 의존성 추가
   - 신규 API: health, defects, users, common-codes, settings, error-logs, history
   - `DELETE /api/defects/:id`는 `is_deleted='Y'` soft delete로 처리

4. Frontend Storage 전환
   - `js/config.js`는 `API_BASE_URL: "/api"`만 유지
   - `index.html`에서 Supabase CDN 제거
   - `js/storage.js` 및 도메인 storage 서비스는 Supabase client 대신 fetch 기반 API client를 사용
   - 기존 `StorageService.defects/users/commonCodes/settings/logs/history` 호출 형태 유지

5. 검증
   - `npm.cmd install`
   - `npm.cmd run check:syntax`
   - `npm.cmd run test:unit`
   - `scripts/start_local_db.ps1`
   - `GET /api/health`
   - 주요 화면 수동 확인: 로그인, 대시보드, 결함 목록/등록/수정, 관리자 사용자/공통코드/오류로그/재확인

## 주의사항
- 현재 `defect_manage2` 저장소는 첫 커밋 전이라 전체 파일이 untracked 상태다.
- 기존 `defect_manage` 운영 소스는 변경하지 않는다.
- Supabase anon key로 REST export가 막히는 테이블이 있으면 service role key 또는 DB 직접 dump 방식으로 이관 단계를 보완해야 한다.
- `defects` 이관 범위는 2026-06-24 사용자 지시에 따라 테스트 구분별 최근 100건으로 제한한다.
- 로컬 DB 전환 후 기존 GitHub Pages 정적 배포 방식은 더 이상 단독 동작하지 않는다. 로컬 Node API가 필수 런타임이다.
