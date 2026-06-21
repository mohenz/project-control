# Project Control Current State

## 기본 정보
- project_key: project_control
- last_updated: 2026-06-21
- current_status: `D:\workspace\project_control`은 workspace 중앙 프로젝트 레지스트리, 상태 파일, 전환 워크플로우, 운영 규칙을 관리하는 Git 저장소. 2026-06-21 기준 `/project handoff <alias>` 운영 규격과 상태 파일 `Handoff` 섹션 표준을 추가하는 중.

## 현재 목표
- `D:\workspace` 내 등록 프로젝트의 상태 복구, 전환, 상태 저장 기준을 안정적으로 유지.
- 프로젝트별 `states/*.md`를 최신 운영 사실 중심으로 관리.

## 최근 완료 작업
- 2026-06-21: Codex handoff 기능 일부를 project-control에 흡수. `/project handoff <alias>` 명령 규격, handoff workflow, state update rule, 상태 템플릿 `Handoff` 섹션, README 주요 명령, governance handoff 운영 규칙을 추가.
- 2026-06-13: `jian_soul` 프로젝트 신규 등록 (`project_registry.md` 반영) 및 상태 파일(`states/jian_soul_current.md`) 생성 완료.
- project-control 스킬과 workspace `AGENTS.md` 기준의 전환/상태 저장 절차 확인.
- `cinetube` 상태 파일의 오래된 미커밋 기록을 실제 Git 상태에 맞게 정정.
- `project_control` 자체 상태 파일을 생성해 중앙 관리 저장소도 상태 관리 대상에 포함.

## 다음 작업
- handoff 규격 변경사항 커밋 및 `origin/main` push 확인.
- `project_registry.md`의 중복 `cinetube` 항목을 정리할지 사용자 결정 필요.
- 상태 파일 변경 커밋 후 `origin/main` push 결과 확인.

## 실행 / 검증
- run_command: N/A
- verify_command: `git status --short --branch`
- latest_verification: `project_control` 작업트리 clean, 로컬 `main`이 `origin/main`보다 1개 커밋 ahead 상태로 확인됨.
- deploy_method: `git push origin main`

## 핵심 경로
- project_root: `D:\workspace\project_control`
- registry: `project_registry.md`
- governance: `project_governance_rules.md`
- workflow: `project_switch_workflow.md`
- states: `states/*.md`

## 리스크 / 주의사항
- `project_registry.md`에 `cinetube` 항목이 중복 등록되어 있음. 둘 다 `states/cinetube_current.md`를 가리키지만 run/verify/deploy 설명이 다르므로 추후 정리 필요.
- startup routine에서는 자동 fast-forward 대상만 갱신하고, dirty/divergent/no-upstream 상태는 강제 처리하지 않는다.
- handoff에는 비밀값, 토큰, 인증정보, 개인키를 기록하지 않는다.

## Handoff
- current_goal: project-control에 `/project handoff <alias>` 명령과 상태 파일 handoff 표준을 추가하고 원격에 반영.
- done_latest: 명령 규격, 워크플로우, 상태 업데이트 규칙, 템플릿, README, governance 문서 수정.
- key_findings: 기존 `project_registry.md` 변경은 `jian_soul` run command 변경이며, 이번 handoff 작업과 무관하므로 내용 수정하지 않음.
- changed_files: `project-control/SKILL.md`, `project-control/references/*.md`, `project_switch_workflow.md`, `project_governance_rules.md`, `templates/project_state_template.md`, `README.md`, `states/project_control_current.md`.
- verification: 문서/규격 변경이라 실행 테스트보다 git diff/status 확인 필요.
- next_action: 변경사항 커밋 후 `git push origin main`.
- risks_or_blockers: 기존 미커밋 변경(`project_registry.md`, `states/cinetube_current.md`)이 함께 존재하므로 커밋 범위 확인 필요.






