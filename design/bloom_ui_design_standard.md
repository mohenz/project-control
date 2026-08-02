# Bloom UI 디자인 표준

## 1. 문서 정보

- 문서명: Bloom UI 디자인 표준
- 버전: 1.0
- 기준일: 2026-08-02
- 적용 대상: `D:\Workspace`에서 개발하는 웹사이트 및 웹 애플리케이션
- 참조 구현: shadcn/ui
- 원칙: 한국어 우선, 접근성 준수, 운영 UI 일관성, 제품별 확장 허용

## 2. 표준 구성

Bloom UI의 기본 구성은 다음으로 고정한다.

| 요소 | 표준 | 비고 |
|---|---|---|
| UI 기반 | Radix UI | 접근성, 안정성, shadcn 생태계 호환성 기준 |
| shadcn 스타일 | Vega | 중립적인 밀도와 형태 |
| 아이콘 | Lucide | 다른 아이콘 라이브러리와 혼용하지 않음 |
| 본문 글꼴 | Pretendard Variable | 한국어, 숫자, 영문 혼용 기준 |
| 대체 글꼴 | Noto Sans KR | Pretendard를 사용할 수 없는 환경 |
| 기본 색상 | Neutral + Blue | 의미 기반 토큰으로 사용 |
| 모서리 반경 | Medium, `0.625rem` | 기본값 10px |
| 간격 체계 | 4px 배수 | 4, 8, 12, 16, 24, 32, 40, 48px |
| 테마 | Light + Dark | 동일한 의미 토큰 유지 |

표준 설정 예시는 다음과 같다.

```json
{
  "base": "radix",
  "style": "vega",
  "iconLibrary": "lucide",
  "baseColor": "neutral",
  "theme": "blue",
  "chartColor": "blue",
  "font": "pretendard-variable",
  "fontHeading": "inherit",
  "radius": "medium",
  "rtl": false,
  "pointer": true,
  "menuAccent": "subtle",
  "menuColor": "default"
}
```

`pretendard-variable`은 shadcn/ui 기본 글꼴 목록에 없으므로 Bloom 공통 Registry 또는 프로젝트 설정에서 별도로 등록한다.

## 3. 기반 선택 규칙

### 3.1 기본 기반

- 신규 웹 프로젝트는 Radix UI를 기본 기반으로 사용한다.
- Dialog, Select, Dropdown Menu, Tooltip, Popover 같은 복합 UI는 직접 다시 구현하지 않는다.
- 컴포넌트의 시각 표현은 Bloom 토큰으로 제어하고 접근성 동작은 기반 라이브러리를 유지한다.
- 제품별로 기반 라이브러리를 혼합하지 않는다.

### 3.2 예외

- 공공·금융·교육처럼 접근성 요구가 특히 높은 프로젝트는 React Aria를 검토할 수 있다.
- Base UI는 프로젝트 착수 시점의 안정성과 Registry 호환성을 검증한 경우에만 사용한다.
- 예외 기반을 사용하려면 프로젝트 설계 문서에 사유와 영향 범위를 기록한다.

## 4. 스타일 사용 규칙

- 공통 스타일은 Vega를 사용한다.
- 고밀도 데스크톱 관리자 화면에는 Vega 토큰을 유지하면서 높이와 간격만 축소한 `compact` 밀도를 허용한다.
- Nova, Luma, Maia, Mira, Rhea, Sera, Lyra를 한 제품 안에서 혼합하지 않는다.
- 브랜드 표현은 기본 컴포넌트 구조를 바꾸기보다 색상, 타이포그래피, 이미지 영역에서 확장한다.
- 과도한 그림자, 투명 효과, 그라데이션, 장식용 문구는 기본 표준에 포함하지 않는다.

## 5. 한국어 현지화

### 5.1 적용 범위

다음 사용자 노출 요소는 모두 한국어로 작성한다.

- 메뉴와 화면 제목
- 필드 레이블과 입력 안내
- 버튼과 상태
- 검색 조건과 필터
- 표 헤더와 정렬 항목
- Dialog, Toast, 확인 메시지
- 유효성 검사와 오류 메시지
- 빈 상태와 로딩 상태
- 페이지네이션

영어는 브랜드명, API·데이터베이스 필드명, 구현 식별자, 필요한 기술 상태 코드에만 허용한다. 기술 상태 코드를 표시할 때는 한국어 레이블을 함께 제공한다.

### 5.2 예시 데이터

