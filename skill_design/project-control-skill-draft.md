---
name: project-control
description: Use when working in a multi-project workspace that uses a top-level project_control folder to manage project switching, alias resolution, state-file based context recovery, minimal startup checks, and command-style /project requests such as /project use, /project status, /project update, /project fix, /project improve, or /project deploy.
---

# project-control

## Core behavior
- Resolve project aliases from `project_registry.md` first.
- Read the matched state file before analyzing the project codebase.
- Perform only the minimum checks required by `project_switch_workflow.md`.
- Keep the selected project as the active context until another `/project` command is given.
- Update the state file after meaningful work.

## Required control files
- Find `project_control` at the workspace top level.
- Use these files in priority order:
  - `project_governance_rules.md`
  - `project_registry.md`
  - `project_switch_workflow.md`
  - matched file in `states/`

## Command handling

### `/project use <alias>`
- Resolve alias from the registry.
- Read the matched state file.
- Summarize current goal, recent completed work, and next work.
- Check path, repo or file status, key docs, run command, verify command, and runtime or port if relevant.
- Set the matched project as the active work context.

### `/project use <alias> --summary`
- Return only the high-signal state summary.

### `/project use <alias> --check`
- Return the minimum startup check results only.

### `/project use <alias> --do "<task>"`
- Switch first.
- Restore context from the state file.
- Start the task immediately.

### `/project status <alias>`
- Return the current state summary and key run or verify information.

### `/project update ...`
- Update the matched state file with completed work and next work.

### `/project close ...`
- Update the matched state file with completed work, verification result, next work, and risks if present.

### `/project deploy <alias>`
- Follow the deploy method recorded in the registry or state file.

### `/project register <project_key> --path "<path>" --aliases "<a,b,c>"`
- Add a registry entry.
- Create a state file from the template.

## Operating rules
- Do not silently guess unregistered projects.
- Do not restart full analysis if the state file is recent and sufficient.
- Do not mix contexts from different projects.
- Be concise and operational.

## References to load when needed
- See `references/command-spec.md` for command grammar and variants.
- See `references/workflow-map.md` for file reading order and switch flow.
- See `references/state-update-rules.md` for state file update conventions.
