# Bloom UI 설계 프로세스

## 1. 문서 정보

- 목적: 신규 프로그램/화면을 설계·구현할 때 `bloom_ui_design_standard.md`를 어떻게 적용하고 검증할지 정의하는 실행 절차.
- 관계: 이 문서는 표준 문서의 하위 절차서다. 색상·타이포그래피·컴포넌트 규칙은 `bloom_ui_design_standard.md`가 유일한 권위이며, 이 문서는 "무엇을"이 아니라 "어떤 순서로 지키고 검증할 것인가"만 다룬다. 두 문서가 충돌하면 표준 문서를 따른다.
- 기준일: 2026-08-02
- 위치: 이 문서와 표준 문서는 `project_control` 저장소(`https://github.com/mohenz/project-control.git`)의 `design/` 아래에서 버전 관리된다.

## 2. 참고 저장소와 역할 구분

| 저장소 | 역할 | 사용 금지 |
|---|---|---|
| `project_control/design/bloom_ui_design_standard.md` | 최종 권위 — 색상/타이포그래피/컴포넌트/접근성 고정값 | — |
| `D:\workspace\shadcn-ui`(머신별 로컬 clone) | Radix 기반·Vega 스타일의 실제 구현 값 조회용 (`apps/v4/registry/base-colors.ts`, `themes.ts`, `styles/style-vega.css` 등) | — |
| `D:\workspace\ui-ux-pro-max-skill`(머신별 로컬 clone) | 구현 방법 레퍼런스(shadcn 컴포넌트 카탈로그·접근성 패턴)와 토큰 하드코딩 자동 검증 도구 | `search.py --design-system`, `--domain style`, `--domain color` 같은 **프로젝트별 스타일·팔레트 추천 기능은 사용하지 않는다.** Bloom은 워크스페이스 전체를 하나의 팔레트(Neutral+Blue)로 고정하는 것이 원칙이라, 제품 유형별로 다른 스타일/팔레트를 추천받는 기능은 이 원칙과 정면으로 충돌한다. |

`ui-ux-pro-max-skill`은 SwiftUI·Flutter·WPF·Three.js·슬라이드 생성 등 D:\Workspace의 실제 스택(Next.js/React 웹)과 무관한 영역도 포함한다. 웹 프로젝트 작업 시 `references/shadcn-*.md`, `references/tailwind-*.md`와 `design-system` 스킬의 토큰 검증 스크립트 외에는 참고하지 않는다.

`shadcn-ui`, `ui-ux-pro-max-skill`은 각각 공개 GitHub 원본이 있으므로 `project_control` 저장소에는 포함하지 않는다. 새 PC/에이전트에서 작업할 때는 아래 명령으로 그 자리에서 다시 clone한다(4장 "새 작업환경 준비" 참고).

## 3. 단계별 프로세스

### Phase 0 — 착수 전 확인

1. `project_control/project_registry.md`에서 프로젝트 등록 여부를 확인한다. 미등록이면 먼저 등록하고 `states/<project>_current.md`를 만든다(project_governance_rules.md 규칙).
2. `bloom_ui_design_standard.md` 2·3·8·9·10장(표준 구성, 기반 선택 규칙, 색상 토큰, 아이콘, 컴포넌트 사용 규칙)을 다시 읽는다. 표준은 자주 바뀌지 않지만, 매번 기억에 의존하지 않고 원문을 확인한다.

### Phase 1 — 기반 설정 (신규 프로젝트/화면)

1. 기반 스택을 고정한다: Radix UI + shadcn Vega 스타일 + Lucide 아이콘 + Pretendard Variable. 이미 다른 기반(다른 아이콘 세트, 다른 CSS 프레임워크)이 깔려 있는 기존 프로젝트라면, 전면 교체보다 단계적 전환(토큰 → 아이콘 → 복합 UI 컴포넌트 순)을 우선한다.
2. 실제 색상 값이 필요하면 `D:\workspace\shadcn-ui`에서 `neutral`(base) + `blue`(theme) 조합의 oklch 값을 그대로 가져온다(`apps/v4/registry/themes.ts`). Bloom 8장의 시맨틱 토큰 이름(`background/foreground`, `primary/secondary`, `success/warning/info` 등)으로 매핑해서 프로젝트의 CSS 변수로 정의한다.
3. shadcn 컴포넌트 구현 방법이 필요하면 `D:\workspace\ui-ux-pro-max-skill\.claude\skills\ui-styling\references\shadcn-components.md`(카탈로그), `shadcn-theming.md`(다크모드/커스터마이징), `shadcn-accessibility.md`(ARIA 패턴)를 how-to 레퍼런스로 참고한다. 색상 값 자체는 여기서 가져오지 않는다 — 2단계에서 정한 Bloom 토큰을 그대로 쓴다.

### Phase 2 — 구현

