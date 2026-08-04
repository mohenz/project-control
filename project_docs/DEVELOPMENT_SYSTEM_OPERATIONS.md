# 개발 시스템 운영정보

## 목적
- 로컬 개발 서버·API·DB의 포트, 실행 명령, 접속 URL을 중앙 관리한다.
- 서버 실행 전에 충돌을 확인해 다른 프로젝트 프로세스를 덮어쓰거나 종료하는 사고를 방지한다.

## 기준 파일
- 기계 판독 원장: `project_docs/development_systems.csv`
- 프로젝트 식별·경로: `project_registry.md`
- 프로젝트별 세부 상태: `states/*_current.md`
- 현재 포트 점검: `scripts/check-development-ports.ps1`

## 현재 포트 정책

| 포트 | 우선 프로젝트 | 서비스 | 정책 |
|---:|---|---|---|
| 3000 | `personal_memo` | Web | personalMemo 전용. 다른 프로젝트는 동시 실행 전 재지정 |
| 3010 | `epms` | Web | EPMS 전용 |
| 5000 | `token_tracker` | Web | 전용 |
| 5174 | `archive_store` | Web | 전용 |
| 5175 | `archive_store` | API | 전용 |
| 8080 | `cinetube` | Web | 전용 |
| 8787 | `bloom` | Translation API | 전용 |
| 54323 | `defect_manage2` | PostgreSQL | 전용 |
| 54324 | `archive_store` | PostgreSQL | 전용 |
| 54325 | `epms` | PostgreSQL 16 | 전용 |

`defect_manage`, `defect_manage2` Web, `schedule_manager`의 기존 3000번 설정은 `reassign-required`로 관리한다. personalMemo와 동시에 실행할 때는 먼저 새 포트를 확정하고 해당 프로젝트 설정·레지스트리·상태 파일·CSV를 함께 갱신한다.

## 서버 실행 절차
1. `scripts/check-development-ports.ps1 -ProjectKey <project_key>`로 예약 포트와 현재 Listener를 확인한다.
2. 포트가 다른 프로젝트에 의해 사용 중이면 해당 PID의 CommandLine과 프로젝트 경로를 확인한다.
3. 같은 프로젝트의 꼬인 프로세스임이 확인된 경우에만 해당 프로세스를 종료한다.
4. 다른 프로젝트 프로세스이면 종료하지 않고 대상 프로젝트 포트를 변경한다.
5. 실행 후 Health URL의 HTTP 200 또는 TCP Listener를 확인한다.

## 정보 변경 규칙
- 포트나 실행 명령 변경 시 다음 네 곳을 같은 작업에서 갱신한다.
  - `project_docs/development_systems.csv`
  - `project_registry.md`
  - `states/<project>_current.md`
  - 프로젝트 실제 실행 설정(`package.json`, 스크립트 등)
- PID와 일시적인 실행 여부는 영구 원장에 기록하지 않는다.
- 비밀값, 토큰, DB 비밀번호는 기록하지 않는다.

## 확인 명령
```powershell
# 전체 개발 시스템
.\scripts\check-development-ports.ps1

# 특정 프로젝트
.\scripts\check-development-ports.ps1 -ProjectKey epms
```
