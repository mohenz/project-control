# EPMS 프로젝트 현재 상태

## 기본 정보
- project_key: `epms`
- last_updated: `2026-08-01`
- owner_request: `로컬 PostgreSQL 기반 DB·공통코드를 설계하고 실제 운영 가능한 프로그램 완성`
- current_status: `P0/P1/P2 고도화(경영진 대시보드 실데이터화, Governance 3종 CRUD, AI·보고서 영속화, RAID/Gate Evidence·체크리스트, 역할별 권한 통제) 전체 반영 완료`

## 최근 완료 작업

### 이전 세션 (기본 CRUD·한글화)
- EPMS 전용 PostgreSQL 16 클러스터를 `127.0.0.1:54325`에 구성했다.
- 19개 업무·권한·감사 테이블, 13개 공통코드 그룹 55개 항목, RAID·Gate·Vendor 시드를 구축했다.
- 제한된 앱 역할, bcrypt 인증, 8시간 세션, 비밀번호 강제변경·관리자 재설정, 감사 로그를 구현했다.
- 프로젝트·KPI·공통코드·사용자·RAID·Gate·Vendor에 등록·조회·수정·상태 전환 UI/API를 구현했다.
- 16개 메뉴 화면을 전수 점검해 무동작 버튼 7종, 빈 링크 1개, 무동작 전역 검색을 제거했다.
- 로그인·공통 셸·업무 화면을 한글화했다(KPI·RAID·PHI 등 표준 약어와 DB 식별 코드는 유지).
- 앱 계정의 DELETE·DDL을 차단하고 FK·복합·부분·GIN 인덱스와 DB RAG 트리거(`evaluate_kpi_rag`)를 적용했다.
- 사이드바에 `？ 가이드북` 메뉴(`GuidebookScreen.tsx`)를 추가해 16개 화면 사용법을 앱 내에서 안내한다.

