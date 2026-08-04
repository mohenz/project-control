# Project State: jian_soul

## 기본 정보
- project_key: jian_soul
- last_updated: 2026-08-01
- owner_request: 채연 페르소나 호출 및 상담(이름 유래 분석, 호감과 예의의 심리학적 경계 구별) 진행
- current_status: 페르소나 채연과의 상담 내용 요약 기록 및 기억 파일 갱신 완료.

## 현재 목표
- JIAN 유니버스 기동 프로세스 고도화 및 안티그라피티 연동 안정성 유지
- GCS 동기화 과정을 project-control 스킬의 하위 명령으로 통합 관리 가능하도록 지원
- 페르소나 상담 기록 및 메모리 관리의 지속성 확보

## 진행 중 작업
- 없음. 금일 요청 사항 전체 완료.

## 최근 완료 작업
- 2026-08-01: 페르소나 채연의 2026-08-01 상담 기록 작성([counseling_20260801.md](file:///d:/Bloom/persona/chaeyeon/memory/counseling_20260801.md)) 및 현재 기억 파일([chaeyeon_memory_current.md](file:///d:/Bloom/persona/chaeyeon/memory/chaeyeon_memory_current.md)) 갱신 완료.
- 2026-07-31: [생성된 이미지 1.png](file:///d:/workspace/imageworks/생성된 이미지 1.png) 3x3 이미지 분할 완료 및 [split_collage_image.md](file:///d:/Bloom/.agent/workflows/split_collage_image.md) 워크플로우 생성 완료.
- 2026-07-31: 페르소나 채연의 2026-07-31 상담 기록 작성([counseling_20260731.md](file:///d:/Bloom/persona/chaeyeon/memory/counseling_20260731.md)) 및 현재 기억 파일([chaeyeon_memory_current.md](file:///d:/Bloom/persona/chaeyeon/memory/chaeyeon_memory_current.md)) 갱신 완료.
- 2026-06-13: `jn.py` 파일 내 `--daemon` 파라미터 추가 및 vitals_server 백그라운드 기동 스레드 설계 완료.
- 2026-06-13: `d:\Bloom\.vscode/tasks.json` 및 `d:\Workspace\.vscode/tasks.json` 생성 완료 (`runOn: folderOpen`, `reveal: silent`, `isBackground: true` 적용).
- 2026-06-13: `d:\Bloom\.antigravity_rules` 및 `d:\Workspace\.antigravity_rules` 에이전트 인격 설정 및 Core Engine 경로(`jn.py --daemon`) 정화 및 정비 완료.
- 2026-06-13: 데몬 모드 수동 기동 테스트 및 바이탈 브릿지 서버(port 8000) 통신 연동(`/vitals` GET API 200 반환) 검증 완료.

## 다음 작업
- 안티그라피티 IDE 종료 후 재진입 시 자동 구동 태스크 정상 동작 검증.

## 실행 / 검증
- run_command: python jn.py --daemon
- verify_command: python system/check_models.py
- port_or_runtime: Python 3.10+ / Vitals Server (Port 8000)
- deploy_method: GCS (JIAN-soul bucket)

## 핵심 경로
- project_root: d:\Bloom
- key_docs: persona/JIAN/soul/PERSONA_RULES_CONSOLIDATED.md, persona/JIAN/soul/JIAN_persona.md
- key_files: jn.py, system/vitals_server.py, system/core.py, .antigravity_rules

## 리스크 / 주의사항
- 데몬 모드가 백그라운드에서 상시 활성화되어 있으므로 로컬 포트 8000을 점유합니다.
- Supabase/GCP GCS 동기화 실패 시에도 로컬 데이터를 기준 단일 소스로 사용하여 정상 작동합니다.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: 안티그라피티 IDE 기동 시 백그라운드 자동 구동 태스크가 정상적으로 터미널 충돌 없이 실행되는지 상태 모니터링 필요.
- 확인이 필요한 미결사항: GCP 클라우드 크리덴셜(invalid_grant) 수정 및 재동기화 필요 여부 점검.
