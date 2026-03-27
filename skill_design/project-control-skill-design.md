# project-control skill 설계서

## 1. 목적
- 여러 프로젝트를 병행하는 워크스페이스에서 프로젝트 전환 비용을 줄인다.
- `project_control` 폴더를 단일 기준으로 사용해 프로젝트 식별, 상태 복구, 최소 점검, 작업 종료 기록을 표준화한다.
- `/project ...` command 스타일 요청을 일관되게 해석한다.

## 2. skill 이름
- 최종 skill 이름: `project-control`

## 3. skill 역할 정의
- 프로젝트 전환 전용 운영 skill
- 특정 프로젝트의 코드 자체를 설명하는 skill이 아니라, 여러 프로젝트 사이에서 문맥을 복구하고 작업을 시작/종료하는 절차 skill

## 4. 트리거 조건
- 사용자가 `/project` command 스타일로 프로젝트 전환 또는 상태 확인을 요청할 때
- 사용자가 프로젝트 별칭만 말하며 문맥 전환 의도를 드러낼 때
- 여러 프로젝트가 같은 워크스페이스에 있고, 상태 파일 기반으로 최소 복구 후 작업해야 할 때
- 프로젝트 종료 후 상태 파일을 갱신해야 할 때

## 5. 비트리거 조건
- 단일 프로젝트만 존재하고 별도 전환 비용이 없는 경우
- 단순 코드 수정만 있고 프로젝트 전환이 필요 없는 경우
- 프로젝트 레지스트리와 상태 파일 체계가 없는 단발성 작업

## 6. 입력 규격

### 6-1. 기본 입력
- command: `/project <action> <alias> [options]`

### 6-2. 대표 action
- `use`
- `status`
- `update`
- `close`
- `improve`
- `fix`
- `start`
- `deploy`
- `register`

### 6-3. 옵션
- `--summary`
- `--check`
- `--do "<task>"`
- `--task "<task>"`
- `--done "<done>"`
- `--next "<next>"`
- `--verify "<verify>"`
- `--path "<path>"`
- `--aliases "<a,b,c>"`

## 7. 출력 규격
- 활성 프로젝트 식별 결과
- 상태 파일 요약
- 실행/검증 명령
- 최소 점검 결과
- 다음 작업
- 필요 시 상태 파일 갱신 결과

## 8. 외부 의존 리소스

이 skill은 아래 워크스페이스 제어 폴더를 사용한다.
- `{{WORKSPACE_ROOT}}\project_control\project_governance_rules.md`
- `{{WORKSPACE_ROOT}}\project_control\project_registry.md`
- `{{WORKSPACE_ROOT}}\project_control\project_switch_workflow.md`
- `{{WORKSPACE_ROOT}}\project_control\project_selection_prompt_list.md`
- `{{WORKSPACE_ROOT}}\project_control\states\*.md`

즉 이 skill은 완전 독립형이라기보다, `project_control` 운영체계를 사용하는 워크스페이스 전용 실행 skill이다.

## 9. 내부 처리 알고리즘

### 9-1. `/project use <alias>`
1. `project_registry.md`에서 alias를 project_key로 해석
2. 매칭된 state file 경로 확인
3. 상태 파일 로드
4. `project_switch_workflow.md` 기준 최소 확인 수행
5. 활성 프로젝트 컨텍스트 고정

### 9-2. `/project use <alias> --summary`
1. 상태 파일 로드
2. 현재 목표, 최근 완료 작업, 다음 작업 요약

### 9-3. `/project use <alias> --check`
1. 경로 확인
2. 저장소 상태 또는 파일 상태 확인
3. 핵심 문서 확인
4. 실행/검증/포트 확인

### 9-4. `/project use <alias> --do "<task>"`
1. `use` 수행
2. 상태 파일 기준 문맥 복구
3. 최소 확인
4. 작업 즉시 시작

### 9-5. `/project update ...`
1. 대상 프로젝트 상태 파일 로드
2. 완료 작업, 다음 작업, 검증 결과, 리스크 반영

### 9-6. `/project deploy <alias>`
1. 상태 파일 또는 registry의 deploy 방식 확인
2. 해당 프로젝트 배포 절차 수행
3. 필요 시 상태 파일 갱신

## 10. skill 구조 제안

```text
project-control/
  SKILL.md
  agents/
    openai.yaml
  references/
    command-spec.md
    workflow-map.md
    state-update-rules.md
```

## 11. 파일별 역할

### 11-1. `SKILL.md`
- skill 목적
- 트리거 조건
- `/project` command 해석 규칙
- `project_control` 폴더 탐색 우선순위
- 최소 점검 규칙

### 11-2. `references/command-spec.md`
- command grammar 상세
- action별 입력/출력 예시

### 11-3. `references/workflow-map.md`
- `project_governance_rules.md`
- `project_registry.md`
- `project_switch_workflow.md`
- `states/*.md`
- 이 4개를 어떤 순서로 읽는지 정리

### 11-4. `references/state-update-rules.md`
- 종료 기록 규칙
- 상태 파일 업데이트 항목
- 신규 프로젝트 등록 시 상태 파일 생성 규칙

## 12. portability 설계
- 절대 경로 `D:\Workspace`를 skill 본문에 고정하지 않는다.
- `WORKSPACE_ROOT` 또는 현재 작업 워크스페이스를 기준으로 `project_control`을 찾는다.
- `project_control`이 없으면 missing file을 명시하고 계속 추정하지 않는다.
- 실제 프로젝트 경로는 항상 `project_registry.md`에서 읽는다.

## 13. 권장 SKILL.md description 초안
- `Use when working in a multi-project workspace that uses a top-level project_control folder to manage project switching, alias resolution, state-file based context recovery, minimal startup checks, and command-style /project requests such as /project use, /project status, /project update, or /project deploy.`

## 14. 핵심 성공 기준
- project alias를 안정적으로 해석할 수 있어야 한다.
- 상태 파일 기반으로 전체 재분석 없이 문맥을 복구해야 한다.
- `/project ...` command를 일관되게 처리해야 한다.
- 작업 종료 후 상태 파일 갱신까지 자연스럽게 연결되어야 한다.

## 15. 구현 우선순위
1. `SKILL.md` 작성
2. command spec reference 분리
3. state update rules 정리
4. `agents/openai.yaml` 생성
5. 실제 skill 폴더 초기화 및 검증

## 16. 다음 단계
- 이 설계를 바탕으로 실제 `project-control` skill 폴더를 생성한다.
- 생성 위치는 사용자 선택이 필요하다.
- 권장 위치는 자동 발견 가능한 Codex skills 경로이다.