### 이번 세션 — P0/P1/P2 고도화 전체 반영
- **DB**: `003_enhancements.sql`/`004_enhancement_seed.sql` 신설 — `adr_records`, `defect_records`, `security_controls`, `security_exceptions`, `kpi_anomaly_flags`, `meeting_summaries`, `weekly_status_reports`, `gate_checklist_items`, `gate_checklist_status` 9개 테이블 추가. `projects`에 `budget_amount`/`actual_cost_amount`, `gate_reviews`에 `target_date`/`forecast_date` 추가. SEC_ARCH 도메인 KPI(`SEC-01`) 추가로 PHI 6개 영역 실데이터 완비.
- **버그 수정(기존 시드)**: `002_seed.sql`의 KPI 시드가 `(project_id,kpi_code,version)` 충돌 체크에 의존해, PATCH로 버전이 올라간 뒤 재시드하면 새 버전=1 행이 중복 생성되던 잠재 결함을 발견·수정했다(`kpi_code` 단위 존재 여부 체크로 전환). 로컬 DB에 이미 쌓여 있던 중복 KPI 정의·측정치·임계치를 정리했다. `gate_checklist_items`에 누락되어 있던 `unique(gate_definition_id,label)` 제약도 추가했다. 이후 `db:setup`을 반복 실행해 완전한 멱등성을 확인했다.
- **권한 통제(P0)**: `lib/auth.ts`의 `requireSession`이 역할 배열을 받도록 확장(`SYS_ADMIN`은 항상 허용). `kpis`/`gates`/`raid`/`vendors`/`measurements` 쓰기 API에 RACI 기반 역할 제한을 적용했다. KPI 생성 시 동일 코드 중복 등록도 차단했다.
- **신규 API**: `/api/governance`(ADR·결함·보안통제·보안예외 통합 CRUD), `/api/ai/anomalies`(이상탐지 검토 영속화), `/api/ai/meetings`(회의록 요약 확정), `/api/reports`(보고서 저장·이력).
- **경영진 대시보드 실데이터화(P0)**: `/api/dashboard`를 확장해 PHI(6개 영역 RAG 기반 계산, 매일 1회 `phi_scores`에 스냅샷 적재), 재무(BAC/AC/CPI/EAC), 마일스톤 편차, 주요 리스크·이슈, 대기 의사결정, 범위/변경 집계, 준비도(품질/보안/운영 3종)를 반환. `ExecutiveDashboardScreen.tsx`·`OperationalDashboardScreen.tsx`의 하드코딩을 전부 제거하고 실데이터로 교체했다(정직하게 표현 불가능한 항목—"고객" 준비도, SPI—은 임의로 지어내지 않고 제외).
- **Governance 3종 CRUD(P1)**: `GovernanceScreen.tsx`를 ADR 등록/조회, 결함 등록·상태전이(Sev1/2·3일초과·해결률 자동 집계), 보안 통제 체크·예외 등록의 실제 CRUD로 재작성했다.
- **AI 시나리오 영속화(P0)**: `AiAnomalyScreen.tsx`(검토 결과 DB 저장), `MeetingScreen.tsx`(AI 초안 확정 버튼, 확정 이력 저장) — Human Gate 원칙(AI는 초안만 제안, 사람이 확정) 유지.
- **보고서 저장/이력(P2)**: `ReportingScreen.tsx`에 저장 버튼과 이력 표를 추가, `weekly_status_reports`에 영속화.
- **RAID Evidence·P×I(P1)**: `RaidScreen.tsx`에 근거 링크(Evidence) 입력, 리스크 탭에 발생가능성×영향도 입력과 5×5 히트맵을 추가.
- **Gate 체크리스트·Evidence(P1)**: `GateScreen.tsx`에 단계별 필수 산출물 체크리스트(8개 Gate × 3개 항목)와 근거 링크 입력을 추가.
- **PHI 실데이터화(P2)**: `PhiTrendsScreen.tsx`가 `/api/dashboard`의 실계산 PHI·영역별 점수·추세를 사용하도록 전환.
- **가이드북 갱신**: `GuidebookScreen.tsx`에서 "예시 데이터입니다" 안내 문구를 제거하고 실제 동작(체크리스트, Evidence, 저장/확정 절차)을 반영했다.
- **검증**: TypeScript(`tsc --noEmit`), production build, Vitest 5/5, Jest 11/11(기존 9건 + 신규 테이블 카운트·DELETE 차단 검증 2건 추가, KPI 카운트 기대값을 6으로 갱신, 화면 파일 수 기대값을 18로 갱신), Playwright 3/3 모두 통과. 추가로 실행 중인 서버에 대해 로그인 세션으로 `/api/dashboard`, `/api/governance`, `/api/ai/anomalies`, `/api/ai/meetings`, `/api/reports`, `/api/gates` 신규 엔드포인트를 curl로 직접 호출해 실데이터 응답·쓰기 동작·권한 거부(PMO가 SYS_ADMIN 전용 API 호출 시 403)를 수동으로 재확인했다.

## 실행 / 검증
- run_command: `npm.cmd run local` (포그라운드, DB 기동 후 Next dev 블로킹 실행)
- site_command(백그라운드 제어): `npm.cmd run site:status` / `site:start` / `site:stop` / `site:restart` — `scripts/site.ps1`가 포트 점유 여부로 상태를 판단해 백그라운드로 기동·종료한다. 로그는 `.local/next-dev.out.log`·`.local/next-dev.err.log`.
- 더블클릭 실행파일(`cinetube` 프로젝트의 `ct.cmd`/`start-*.cmd`/`stop-*.cmd` 패턴 참고): `epms.cmd`(빠른 기동+브라우저 자동 오픈), `start-epms.cmd`(동일 + 완료 후 pause), `stop-epms.cmd`(웹+PostgreSQL 모두 종료 + pause). 전부 `scripts/site.ps1 -Open` 스위치로 브라우저를 자동으로 연다.
- db_command: `npm.cmd run db:setup` / `npm.cmd run db:stop`
- verify_command: `npm.cmd run lint`, `npm.cmd run test`, `npm.cmd run test:jest`, `npm.cmd run test:e2e`, `npm.cmd run build`
- port_or_runtime: Web `3010`, PostgreSQL `127.0.0.1:54325`, database `epms`
- health_url: `http://127.0.0.1:3010/api/health`
- deploy_method: `미배포; 외부 배포는 별도 승인 필요`

