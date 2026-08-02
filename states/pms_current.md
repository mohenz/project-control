# PMS Current State

## 기본 정보
- project_key: pms
- last_updated: 2026-07-31
- owner_request: PMS 프로젝트를 `project_control`에 등록하고 Supabase·Vercel 기반 개발 준비 상태를 공유한다.
- current_status: Excel 원형 데이터와 16개 디자인 화면 분석, 개발작업계획 및 로컬·원격 개발환경 아키텍처 설계 완료. 애플리케이션 구현과 배포 환경 구성은 미착수.

## 현재 목표
- Next.js + Supabase + Vercel 기준으로 로컬·staging·production 환경을 분리하고 PMS 개발 기반을 구축한다.

## 진행 중 작업
- 프로젝트 레지스트리·아키텍처 맵·상태 파일 등록
- Supabase 프로젝트와 GitHub 원격 정보의 안전한 환경변수 관리 방식 정리 필요

## 최근 완료 작업
- `PMS Design.xlsx`의 주간보고·주간실적·이슈사항·인력변동·사용자·코드 6개 시트 분석
- `D:\Workspace\design\epms`의 HTML/PNG 디자인 16개 화면 분석
- `docs\PMS_개발작업계획서.md` 작성
- `docs\PMS_개발환경_아키텍처.md` 작성
- 로컬 Supabase CLI, 원격 staging, Vercel Preview, Supabase/Vercel production 분리 구조 설계
- 브라우저 일반 CRUD는 사용자 JWT+RLS, 관리자·보고서·트랜잭션은 Vercel 서버 계층으로 분리

## 다음 작업
- 평문 비밀정보 파일을 저장소 추적 대상에서 제거하고 노출된 비밀키·토큰 회전
- Next.js App Router + TypeScript 프로젝트 골격 생성
- Supabase CLI 로컬 환경 초기화 및 `supabase/config.toml`, `migrations`, `seed.sql` 구성
- 사용자·프로젝트·멤버십·역할 데이터 모델과 RLS 정책 초안 작성
- Vercel Development/Preview/Production 환경변수 분리 및 환경 불변조건 검사 구현
- 디자인 시스템 토큰과 공통 앱 셸 구현

## 실행 / 검증
- run_command: planned `npm.cmd run dev`
- verify_command: planned `npm.cmd run lint`, `npm.cmd run test`, `npm.cmd run build`, `supabase db reset`
- port_or_runtime: planned Next.js `http://localhost:3000`, Supabase local ports are defined by `supabase/config.toml`
- deploy_method: GitHub `mohenz/projectmgmt` → Vercel; Supabase staging/production migrations are approval-gated and applied separately

## 핵심 경로
- project_root: `D:\Workspace\epms`
- key_docs: `docs\PMS_개발작업계획서.md`, `docs\PMS_개발환경_아키텍처.md`, `docs\디자인작업의뢰서`, `docs\PMS Design.xlsx`
- key_files: planned `apps\web`, `packages\ui`, `packages\domain`, `supabase\migrations`, `supabase\seed.sql`

## 리스크 / 주의사항
- `docs\project_setting.md`에 비밀정보가 평문으로 기록되어 있어 Git 커밋·공유 금지. 해당 키·토큰은 노출된 것으로 간주하고 회전한 뒤 Vercel/Supabase 환경변수로 이전해야 한다.
- 데이터베이스 스키마 변경·이관·초기화는 사용자 승인과 백업 없이 수행하지 않는다.
- Vercel Preview가 Supabase production에 연결되지 않도록 환경별 project ref를 빌드 단계에서 검증한다.
- `service_role` 키와 DB 접속 문자열에는 `NEXT_PUBLIC_` 접두사를 사용하지 않는다.
- 디자인 시안의 영문 메뉴·상태·외국 예시 데이터는 구현 시 한국어 UI와 한국형 예시 데이터로 교체한다.
- 프로젝트 폴더는 아직 독립 Git 저장소로 초기화되지 않은 상태일 수 있으므로 첫 구현 전에 저장소 경계를 확인한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome`을 우선 검토한다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs\PMS_개발환경_아키텍처.md`, `docs\PMS_개발작업계획서.md`, `D:\Workspace\design\epms\structure_flow\DESIGN.md`
- 확인이 필요한 미결사항: Vercel·Supabase 플랜, staging 환경 방식, 인증 방식, 리전, 운영 도메인, 공정율 집계 기준

## Handoff
- current_goal: Next.js + Supabase + Vercel 기반 PMS 개발환경 기준선 구축
- done_latest: Excel 6개 시트와 디자인 16개 화면 분석, 개발계획·환경 아키텍처 문서 작성, project_control 등록
- key_findings: 사용자 범위 CRUD는 RLS를 유지하고 관리자·보고서·트랜잭션만 서버 계층으로 분리해야 하며 local/staging/production DB를 물리적으로 분리해야 함
- changed_files: `project_registry.md`, `project_docs\PROJECT_ARCHITECTURE_MAP.md`, `states\pms_current.md`; 프로젝트 문서 `epms\docs\PMS_개발작업계획서.md`, `epms\docs\PMS_개발환경_아키텍처.md`
- verification: 레지스트리 경로·핵심 문서 존재 확인, 구현·런타임·배포 검증은 아직 미착수
- next_action: 비밀정보 회전 및 환경변수 이전 승인 후 Next.js·Supabase 로컬 골격 생성
- risks_or_blockers: `blocked_by` 평문 비밀정보 처리와 환경별 Supabase/Vercel 정책 확정; `do_not_do` 현재 비밀정보 파일을 Git에 커밋하거나 값을 상태 파일에 복사하지 말 것
