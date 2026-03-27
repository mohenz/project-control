# n8n_defect_automation Current State

## 기본 정보
- project_key: `n8n_defect_automation`
- last_updated: `2026-03-27`
- owner_request: n8n 프로젝트로 전환 예정
- current_status: 문서/워크플로우 기반 자동화 프로젝트

## 현재 목표
- n8n 결함 리포트 자동화 프로젝트를 빠르게 재개할 수 있도록 문맥 복구 포인트를 정리한다.

## 진행 중 작업
- 현재 세션 기준 구현 변경 없음

## 최근 완료 작업
- 중앙 프로젝트 관리 체계에 프로젝트 등록

## 다음 작업
- 현재 운영 중인 n8n 인스턴스 환경 확인
- 워크플로우 JSON과 실제 n8n 배치 상태 비교
- Supabase / Gmail / Schedule 자격 증명 및 타임존 상태 점검

## 실행 / 검증
- run_command: `n8n Cloud 또는 Desktop에서 workflow/defect_report_workflow.json 임포트`
- verify_command: `docs/n8n_project_manual.md`, `docs/n8n_setup_guide.md`, `workflow/defect_report_workflow.json` 확인
- port_or_runtime: `n8n Cloud 또는 Desktop`
- deploy_method: `n8n 워크플로우 활성화`

## 핵심 경로
- project_root: `D:\Workspace\n8n-defect-automation`
- key_docs:
  - `docs/n8n_project_manual.md`
  - `docs/n8n_setup_guide.md`
  - `docs/update_log_2026-03-26.md`
- key_files:
  - `workflow/defect_report_workflow.json`
  - `scripts/collect_defect_stats.js`
  - `scripts/email_template.html`

## 리스크 / 주의사항
- 실행 상태는 로컬 코드만으로 완전히 확인할 수 없고 실제 n8n 인스턴스 확인이 필요함
- Gmail, Supabase, Schedule 자격 증명 상태에 따라 동일 파일이라도 실행 결과가 달라질 수 있음
- 타임존은 `Asia/Seoul` 기준 확인 필요

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `docs/n8n_project_manual.md`, `workflow/defect_report_workflow.json`
- 확인이 필요한 미결사항: 현재 운영 인스턴스 위치와 자격 증명 보관 방식