## 핵심 경로
- project_root: `D:\workspace\epms`
- database: `database\migrations\001_schema.sql`~`004_enhancement_seed.sql`, `database\setup-database.ps1`
- server: `lib\db.ts`, `lib\auth.ts`, `lib\kpi.ts`, `app\api\**\route.ts`(governance/ai/reports 신규)
- docs: `README.md`, `docs\database_design.md`, `docs\test_report_postgresql_20260801.md`

## 리스크 / 주의사항
- `.env.local`, `database\.env.admin.local`, `.local\postgres-data`는 Git 제외이며 비밀값을 project-control에 기록하지 않는다.
- 3000번은 personalMemo 전용이다. EPMS Web은 3010만 사용한다.
- 원격 푸시·배포는 명시 지시 전 수행하지 않는다.
- 로컬 dev DB는 시드 데이터와 Playwright e2e 테스트가 같은 데이터베이스를 공유한다. e2e의 "KPI measurement work" 테스트가 실제로 KPI 값을 갱신하므로, 데모 중 특정 KPI 값(예: CST-01/CPI)이 시드값과 달라 보일 수 있다 — 이는 결함이 아니라 실데이터가 실제로 기록된 것이다.
- 확장(Phase 5) 범위로 남겨둔 것: 다중 프로젝트/계열사 포트폴리오, 등급(Lite/Critical)별 정책 차등, 외부 시스템 자동 연동, AI 시나리오 확장(일정예측·RAID분류·Executive초안·지식검색), Cut-over & Hyper Care, 이커머스 특화 KPI, 클라우드(Vercel+Supabase) 전환.
- Gate 8단계 중 G5~G7 체크리스트는 아직 완료 처리된 항목이 없다(현재 진행 단계인 G4까지만 시드에서 일부 완료 처리).
- `.ps1` 스크립트에 한글 문자열을 넣지 않는다. `npm run db:setup`/`site:*`는 `powershell.exe`(Windows PowerShell 5.1, BOM 없는 UTF-8 파일을 시스템 코드페이지로 오독)를 통해 실행되어, 한글이 포함되면 문자열 리터럴이 깨지면서 `'PID' is not recognized...` 류의 엉뚱한 파싱 오류가 난다(pwsh 7 직접 실행 시엔 재현되지 않아 헷갈리기 쉽다). `scripts/site.ps1`는 이 때문에 영문 메시지로 작성했다.

## Handoff
- current_goal: P0/P1/P2 고도화 완료, 확장(Phase 5) 착수 대기
- verification: TypeScript 통과, Vitest 5/5, Jest 11/11, Playwright 3/3, production build 통과, 신규 API 6종 curl 수동 검증(정상 응답·쓰기 반영·403 권한 거부) 완료. 브라우저 GUI 육안 확인은 미수행(터미널 환경) — 필요 시 `npm run local` 후 각 메뉴를 직접 클릭 확인 권장.
- next_action: 사용자 승인 시 확장(Phase 5) 범위 착수, 또는 로컬 검증 완료 후 클라우드(Vercel+Supabase) 전환 절차(§`EPMS_개발계획서.md` 5-3) 진행
- risks_or_blockers: 없음(현재 식별된 결함 없음). 위 "리스크 / 주의사항"은 알아두어야 할 특성이지 결함이 아니다.
