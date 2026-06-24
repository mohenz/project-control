# 프로젝트 레지스트리

## 사용 규칙
- 이 문서는 프로젝트 식별의 기준표입니다.
- 프로젝트 전환 요청이 오면 먼저 이 문서로 프로젝트 키를 확정합니다.
- 상태 파일 경로와 실행 명령은 여기 값을 우선 사용합니다.

## 등록 프로젝트

| project_key | aliases | path | type | local run / verify | state file | key docs | deploy |
|---|---|---|---|---|---|---|---|
| `defect_manage` | `defect manage`, `defect manager`, `defect_manage`, `defect` | `D:\Workspace\defect_manage` | Supabase + Vanilla JS web app | run: `npm.cmd start` / verify: `npm.cmd run check:syntax`, `npm.cmd run test:unit` / port: `3000` | `states/defect_manage_current.md` | `README.md`, `docs/README_ko.md`, `docs/CHANGELOG.md` | GitHub Pages + local Node server |
| `defect_manage2` | `defect manage2`, `defect manage 2`, `defect_manage2`, `defect2` | `D:\Workspace\defect_manage2` | Local PostgreSQL + Node API + Vanilla JS web app | run: `npm.cmd start` / verify: `npm.cmd run check:syntax`, `npm.cmd run test:unit`, `npm.cmd run test:e2e` / port: `3000`, DB `127.0.0.1:54323` | `states/defect_manage2_current.md` | `README.md`, `docs/README_ko.md`, `docs/executable_size_structure_improvement_plan.md`, `docs/defect_manage2_local_postgres_cutover_plan_20260624.md` | separate repo `mohenz/defect_manage2` / local Node server |
| `n8n_defect_automation` | `n8n`, `n8n defect`, `n8n automation`, `n8n-defect-automation` | `D:\Workspace\n8n-defect-automation` | n8n workflow automation project | verify: `workflow/defect_report_workflow.json`, `docs/n8n_project_manual.md` / runtime: n8n Cloud or Desktop | `states/n8n_defect_automation_current.md` | `docs/n8n_project_manual.md`, `docs/n8n_setup_guide.md`, `workflow/defect_report_workflow.json` | n8n import / activation |
| `makeyourtoday` | `makeyourtoday`, `make your today`, `make-your-today` | `D:\Workspace\makeyourtoday` | documentation-driven product planning project | verify: inspect `범용_멀티에이전트_운영체계.md`, `MBDP_요구사항정의서_v1.0.md`, `pm_도구_ai_에이전트_전체_설계서_mvp_포함.md` / runtime: N/A | `states/makeyourtoday_current.md` | `범용_멀티에이전트_운영체계.md`, `MBDP_요구사항정의서_v1.0.md`, `pm_도구_ai_에이전트_전체_설계서_mvp_포함.md` | local docs / TBD |
| `trinity_room` | `trinity_room`, `trinity room`, `trinity meeting room`, `trinity soul shell` | `D:\Workspace\trinity_room` | Electron desktop app planning and prototype project | run: `npm.cmd run start` / verify: `npm.cmd run build`, `npm.cmd run check:types` / runtime: `Electron local desktop app` | `states/trinity_room_current.md` | `trinity_meeting_room_plan.md`, `room_protocol.md`, `trinity_soul_shell_architecture.md`, `trinity_room_work_plan_checklist.md` | local desktop prototype / TBD |
| `jina_writer` | `jina writer`, `jina_writer`, `jina novel`, `jinawriter` | `D:\Workspace\jina_writer` | Python desktop novel-writing app with local-first storage and Gemini 2.5 Flash integration | run: `python app.py` / verify: `python -m py_compile app.py desktop_app\storage.py desktop_app\gemini.py` / runtime: `Tkinter local desktop app` | `states/jina_writer_current.md` | `README.md`, `docs/app_plan.md`, `docs/gemini_integration.md` | local desktop app / installer TBD |
| `ui_code_helper` | `ui_code_helper`, `ui code helper`, `ui-code-helper`, `ui markdown capture` | `D:\Workspace\ui_code_helper` | Chrome extension project for UI element selection and Markdown change request generation | run: load unpacked extension in Chrome / verify: `npm.cmd run check:syntax` / runtime: Chrome side panel extension | `states/ui_code_helper_current.md` | `README.md`, `docs/mvp_spec.md`, `docs/사용자_매뉴얼.md`, `docs/다중선택_UX_설계안.md`, `manifest.json` | local unpacked extension / zip sync |
| `unit_test` | `unit_test`, `unit test`, `unit-test` | `D:\Workspace\unit_test` | centralized unit test governance and report repository | verify: inspect `README.md`, `docs/unit_test_workflow.md`, `docs/unit_test_rules.md`, `docs/common_checklist_master.md`, `SKILL.md` / runtime: N/A | `states/unit_test_current.md` | `README.md`, `docs/unit_test_workflow.md`, `docs/unit_test_rules.md`, `docs/common_checklist_master.md`, `SKILL.md` | local docs / GitHub repo sync |
| `project_control` | `project-control`, `project control`, `project_control`, `프로젝트 컨트롤` | `D:\Workspace\project_control` | workspace central project registry and state-control repository | verify: `git status --short --branch` / runtime: N/A | `states/project_control_current.md` | `project_governance_rules.md`, `project_registry.md`, `project_switch_workflow.md` | GitHub repository sync |
| `project_04` | `project 4`, `project_04`, `tbd` | `TBD` | TBD | TBD | `states/project_04_placeholder.md` | TBD | TBD |
| `token_tracker` | `token tracker`, `token_tracker`, `토큰 트래커`, `토큰트래커` | `D:\Workspace\token_tracker` | Zero-dependency Python local server + Premium HTML/JS Web Dashboard | run: `python server.py` / verify: `python test_tracker.py` / port: `5000` | `states/token_tracker_current.md` | `config.json`, `database.py`, `server.py`, `static/index.html` | local Python server |
| `cinetube` | `cinetube`, `cine tube`, `cinehub`, `cine hub`, `씨네튜브` | `D:\Workspace\cinetube` | Supabase + static responsive movie information web app | run: `python -m http.server 8080` / verify: browser inspect `index.html`, `assets/js/app.js`, `supabase/schema.sql` / port: `8080` | `states/cinetube_current.md` | `docs\requirements\cinetube 기본요구사항.txt`, `docs\requirements\cinetube 기능추가요구사항.txt`, `docs\reference\stitch_cinetube_movie_hub\cinematic_archive_system\DESIGN.md`, `index.html`, `supabase/schema.sql` | local static site / deploy TBD |
| `bloom` | `bloom`, `bloom prompt`, `bloom prompt generator`, `bloom-prompt-generator`, `prompt builder`, `Prompt Builder`, `bloom deploy`, `bloom-deploy`, `prompt generator`, `prompt-generator` | `D:\Workspace\bloom` | static prompt generator web app with optional Vercel Functions and local Node translation API | run: browser open `index.html` / optional API: `npm.cmd run start:api` / verify: `node --check server/translate-api.mjs`, `node --check api/translate.js`, `node --check api/auth/login.js`, `node --check prompt-generator/ui/app.js`, `GET /healthz` / port: `8787` | `states/bloom_current.md` | `README.md`, `docs/general_login_auth_schema.sql`, `docs/prompt_history_schema.sql`, `index.html`, `server/translate-api.mjs` | `git push origin main` -> Vercel static + `api/` functions |
| `jian_soul` | `jian_soul`, `jian soul`, `jian`, `지안`, `지안 소울` | `D:\Bloom` | JIAN Unified Soul System & Autonomic Nervous System | run: `python jn.py` / verify: `python system/check_models.py` | `states/jian_soul_current.md` | `persona/JIAN/soul/PERSONA_RULES_CONSOLIDATED.md`, `persona/JIAN/soul/JIAN_persona.md` | GCS (JIAN-soul bucket) |


## 전환 표준 문장
- `defect manage로 전환`
- `n8n 프로젝트 확인`
- `auth pro 작업 이어서`
- `ui code helper 프로젝트 확인`
- `unit test 프로젝트 확인`
- `bloom 프로젝트 확인`
- `token tracker 프로젝트 확인`

## 매핑 원칙
- 별칭은 소문자 기준으로 비교합니다.
- 공백, `_`, `-` 차이는 허용합니다.
- 등록되지 않은 프로젝트는 먼저 이 레지스트리에 추가한 뒤 작업합니다.






