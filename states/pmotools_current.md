# pmotools Current State

## 기본 정보
- project_key: `pmotools`
- last_updated: `2026-10-13`
- owner_request: 에이전트 거버넌스 정비 및 최근 완료 작업 상태 파일 반영
- current_status: Green

## 현재 목표
- Next.js + Prisma ORM + PostgreSQL 기반 EPMS/PMO 통제 웹 애플리케이션의 개발 및 운영 준비 상태 유지.

## 진행 중 작업
- 현재 세션 기준 긴급 미완료 작업 없음

## 최근 완료 작업
- GitHub 저장소 (`mohenz/pmotools`) 수집 및 `d:\workspace\pmotools` 배치
- Node.js LTS (v24.19.0) 및 PostgreSQL 18.6-3 winget 자동 설치 및 PATH 세팅
- PostgreSQL 18 한글 로케일(`dict_snowball` 인코딩) 호환성 패치 (`snowball_create.sql` ASCII BOM 제거, `--locale=C --encoding=UTF8`)
- PostgreSQL 55432 포트 윈도우 영속 서비스 (`PostgreSQL-pmotools`) 정식 등록 및 기동
- 50개 Prisma 스키마 마이그레이션 전체 적용 (`npx prisma migrate deploy`)
- `prisma/seed.ts` 멱등성 보완 및 관리자 계정 (`pmo.admin` / `ChangeMe!2026`, `ADMIN` 권한) 데이터 시딩
- **원격 DB (Supabase Cloud) ➔ 로컬 DB (PostgreSQL 55432 / mydb) 전체 데이터 이행 완수**:
  - `migrate-prod-to-local.ps1`을 통한 6.3MB 프로덕션 덤프 수집 및 로컬 복원 완료
  - **이행 데이터 검증**: `users` (81건), `wbs_items` (3,418건), `issues` (2건) 등 프로덕션 전체 실데이터 로컬 복제 성공
- Next.js 웹 개발 서버 기동 (`npm run local` / 포트 3020)
- 헬스체크 통과 확인 (`http://localhost:3020/api/health` -> `{"status":"ok","database":"connected","provider":"postgres"}`)
- project-control 등록 (`project_registry.md`, `states/pmotools_current.md`, `switch-project.ps1`)
- **[2026-10-01~02] EOCP 프로젝트 분리 및 마이그레이션 작전 완료**:
  - S-5E DB 무결성 복구 (psql 마이그레이션 누락 파일 3개 강제 적용)
  - 권한 롤백 대응 (`SUPER_ADMIN` 및 10명 사용자 계정 복구)
  - 5개 신규 프로젝트 트리 구조 생성 및 번호 체계(`numberingBase`) 검증 완료
  - `pmotools` Public API 프로젝트 정렬 캐싱/타입캐스팅 버그 패치 (`route.ts` `force-dynamic` 추가 및 DB `sortOrder` 강제 갱신)
  - PA-1 및 D-8 배포 문서 최종 정리 (`d:\workspace\docs\작업파일_내부서버배포_20261001.md`)
- **[2026-10-12~13] UI 기능 고도화 완료**:
  - 회의록 Action Item 표준 페이징 구현 완료
  - 회의록 목록 표준 페이징 구현 완료
  - 서브메뉴 접기/펼치기 (스플리터/드래그 리사이저 포함) 구현 완료
  - Admin 고유 기능 통합 완료

## 다음 작업
- 캘린더 고도화 (반복일정 RRULE, 다중 담당자/그룹 태깅) 및 WBS/주간보고 기능 연동
- 엑셀 업/다운로드, 첨부파일 (Supabase Storage)
- Supabase Connection Pooling · RLS · 백업(PITR) 운영 정책 확정
- 프로덕션 실데이터 취급 보안 조치 유지 (외부 유출/커밋 금지)

## 실행 / 검증
- run_command: `npm.cmd run local`
- verify_command: `http://localhost:3020/api/health`
- port_or_runtime: `localhost:3020` (Web) / `localhost:55432` (PostgreSQL)
- deploy_method: Vercel Production + Supabase Managed Postgres

## 핵심 경로
- project_root: `D:\workspace\pmotools`
- key_docs:
  - `README.md`
  - `SETUP_CHECKLIST.md`
  - `scripts/migrate/프로덕션DB_로컬마이그레이션_가이드.md`
  - `docs/PMS_개발환경_아키텍처.md`
- key_files:
  - `scripts/migrate/migrate-prod-to-local.ps1`
  - `prisma/schema.prisma`
  - `prisma/seed.ts`
  - `lib/server/auth.ts`
  - `app/login/page.tsx`

## 리스크 / 주의사항
- PostgreSQL 18 Windows 빌드는 로케일 `dict_snowball` 모듈 누락 문제로 `initdb` 시 `--locale=C` 옵션 필수.
- `PostgreSQL-pmotools` 윈도우 서비스가 멈출 경우 `Start-Service PostgreSQL-pmotools`로 재기동 필요.
- 로컬 DB에 프로덕션 실데이터(사용자 81명, WBS 3418건)가 그대로 존재하므로 외부 유출 금지.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `SETUP_CHECKLIST.md`, `http://localhost:3020/api/health`, `scripts/migrate/migrate-prod-to-local.ps1`
- 관리자 계정: `pmo.admin` / `ChangeMe!2026`
