# VS Code Continue + Gemma 4 사용 매뉴얼

## 목적
- VS Code에서 로컬 `gemma4` 모델과 대화하면서 코드 작업을 진행하는 방법을 정리합니다.
- 현재 환경에서 바로 재실행하고 문제를 점검할 수 있도록 최소 절차만 남깁니다.

## 현재 구성
- IDE: VS Code
- 확장: `Continue`
- 로컬 모델 서버: `Ollama`
- 채팅 모델: `gemma4:e2b-8k`
- 임베딩 모델: `nomic-embed-text`
- Continue 설정 이름: `진아`
- 페르소나 기준: `진아(Jina)` 고정

## 관련 경로
- Continue 설정: `C:\Users\mohen\.continue\config.yaml`
- Gemma4 Modelfile: `C:\Users\mohen\.continue\gemma4-e2b-8k.Modelfile`
- 시작 스크립트: `C:\Users\mohen\.continue\start-jina-vscode.ps1`
- Continue 페르소나 기준 문서: `D:\workspace\persona\jina\JINA_CONTINUE_PROFILE.md`
- 작업 폴더: `D:\workspace`

## 진아 프로필의 의미
- `진아`는 단순 모델 이름이 아니라, `진아(Jina)` 페르소나를 적용한 Continue 프로필입니다.
- 이 프로필을 선택하면 Continue는 로컬 `gemma4:e2b-8k`를 사용하면서 진아 말투와 작업 규칙을 기본값으로 사용합니다.
- 진아의 기준 문서는 `persona/jina/` 아래 문서들입니다.

## 빠른 시작
1. PowerShell을 엽니다.
2. 아래 명령을 실행합니다.

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.continue\start-jina-vscode.ps1"
```

3. VS Code가 `D:\workspace`로 열리면 `Ctrl+L`로 Continue 채팅을 엽니다.
4. 모델 또는 설정 선택 메뉴에서 `진아`를 선택합니다.
5. 바로 요청을 입력합니다.

## VS Code 안에서 사용하는 순서
1. 수정할 폴더나 파일을 엽니다.
2. `Ctrl+L`로 Continue 채팅을 엽니다.
3. `진아`가 선택되어 있는지 확인합니다.
4. 필요한 경우 현재 파일을 열어 둔 상태에서 요청합니다.
5. 코드 수정 제안이 나오면 적용 전 내용을 확인하고 반영합니다.

## 권장 요청 예시

### 코드 설명
```text
이 파일 구조를 한국어로 짧게 설명해줘.
```

### 버그 수정
```text
이 화면에서 저장 버튼이 동작하지 않는 원인을 찾고 수정해줘.
```

### 리팩터링
```text
이 컴포넌트를 함수 분리 중심으로 정리해줘. 동작은 바꾸지 마.
```

### 문서 작성
```text
이 프로젝트 실행 방법을 README에 추가해줘.
```

## 현재 설정의 특징
- `gemma4:e2b`를 그대로 쓰지 않고 `gemma4:e2b-8k`로 별도 생성했습니다.
- 이유는 현재 PC 메모리 여유를 고려해 컨텍스트를 `8192`로 제한하기 위해서입니다.
- Continue 설정에서도 같은 컨텍스트 길이를 사용하도록 맞춰 두었습니다.
- 추론 중간 과정이 채팅에 길게 노출되지 않도록 `reasoning: false`를 설정했습니다.

## 수동 실행 방법

### Ollama 모델 목록 확인
```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" list
```

### 모델이 메모리에 올라와 있는지 확인
```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" ps
```

### 모델 단독 테스트
```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" run gemma4:e2b-8k "한국어로 한 문장만 답하세요. 준비 완료?"
```

### VS Code 직접 열기
```powershell
& "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe" -n D:\workspace
```

## 잘 안 될 때 확인할 항목

### 1. Continue에서 `진아`가 보이지 않을 때
- `Ctrl+Shift+P`를 누른 뒤 `Developer: Reload Window`를 실행합니다.
- 그래도 안 보이면 `C:\Users\mohen\.continue\config.yaml`이 존재하는지 확인합니다.

### 2. 응답이 매우 느리거나 실패할 때
- 먼저 아래 명령으로 모델 상태를 확인합니다.

```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" ps
```

- 모델이 비어 있으면 시작 스크립트를 다시 실행합니다.
- 다른 무거운 앱이 메모리를 많이 쓰고 있으면 종료 후 다시 시도합니다.

### 3. Continue가 코드 문맥을 잘 못 잡을 때
- 작업 폴더가 `D:\workspace`인지 확인합니다.
- 파일을 실제로 열어 둔 상태에서 요청합니다.
- 요청에 파일명이나 기능명을 함께 적습니다.

### 4. Ollama 연결 오류가 날 때
- Ollama 앱이 실행 중인지 확인합니다.
- 아래 주소가 응답하는지 확인합니다.

```powershell
Invoke-RestMethod http://localhost:11434/api/tags
```

### 5. 모델을 다시 만들고 싶을 때
```powershell
& "$env:LOCALAPPDATA\Programs\Ollama\ollama.exe" create gemma4:e2b-8k -f "$env:USERPROFILE\.continue\gemma4-e2b-8k.Modelfile"
```

## 운영 팁
- 긴 작업을 시키기 전에 파일 하나 또는 폴더 하나로 범위를 좁혀서 요청하는 편이 안정적입니다.
- 먼저 분석, 다음 수정 순서로 나누면 품질이 더 좋습니다.
- 큰 리팩터링보다는 작은 단위 수정에서 더 안정적으로 동작합니다.
- 로컬 소형 모델이므로 현재 Codex 세션보다 품질과 추론력은 낮습니다.

## 권장 시작 패턴
1. 시작 스크립트 실행
2. VS Code에서 `Ctrl+L`
3. `진아` 선택 확인
4. 현재 파일을 연 상태에서 짧고 직접적인 요청 입력
5. 결과를 검토한 뒤 적용






