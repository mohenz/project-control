# rick_deckard Current State

## 기본 정보
- project_key: `rick_deckard`
- last_updated: `2026-06-01`
- owner_request: 릭 데커드 PMO 에이전트 페르소나 구성 및 모든 세션 자동 적용
- current_status: 구성 완료 / 운영 중

## 현재 목표
- 모든 OpenCode 세션에서 릭 데커드(Rick Deckard) 페르소나가 자동으로 로드되어 일관된 PMO 에이전트로 동작한다.

## 완료된 작업
- `D:\workspace\AGENTS.md` 생성 — OpenCode 세션 시작 시 자동으로 릭 데커드 페르소나 로드
  - 페르소나 고정 (이탈 방지 장치 포함)
  - 세션 시작 응답 형식 고정 (`[Rick Deckard | PMO] 접속 확인.`)
  - 핵심 파일 참조 목록 내장 (Persona.md, rule.md, status.json, memory/)
  - 즉시 실행 커맨드 정의 (hi rick!, 기억해줘, C레벨 보고서 등)
- 기존 `Rick Persona.md`, `rule.md` 검토 및 내용 반영

## 핵심 경로
- project_root: `D:\workspace\Rick`
- agents_file: `D:\workspace\AGENTS.md` ← 세션 자동 로드 핵심 파일
- key_docs:
  - `D:\workspace\Rick\Rick Persona.md` — 전체 페르소나 정의
  - `D:\workspace\Rick\rule.md` — 운영 규칙
  - `D:\workspace\Rick\system\status.json` — 현재 상태 (Green/Yellow/Red)
  - `D:\workspace\Rick\memory\` — 세션 기억 파일 저장소

## 즉시 실행 커맨드 요약
| 입력 | 동작 |
|------|------|
| `hi rick!` | Persona.md + rule.md 재확인 후 상태 보고 |
| `기억해줘` | 현재 세션 내용을 `memory/memory_YYYYMMDD.md`로 저장 |
| `C레벨 보고서 작성해줘` | Executive Summary + Decision Required 형식 출력 |
| `이 이슈 에스컬레이션 필요할까?` | Escalation Level 판단 및 책임 소재 명확화 |
| `감사 리스크 분석해줘` | 산출물 증적 현황 및 감사 취약점 분석 |
| `독한 질문 모드` | 실명 기반 지연 책임 추적, 허수 진행률 발라내기 |

## 다음 작업 (선택)
- 페르소나 응답 품질 모니터링 후 Persona.md 추가 고도화 검토
- memory/ 폴더 내 세션 기억 파일 누적 관리

## 리스크 / 주의사항
- `AGENTS.md`는 workspace 루트에 위치해야 OpenCode가 자동으로 읽음. 경로 이동 금지.
- Persona.md 수정 시 AGENTS.md 내용과 일관성 유지 필요.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `D:\workspace\AGENTS.md`, `D:\workspace\Rick\system\status.json`
- 페르소나 이탈 발생 시: `hi rick!` 호출로 즉시 재동기화
