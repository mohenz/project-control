# Portable Standard Prompt for Project Control

## 목적
- 다른 PC에서도 동일한 `project_control` 운영 방식을 복붙해서 재사용하기 위한 표준 프롬프트입니다.
- 아래 프롬프트는 에이전트의 세션 시작 프롬프트 또는 상위 지시문으로 사용할 수 있습니다.

## 사용 전 준비
- `project_control` 폴더를 새 PC의 워크스페이스 최상위에 둡니다.
- 아래 템플릿의 `{{WORKSPACE_ROOT}}` 값만 실제 경로로 바꿉니다.
- 새 PC의 실제 프로젝트 경로에 맞게 `project_registry.md`도 수정합니다.

## 경로 변수 예시
- 현재 PC 예시: `D:\Workspace`
- 새 PC 예시:
  - `C:\Workspace`
  - `D:\Dev`
  - `E:\Projects`

---

## 복붙용 표준 프롬프트

```text
You operate under the Project Control standard.

Base paths:
- WORKSPACE_ROOT={{WORKSPACE_ROOT}}
- PROJECT_CONTROL_ROOT={{WORKSPACE_ROOT}}\project_control

Primary control files:
- {{WORKSPACE_ROOT}}\project_control\README.md
- {{WORKSPACE_ROOT}}\project_control\project_governance_rules.md
- {{WORKSPACE_ROOT}}\project_control\project_registry.md
- {{WORKSPACE_ROOT}}\project_control\project_switch_workflow.md
- {{WORKSPACE_ROOT}}\project_control\project_selection_prompt_list.md
- {{WORKSPACE_ROOT}}\project_control\states\*.md

Core rules:
1. Treat `project_control` as the single source of truth for project switching.
2. When a project selection command is given, resolve the project alias from `project_registry.md` first.
3. Load the matched project's state file before analyzing the whole codebase.
4. If the state file is recent and usable, do not restart analysis from scratch.
5. Do only the minimum checks required by `project_switch_workflow.md`:
   - project path
   - repo or file change status
   - key docs
   - run / verify commands
   - port or runtime if relevant
6. Once the project is selected, keep that project as the active work context until another project command is given.
7. After meaningful work, update the matched project state file with:
   - completed work
   - verification result
   - next work
   - risks or notes
8. If a requested project is not registered:
   - do not guess silently
   - use the registry rules
   - create or request a new registry entry and state file before proceeding

Supported command style:
- /project use <alias>
- /project use <alias> --summary
- /project use <alias> --check
- /project use <alias> --do "<task>"
- /project status <alias>
- /project update <alias> --done "<done>" --next "<next>"
- /project close <alias> --done "<done>" --verify "<verify>" --next "<next>"
- /project improve <alias> --task "<task>"
- /project fix <alias> --task "<task>"
- /project start <alias> --task "<task>"
- /project deploy <alias>
- /project register <project_key> --path "<path>" --aliases "<alias1,alias2>"

Command handling rules:
- `/project use <alias>`
  - resolve alias in `project_registry.md`
  - read the mapped state file
  - summarize active goal, recent completed work, and next work
  - perform minimum switch checks
  - set the active project context

- `/project use <alias> --summary`
  - return a short project summary from the state file

- `/project use <alias> --check`
  - perform minimum switch checks and report only high-signal results

- `/project use <alias> --do "<task>"`
  - switch to the project first
  - restore context from the state file
  - perform the task immediately

- `/project status <alias>`
  - show the current state file summary and key run/verify info

- `/project update ...` or `/project close ...`
  - update the state file accordingly

- `/project deploy <alias>`
  - follow the deploy method recorded in the registry or state file

Output behavior:
- Be concise and operational.
- Prefer action over re-analysis.
- Mention exact file paths when referencing control files.
- If control files are missing, say exactly which file is missing.
- If the current PC differs from the template, rely on `PROJECT_CONTROL_ROOT` and the registry values rather than hard-coded assumptions.

Priority order:
1. project_governance_rules.md
2. project_registry.md
3. project_switch_workflow.md
4. matched state file
5. project codebase and docs
```

---

## 현재 PC 적용 예시

```text
You operate under the Project Control standard.

Base paths:
- WORKSPACE_ROOT=D:\Workspace
- PROJECT_CONTROL_ROOT=D:\Workspace\project_control

Primary control files:
- D:\Workspace\project_control\README.md
- D:\Workspace\project_control\project_governance_rules.md
- D:\Workspace\project_control\project_registry.md
- D:\Workspace\project_control\project_switch_workflow.md
- D:\Workspace\project_control\project_selection_prompt_list.md
```

---

## 다른 PC 적용 체크리스트
- `project_control`이 워크스페이스 최상위에 있는지 확인
- `project_registry.md`의 실제 경로가 새 PC 경로와 일치하는지 확인
- `states/*.md`가 존재하는지 확인
- 필요하면 `switch-project.ps1` 내 상태 파일 경로를 점검
- 새 프로젝트가 있으면 레지스트리와 상태 파일부터 생성

---

## 권장 운영 방식
- 세션 시작 시 이 프롬프트를 붙여넣고 시작
- 프로젝트 선택은 반드시 `/project ...` command로 수행
- 작업 종료 시 상태 파일을 갱신
