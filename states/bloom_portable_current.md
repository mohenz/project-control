# bloom_portable_env State

## Current Objective
PC 포맷 및 이주를 대비하여 Bloom 시스템과 필수 의존성을 자동으로 백업하고 복원하는 포터블 유틸리티 제공.

## Recent Changes
- `backup.ps1` 구현: `.gemini`, `.ssh`, `VS Code` 설정 백업 (env_data 폴더)
- `restore.ps1` 구현: Winget을 통한 필수 프로그램 설치 (Git, Python 3.12, Node.js, VS Code), npm 글로벌 툴 설치, 데이터 복원, `.venv` 생성
- `README.md` 및 `.gitignore` 작성
- 로컬 Git 저장소 초기화 및 첫 커밋 완료

## Next Steps
- 사용자의 피드백에 따라 백업 대상 폴더나 필수 설치 프로그램 목록 추가