디자인 시안과 개발용 예시는 한국형 데이터를 사용한다.

```text
이름: 김민준
전화번호: 010-1234-5678
주소: 서울특별시 중구 세종대로 110
금액: ₩1,250,000
날짜: 2026년 8월 2일
상태: 검토 중
```

외국 이름, 외국 전화번호, 외국 주소, 달러 기반 금액을 기본 placeholder로 사용하지 않는다.

### 5.3 문구 원칙

- 버튼은 행동을 구체적으로 표현한다: `저장`, `프로젝트 생성`, `변경사항 적용`.
- 모호한 `확인`, `계속`은 문맥이 명백할 때만 사용한다.
- 오류 메시지는 문제와 다음 행동을 함께 안내한다.
- 운영 화면에 긴 홍보 문구나 반복적인 도움말을 넣지 않는다.
- 로딩 문구는 말줄임표 문자 `…`를 사용한다: `저장 중…`.

## 6. 타이포그래피

### 6.1 글꼴

```css
:root {
  --font-sans:
    "Pretendard Variable",
    Pretendard,
    "Noto Sans KR",
    "Apple SD Gothic Neo",
    "Malgun Gothic",
    sans-serif;

  --font-mono:
    "JetBrains Mono",
    "D2Coding",
    monospace;
}

html {
  font-family: var(--font-sans);
  word-break: keep-all;
}

body {
  font-size: 16px;
  line-height: 1.6;
  letter-spacing: -0.01em;
}

button,
input,
select,
textarea {
  font: inherit;
}

table,
[data-numeric] {
  font-variant-numeric: tabular-nums;
}
```

영문용 Inter, Geist, Figtree를 한글 본문 기본 글꼴로 사용하지 않는다. 한글에 과도한 음수 자간을 적용하지 않는다.

### 6.2 크기 체계

| 용도 | 크기/행간 | 굵기 |
|---|---:|---:|
| 화면 제목 | 24/34px | 700 |
| 섹션 제목 | 20/30px | 600 |
| 카드 제목 | 16/24px | 600 |
| 본문 | 16/26px | 400 |
| 업무 UI·표 | 14/22px | 400 |
| 필드 레이블 | 14/20px | 500 |
| 보조 정보 | 13/20px | 400 |
| 최소 허용 | 12/18px | 400 |

한글 본문에는 12px 미만의 글자를 사용하지 않는다.

## 7. 크기와 레이아웃

### 7.1 조작 요소

| 요소 | 데스크톱 | 모바일 |
|---|---:|---:|
| 기본 버튼·입력 | 최소 36px | 최소 44px |
| 주요 버튼 | 40px | 48px 권장 |
| 아이콘 버튼 클릭 영역 | 최소 40px | 최소 44px |
| 체크박스·라디오 클릭 영역 | 최소 40px | 최소 44px |

아이콘의 시각 크기와 클릭 영역을 동일하게 취급하지 않는다. 16px 아이콘도 충분한 버튼 영역 안에 배치한다.

### 7.2 레이아웃

- 기본 간격은 4px 배수로 구성한다.
- 모바일 화면의 좌우 여백은 최소 16px로 한다.
- 읽기 중심 본문은 지나치게 긴 한 줄이 되지 않도록 너비를 제한한다.
- 화면 측정은 JavaScript보다 Flexbox와 Grid를 우선한다.
- 긴 한국어 이름과 제목에 `min-width: 0`, 줄임, 줄바꿈 정책을 명시한다.
- 모달, Drawer, Sheet 내부 스크롤이 바깥 화면으로 전파되지 않게 한다.

## 8. 색상 토큰

컴포넌트에 임의의 색상값을 직접 넣지 않고 의미 기반 토큰을 사용한다.

```text
background / foreground
card / card-foreground
popover / popover-foreground
muted / muted-foreground
primary / primary-foreground
secondary / secondary-foreground
accent / accent-foreground
destructive / destructive-foreground
border / input / ring
success / success-foreground
warning / warning-foreground
info / info-foreground
```

- 본문과 배경은 WCAG AA 수준의 대비를 확보한다.
- 상태를 빨강과 초록 같은 색상만으로 구분하지 않는다.
- 오류, 성공, 경고에는 아이콘 또는 텍스트 레이블을 함께 사용한다.
- Dark Theme에서도 의미 토큰의 역할을 변경하지 않는다.
- 표와 대시보드 숫자는 우측 정렬하고 `tabular-nums`를 적용한다.

