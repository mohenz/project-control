---
name: project-control
description: Use when working in a multi-project workspace that keeps a top-level project_control folder for alias-based project switching, state-file context recovery, minimal startup checks, and /project command handling such as /project use, /project status, /project update, /project close, /project improve, /project fix, /project start, /project deploy, or /project register.
---

# Project Control

Use this skill when the workspace has a top-level `project_control` folder and the user wants to switch projects, restore context from state files, or manage work through `/project ...` commands.

## Find Control Files

- Find `project_control` at the workspace top level.
- Use these files in this order:
  1. `project_governance_rules.md`
  2. `project_registry.md`
  3. `project_switch_workflow.md`
  4. matched file in `states/`
- If any required file is missing, report the exact missing path and stop guessing.
- Treat `project_registry.md` as the source of truth for alias resolution, project path, state file path, and deploy hints.

## Handle Commands

### `/project use <alias>`
- Resolve the alias in `project_registry.md`.
- Read the matched state file before reading the project codebase.
- Summarize:
  - active goal
  - recent completed work
  - next work
- Perform only the minimum checks required by the workspace switch workflow:
  - project path
  - repo or file change status
  - key docs
  - run command
  - verify command
  - runtime or port when relevant
- Keep the matched project as the active context until another `/project` command is given.

### `/project use <alias> --summary`
- Return the high-signal state summary only.

### `/project use <alias> --check`
- Return only the minimum startup check results.

### `/project use <alias> --do "<task>"`
- Switch first.
- Restore context from the state file.
- Perform the task immediately.

### `/project status <alias>`
- Return the current state summary and key run or verify information.

### `/project update ...`
- Update the matched state file with completed work and next work.

### `/project close ...`
- Update the matched state file with completed work, verification result, next work, and relevant risks.

### `/project deploy <alias>`
- Follow the deploy method recorded in the registry or state file.

### `/project register <project_key> --path "<path>" --aliases "<a,b,c>"`
- Add a registry entry.
- Create a state file from the template before starting project work.

## Operating Rules

- Do not silently guess unregistered projects.
- Do not restart full analysis if the state file is recent and sufficient.
- Do not mix context between projects.
- Prefer action over re-analysis.
- After meaningful work, update the matched state file.

## Optional Helper

- If the workspace has `project_control/scripts/switch-project.ps1`, use it as a helper for quick status output in PowerShell environments.
- Do not treat the script as the source of truth when it conflicts with the registry or state file.

## References

- Read `references/command-spec.md` for command grammar and action meanings.
- Read `references/workflow-map.md` for the control-file reading order and switch procedure.
- Read `references/state-update-rules.md` when updating or closing project state files.
