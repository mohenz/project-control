# Project State

## 기본 정보
- project_key: `token_tracker`
- last_updated: `2026-05-20`
- owner_request: `Gemini와 Codex의 월단위 토큰 사용량과 남은 잔여량을 실시간으로 확인할 수 있는 로컬 웹 서버 및 프리미엄 대시보드 구축`
- current_status: `완료 및 서비스 중`

## 현재 목표
- 월간 사용량 누적 및 달러 요금 계산 상태를 실시간으로 모니터링한다.
- `codex.ps1`을 통한 AI 호출 시 토큰 수치가 실시간 반영되도록 보장한다.

## 진행 중 작업
- 없음 (완료됨)

## 최근 완료 작업
- `D:\workspace\token_tracker` 프로젝트 기본 구조 설계 및 생성
- `config.json` 설정 파일 작성 (gpt-5.5, gemini-3.5-flash 가격 및 예산 정의)
- SQLite 데이터베이스 (`token_usage.db`) 및 `database.py` 구현
- 파이썬 표준 라이브러리 기반 독자 웹 서버 `server.py` 구현 및 가동 완료 (포트 5000)
- 프리미엄 유리모피즘 다크 모드 대시보드 (`static/index.html`, `style.css`, `app.js`) 구현
- `codex.ps1` 스크립트 수정 및 비동기 API 로깅 연동 완료
- 차트 및 프로그레스 바 시각화를 위한 7일간의 샘플 데이터 시딩 완료 및 사용자 요청에 따른 데이터베이스 초기화(리셋) 완료

## 다음 작업
- Brian이 사용하는 개별 Gemini 파이썬/NodeJS 스크립트에 로깅 연동 지원
- 달러 환율 연동 및 원화(KRW) 표시 기능 추가 검토
- 월간 한도 초과 시 윈도우 알림(System Notification) 또는 경고 기능 추가

## 실행 / 검증
- run_command: `python server.py`
- verify_command: `python test_tracker.py`
- port_or_runtime: `port: 5000 / python server.py`
- deploy_method: `local Python server / static dashboard`

## 핵심 경로
- project_root: `D:\workspace\token_tracker`
- key_docs: `README.md`, `D:\workspace\scratch\bloommem.md`
- key_files: `server.py`, `database.py`, `config.json`, `static/index.html`, `static/style.css`, `static/app.js`

## 리스크 / 주의사항
- Windows 터미널 환경(CP949)에서 콘솔 출력 시 유니코드/이모지 오류가 발생하는 것을 방지하기 위해 서버 및 테스트 스크립트의 print문에서 특수 이모지를 제외하고 일반 텍스트로 보완했습니다.
- 백그라운드에서 `server.py`가 작동 중이어야 실시간 로깅 및 대시보드 접속이 가능합니다. (현재 백그라운드 프로세스로 안전하게 작동 중)

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `D:\workspace\token_tracker\server.py`, `D:\workspace\token_tracker\database.py`, `D:\workspace\project_control\states\token_tracker_current.md`
- 확인이 필요한 미결사항: `추가 Gemini 스크립트 로깅 연동 여부, 윈도우 시스템 알림 기능 추가 여부`
