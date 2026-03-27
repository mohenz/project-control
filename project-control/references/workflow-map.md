# Workflow Map

## Control file order
1. `project_governance_rules.md`
2. `project_registry.md`
3. `project_switch_workflow.md`
4. matched `states/*.md`

## Switch flow
1. Resolve alias in the registry.
2. Find the project path and state file.
3. Read the state file first.
4. Perform minimum checks only:
   - project path
   - repo or file status
   - key docs
   - run or verify commands
   - port or runtime if relevant
5. Start work in the matched project context.

## Missing or ambiguous cases
- Missing registry: stop and report the missing file.
- Missing state file: report it and fall back to minimum context building.
- Ambiguous alias: prefer registry exact match; otherwise ask briefly.