## 9. 아이콘

- Lucide만 기본 아이콘 라이브러리로 사용한다.
- 기본 크기는 16px, 주요 작업은 18px, 빈 상태·안내는 24~32px로 한다.
- 기본 선 굵기는 2를 유지한다.
- 아이콘과 텍스트 사이 간격은 6~8px로 한다.
- 의미가 같은 기능에는 모든 프로젝트에서 같은 아이콘을 사용한다.
- 장식 아이콘에는 `aria-hidden="true"`를 적용한다.
- 아이콘 전용 버튼에는 한국어 `aria-label`을 제공한다.
- 삭제·경고 기능을 아이콘만으로 표현하지 않는다.

```tsx
<Button size="icon" variant="ghost" aria-label="프로젝트 삭제">
  <Trash2 aria-hidden="true" />
</Button>
```

## 10. 컴포넌트 사용 규칙

### 10.1 버튼

- 화면의 주요 행동은 한 영역에 하나만 `primary`로 표시한다.
- 취소는 기본 또는 Ghost, 삭제는 Destructive를 사용한다.
- 링크 이동에는 Button 대신 Link를 사용한다.
- 요청 시작 후 중복 실행을 방지하고 진행 상태를 표시한다.

### 10.2 폼

- 모든 입력에 화면에 보이는 Label을 제공한다.
- Placeholder를 Label 대용으로 사용하지 않는다.
- 입력에는 의미 있는 `name`, 올바른 `type`, `inputmode`, `autocomplete`를 설정한다.
- 오류는 해당 필드 가까이에 표시하고 해결 방법을 포함한다.
- 제출 실패 시 첫 오류 필드로 포커스를 이동한다.
- 이메일, 인증 코드, 사용자 ID에는 필요에 따라 맞춤법 검사를 비활성화한다.
- 붙여넣기를 차단하지 않는다.

### 10.3 Dialog와 삭제

- 파괴적 작업은 확인 Dialog 또는 실행 취소 시간을 제공한다.
- 확인 버튼에는 `확인` 대신 `프로젝트 삭제`처럼 실제 행동을 표시한다.
- 모달이 열리면 키보드 포커스를 내부에 유지하고 닫힌 뒤 실행 버튼으로 복귀시킨다.

### 10.4 표와 목록

- 표는 의미상 표 형식인 데이터에만 사용한다.
- 숫자와 통화는 오른쪽, 텍스트는 왼쪽 정렬한다.
- 50개를 넘는 대형 목록은 페이지네이션 또는 가상화를 적용한다.
- 필터, 정렬, 탭, 페이지는 가능한 경우 URL과 동기화한다.
- 데이터가 없을 때 빈 화면 대신 한국어 Empty State를 표시한다.

### 10.5 상태와 알림

- 상태 Badge에는 `진행 중`, `완료`, `실패`처럼 한국어 레이블을 제공한다.
- Toast와 비동기 결과에는 `aria-live="polite"`를 적용한다.
- 오류 메시지는 원인과 사용자가 취할 다음 행동을 포함한다.

## 11. 접근성

- 동작에는 `<button>`, 이동에는 `<a>` 또는 Router Link를 사용한다.
- 클릭 가능한 `<div>`와 `<span>`을 만들지 않는다.
- 모든 상호작용 요소에 키보드 접근과 보이는 `focus-visible` 상태를 제공한다.
- 대체 포커스 표현 없이 `outline: none`을 사용하지 않는다.
- 이미지에는 목적에 맞는 `alt`와 명시적인 크기를 제공한다.
- 제목은 `h1`부터 순서대로 구성하고 본문 바로가기 링크를 제공한다.
- 애니메이션은 `prefers-reduced-motion`을 존중한다.
- 모바일 확대를 차단하지 않는다.
- 날짜, 숫자, 통화는 `Intl` API와 `ko-KR` 로케일을 사용한다.

```ts
new Intl.DateTimeFormat("ko-KR", {
  year: "numeric",
  month: "long",
  day: "numeric",
}).format(date)

new Intl.NumberFormat("ko-KR", {
  style: "currency",
  currency: "KRW",
  maximumFractionDigits: 0,
}).format(amount)
```

## 12. 모션

