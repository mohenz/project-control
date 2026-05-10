# Project State

## 기본 정보
- project_key: memo_app_design
- last_updated: 2026-04-28
- owner_request: 개인용 캐주얼 메모 웹앱의 요구사항 분석 및 설계 작업을 프로젝트로 등록
- current_status: 요구사항/시스템/DB/디자인 검토 완료, C안 기반 최종 UI/UX 명세 및 구현 착수 전 실행 계획 수립 단계

## 현재 목표
- PC와 모바일 브라우저에서 사용 가능한 개인용 메모 앱의 MVP 요구사항과 설계를 구체화한다.
- 사용자 기능과 관리자 기능을 분리하고, 메모 CRUD, 카테고리 CRUD, 공유 등록 기능을 포함한다.
- 화이트/블랙 톤의 심플한 UI 방향을 유지한다.

## 진행 중 작업
- 시스템 설계 산출물 관리
- 다음 상세 설계 산출물 준비

## 최근 완료 작업
- `D:\Workspace\memo_app_design\basic_requirements_and_design.md` 작성
- `D:\Workspace\work\memo_app_design`에서 `D:\Workspace\memo_app_design`로 프로젝트 폴더 이동
- 프로젝트 레지스트리에 `memo_app_design` 등록
- `D:\Workspace\memo_app_design\system_design.md` 작성
- 레지스트리 핵심 문서에 `system_design.md` 추가
- 데이터베이스 설계를 SQLite에서 기존 `bloom` Supabase Cloud Postgres에 `memo_` 테이블을 추가하는 방식으로 변경
- 앱 구조를 Next.js 단독 앱에서 기존 `bloom` 정적 프런트 + Vercel Functions + Supabase REST 확장 방식으로 변경
- `basic_requirements_and_design.md`의 권장 기술 구조를 기존 `bloom` 프로젝트 + Supabase Cloud 기준으로 정정
- `D:\Workspace\memo_app_design\database_schema.md` 작성
- `D:\Workspace\bloom\docs\memo_app_schema.sql` 작성
- Supabase 테이블 생성 작업 완료 보고 수신
- Google Stitch 요청용 UI/UX 시안 프롬프트 3종 작성: `D:\Workspace\memo_app_design\ui_ux_stitch_design_requests.md`
- Codex MCP에 원격 `stitch` 서버 등록 시도 완료: `https://stitch.googleapis.com/mcp`
- `codex mcp login stitch`는 Stitch 원격 OAuth의 Dynamic Client Registration 미지원 오류로 실패
- 로컬 proxy 방식 전환에는 Google Cloud CLI 설치와 Google Cloud project id가 필요함을 확인
- 디자인 확정 이후 실제 구현 태스크 문서 작성: `D:\Workspace\memo_app_design\post_design_implementation_tasks.md`
- Google Stitch 산출물 폴더 확인: `D:\Workspace\memo_app_design\stitch_bloom_memo_ui_design`
- 중첩 폴더 내 PC 시안 확인 완료: `concept_c_capture_main_desktop`, `concept_c_capture_new_desktop`
- C안만 기준으로 Stitch 디자인 검토 문서 재작성: `D:\Workspace\memo_app_design\stitch_design_review.md`
- 브라우저 확장프로그램 서비스 제공을 위한 디자인 요청서 작성: `D:\Workspace\memo_app_design\browser_extension_design_request.md`
- 브라우저 확장프로그램 Stitch 산출물 확인: `extension_popup_main`, `extension_registration`, `extension_success_error_states`
- 브라우저 확장프로그램 디자인 검토 문서 작성: `D:\Workspace\memo_app_design\browser_extension_design_review.md`
- 현재까지 프로젝트 진행사항 요약 문서 작성: `D:\Workspace\memo_app_design\project_progress_summary.md`
- 이후 실행 작업 계획 문서 작성: `D:\Workspace\memo_app_design\next_execution_plan.md`

