# Command Spec

## Grammar

```text
/project <action> <project_alias> [options]
```

## Actions
- `use`
- `status`
- `handoff`
- `update`
- `close`
- `improve`
- `fix`
- `start`
- `deploy`
- `sync`
- `mail`
- `register`

## Common options
- `--summary`
- `--check`
- `--do "<task>"`
- `--task "<task>"`
- `--done "<done>"`
- `--next "<next>"`
- `--verify "<verify>"`
- `--path "<path>"`
- `--aliases "<a,b,c>"`
- `--to "<mail1,mail2>"`
- `--cc "<mail1,mail2>"`
- `--subject "<subject>"`
- `--preview`

## Meaning

### `use`
- Switch active context to the matched project.

### `status`
- Show state summary and key run or verify info.

### `handoff`
- Build a next-session handoff for the matched project.
- Source from the registry, matched state file, project repo status, and recent work notes.
- Include:
  - current goal
  - done in latest session
  - key findings
  - changed files
  - verification
  - next action
  - risks or blockers

### `update`
- Update state file with progress notes.

### `close`
- Update state file with completion, verification, and next work.

### `improve`
- Switch to the project and execute a feature improvement task.

### `fix`
- Switch to the project and execute a bug fix task.

### `start`
- Switch to the project and start a new task.

### `deploy`
- Read the global deployment prevention standard.
- Confirm explicit deployment approval.
- Run the registered pre-deploy check, deploy method, and post-deploy check in order.
- Record commit, release, asset, and verification results.
- Stop after the first failure; classify and fix it before restarting from preflight.

### `sync`
- Synchronize project data with cloud storage (e.g., GCS).
- Options: `--in` (download), `--out` (upload).

### `mail`
- Create or send a work summary mail for the matched project.

### `register`
- Add a new project entry and create a state file.






