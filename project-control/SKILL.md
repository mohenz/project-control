---
name: project-control
description: Use when working in this multi-project workspace (D:\Workspace) that keeps a top-level project_control folder for alias-based project switching, state-file context recovery, handoff summaries, minimal startup checks, and /project command handling such as /project use, /project status, /project handoff, /project update, /project close, /project improve, /project fix, /project start, /project deploy, /project sync, /project mail, or /project register. This is the same operating structure used by the Codex agent in this workspace, so state files and handoffs are shared between Codex and Claude Code sessions.
---

# Project Control

Use this skill when the workspace has a top-level `project_control` folder and the user wants to switch projects, restore context from state files, or manage work through `/project ...` commands.

This workspace also runs a Codex agent against the exact same `D:\Workspace\project_control` files (registry, governance rules, state files). Treat the `states/*.md` files as shared, cross-agent memory: a handoff written by Codex should be readable and continuable here, and vice versa. Do not fork or duplicate the state files for Claude-only use.

Sessions often start inside a subproject (for example `D:\Workspace\memorybook`) rather than at the workspace root, so resolve `project_control` from `D:\Workspace` rather than from the current working directory.

## Find Control Files

- Find `project_control` at the workspace top level (`D:\Workspace\project_control`).
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

### `/project handoff <alias>`
- Resolve the alias in `project_registry.md`.
- Read the matched state file before reading the project codebase.
- Produce a concise handoff summary for the next session or agent (Codex or Claude):
  - current goal
  - done in the latest session
  - key findings
  - changed files
  - verification results
  - next action
  - risks, blockers, and do-not-do notes
- Include project repo status when available.
- Do not hide blockers. Mark them as `blocked_by`, `required_decision`, or `do_not_do` when useful.

### `/project update ...`
- Update the matched state file with completed work and next work.

### `/project close ...`
- Update the matched state file with completed work, verification result, next work, relevant risks, and the handoff section when the work changed execution context or left a next-session dependency.

### `/project deploy <alias>`
- Read `project_docs/DEPLOYMENT_PREVENTION_STANDARD.md`.
- Resolve the exact deploy target, command, checks, and invariants from the registry and matched state file.
- Confirm explicit user deployment approval.
- Run the recorded pre-deploy check before the deploy command.
- Run the recorded post-deploy check and update the matched state file.
- Do not repeat a failed deploy command without classifying and fixing the first error.

### `/project sync <alias> [--in|--out]`
- Trigger cloud synchronization for the matched project.
- Use `--in` to download latest data from cloud.
- Use `--out` to upload local changes to cloud.

### `/project mail <alias>`
- Resolve the alias in `project_registry.md`.
- Read the matched state file.
- Build a work summary from:
  - current goal
  - recent completed work
  - next work
  - risks or notes
- If available, include recent Git commit summary from the project path.
- Use the workspace mail helper script or equivalent local SMTP workflow.

### `/project register <project_key> --path "<path>" --aliases "<a,b,c>"`
- Add a registry entry.
- Create a state file from the template before starting project work.

## Operating Rules

- Do not silently guess unregistered projects.
- Do not restart full analysis if the state file is recent and sufficient.
- Do not mix context between projects.
- Prefer action over re-analysis.
- After meaningful work, update the matched state file so a following Codex session can pick it up without re-deriving context.
- Never write secrets, tokens, or credentials into state files or handoffs (matches `project_governance_rules.md` section 8-2).
- Before starting a local server, read `project_docs/development_systems.csv` and run `scripts/check-development-ports.ps1 -ProjectKey <project_key>` when available.
- If another project owns the requested port, do not stop it. Reassign the target project's port and update the runtime config, registry, state file, and development systems registry together.

## Optional Helper

- If the workspace has `project_control/scripts/switch-project.ps1`, use it as a helper for quick status output in PowerShell environments.
- Do not treat the script as the source of truth when it conflicts with the registry or state file.

## References

- Read `references/command-spec.md` for command grammar and action meanings.
- Read `references/workflow-map.md` for the control-file reading order and switch procedure.
- Read `references/state-update-rules.md` when updating or closing project state files.
- After locating the workspace-level `project_control` folder, read `project_control/project_docs/DEPLOYMENT_PREVENTION_STANDARD.md` before any deployment.