## 다음 작업
1. Google Stitch MCP 연결 준비
   - Google Cloud CLI 설치 여부 재확인
   - 미설치 시 Google Cloud CLI 설치
   - 사용자 브라우저에서 `gcloud auth login` 인증 진행
   - 사용자 브라우저에서 `gcloud auth application-default login` 인증 진행
   - 사용할 Google Cloud `PROJECT_ID` 확인 또는 선택
   - `gcloud config set project <PROJECT_ID>` 설정
   - `gcloud beta services mcp enable stitch.googleapis.com --project=<PROJECT_ID>` 실행
   - Codex MCP에서 `stitch` 원격 등록/OAuth 실패 상태를 정리하고, 가능한 경우 로컬 proxy 방식으로 재구성
2. Google Stitch 디자인 시안 생성
   - C안 검토 결과는 `D:\Workspace\memo_app_design\stitch_design_review.md` 참조
   - C안 PC/모바일 메인 및 등록 화면 기준으로 최종 UI/UX 명세 작성
   - C안은 검색 필드, 태그 입력, 저장 액션 중복, 모바일 화면 잘림 이슈 보완 필요
   - 추가 요청이 필요하면 `stitch_design_review.md`의 C안 보완 프롬프트 사용
   - PC/모바일 반응형 결과 확인
3. UI/UX 시안 비교 및 확정
   - 리스트 중심 미니멀, 분할 패널형, 빠른 캡처 중심 중 1개 방향 선택
   - 선택 시안의 수정사항 정리
   - 최종 UI/UX 명세 문서 작성
   - 브라우저 확장프로그램 팝업/빠른 등록/상태 화면 시안 확인
   - 브라우저 확장프로그램 디자인은 `D:\Workspace\memo_app_design\browser_extension_design_review.md` 기준으로 보완 후 확정
4. 개발 착수 전 후속 설계
   - `D:\Workspace\memo_app_design\project_progress_summary.md` 기준으로 현재 상태 확인
   - `D:\Workspace\memo_app_design\next_execution_plan.md` 기준으로 실행 순서 확정
   - `D:\Workspace\memo_app_design\post_design_implementation_tasks.md` 기준으로 구현 태스크 확정
   - API 명세 상세화
   - 화면 와이어프레임 정리
   - MVP 구현 계획 수립
   - 브라우저 확장프로그램 구현 범위 확정
   - 확장프로그램 MVP는 팝업 기반 빠른 저장으로 제한하고 사이드패널/오프라인 큐는 후순위로 둠
   - 초기 관리자 `memo_user_roles` 및 기본 카테고리 데이터 등록 여부 확인
   - 기존 `bloom` 인증/세션과 메모 앱 권한 연동 방식 상세화

## 실행 / 검증
- run_command: N/A
- verify_command: `basic_requirements_and_design.md`, `system_design.md`, `database_schema.md`, `bloom/docs/memo_app_schema.sql` 검토
- port_or_runtime: browser-based app planned, port undecided
- deploy_method: design project / deploy undecided

## 핵심 경로
- project_root: `D:\Workspace\memo_app_design`
- key_docs: `basic_requirements_and_design.md`, `system_design.md`, `database_schema.md`, `stitch_design_review.md`, `browser_extension_design_review.md`, `project_progress_summary.md`, `next_execution_plan.md`, `D:\Workspace\bloom\docs\memo_app_schema.sql`
- key_files: N/A

## 리스크 / 주의사항
- PC 브라우저 공유 연동은 네이티브 지원이 제한적이므로 북마클릿 또는 브라우저 확장 대안이 필요하다.
- 모바일 공유 대상 노출은 PWA 설치 및 브라우저 지원 상태에 영향을 받는다.
- 개인용 앱이어도 인증, 세션, 비밀번호 해시 저장은 기본 요구사항으로 유지한다.
- 기존 `bloom` Supabase 프로젝트의 테이블 네이밍, 권한, service role key 관리 정책과 충돌하지 않도록 `memo_` prefix를 사용한다.
- 아이콘 작업 필요 시 `project_control/docs/icon_workflow.md` 기준으로 `Font Awesome` 우선 검토

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `D:\Workspace\memo_app_design\project_progress_summary.md`, `D:\Workspace\memo_app_design\next_execution_plan.md`
- 확인이 필요한 미결사항: 최종 UI/UX 명세 작성, 초기 관리자 role 등록 여부, 기본 카테고리 등록 여부, API 상세 명세 작성, 실제 구현을 `bloom` 프로젝트에서 바로 진행할지 여부, 확장프로그램 코드를 bloom 내부에 둘지 별도 폴더로 둘지 결정
