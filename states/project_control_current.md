# Project Control Current State

## 기본 정보
- project_key: project_control
- last_updated: 2026-07-29
- current_status: MEMOry의 2026-07-29 UI·캘린더 개선과 매주 반복 일정 기능, 검증 및 Firebase Hosting 배포 결과를 중앙 상태 문서에 반영

## 현재 목표
- `D:\workspace` 내 등록 프로젝트의 상태 복구, 전환, 상태 저장 기준을 안정적으로 유지.
- 프로젝트별 `states/*.md`를 최신 운영 사실 중심으로 관리.

## 최근 완료 작업
- 2026-07-29: MEMOry UI·캘린더 개선 커밋 `daffd86`, 매주 반복 일정 기능 커밋 `dd0ab64`, 중앙 기록 동기화를 포함한 작업 기록 커밋 `f29da36`, 운영 번들 `assets/index-C3_I0vDV.js`, HTTP 200 및 전체 테스트 통과 결과를 `states/personal_memo_current.md`에 기록.
- 2026-07-24: MEMOry 자료실 스크롤 수정 커밋 `4e45bf6`, Firebase Hosting 버전 `59dab75d73371692`, 운영 스크롤 검증 결과를 `states/personal_memo_current.md`에 기록.
- 2026-07-24: `schedule_manager` 프로젝트를 레지스트리·아키텍처 맵에 등록하고 상태 파일 생성.
- 2026-07-24: 원격 선행 커밋 `a0bdc21`의 자료실 UI 배포 기록을 보존하면서 최신 MEMOry 상태와 통합.
- 2026-07-23: 모든 등록 프로젝트에 적용할 `project_docs/DEPLOYMENT_PREVENTION_STANDARD.md` 생성.
- 배포 전 Git·CLI·테스트·빌드·환경·산출물 검증, 배포 후 HTTP·자산 해시·운영 불변조건 검증을 공통 절차로 정의.
- 최초 실패 후 원인 분석 없는 동일 명령 재시도를 금지하고 실패 분류·전체 사전검증 재시작 규칙을 추가.
- `project_governance_rules.md`, `project_switch_workflow.md`, `project-control/SKILL.md`, command/workflow references, 상태 템플릿과 README에 글로벌 표준 연결.
- `personal_memo` 레지스트리·상태 파일을 `deploy:check`, `deploy:hosting` 기준으로 갱신.
- project-control skill 설치본을 `C:\Users\mohen\.codex\skills\project-control`에 갱신.
- 2026-07-04: 전체 프로젝트 아키텍처 참조 문서 `project_docs/PROJECT_ARCHITECTURE_MAP.md` 생성. `project_registry.md`, `README.md`, `project_switch_workflow.md`에서 해당 문서를 참조하도록 반영.
- 2026-07-03: `origin/main`에서 `archive_store` 등록 및 handoff 상태 업데이트 커밋 2건을 fast-forward로 반영. 현재 HEAD는 `0a865f9` (`Update archive_store handoff state`).
- 2026-06-21: Codex handoff 기능 일부를 project-control에 흡수. `/project handoff <alias>` 명령 규격, handoff workflow, state update rule, 상태 템플릿 `Handoff` 섹션, README 주요 명령, governance handoff 운영 규칙을 추가.
- 2026-06-13: `jian_soul` 프로젝트 신규 등록 (`project_registry.md` 반영) 및 상태 파일(`states/jian_soul_current.md`) 생성 완료.
- project-control 스킬과 workspace `AGENTS.md` 기준의 전환/상태 저장 절차 확인.
- `cinetube` 상태 파일의 오래된 미커밋 기록을 실제 Git 상태에 맞게 정정.
- `project_control` 자체 상태 파일을 생성해 중앙 관리 저장소도 상태 관리 대상에 포함.

## 다음 작업
- `project_docs/PROJECT_ARCHITECTURE_MAP.md`를 기준으로 레지스트리 등록 누락 상태 파일을 정식 등록할지 결정.
- `project_registry.md`의 중복 `cinetube` 항목을 정리할지 사용자 결정 필요.

## 실행 / 검증
- run_command: N/A
- verify_command: `git status --short --branch`
- latest_verification: 2026-07-29 `personalMemo`와 `project_control`이 각각 `origin/main`과 동기화된 상태에서 MEMOry 작업·배포 사실을 중앙 상태에 반영하고 `git diff --check` 및 변경 범위를 검증.
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

## Handoff
- current_goal: 모든 등록 프로젝트에 동일한 배포 실패 예방 절차 적용.
- done_latest: MEMOry의 2026-07-29 UI·캘린더 개선, 매주 반복 일정 기능, 전체 검증 및 최신 Hosting 배포 상태를 중앙 기록에 동기화.
- key_findings: 프로젝트별 배포 명령은 달라도 사전검증, 최초 실패 분류, 사후 자산 검증, 상태 기록 필드는 공통화할 수 있음.
- changed_files: `states/personal_memo_current.md`, `states/project_control_current.md`.
- verification: 두 저장소 원격 동기화, MEMOry 기능·배포 커밋/번들/테스트 결과 일치, `git diff --check` 확인.
- next_action: 필수 후속 작업 없음.
- risks_or_blockers: 없음.






