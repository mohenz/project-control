# Project Control Current State

## 기본 정보
- project_key: project_control
- last_updated: 2026-08-14
- current_status: 신규 PC로 워크스페이스를 이관하고 `memorybook`·`projectmgmt` 상태 파일을 갱신. projectmgmt는 참석자→비고 전환이 DB 미적용 상태로 중단되어 blocker를 기록함

## 현재 목표
- `D:\workspace` 내 등록 프로젝트의 상태 복구, 전환, 상태 저장 기준을 안정적으로 유지.
- 프로젝트별 `states/*.md`를 최신 운영 사실 중심으로 관리.

## 최근 완료 작업
- 2026-08-14: **신규 PC 워크스페이스 이관**. `workspace_installer`로 페르소나·에이전트 자산을 설치하고 `project_control`·`skills`·`memorybook`·`projectmgmt`를 클론. 두 프로젝트 상태 파일을 이번 세션 결과로 갱신(`memorybook`은 캘린더 보기 UI 교체 후 프로덕션 배포 완료, `projectmgmt`는 참석자→비고 전환이 DB 미적용으로 중단). 신규 PC 환경 제약을 상태 파일에 기록: PostgreSQL·Docker 미설치, GitHub 인증은 `gh`(2.97.0)로 신규 구성, git 전역 신원 미설정(저장소별로 설정함).
- 2026-08-05: `D:\workspace\memorybook`을 신규 프로젝트로 등록하고 레지스트리·아키텍처 맵·개발 시스템 원장·상태 파일을 동기화. 소스에는 Firebase와 3000번 포트 설정이 남아 있어 전환 전 기준선으로 기록함.
- 2026-08-01: `project_docs/development_systems.csv`와 `DEVELOPMENT_SYSTEM_OPERATIONS.md`를 생성해 개발 서버·API·DB 운영정보를 중앙화.
- 2026-08-01: `scripts/check-development-ports.ps1`을 추가하고 서버 시작 전 포트 Listener 확인을 governance·switch workflow·project-control skill 필수 절차로 연결.
- 2026-08-01: `epms`를 레지스트리·아키텍처 맵에 등록하고 `states/epms_current.md`를 생성·완료 상태로 갱신.
- 2026-08-01: personalMemo의 실제 고정 포트 `3000`을 중앙 문서에 정정하고 EPMS 기본 포트를 `3010`으로 분리.
- 2026-08-01 시작 동기화: `defect_manage`, `defect_manage2`, `bloom`은 원격 최신. 원격 새 커밋으로 fast-forward된 프로젝트는 없음. `trinity_room`은 원격 저장소 미존재 오류, 일부 폴더는 독립 Git/upstream 부재 또는 기존 로컬 변경으로 자동 갱신하지 않음.
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
- latest_verification: 2026-08-05 `memorybook` 경로와 React/Vite 소스 복제 상태를 확인하고 중앙 등록 문서 정합성을 점검.
- deploy_method: `git push origin main`

## 핵심 경로
- project_root: `D:\workspace\project_control`
- registry: `project_registry.md`
- governance: `project_governance_rules.md`
- workflow: `project_switch_workflow.md`
- development_systems: `project_docs/development_systems.csv`, `project_docs/DEVELOPMENT_SYSTEM_OPERATIONS.md`
- states: `states/*.md`

## 리스크 / 주의사항
- `project_registry.md`에 `cinetube` 항목이 중복 등록되어 있음. 둘 다 `states/cinetube_current.md`를 가리키지만 run/verify/deploy 설명이 다르므로 추후 정리 필요.
- startup routine에서는 자동 fast-forward 대상만 갱신하고, dirty/divergent/no-upstream 상태는 강제 처리하지 않는다.
- 3000번 포트는 personalMemo 우선 예약이며 `defect_manage`, `defect_manage2`, `schedule_manager`는 동시 실행 전 포트 재지정이 필요하다.
- `memorybook`도 복제된 3000번 설정을 상속했으므로 동시 실행 전 전용 포트 재지정이 필요하다.
- handoff에는 비밀값, 토큰, 인증정보, 개인키를 기록하지 않는다.

## Handoff
- current_goal: 개발 시스템 운영정보와 포트 충돌 방지 절차를 중앙 관리.
- done_latest: 운영 원장·가이드·포트 점검 스크립트 생성, 관련 governance/workflow/skill 연결.
- key_findings: 3000번은 personalMemo 우선 예약이며 기존 3개 프로젝트가 재지정 필요 상태.
- changed_files: `project_docs/development_systems.csv`, `project_docs/DEVELOPMENT_SYSTEM_OPERATIONS.md`, `scripts/check-development-ports.ps1`, governance/workflow/skill/registry/README/state 문서.
- verification: 전체/EPMS 포트 원장 파싱 성공, EPMS 3010·CineTube 8080 Listener 확인, `git diff --check` 통과.
- next_action: 필수 후속 작업 없음.
- risks_or_blockers: 없음.






