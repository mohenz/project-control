# project-control Skill 설치 매뉴얼

## 목적
- 저장소에 포함된 `project-control` skill 배포본을 로컬 Codex skills 경로에 설치합니다.
- 다른 PC에서도 같은 방식으로 동일한 skill을 사용할 수 있게 합니다.

## 배포본 위치
- 저장소 내 skill 패키지: `D:\Workspace\project_control\project-control`

## 설치 대상 경로
- `CODEX_HOME`이 설정된 경우: `CODEX_HOME\skills\project-control`
- `CODEX_HOME`이 없으면 기본 경로: `%USERPROFILE%\.codex\skills\project-control`

## 1. 수동 설치
1. 이 저장소를 로컬 PC에 받습니다.
2. 저장소 안의 `project-control` 폴더를 로컬 Codex skills 경로로 복사합니다.
3. 최종 경로에 아래 파일이 있는지 확인합니다.

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

## 2. PowerShell 설치 예시

```powershell
$src = "D:\Workspace\project_control\project-control"
$skillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\\skills" }
$dst = Join-Path $skillsRoot "project-control"

New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
Copy-Item -Recurse -Force $src $dst
```

## 3. 설치 후 확인
아래 경로가 실제로 존재해야 합니다.

```powershell
$skillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\\skills" }
Get-ChildItem (Join-Path $skillsRoot "project-control") -Recurse
```

필수 확인 파일:
- `SKILL.md`
- `agents/openai.yaml`
- `references/command-spec.md`
- `references/workflow-map.md`
- `references/state-update-rules.md`

## 4. VSCode에서 사용 확인
설치 후 VSCode의 Codex 채팅에서 아래처럼 호출합니다.

```text
$project-control /project use n8n
```

```text
$project-control /project status "defect manage"
```

## 5. 업데이트 방법
저장소의 `project-control` 폴더 최신본으로 다시 덮어씁니다.

```powershell
$src = "D:\Workspace\project_control\project-control"
$skillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\\skills" }
$dst = Join-Path $skillsRoot "project-control"

if (Test-Path $dst) {
    Remove-Item -Recurse -Force $dst
}

Copy-Item -Recurse -Force $src $dst
```

## 6. 제거 방법

```powershell
$skillsRoot = if ($env:CODEX_HOME) { Join-Path $env:CODEX_HOME "skills" } else { Join-Path $HOME ".codex\\skills" }
$dst = Join-Path $skillsRoot "project-control"

if (Test-Path $dst) {
    Remove-Item -Recurse -Force $dst
}
```

## 7. 잘 안 될 때 확인할 항목
1. skill 폴더 이름이 정확히 `project-control`인지 확인합니다.
2. 설치 위치가 `skills` 바로 아래인지 확인합니다.
3. `SKILL.md`가 폴더 루트에 있는지 확인합니다.
4. VSCode에서 새 채팅을 열고 다시 호출합니다.
5. 워크스페이스 안에 `project_control` 폴더와 `project_registry.md`가 있는지 확인합니다.

## 관련 문서
- `README.md`
- `vscode_skill_manual.md`
- `project-control/SKILL.md`
