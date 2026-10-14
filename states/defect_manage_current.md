# defect_manage Current State

## 기본 정보
- project_key: `defect_manage`
- last_updated: `2026-10-14`
- owner_request: 로컬 PostgreSQL 18 및 모듈 분해 차세대 아키텍처(defect_manage2)로 전면 컷오버 및 사내 Gitea 배포
- current_status: 활성 운영 프로젝트 (로컬 PostgreSQL 18 + Node API 서버 + 23개 모듈형 프론트엔드 전환 완료)

## 현재 목표
- Cloud Supabase 의존성을 완전히 제거한 로컬 PostgreSQL 18 기반 독립 운영 체계 안정화 및 성능 유지.
- 23개 독립 모듈/서비스/유틸로 분해된 모듈형 프론트엔드의 화면별 기능 회귀 방지 및 안정적 서비스 제공.

## 진행 중 작업
- 로컬 Node API 서버(`server.js`) 및 PostgreSQL 18 (`127.0.0.1:54323`) 연동 실동작 모니터링
- Vitest 및 Playwright 기반 로컬 테스트 러너 환경 점검

## 최근 완료 작업
- **2026-10-14 20:23**: 사내 Gitea 원격 배포 트리거 완료 (`3ff0689 deploy: trigger internal server workspace clone and deployment`)
- **2026-10-14 20:06**: 로컬 PostgreSQL 18 및 모듈 분해 차세대 아키텍처 전면 컷오버 완수 (`ff577de feat: cutover to local PostgreSQL 18 and modular architecture`)
  - **DB 레이어**: Cloud Supabase 종속성 완전 제거 ➔ 로컬 PostgreSQL 18 (`127.0.0.1:54323`, database: `defect_manage2`, user: `postgres`) 전환
  - **백엔드 API**: Express/Node.js 기반 REST API 서버(`server.js`) 구축, `scripts/start_local_db.ps1`, `scripts/stop_local_db.ps1`, `scripts/migrate_supabase_to_local.ps1` 배치
  - **프론트엔드 모듈 분해**: 기존 3,780라인 모놀리식 `js/app.js` 및 `js/storage.js`를 23개 도메인 모듈로 완전 분리
    - `js/modules/`: `admin-module.js`, `admin-settings-module.js`, `assignee-status-module.js`, `auth-module.js`, `dashboard-module.js`, `form-module.js`, `list-module.js`
    - `js/services/`: `bridge-service.js`, `image-service.js`, `defect-storage-service.js`, `common-code-storage-service.js`, `error-log-storage-service.js`, `history-storage-service.js`, `settings-storage-service.js`, `user-storage-service.js`
    - `js/utils/`: `app-utils.js`, `storage-query-utils.js`
  - **테스트 환경**: Vitest (`config/vitest.config.js`), Playwright (`config/playwright.config.js`) 설정 및 단위/E2E 테스트 배치
  - **무결성 검증**: `npm.cmd run check:syntax` 수행 결과 23개 전 파일 문법 검증 통과 (`All syntax checks passed`)
- **2026-06-12**: 인코딩 복구 및 동기화 정리 (`e1960bd`)
- **2026-04-30**: 대시보드 테스트 구분별 요약 집계 1,000건 단위 페이징 수집 버그 수정 (`1b7b5e8`)
- **2026-04-09**: 대시보드 조치완료율 및 조치 미완료 카드 필터 연동 (`db41656`, `0445498`, `16b553d`)
- **2026-04-07**: `action_due_date` (조치예정일) 컬럼 및 목록/상세/엑셀 다운로드 연동 (`109e576`)

## 다음 작업
- 브라우저를 통한 로컬 웹앱(`http://127.0.0.1:3000`) 대시보드 및 결함 목록/등록/수정 전체 기능 실동작 점검
- `npm install` 후 `npm.cmd run test:unit` 전체 테스트 스위트 정상 통과 검증
- 결함 등록 시 첨부 이미지 및 화면 캡처 업로드 흐름의 로컬 파일 저장소 검증

## 실행 / 검증
- run_command: `npm.cmd start` (또는 `start_local.bat`)
- verify_command: `npm.cmd run check:syntax`, `npm.cmd run test:unit`
- port_or_runtime: App `http://127.0.0.1:3000`, API `http://127.0.0.1:3000/api`, PostgreSQL `127.0.0.1:54323` (DB: `defect_manage2`)
- deploy_method: 사내 Gitea `http://127.0.0.1:3000/PMO/defect_manage.git` push
- latest_deploy: `2026-10-14 20:23` / commit `3ff0689` pushed to `origin/main`

## 핵심 경로
- project_root: `D:\workspace\defect_manage`
- key_docs:
  - `README.md`
  - `docs/CHANGELOG.md`
  - `docs/executable_size_structure_improvement_plan.md`
  - `docs/user_manual.md`
- key_files:
  - `server.js`
  - `index.html`
  - `js/app.js`
  - `js/config.js`
  - `js/storage.js`
  - `local/schema.sql`

## 리스크 / 주의사항
- 로컬 DB 서버(`PostgreSQL 18`)가 54323 포트에서 가동 중이어야 API가 정상 동작함 (`scripts/start_local_db.ps1` 사용).
- 디렉토리가 `NT AUTHORITY/SYSTEM` 소유이므로, 일반 사용자 터미널 환경에서 Git 사용 시 `safe.directory` 예외 등록 필요 (`git config --global --add safe.directory D:/workspace/defect_manage`).
- 모듈화로 인해 스크립트 의존 관계가 `index.html`의 스크립트 로드 순서 및 ES 모듈/글로벌 바인딩 방식에 의존하므로 신규 파일 추가 시 로드 순서 주의.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `server.js`, `js/modules/dashboard-module.js`, `js/services/storage/defect-storage-service.js`
- 확인이 필요한 미결사항: 로컬 PostgreSQL 54323 포트 서비스 상시 구동 여부 및 Vitest 의존성 설치 확인
