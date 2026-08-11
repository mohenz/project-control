# project-control Skill 설치 매뉴얼

## 목적
- 저장소에 포함된 `project-control` skill 배포본을 로컬 skills 경로에 설치합니다.
- 다른 PC에서도 같은 방식으로 동일한 skill을 사용할 수 있게 합니다.
- 1~8절은 Codex(VSCode) 기준입니다. Claude Code는 설치 경로와 주의사항이 다르므로 **9절**을 보세요.

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

## 9. Claude Code 설치 (다른 PC 세팅 포함)

Claude Code는 Codex와 skill 경로도, 설치 구성도 다릅니다. 1~8절을 그대로 따르면 동작하지 않습니다.

### 9-1. Codex와 다른 점

| 항목 | Codex | Claude Code |
|---|---|---|
| skills 경로 | `%USERPROFILE%\.codex\skills` | `%USERPROFILE%\.claude\skills` 또는 `<프로젝트 루트>\.claude\skills` |
| 설치 파일 | `install-project-control-skill.cmd` | `install-project-control-skill-claude.cmd` |
| 설치 대상 | `SKILL.md`, `agents/`, `references/` | `SKILL.md`, `references/` (`agents/`는 Codex 전용이라 제외) |
| 인식 시점 | 새 채팅 또는 Reload Window | **새 세션** |

### 9-2. 설치 경로를 반드시 사용자 전역으로 할 것

Claude Code는 skill을 두 곳에서 찾습니다.

- **사용자 전역**: `%USERPROFILE%\.claude\skills\project-control` — 모든 세션에서 보입니다.
- **프로젝트**: `<프로젝트 루트>\.claude\skills\project-control` — 그 프로젝트 루트에서 연 세션에서만 보입니다.

`install-project-control-skill-claude.ps1`의 기본 설치 위치는 **워크스페이스 루트**(`D:\Workspace\.claude\skills`)입니다.
그런데 실제 작업은 `D:\Workspace\memorybook`처럼 하위 프로젝트를 열고 시작하는 경우가 많고,
그때 워크스페이스 루트는 프로젝트 루트가 아니므로 **skill이 목록에 잡히지 않습니다.**

따라서 다른 PC에서는 사용자 전역에 설치하는 것을 기본으로 하세요.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill-claude.ps1 `
  -Action Install -SkillsRoot "$HOME\.claude\skills"
```

워크스페이스 루트에서도 쓰고 싶으면 두 곳 모두에 설치하되, **내용을 항상 동일하게 유지**하세요.
프로젝트 레벨이 사용자 전역보다 우선하므로, 워크스페이스 사본이 구버전이면 거기서만 구버전이 동작합니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-project-control-skill-claude.ps1 -Action Install
```

### 9-3. 설치 후 확인

```powershell
Get-ChildItem "$HOME\.claude\skills\project-control" -Recurse | Select-Object FullName
```

아래 4개가 있어야 합니다. `agents/`는 Claude Code 설치본에 없는 것이 정상입니다.

```text
project-control/
  SKILL.md
  references/
    command-spec.md
    workflow-map.md
    state-update-rules.md
```

`SKILL.md` 첫 줄이 `---`로 시작하는지 확인하세요. 파일 앞에 UTF-8 BOM이 남아 있으면
frontmatter 파싱이 깨져 skill이 인식되지 않습니다. 저장소 배포본은 BOM 없이 관리합니다.

설치 후에는 **새 세션을 열어야** skill 목록에 나타납니다. 기존 세션에서는 보이지 않습니다.

### 9-4. 사본 3벌을 동일하게 유지할 것

같은 skill이 최대 세 곳에 존재할 수 있습니다.

1. 소스(배포본): `D:\Workspace\project_control\project-control`
2. 워크스페이스: `D:\Workspace\.claude\skills\project-control`
3. 사용자 전역: `%USERPROFILE%\.claude\skills\project-control`

**설치 스크립트는 대상 폴더를 통째로 지우고 소스로 덮어씁니다.** 설치본을 손으로 고쳐 두면
다음 설치 때 조용히 사라집니다. 실제로 과거에 설치본에만 존재하던 규칙
(비밀값·토큰을 상태 파일과 핸드오프에 기록 금지)이 소스에 없어, 스크립트 실행이
안전 규칙 손실로 이어질 뻔했습니다.

수정이 필요하면 **소스를 고치고 커밋한 뒤 재설치**하세요. 설치본을 직접 고치지 마세요.

동일성 확인:

```powershell
$src = "D:\Workspace\project_control\project-control"
$dst = "$HOME\.claude\skills\project-control"
Compare-Object (Get-Content "$src\SKILL.md") (Get-Content "$dst\SKILL.md")
Get-ChildItem "$src\references" | ForEach-Object {
    Compare-Object (Get-Content $_.FullName) (Get-Content "$dst\references\$($_.Name)")
}
```

출력이 없으면 동일합니다.

### 9-5. 다른 PC 세팅 순서

1. `git clone https://github.com/mohenz/project-control.git`
2. 워크스페이스 구조를 맞춥니다. skill은 `project_control`이 워크스페이스 최상위에 있다고 가정하며,
   `SKILL.md`가 `D:\Workspace` 경로를 명시하고 있으므로 경로가 다르면 `SKILL.md`의 경로 표기를
   그 PC 기준으로 수정하고 커밋해야 합니다.
3. 9-2의 사용자 전역 설치 명령을 실행합니다.
4. 9-3으로 파일과 frontmatter를 확인합니다.
5. 새 세션을 열고 `/project status memorybook`처럼 호출해 동작을 확인합니다.
6. `project_registry.md`의 각 프로젝트 `path`가 그 PC의 실제 경로와 맞는지 확인합니다.
   경로가 다르면 alias 해석은 되지만 이후 파일 접근이 전부 실패합니다.

### 9-6. 잘 안 될 때

1. 새 세션을 열었는지 확인합니다. 기존 세션에는 반영되지 않습니다.
2. `SKILL.md`가 `project-control` 폴더 루트에 있는지 확인합니다.
3. `SKILL.md` 첫 줄의 BOM 여부를 확인합니다.
4. frontmatter에 `name`과 `description`이 모두 있는지 확인합니다.
5. 하위 프로젝트에서 열었다면 사용자 전역에 설치돼 있는지 확인합니다(9-2).
6. `D:\Workspace\project_control\project_registry.md`가 존재하는지 확인합니다.

## 관련 문서
- `README.md`
- `vscode_skill_manual.md`
- `project-control/SKILL.md`






