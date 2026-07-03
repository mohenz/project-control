# Project Control Current State

## 기본 정보
- project_key: project_control
- last_updated: 2026-07-03
- current_status: `D:\workspace\project_control`은 workspace 중앙 프로젝트 레지스트리, 상태 파일, 전환 워크플로우, 운영 규칙을 관리하는 Git 저장소. 2026-07-03 기준 `origin/main`과 동기화 완료.

## 현재 목표
- `D:\workspace` 내 등록 프로젝트의 상태 복구, 전환, 상태 저장 기준을 안정적으로 유지.
- 프로젝트별 `states/*.md`를 최신 운영 사실 중심으로 관리.

## 최근 완료 작업
- 2026-07-04: 전체 프로젝트 아키텍처 참조 문서 `project_docs/PROJECT_ARCHITECTURE_MAP.md` 생성. `project_registry.md`, `README.md`, `project_switch_workflow.md`에서 해당 문서를 참조하도록 반영.
- 2026-07-03: `origin/main`에서 `archive_store` 등록 및 handoff 상태 업데이트 커밋 2건을 fast-forward로 반영. 현재 HEAD는 `0a865f9` (`Update archive_store handoff state`).
- 2026-06-21: Codex handoff 기능 일부를 project-control에 흡수. `/project handoff <alias>` 명령 규격, handoff workflow, state update rule, 상태 템플릿 `Handoff` 섹션, README 주요 명령, governance handoff 운영 규칙을 추가.
- 2026-06-13: `jian_soul` 프로젝트 신규 등록 (`project_registry.md` 반영) 및 상태 파일(`states/jian_soul_current.md`) 생성 완료.
- project-control 스킬과 workspace `AGENTS.md` 기준의 전환/상태 저장 절차 확인.
- `cinetube` 상태 파일의 오래된 미커밋 기록을 실제 Git 상태에 맞게 정정.
- `project_control` 자체 상태 파일을 생성해 중앙 관리 저장소도 상태 관리 대상에 포함.

## 다음 작업
- `project_docs/PROJECT_ARCHITECTURE_MAP.md`를 기준으로 레지스트리 등록 누락 상태 파일을 정식 등록할지 결정.
- 로컬 미커밋 상태 파일 변경(`states/cinetube_current.md`, `states/unit_test_current.md`, `states/project_control_current.md`)의 커밋 여부를 사용자 결정에 따라 처리.
- `project_registry.md`의 중복 `cinetube` 항목을 정리할지 사용자 결정 필요.

## 실행 / 검증
- run_command: N/A
- verify_command: `git status --short --branch`
- latest_verification: 2026-07-03 `git fetch origin` 후 `git merge --ff-only origin/main` 성공. 로컬 `main`과 `origin/main`은 같은 커밋이며, 작업트리에는 상태 파일 미커밋 변경이 남아 있음.
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
- 2026-07-03 현재 `states/cinetube_current.md`, `states/unit_test_current.md`는 기존 미커밋 변경으로 남아 있으므로 이번 동기화 작업에서 수정하지 않음.

## Handoff
- current_goal: project-control 중앙 레지스트리, 상태 파일, 전체 아키텍처 참조 문서를 최신 운영 기준으로 유지.
- done_latest: `project_docs/PROJECT_ARCHITECTURE_MAP.md` 생성 및 README/workflow/registry 참조 연결.
- key_findings: 레지스트리 등록 프로젝트와 상태 파일만 있는 프로젝트가 혼재되어 있어, 아키텍처 맵에서 `등록 프로젝트`와 `상태 파일 기준 추가 프로젝트`로 분리함.
- changed_files: `project_docs/PROJECT_ARCHITECTURE_MAP.md`, `README.md`, `project_switch_workflow.md`, `project_registry.md`, `states/project_control_current.md`.
- verification: 문서 변경으로 `git diff --check` 확인 필요.
- next_action: 변경사항 검증 후 커밋/푸시. 이후 상태 파일만 있는 프로젝트의 정식 레지스트리 등록 여부 결정.
- risks_or_blockers: 기존 미커밋 변경 `states/cinetube_current.md`, `states/unit_test_current.md`는 이번 작업 범위가 아니므로 건드리지 않음.






