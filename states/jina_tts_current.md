# jina_tts Current State

## 기본 정보
- project_key: `jina_tts`
- last_updated: `2026-08-11`
- owner_request: 허가받은 동일 성우 음성 2개를 이용해 다른 PC에서도 실행 가능한 진아 로컬 복제 TTS 구성
- current_status: 독립 실행 환경, 참조 음성 전처리, XTTS v2 모델 설치, 실제 한국어 합성·스피커 재생 검증 완료

## 현재 목표
- `D:\Workspace\jina_tts`만으로 참조 음성 전처리, XTTS 음성 생성, 로컬 재생과 검증을 수행할 수 있게 한다.

## 진행 중 작업
- 없음

## 최근 완료 작업
- 허가받은 동일 성우 MP3 참조 음성 2개 존재 및 서로 다른 SHA-256 확인
- 기존 브리핑·타 PC 설치 문서와 Python XTTS 스크립트 검토
- Python 3.10 `.venv`, CPU PyTorch 2.5.1, Coqui TTS 0.27.5와 고정 의존성 설치
- MP3 2개를 각각 24kHz·모노·16-bit PCM WAV로 변환
- XTTS v2 모델 1.87GB 로컬 캐시 설치 및 참조 음성 2개 동시 사용 구현
- 4.78초 한국어 검증 WAV 생성과 PC 기본 출력 장치 재생 완료

## 다음 작업
- 사용자가 실제 브리핑 문장으로 음질을 평가하고 필요 시 참조 구간 선별 또는 합성 파라미터 조정

## 실행 / 검증
- run_command: `.\speak-jina.ps1 -Text "브리핑을 시작하겠습니다."`
- verify_command: `.\verify-jina-tts.ps1`
- port_or_runtime: `Python 3.10 local CPU/GPU, no port`
- deploy_method: `local only / no remote deploy`
- deploy_check_command: `N/A`
- deploy_post_check: `N/A`
- deploy_invariants: `참조·생성 음성과 브리핑 문장을 외부 TTS 서비스나 공개 Git에 전송하지 않음`
- deploy_abort_condition: `허가되지 않은 음성, 참조 음성 누락, 패키지·모델 검증 실패`
- latest_deployment: `N/A`

## 핵심 경로
- project_root: `D:\Workspace\jina_tts`
- key_docs: `README.md`, `JINA_TTS_BRIEFING.md`, `JINA_TTS_OTHER_PC_SETUP.md`
- key_files: `jina-cloned-tts.py`, `speak-jina.ps1`, `prepare-reference.ps1`, `verify-jina-tts.ps1`

## 리스크 / 주의사항
- 참조 음성과 생성 음성은 비공개 로컬 자산이며 Git 추적·외부 업로드 금지
- XTTS CPML 조건에 따라 개인용 브리핑 범위로 제한
- CPU 생성은 짧은 문장도 1분 이상 걸릴 수 있음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `verify-jina-tts.ps1`
- 확인이 필요한 미결사항: 사용자의 주관적 음색·발음 품질 평가

## Handoff
- current_goal: 독립 실행 가능한 진아 로컬 복제 TTS 완성
- done_latest: 독립 로컬 XTTS 실행 환경과 모델 설치, 두 참조 음성 전처리, 실제 합성·재생 완료
- key_findings: 참조 음성은 20.22초와 21.97초이며 두 파일 모두 24kHz 모노 PCM으로 정상 변환됨
- changed_files: `README.md`, `.gitignore`, `jina-cloned-tts.py`, `prepare-reference.py`, `setup-jina-tts.ps1`, `speak-jina.ps1`, `verify-jina-tts.ps1`, TTS 문서, 중앙 레지스트리·상태 파일
- verification: Python 문법, PyTorch/TTS import, 참조 WAV 규격·해시, XTTS CPU 합성, 4.78초 WAV 규격과 스피커 재생 통과
- next_action: `.\speak-jina.ps1 -Text "원하는 문장"`으로 실제 사용 및 품질 평가
- risks_or_blockers: CPU 합성 시간, 사용자 주관적 음질 평가는 별도 확인 필요
