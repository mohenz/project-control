# Project Control Center

## 목적
- 여러 프로젝트를 병행할 때 프로젝트 전환 비용을 줄이기 위한 중앙 운영 폴더입니다.
- 프로젝트별 규칙, 별칭, 현재 상태, 전환 절차를 한 곳에서 관리합니다.

## 사용 원칙
- 프로젝트 전환 요청이 오면 먼저 `project_registry.md`에서 별칭을 확인합니다.
- 매칭된 프로젝트의 상태 파일을 먼저 읽고 필요한 최소 검증만 수행합니다.
- 상태 파일이 최신이면 처음부터 전체 분석하지 않습니다.
- 작업 종료 전에는 상태 파일에 현재 상황과 다음 작업을 반영합니다.

## 빠른 사용 순서
1. 사용자 요청에서 프로젝트 별칭을 확인합니다.
2. `project_registry.md`에서 프로젝트 키와 경로를 찾습니다.
3. 해당 프로젝트의 `states/*.md` 파일을 읽습니다.
4. `project_switch_workflow.md`의 진입 체크리스트대로 최소 확인을 수행합니다.
5. 작업을 진행합니다.
6. 종료 전 상태 파일과 필요한 변경 이력을 갱신합니다.

## 포함 문서
- `project_governance_rules.md`
- `project_registry.md`
- `project_switch_workflow.md`
- `project_selection_prompt_list.md`
- `vscode_skill_manual.md`
- `portable_standard_prompt.md`
- `templates/project_state_template.md`
- `states/*.md`
- `scripts/switch-project.ps1`

## 현재 등록 프로젝트
- `defect_manage`
- `n8n_defect_automation`
- `auth_pro`
- `project_04` placeholder

## 폴더 구조
```text
project_control/
  README.md
  project_governance_rules.md
  project_registry.md
  project_switch_workflow.md
  templates/
    project_state_template.md
  states/
    defect_manage_current.md
    n8n_defect_automation_current.md
    auth_pro_current.md
    project_04_placeholder.md
  scripts/
    switch-project.ps1
```
