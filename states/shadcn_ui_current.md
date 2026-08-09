# shadcn/ui Project State

## 기본 정보
- project_key: shadcn_ui
- last_updated: 2026-08-06
- owner_request: 전체 컴포넌트를 로컬에 가져와 웹사이트 디자인 표준으로 활용 가능한지 검토
- current_status: upstream 전체 복제 및 구조 점검 완료

## 현재 목표
- 공식 저장소의 컴포넌트, Registry, CLI, 문서를 로컬 참조 자산으로 확보하고 디자인 표준 활용성을 평가

## 진행 중 작업
- 제품 공통 디자인 토큰·컴포넌트 정책을 별도 표준으로 정의할지 결정 대기

## 최근 완료 작업
- 워크스페이스 독립 저장소 및 프로젝트 레지스트리 등록
- `shadcn-ui/ui` 전체 Git 저장소를 `D:\Workspace\shadcn-ui`에 복제
- `main` HEAD `cb2bcd88d`, upstream 일치 및 clean worktree 확인
- Registry 1,506개 파일, 전체 5,681개 파일 확인
- UI 기반별 컴포넌트 파일 집계: Aria 58, Base UI 62, Radix 61
- 8개 스타일(Luma, Lyra, Maia, Mira, Nova, Rhea, Sera, Vega)과 5개 아이콘 계열 확인
- 한국어 UI 디자인 표준 권장 조합 도출: Radix UI + Vega + Lucide + Pretendard Variable/Noto Sans KR
- 기본 제공 폰트 정의가 모두 `latin` subset 중심임을 확인하여 한글 폰트 별도 적용 필요 기록
- Bloom 한국어 UI 표준을 `D:\Workspace\design\bloom_ui_design_standard.md`로 문서화
- 시작 점검에서 원격 `main`의 신규 6개 커밋을 clean fast-forward하여 HEAD `b1c580c6`으로 동기화

## 다음 작업
- 문서 기준의 공통 디자인 토큰과 Registry 또는 starter template 구현 여부 결정

## 실행 / 검증
- run_command: `pnpm v4:dev`
- verify_command: `pnpm check`
- port_or_runtime: `http://localhost:4000`
- deploy_method: 배포 없음, upstream 참조용 독립 저장소

## 핵심 경로
- project_root: `D:\Workspace\shadcn-ui`
- key_docs: `README.md`, `CONTRIBUTING.md`
- key_files: `apps/v4/registry`, `packages/shadcn`, `package.json`

## 리스크 / 주의사항
- upstream 원본은 자주 갱신되므로 제품별 디자인 토큰과 컴포넌트 정책은 별도로 버전 관리해야 함
- 루트 저장소가 아닌 `shadcn-ui` 독립 저장소에서만 Git 작업 수행

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `apps/v4/registry`, `packages/shadcn`
- 확인이 필요한 미결사항: 실제 프로젝트용 디자인 표준 패키지/Registry 분리 여부

## Handoff
- current_goal: 전체 컴포넌트 확보 및 디자인 표준 적합성 검토
- done_latest: 프로젝트 등록
- key_findings: 공식 저장소는 컴포넌트 코드 소유형 Registry 구조; 한국어 운영 UI 권장 조합은 Radix/Vega/Lucide이며 한글 폰트와 터치 크기 보정 필요
- changed_files: `D:\Workspace\design\bloom_ui_design_standard.md`, workspace/project-control 상태 파일
- verification: `git status --short --branch` = `main...origin/main`, HEAD `b1c580c6`; 파일 및 Registry 구조 집계 완료
- next_action: 실제 제품에 사용할 기반(Radix/Base UI/Aria), 스타일, 아이콘 계열을 고르고 공통 Registry/토큰 정책 설계
- risks_or_blockers: 없음
