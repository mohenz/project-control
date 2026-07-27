# makeyourtoday Current State

## 기본 정보
- project_key: `makeyourtoday`
- last_updated: `2026-07-27`
- owner_request: MBDP 요구사항 기준으로 플랫폼 기초 시스템 설계 방향 분석 / monday.com 벤치마크 반영 / 디자인 작업 의뢰서 작성 / 시안을 HTML로 받아 Claude Code가 참조 개발하는 방식으로 전환
- current_status: 요구사항 문서 v1.1 개정 완료, 디자인 작업 의뢰서 v1.1 개정 완료(전체 65개 화면 중 필수 시안 42개 + 공통 템플릿 7종(T1~T7) + 생략가능 1개로 분류, 산출물 포맷을 HTML/CSS 정적 파일 기준으로 전환), 실제 착수 전 Gate1 확정 및 디자인 착수 일정 확정 대기

## 현재 목표
- 문서 기반 기획 프로젝트를 project_control 레지스트리에 편입하고 다음 작업을 빠르게 시작할 수 있는 상태를 만든다.

## 진행 중 작업
- MBDP 요구사항과 PMO 적용 문서 기준으로 플랫폼 기초 시스템 우선 설계안 정리
- 축소 MVP 범위(동적 스키마 + AJAX CRUD + 이메일 인증, 테이블 뷰만) 확정 대기

## 최근 완료 작업
- `D:\Workspace\makeyourtoday` 경로 존재 확인
- 핵심 문서 3종 확인
- `project_registry.md`에 프로젝트 등록
- 현재 상태 파일 신규 생성
- MBDP 요구사항 기반으로 플랫폼 기초 시스템의 우선 설계 축 분석
- 개발 방식 제안: 동적 스키마는 JSONB 메타데이터 기반 권장, Phase 1 축소 MVP 슬라이스 제안, 기술스택 Node.js(Fastify)+TS+PostgreSQL+Redis로 단순화 제안
- monday.com 기능 조사 후 MBDP와 대조, 4개 기능을 `MBDP_요구사항정의서_v1.0.md` v1.1로 반영 완료:
  - Dependency 컬럼 + Timeline/Gantt 뷰 (Section 2-3, 4, 로드맵 Phase 3)
  - 자동화 레시피 빌더 (조건→액션, 보드 간 액션) (Section 7-3, 로드맵 Phase 4)
  - 멀티보드 결합 대시보드 (Section 5-2, 로드맵 Phase 4)
  - Subitem(다단계 하위 항목) 후보 검토로 명시 (신설 Section 2-4, 로드맵 "향후 검토")

## 다음 작업
- 축소 MVP 범위를 PMO/Planning 관점에서 Gate1 승인 (owner 확정 필요)
- `MBDP_디자인_작업의뢰서_v1.0.md`(내용 v1.1)의 11번(일정/문의처) TBD 항목 확정, 필수 42개 화면 목록 owner 검수
- owner가 HTML 시안을 제작해 `makeyourtoday/design-comps/` 하위에 전달하면(폴더 구조는 문서 10번 참조), Claude Code가 이를 참조해 실제 프론트엔드 코드로 이식하는 작업 진행 예정
- JSONB 기반 동적 스키마 전략을 바탕으로 `DB 설계서` 초안 작성 (Gate2 준비)
- `API 명세서`, `화면/메뉴 구조도` 초안 분리 (디자인 의뢰서의 사이트맵을 화면/메뉴 구조도의 기초자료로 활용 가능)
- `범용_멀티에이전트_운영체계.md`와 PMO 적용 문서의 관계를 정리
- 프로젝트의 실제 산출물 형태가 문서 확장인지, 코드 구현인지 결정
- 필요 시 실행 저장소 또는 프로토타입 경로를 별도 분리 등록

## 실행 / 검증
- run_command: `해당 없음`
- verify_command: `핵심 기획 문서 수동 검토`
- port_or_runtime: `N/A`
- deploy_method: `local docs / TBD`

## 핵심 경로
- project_root: `D:\Workspace\makeyourtoday`
- key_docs:
  - `D:\Workspace\makeyourtoday\범용_멀티에이전트_운영체계.md`
  - `D:\Workspace\makeyourtoday\MBDP_요구사항정의서_v1.0.md` (내용 v1.1)
  - `D:\Workspace\makeyourtoday\pm_도구_ai_에이전트_전체_설계서_mvp_포함.md`
  - `D:\Workspace\makeyourtoday\MBDP_디자인_작업의뢰서_v1.0.md` (신규)
- key_files:
  - `D:\Workspace\makeyourtoday\범용_멀티에이전트_운영체계.md`
  - `D:\Workspace\makeyourtoday\MBDP_요구사항정의서_v1.0.md`
  - `D:\Workspace\makeyourtoday\pm_도구_ai_에이전트_전체_설계서_mvp_포함.md`
  - `D:\Workspace\makeyourtoday\MBDP_디자인_작업의뢰서_v1.0.md`

## 리스크 / 주의사항
- 현재는 문서만 존재하며 실행 가능한 코드베이스나 배포 경로는 확인되지 않음
- 프로젝트명 `makeyourtoday`와 문서 내부 명칭 `MBDP 기반 PMO 플랫폼`의 관계를 이후 명확히 정리할 필요가 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `MBDP_요구사항정의서_v1.0.md`(내용은 v1.1)의 Section 2(2-3·2-4 신설 포함), 4, 5-2, 7-3, 10, 11과 `pm_도구_ai_에이전트_전체_설계서_mvp_포함.md`의 Section 4, 5
- 확인이 필요한 미결사항: 실제 구현 대상 저장소 유무, 축소 MVP 범위의 owner 승인 여부, 프로젝트 공식 명칭, 기초 시스템 이후 상세 DB/API 문서 작성 순서
- 파일명은 `MBDP_요구사항정의서_v1.0.md`를 유지한 채 내부 버전 표기만 v1.1로 갱신했음(파일 리네임 아님) — 향후 리네임 필요 시 owner 확인 후 진행