1. Bloom 10장(버튼/폼/Dialog/표/상태 알림) 규칙에 맞춰 컴포넌트를 만든다. Dialog·Select·Dropdown·Tooltip·Popover 같은 복합 UI는 직접 `<div>`로 재구현하지 않고 Radix 프리미티브를 쓴다.
2. 접근성·터치 타깃·타이포그래피 수치는 Bloom 7·11장이 1차 기준이다. `ui-ux-pro-max-skill`의 `ux` 도메인(98개 가이드라인, `.claude/skills/ui-ux-pro-max/references/quick-reference.md`)은 교차 검증용 2차 체크리스트로만 쓴다. 두 문서의 수치가 다르면(예: 터치 타깃 Bloom 40px vs 이 저장소 44px) **Bloom 값을 따른다.**
3. 라이트/다크 테마 둘 다 구현한다(Bloom 2장). 새 색상 토큰을 추가할 때는 반드시 `:root`와 `[data-theme="dark"]` 양쪽에 짝을 채운다 — 한쪽만 정의하면 다른 테마에서 텍스트가 배경에 묻히는 대비 사고로 이어진다(PMO CONTROL에서 실제 발생: `color-mix(..., white NN%)`로 만든 배경 토큰이 다크 테마에서도 흰색에 수렴해 텍스트가 안 보였던 사례 — `states/projectmgmt_current.md` 참고).

### Phase 3 — 검증

**3-1. 자동 토큰 검증**

```bash
node "D:\workspace\ui-ux-pro-max-skill\.claude\skills\design-system\scripts\validate-tokens.cjs" -d "<프로젝트 경로>" -i node_modules -i .next -i .next-ci
```

하드코딩된 hex 색상값·px 값을 찾아준다. 주의할 점:
- 빌드 산출물 디렉터리(`.next`, `.next-ci`, `dist`, `build` 등)를 반드시 `-i`로 제외한다 — 안 그러면 컴파일된 옛 CSS 캐시가 잡혀서 이미 고친 코드가 다시 위반으로 뜨는 오탐이 난다.
- 이 스크립트는 `var(--color-*)` 네이밍을 기대하고 제안을 준다. Bloom 토큰 이름(`--primary`, `--background` 등)과 다르므로 "이 변수를 써라"는 제안 문구 자체는 무시하고, "여기 하드코딩된 값이 있다"는 사실만 받아들여 Bloom 토큰으로 바꾼다.

**3-2. 라이트/다크 스크린샷 스윕**

Playwright(headless Chromium)로 주요 라우트를 라이트/다크 각각 방문해 스크린샷과 콘솔 에러를 확인한다. `localStorage.setItem("<프로젝트의 테마 키>", "dark")`를 `addInitScript`로 주입한 뒤 페이지를 열면 다크 테마를 재현할 수 있다(PMO CONTROL 세션에서 사용한 방식). 표/뱃지/위험 강조행처럼 배경+텍스트 조합이 있는 요소를 우선 확인한다.

**3-3. 체크리스트 확인**

Bloom 14장 체크리스트(현지화/일관성/접근성/반응형)를 화면 단위로 순회한다. 특히 실무에서 자주 놓치는 항목:
- placeholder만 있고 화면에 보이는 Label이 없는 입력 (10.2)
- `window.confirm` 등 버튼 문구를 커스터마이징할 수 없는 네이티브 확인창을 파괴적 작업에 쓰는 경우 (10.3) → Radix AlertDialog로 교체
- 아이콘 전용 버튼에 한국어 `aria-label` 누락 (9장)
- 본문 바로가기 스킵 링크 누락 (11장)

### Phase 4 — 기록

1. `project_control/states/<project>_current.md`에 표준 준수 현황(반영한 것/남은 격차)을 기록한다.
2. 표준에서 벗어난 예외를 사용했다면 사유·영향 범위·종료 조건을 프로젝트 설계 문서에 남긴다(Bloom 3.2, 15장).

## 4. 새 작업환경 준비 (다른 PC / 다른 에이전트)

이 두 문서는 `project_control` 저장소에 커밋되어 있으므로, 다른 PC나 다른 에이전트(Codex/Rick, Gemini/Jian 등)에서도 아래만 하면 동일한 표준을 그대로 쓸 수 있다.

```bash
# 1) 표준 문서 확보 — project_control 저장소를 clone/pull
git clone https://github.com/mohenz/project-control.git
# 이미 clone되어 있다면
git pull origin main

# 2) 구현 참고용 로컬 도구 — 필요할 때 그 자리에서 새로 clone (project_control에는 포함되지 않음)
git clone https://github.com/shadcn-ui/ui.git shadcn-ui
git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git
```

`project_control/design/bloom_ui_design_standard.md`, `bloom_ui_design_process.md`가 이 절차의 유일한 원본이다. 다른 위치에 있는 사본(예: 과거 `D:\workspace\design\` 경로)은 안내 문구만 남긴 포인터이며 최신본이 아니다.

## 5. 한 줄 요약 체크리스트

- [ ] 프로젝트가 `project_registry.md`에 등록되어 있는가?
- [ ] Radix + Vega(neutral/blue) + Lucide + Pretendard 조합을 그대로 썼는가?
- [ ] 새 색상 토큰을 `:root`와 `[data-theme="dark"]` 양쪽에 다 정의했는가?
- [ ] `validate-tokens.cjs`로 하드코딩 값 스캔했는가(빌드 산출물 제외하고)?
- [ ] 라이트/다크 둘 다 스크린샷으로 실제 확인했는가?
- [ ] Bloom 14장 체크리스트를 화면 단위로 확인했는가?
- [ ] `ui-ux-pro-max-skill`의 스타일/팔레트 추천 기능을 쓰지 않았는가?
- [ ] states 파일과 표준 예외 기록을 남겼는가?
