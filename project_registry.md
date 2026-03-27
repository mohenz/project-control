# 프로젝트 레지스트리

## 사용 규칙
- 이 문서는 프로젝트 식별의 기준표입니다.
- 프로젝트 전환 요청이 오면 먼저 이 문서로 프로젝트 키를 확정합니다.
- 상태 파일 경로와 실행 명령은 여기 값을 우선 사용합니다.

## 등록 프로젝트

| project_key | aliases | path | type | local run / verify | state file | key docs | deploy |
|---|---|---|---|---|---|---|---|
| `defect_manage` | `defect manage`, `defect manager`, `defect_manage`, `defect` | `D:\Workspace\defect_manage` | Supabase + Vanilla JS web app | run: `npm.cmd start` / verify: `npm.cmd run check:syntax`, `npm.cmd run test:unit` / port: `3000` | `states/defect_manage_current.md` | `README.md`, `docs/README_ko.md`, `docs/CHANGELOG.md` | GitHub Pages + local Node server |
| `n8n_defect_automation` | `n8n`, `n8n defect`, `n8n automation`, `n8n-defect-automation` | `D:\Workspace\n8n-defect-automation` | n8n workflow automation project | verify: `workflow/defect_report_workflow.json`, `docs/n8n_project_manual.md` / runtime: n8n Cloud or Desktop | `states/n8n_defect_automation_current.md` | `docs/n8n_project_manual.md`, `docs/n8n_setup_guide.md`, `workflow/defect_report_workflow.json` | n8n import / activation |
| `auth_pro` | `auth`, `auth pro`, `auth_pro` | `D:\Workspace\auth_pro` | static auth UI prototype | run: browser open or static server / verify: inspect `index.html`, `js/app.js`, `css/style.css` | `states/auth_pro_current.md` | `index.html`, `js/app.js`, `css/style.css` | local / static |
| `project_04` | `project 4`, `project_04`, `tbd` | `TBD` | TBD | TBD | `states/project_04_placeholder.md` | TBD | TBD |

## 전환 표준 문장
- `defect manage로 전환`
- `n8n 프로젝트 확인`
- `auth pro 작업 이어서`

## 매핑 원칙
- 별칭은 소문자 기준으로 비교합니다.
- 공백, `_`, `-` 차이는 허용합니다.
- 등록되지 않은 프로젝트는 먼저 이 레지스트리에 추가한 뒤 작업합니다.
