# Project State

## 기본 정보
- project_key: `wbs`
- last_updated: `2026-07-16`
- owner_request: `WBS 엑셀 데이터 분석 및 데이터베이스(PostgreSQL) 연동 기반 프로젝트 수행일정 관리/시각화 대시보드(PC/Mobile) 구축`
- current_status: `WBS 엑셀 데이터 DB 이관 완료 및 WBS 에디터 실시간 연동 실증 완료`

## 현재 목표
- WBS 데이터를 PostgreSQL 데이터베이스에서 관리하고, 계획 및 실적 일자에 따른 상태/공정율 실시간 자동 연산 엔진을 구축한다.
- PC Web(풀 관리기능) 및 Mobile Web(캘린더/일정 조회기능) 디자인 시안을 획득하고 개발한다.

## 진행 중 작업
- 사용자(Brian)의 다음 화면 디자인 및 기능 고도화 지시 대기.

## 최근 완료 작업
- WBS 엑셀 파일 데이터 및 수식 상세 분석 완료.
- [implementation_plan.md](file:///d:/Workspace/wbs/docs/implementation_plan.md) 작성 및 사용자 요구사항 반영 완료.
- 로컬 PostgreSQL 54322 포트에 WBS 스키마 구축 완료 ([schema.sql](file:///d:/Workspace/wbs/docs/schema.sql)).
- 엑셀 데이터 618개행을 데이터베이스로 마이그레이션 이관 성공 ([migrate_wbs_data.py](file:///C:/Users/mohen/.gemini/antigravity-ide/brain/1b4d362f-77cd-4b00-83c9-bbd95857b203/scratch/migrate_wbs_data.py)).
- FastAPI 백엔드 CRUD API 서버 구축 및 가동 완료 ([api_server.py](file:///d:/Workspace/wbs/api_server.py)).
- WBS EDITOR 프로토타입 UI에 실시간 데이터 로드 및 인라인 편집 저장 기능 연동 완료 ([wbs_editor.html](file:///d:/Workspace/wbs/prototype/wbs_editor.html)).
- 브라우저 서브에이전트 실증 테스트를 통한 수정값 영속화 검증 성공 (수정값 리로드 유지).

## 다음 작업
- 영업일수 자동 연산 및 공휴일 제외 로직 개발.
- 엑셀 다운로드 / 엑셀 업로드 백엔드 API 및 프론트엔드 액션 추가.
- 전체 대시보드 화면 연동 개발.

## 실행 / 검증
- run_command: `TBD`
- verify_command: `inspect docs/implementation_plan.md, docs/design_request.md`
- port_or_runtime: `TBD`
- deploy_method: `React client (Vite) + FastAPI server + Local PostgreSQL`

## 핵심 경로
- project_root: `d:\Workspace\wbs`
- key_docs: `docs/ECLUB_MNG_PL_0002_WBS_이클럽 프로젝트 일정관리_v.0.6_20260428.xlsx`, `docs/implementation_plan.md`, `docs/design_request.md`

## 리스크 / 주의사항
- **개발 규칙 준수**: 무단으로 개발하지 말고 규칙을 준수할 것. 사용자의 명시적 수동 지시가 확인된 후에 실제 코딩을 시작해야 함.
- **영업일수 정밀 계산**: `NETWORKDAYS` 로직 이식 시 주말 및 공휴일 테이블(`wbs_holiday`) 데이터를 완벽히 제외하도록 처리할 것.
