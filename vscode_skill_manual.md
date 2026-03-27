# VSCode Skill 사용 매뉴얼

## 목적
- VSCode에서 `project-control` skill을 명시적으로 호출해 프로젝트 전환과 상태 복구를 표준화합니다.
- 프로젝트별 재분석 시간을 줄이고 `project_control` 기준으로 작업을 이어갑니다.

## 전제 조건
- skill 설치 경로: `C:\Users\mohen\.codex\skills\project-control`
- 워크스페이스 기준 폴더: `D:\Workspace\project_control`
- 프로젝트 등록 기준표: `D:\Workspace\project_control\project_registry.md`

## 기본 원칙
- VSCode에서는 가능하면 skill을 명시적으로 호출합니다.
- 권장 형식은 `$project-control` 뒤에 `/project ...` command를 붙이는 방식입니다.
- 프로젝트 식별은 자연어 추측이 아니라 `project_registry.md`의 `aliases`를 기준으로 합니다.

## VSCode에서 사용하는 순서
1. VSCode에서 작업할 워크스페이스 루트를 엽니다.
2. Codex 채팅 또는 에이전트 입력창을 엽니다.
3. 아래 형식으로 입력합니다.

```text
$project-control /project use n8n
```

```text
$project-control /project use "defect manage" --summary
```

```text
$project-control /project use auth_pro --do "로그인 UI 수정"
```

## 권장 Command 패턴

### 프로젝트 전환
```text
$project-control /project use n8n
```

```text
$project-control /project use "defect manage"
```

### 전환 후 상태 요약
```text
$project-control /project use n8n --summary
```

### 전환 후 최소 점검
```text
$project-control /project use "defect manage" --check
```

### 전환 후 바로 작업 시작
```text
$project-control /project use auth_pro --do "회원가입 화면 구현"
```

### 현재 상태 확인
```text
$project-control /project status n8n
```

### 상태 기록 갱신
```text
$project-control /project update "defect manage" --done "대시보드 튜닝 반영" --next "배포본 확인"
```

### 작업 종료 기록
```text
$project-control /project close n8n --done "수정 완료" --verify "manual check" --next "운영 확인"
```

### 배포
```text
$project-control /project deploy "defect manage"
```

## VSCode에서 기대되는 동작
- `project_control` 폴더를 먼저 기준점으로 삼습니다.
- `project_registry.md`에서 프로젝트 별칭과 경로를 해석합니다.
- 매칭된 `states/*.md` 파일을 먼저 읽고 문맥을 복구합니다.
- 필요한 최소 확인만 수행한 뒤 작업을 이어갑니다.

## plain command와 skill command의 차이

### 권장
```text
$project-control /project use n8n
```

### 비권장
```text
/project use n8n
```

- plain command만 써도 해석될 수는 있지만, VSCode에서는 skill을 명시적으로 호출하는 편이 더 안정적입니다.
- 운영 표준은 `$project-control /project ...` 형식입니다.

## 잘 안 될 때 확인할 항목
1. `C:\Users\mohen\.codex\skills\project-control\SKILL.md`가 존재하는지 확인합니다.
2. `D:\Workspace\project_control\project_registry.md`가 존재하는지 확인합니다.
3. 프로젝트가 레지스트리에 등록되어 있는지 확인합니다.
4. 입력을 `$project-control /project ...` 형식으로 다시 보냅니다.
5. 인식이 애매하면 새 채팅에서 다시 시도합니다.

## 운영 팁
- 프로젝트를 바꿀 때마다 먼저 `use` 또는 `status`를 호출합니다.
- 실제 구현 요청은 `--do` 또는 `/project improve`, `/project fix`, `/project start` 형식으로 바로 연결합니다.
- 작업이 끝나면 `/project update` 또는 `/project close`로 상태 파일을 갱신합니다.

## 관련 문서
- `project_selection_prompt_list.md`
- `project_switch_workflow.md`
- `portable_standard_prompt.md`
