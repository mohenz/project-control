# performance_lab Current State

## 기본 정보
- project_key: `performance_lab`
- last_updated: `2026-03-30`
- owner_request: 모든 프로젝트에서 공통으로 사용할 별도 성능 점검 프로젝트 생성
- current_status: 공통 성능 점검 전용 프로젝트 초기 생성

## 현재 목표
- 워크스페이스 공통 성능 점검과 기본 부하 테스트를 별도 프로젝트에서 재사용할 수 있게 준비한다.

## 진행 중 작업
- 현재 세션 기준 긴급 미완료 작업은 없음

## 최근 완료 작업
- 프로젝트 레지스트리 등록
- 공통 성능 점검 매뉴얼 생성
- Artillery 기반 기본 부하 테스트 구조 생성
- `npm install` 완료 및 `package-lock.json` 생성
- `npm.cmd run check:env` 실행 확인
- `npm.cmd run load:smoke` 실행 확인

## 다음 작업
- 다른 프로젝트별 타깃 예시 파일 추가 검토
- 인증/쿠키가 필요한 프로젝트 전용 시나리오 보강 가능
- 필요 시 `k6` 또는 고급 API 부하 테스트 도구 추가 검토

## 실행 / 검증
- run_command: `npm.cmd install`, `npm.cmd run check:env`
- verify_command: `npm.cmd run check:env`, `npm.cmd run load:smoke`
- port_or_runtime: `타깃 프로젝트별 상이`, 기본 예시 `http://localhost:3000`
- deploy_method: `배포 없음`, 공용 로컬 툴킷으로 사용

## 핵심 경로
- project_root: `D:\Workspace\performance_lab`
- key_docs:
  - `README.md`
  - `docs/성능점검_수행매뉴얼.md`
- key_files:
  - `package.json`
  - `scripts/check-env.ps1`
  - `scripts/run-artillery.js`
  - `targets/active-target.json`

## 리스크 / 주의사항
- `chrome-devtools` MCP는 Codex 세션 재시작 후 연결 안정성이 더 높을 수 있음
- Artillery는 기본 HTTP 부하 테스트만 포함하며 인증/API 쓰기 시나리오는 추가 보강 필요
- `k6`는 아직 시스템에 설치되어 있지 않음

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `README.md`, `docs/성능점검_수행매뉴얼.md`
- 확인이 필요한 미결사항: 프로젝트별 예시 타깃 파일 확장 여부, 추가 시나리오 필요 여부
