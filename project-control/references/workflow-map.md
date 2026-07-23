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

## Handoff flow
1. Resolve alias in the registry.
2. Read the matched state file.
3. Check project path and repo status when available.
4. Extract the latest operational facts:
   - current goal
   - latest completed work
   - current blockers
   - verification status
   - next action
5. Return a compact handoff summary.
6. If closing a meaningful work session, update the state file handoff section.

## Deploy flow
1. Read `project_docs/DEPLOYMENT_PREVENTION_STANDARD.md`.
2. Resolve deploy target and invariants from the registry and state file.
3. Confirm explicit user approval.
4. Refresh remote state and verify a clean, synchronized deploy branch.
5. Run `deploy_check_command`.
6. Run `deploy_method`.
7. Run `deploy_post_check`.
8. Record commit, release, asset hash, and verification in the state file.
9. On failure, classify the first error and restart from preflight only after correction.

## Missing or ambiguous cases
- Missing registry: stop and report the missing file.
- Missing state file: report it and fall back to minimum context building.
- Ambiguous alias: prefer registry exact match; otherwise ask briefly.






