# Command Spec

## Grammar

```text
/project <action> <project_alias> [options]
```

## Actions
- `use`
- `status`
- `update`
- `close`
- `improve`
- `fix`
- `start`
- `deploy`
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

## Meaning

### `use`
- Switch active context to the matched project.

### `status`
- Show state summary and key run or verify info.

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
- Use the registered deploy method.

### `register`
- Add a new project entry and create a state file.
