# Project Control 메일 발송 워크플로우

## 목적
- `n8n` 없이도 현재 프로젝트 상태와 최근 작업 내용을 메일로 보낼 수 있게 합니다.
- 여러 PC에서 같은 방식으로 상태 파일 기반 작업 요약 메일을 발송할 수 있게 합니다.

## 방식
- `project_control/project_registry.md`에서 프로젝트 경로와 상태 파일을 찾습니다.
- 해당 프로젝트의 `states/*.md`를 읽어 현재 목표, 최근 완료 작업, 다음 작업, 리스크를 추출합니다.
- 프로젝트 경로가 Git 저장소라면 최근 커밋과 작업 트리 상태도 함께 붙입니다.
- SMTP 설정이 있으면 HTML 메일로 발송하고, 없으면 `--PreviewOnly`로 본문만 미리 볼 수 있습니다.

## 스크립트
- `scripts/send-work-summary.ps1`

## 필수 환경 변수
- `PROJECT_CONTROL_MAIL_TO`
- `PROJECT_CONTROL_MAIL_FROM`
- `PROJECT_CONTROL_SMTP_HOST`
- `PROJECT_CONTROL_SMTP_PORT`
- `PROJECT_CONTROL_SMTP_USER`
- `PROJECT_CONTROL_SMTP_PASSWORD`

## 선택 환경 변수
- `PROJECT_CONTROL_MAIL_CC`
- `PROJECT_CONTROL_SMTP_USE_SSL`

## 가장 안전한 시작 방법
```powershell
.\scripts\send-work-summary.ps1 -ProjectAlias bloom -PreviewOnly
```

## 실제 메일 발송 예시
```powershell
$env:PROJECT_CONTROL_MAIL_TO = 'me@example.com'
$env:PROJECT_CONTROL_MAIL_FROM = 'bot@example.com'
$env:PROJECT_CONTROL_SMTP_HOST = 'smtp.gmail.com'
$env:PROJECT_CONTROL_SMTP_PORT = '587'
$env:PROJECT_CONTROL_SMTP_USER = 'bot@example.com'
$env:PROJECT_CONTROL_SMTP_PASSWORD = 'app-password'
$env:PROJECT_CONTROL_SMTP_USE_SSL = 'true'

.\scripts\send-work-summary.ps1 -ProjectAlias bloom -ExtraNote '배포 후 멀티 PC 운영안 페이지 확인 필요'
```

## 미리보기 HTML 저장 예시
```powershell
.\scripts\send-work-summary.ps1 -ProjectAlias bloom -PreviewOnly -OutputPath .\tmp\bloom-work-summary.html
```

## 권장 운영 절차
1. `/project use <alias>` 또는 상태 파일 확인으로 현재 문맥 복구
2. 작업 완료 후 상태 파일의 `최근 완료 작업`, `다음 작업`, `리스크 / 주의사항` 갱신
3. `send-work-summary.ps1`를 실행해 메일 발송 또는 미리보기 확인
4. 다른 PC에서는 상태 파일과 메일 내용을 함께 참고해 즉시 이어서 작업

## 멀티 PC 운영 팁
- 메일은 기록 보조 수단으로 쓰고, 원본 상태는 항상 `states/*.md`에 남깁니다.
- 비밀 정보나 토큰은 메일 본문이나 상태 파일에 넣지 않습니다.
- SMTP 계정은 공용 메일봇 계정 또는 앱 비밀번호 방식으로 분리하는 편이 안전합니다.
