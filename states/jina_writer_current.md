# Project State

## 기본 정보
- project_key: `jina_writer`
- last_updated: `2026-04-04`
- owner_request: `Gemini 2.5 Flash 기준으로 데스크톱 소설 집필 앱을 수정하고, 첫 작품으로 "진아와의 만남"을 이어서 쓸 수 있게 준비하다가 프로젝트 중단 결정`
- current_status: `사용자 요청으로 보류`

## 현재 목표
- 프로젝트 보류 상태를 명확히 기록한다.

## 진행 중 작업
- 없음

## 최근 완료 작업
- `project_control` 신규 프로젝트 등록 완료
- `Python + Tkinter` 기반 데스크톱 앱 구현 완료
- 작품/장면 편집, 작품 메모, 자동 저장, Gemini 2.5 Flash 연동, 샘플 작품 `진아와의 만남` 구성 완료
- Mancer 기본값과 UI 문구를 Gemini 기준으로 전환
- 최근 장면 흐름 4개를 함께 보내는 긴글 문맥 보조 추가
- Electron/React 잔여 코드의 기본값과 API 라우팅도 Gemini 기준으로 정리
- `python -m py_compile app.py desktop_app\storage.py desktop_app\gemini.py` 검증 완료
- `python app.py` 실행 시 초기화 오류 없이 GUI 프로세스 시작 확인
- Gemini 생성 실패 시 UI 스레드 예외 전달 경로를 보강하여 다운 대신 오류 팝업과 로그 기록으로 처리하도록 수정

## 다음 작업
- 프로젝트 재개 여부 판단
- 재개 시 실제 Gemini 키 기준 호출 확인
- 설치형 배포 방식 결정
- Markdown/EPUB 내보내기
- API 키 저장 보안 강화
- 장면 정렬/검색 등 편집 편의 기능 확장

## 실행 / 검증
- run_command: `python app.py`
- verify_command: `python -m py_compile app.py desktop_app\storage.py desktop_app\gemini.py`
- port_or_runtime: `Tkinter local desktop app`
- deploy_method: `local desktop app / installer TBD`

## 핵심 경로
- project_root: `D:\Workspace\jina_writer`
- key_docs: `README.md`, `docs/app_plan.md`, `docs/gemini_integration.md`
- key_files: `app.py`, `desktop_app/storage.py`, `desktop_app/gemini.py`, `run_app.ps1`

## 리스크 / 주의사항
- Windows 환경에서 Electron 런타임이 `require('electron')`을 API 객체 대신 실행 경로로 해석하는 이슈가 재현되었다.
- Gemini API 키는 현재 로컬 JSON 설정 파일에 저장된다. 추후 암호화 저장이 필요하다.
- 기존 Mancer 키(`mcr-...`)는 Gemini API에서 사용할 수 없으므로 사용자가 새 Gemini 키로 교체해야 한다.
- Gemini 요청 실패나 잘못된 설정값 입력 시 `AppData\Local\JinaWriter\logs\app-error.log`에 오류가 기록된다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `docs/app_plan.md`, `docs/gemini_integration.md`, `project_control/states/jina_writer_current.md`
- 확인이 필요한 미결사항: `프로젝트 재개 필요성, 실제 Gemini 키 기준 호출 확인, 설치형 배포 방식, 내보내기 기능, API 키 저장 보안`