- 애니메이션은 기능과 상태 변화 설명에 필요한 경우만 사용한다.
- 기본 지속시간은 100~200ms, 큰 화면 전환은 200~300ms 이내로 한다.
- `transition: all`을 사용하지 않고 속성을 명시한다.
- 성능을 위해 `transform`과 `opacity` 중심으로 구성한다.
- 진행 중 애니메이션은 사용자 입력으로 중단할 수 있어야 한다.

## 13. 반응형 기준

- 모바일 우선으로 설계한다.
- 작은 화면에서도 주요 행동과 상태를 숨기지 않는다.
- 데스크톱 표를 모바일에서 무조건 가로 축소하지 않는다. 카드형 목록, 핵심 열 우선 표시, 가로 스크롤 중 적합한 방식을 선택한다.
- Hover에만 의존하는 정보나 동작을 만들지 않는다.
- 모바일에서 자동 포커스를 남용하지 않는다.
- Safe Area가 있는 기기에서 전체 화면 UI는 `env(safe-area-inset-*)`를 반영한다.

## 14. 디자인 검토 체크리스트

### 현지화

- [ ] 모든 사용자 노출 UI가 한국어인가?
- [ ] 영어 placeholder와 미번역 상태 코드가 남아 있지 않은가?
- [ ] 이름, 전화번호, 주소, 통화, 날짜가 한국형 예시인가?
- [ ] 날짜·숫자·통화에 `Intl`과 `ko-KR`을 사용하는가?

### 일관성

- [ ] Radix UI, Vega, Lucide 조합을 유지하는가?
- [ ] 의미 기반 색상 토큰만 사용하는가?
- [ ] 버튼, 입력, Dialog, Badge의 변형을 임의로 추가하지 않았는가?
- [ ] 4px 간격 체계와 타이포그래피 체계를 따르는가?

### 접근성

- [ ] 모든 입력에 Label이 있는가?
- [ ] 아이콘 버튼에 한국어 `aria-label`이 있는가?
- [ ] 키보드 포커스가 명확하게 보이는가?
- [ ] 색상 이외의 상태 식별 수단이 있는가?
- [ ] 오류 메시지에 수정 방법이 포함되는가?
- [ ] 파괴적 작업에 확인 또는 실행 취소가 있는가?

### 반응형과 콘텐츠

- [ ] 모바일 조작 영역이 최소 44px인가?
- [ ] 긴 한국어 텍스트와 빈 데이터 상태를 처리하는가?
- [ ] 표와 목록이 작은 화면에서도 사용할 수 있는가?
- [ ] 불필요한 홍보 문구와 반복 도움말이 없는가?

## 15. 운영 및 버전 관리

- 공식 shadcn/ui 저장소는 참조용 upstream으로 유지한다.
- Bloom 표준은 별도의 공통 Registry 또는 Starter Template으로 관리한다.
- 프로젝트는 필요한 컴포넌트 코드만 가져오되 토큰과 사용 규칙은 공통 표준을 따른다.
- upstream 업데이트는 자동 반영하지 않고 변경점, 접근성, 한국어 레이아웃을 검토한 뒤 반영한다.
- 표준 예외는 프로젝트 문서에 사유, 영향, 종료 조건을 기록한다.
- 이 문서는 `project_control` 저장소(`https://github.com/mohenz/project-control.git`)의 `design/` 아래에서 버전 관리된다. 다른 PC·에이전트는 이 저장소를 clone/pull하면 최신 표준을 받는다.

## 16. 참조 경로

- 이 저장소 안의 문서: `project_control/design/bloom_ui_design_standard.md`(이 문서), `project_control/design/bloom_ui_design_process.md`(설계·검증 실행 절차)
- shadcn/ui 로컬 저장소(머신별로 직접 clone, 저장소에는 포함하지 않음): `D:\Workspace\shadcn-ui` ← `git clone https://github.com/shadcn-ui/ui.git`
  - 기반 정의: `apps\v4\registry\bases.ts`
  - Vega 스타일: `apps\v4\registry\styles\style-vega.css`
  - 아이콘 정의: `packages\shadcn\src\icons\libraries.ts`
  - 글꼴 정의: `apps\v4\lib\font-definitions.ts`
- 보조 구현 레퍼런스·검증 도구(머신별로 직접 clone, 저장소에는 포함하지 않음): `D:\Workspace\ui-ux-pro-max-skill` ← `git clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git` (shadcn 컴포넌트 카탈로그, 토큰 하드코딩 검증 스크립트만 사용 — 스타일/팔레트 추천 기능은 `bloom_ui_design_process.md` 2장에 따라 사용 금지)
