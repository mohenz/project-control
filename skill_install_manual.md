# project-control Skill 설치 매뉴얼

## 목적
- 저장소에 포함된 `project-control` skill 배포본을 로컬 Codex skills 경로에 설치합니다.
- 다른 PC에서도 같은 방식으로 동일한 skill을 사용할 수 있게 합니다.

## 배포본 위치
- 저장소 내 skill 패키지: `D:\Workspace\project_control\project-control`
- 원클릭 설치 파일: `D:\Workspace\project_control\install-project-control-skill.cmd`
- 설치 스크립트: `D:\Workspace\project_control\scripts\install-project-control-skill.ps1`

## 설치 대상 경로
- `CODEX_HOME`이 설정된 경우: `CODEX_HOME\skills\project-control`
- `CODEX_HOME`이 없으면 기본 경로: `%USERPROFILE%\.codex\skills\project-control`

## 1. 원클릭 설치
Windows에서는 아래 파일을 더블클릭하면 설치할 수 있습니다.

```text
install-project-control-skill.cmd
```

내부적으로 아래 스크립트를 실행합니다.

```text
scripts/install-project-control-skill.ps1
```

기본 동작:
- `CODEX_HOME`이 있으면 `CODEX_HOME\skills\project-control`에 설치
- 없으면 `%USERPROFILE%\.codex\skills\project-control`에 설치
- 설치 시 `SKILL.md`, `agents`, `references`만 교체
- `.cmd`와 설치 스크립트 출력 메시지는 Windows 콘솔 코드페이지 차이로 인한 한글 깨짐을 피하기 위해 ASCII로 유지

## 2. 수동 설치
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

## 3. PowerShell 설치 예시

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill.ps1 -Action Install
```

특정 skills 경로를 강제로 지정하려면:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill.ps1 -Action Install -SkillsRoot "C:\Users\mohen\.codex\skills"
```

## 4. 설치 후 확인
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

스크립트로 검증하려면:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill.ps1 -Action Verify
```

## 4-1. VSCode 반영 순서
- 설치 직후 현재 열려 있는 Codex 채팅에서는 새 skill이 바로 보이지 않을 수 있습니다.
- 먼저 VSCode에서 새 Codex 채팅을 열고 다시 호출합니다.
- 그래도 인식되지 않으면 `Developer: Reload Window`를 실행합니다.
- 그다음에도 인식되지 않으면 VSCode를 재실행합니다.

## 5. VSCode에서 사용 확인
설치 후 가능하면 새 Codex 채팅에서 아래처럼 호출합니다.

```text
$project-control /project use n8n
```

```text
$project-control /project status "defect manage"
```

## 6. 업데이트 방법
원클릭 파일을 다시 실행하거나, 아래처럼 업데이트할 수 있습니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill.ps1 -Action Update
```

## 7. 제거 방법

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill.ps1 -Action Remove
```

## 8. 잘 안 될 때 확인할 항목
1. skill 폴더 이름이 정확히 `project-control`인지 확인합니다.
2. 설치 위치가 `skills` 바로 아래인지 확인합니다.
3. `SKILL.md`가 폴더 루트에 있는지 확인합니다.
4. VSCode에서 새 채팅을 열고 다시 호출합니다.
5. 새 채팅에서도 안 되면 `Developer: Reload Window`를 실행합니다.
6. 그래도 안 되면 VSCode를 재실행합니다.
7. 워크스페이스 안에 `project_control` 폴더와 `project_registry.md`가 있는지 확인합니다.
8. `install-project-control-skill.cmd`를 일반 권한으로 다시 실행해 봅니다.

## 관련 문서
- `README.md`
- `vscode_skill_manual.md`
- `project-control/SKILL.md`
