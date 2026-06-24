# 프로젝트 표준 개발 프로세스

모든 프로젝트에서 적용해야 하는 필수 표준 프로세스입니다.

---

## 📋 필수 적용 사항

### 1. Context7 활용 ✅

프로젝트 시작 시 Context7 MCP를 활용하여 공식 문서를 참조합니다.

**사용 방법**:
```
use context7 [라이브러리@버전]
```

**예시**:
```
use context7 react@18, playwright@1.40
use context7 vue@3, express@4
use context7 next@14, tailwindcss@3
```

**장점**:
- 📚 최신 공식 문서 참조
- ✅ 정확한 API 사용법 확인
- 🚀 개발 속도 향상
- 🐛 오류 감소

---

### 2. Playwright 테스트 자동화 ✅

모든 프로젝트에 E2E 테스트를 구현하고 상세한 결과 보고서를 작성합니다.

**테스트 위치**:
```
D:\workspace\playwright\[프로젝트명]\
```

**필수 구성 요소**:
- ✅ 한글 테스트 파일 작성
- ✅ 테스트 결과 보고서 작성
- ✅ 실패 항목 상세 분석
- ✅ 개선 방안 제시
- ✅ 스크린샷/비디오 첨부

---

## 🔄 표준 작업 플로우

```
1. 프로젝트 시작
   ↓
2. use context7 [라이브러리@버전]
   - 사용할 라이브러리의 공식 문서 로드
   ↓
3. 개발 진행
   - Context7 참조하며 코드 작성
   ↓
4. Playwright 테스트 작성
   - 한글 파일명으로 테스트 작성
   - D:\workspace\playwright\[프로젝트명]\ 에 저장
   ↓
5. 테스트 실행
   - npm test
   ↓
6. 결과 분석 및 보고서 작성
   - 통과/실패/스킵 집계
   - 실패 원인 분석
   - 개선 방안 도출
   ↓
7. 실패 항목 수정
   - 수정 코드 작성
   - 재테스트
   ↓
8. 최종 검증
   - 100% 통과 목표
```

---

## 📁 표준 디렉토리 구조

### 프로젝트 루트
```
D:\workspace\
├── [프로젝트명]/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── README.md
└── playwright/
    └── [프로젝트명]/
        ├── tests/
        ├── playwright.config.js
        ├── package.json
        └── 테스트_결과_보고서.md
```

### Playwright 테스트 구조
```
D:\workspace\playwright\[프로젝트명]/
├── tests/
│   ├── e2e/
│   │   ├── 초기_로딩.spec.js
│   │   ├── 생성_기능.spec.js
│   │   ├── 조회_기능.spec.js
│   │   ├── 수정_기능.spec.js
│   │   ├── 삭제_기능.spec.js
│   │   └── UI_상호작용.spec.js
│   └── fixtures/
│       └── 테스트_데이터.js
├── playwright.config.js
├── package.json
├── 테스트_결과_보고서.md
└── test-results/
    ├── html/
    ├── results.json
    └── screenshots/
```

---

## 📝 테스트 결과 보고서 필수 항목

### 1. 전체 테스트 결과 요약
```markdown
**총 테스트 수**: XX개
**통과**: XX개 ✅
**실패**: XX개 ❌
**스킵**: XX개 ⏭️
**통과율**: XX%
**실행 시간**: X분 X초
```

### 2. 통과한 테스트 목록
- 카테고리별로 그룹화
- 각 테스트 이름 명시

### 3. 실패한 테스트 상세 분석

각 실패 테스트마다 다음 항목 포함:

**필수 항목**:
- ❌ **테스트 이름**
- 📁 **파일 위치**
- 🐛 **실패 원인**: 상세한 원인 분석
- 📋 **에러 메시지**: 실제 에러 메시지
- 💡 **개선 방안**: 즉시 개선 + 장기 개선
- 💻 **수정된 코드**: 실제 수정 코드 예시

**예시**:
```markdown
### 1. Supabase 연결 상태 표시
**파일**: `초기_로딩.spec.js`

**실패 원인**:
- Supabase 연결이 10초 내에 완료되지 않음
- config.js 파일 미설정

**에러 메시지**:
```
Timeout 10000ms exceeded
```

**개선 방안**:
1. 즉시 개선: 타임아웃 15초로 증가
2. 장기 개선: 모킹 레이어 추가

**수정된 코드**:
```javascript
// 수정 전
await expect(연결_상태).toContainText('연결됨', { timeout: 10000 });

// 수정 후
await expect(연결_상태).toContainText('연결됨', { timeout: 15000 });
```
```

### 4. 성능 메트릭
- 평균 테스트 시간
- 가장 빠른/느린 테스트
- 총 실행 시간

### 5. 크로스 브라우저 테스트 결과
- Chromium, Firefox, WebKit 결과

### 6. 개선 권장사항
- 즉시 적용 가능한 개선사항
- 장기 개선사항

---

## 🎯 테스트 작성 가이드

### 한글 파일명 규칙
```
기능명.spec.js
```

**예시**:
- `초기_로딩.spec.js`
- `생성_기능.spec.js`
- `조회_기능.spec.js`
- `수정_기능.spec.js`
- `삭제_기능.spec.js`
- `UI_상호작용.spec.js`

### 한글 변수명 사용
```javascript
const 테스트_데이터 = {
  제목: 'Playwright 테스트',
  설명: 'E2E 테스트 자동화'
};

test('항목 추가', async ({ page }) => {
  const 항목_수 = await page.locator('.item').count();
  expect(항목_수).toBeGreaterThan(0);
});
```

### 테스트 구조
```javascript
import { test, expect } from '@playwright/test';

test.describe('기능 그룹', () => {
  test.beforeEach(async ({ page }) => {
    // 초기 설정
  });

  test('테스트 케이스 1', async ({ page }) => {
    // 테스트 로직
  });

  test('테스트 케이스 2', async ({ page }) => {
    // 테스트 로직
  });
});
```

---

## 🛠️ Playwright 설정

### playwright.config.js 기본 템플릿

```javascript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { outputFolder: 'test-results/html' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['list']
  ],
  
  use: {
    baseURL: 'http://localhost:포트번호',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
```

### package.json 스크립트

```json
{
  "scripts": {
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:report": "playwright show-report test-results/html"
  }
}
```

---

## 📊 품질 기준

### 테스트 통과율 목표
- 🎯 **목표**: 100%
- ⚠️ **최소**: 80%
- ❌ **불합격**: 70% 미만

### 코드 커버리지
- 주요 기능 100% 커버
- UI 상호작용 포함
- 에러 처리 시나리오 포함

---

## ✅ 체크리스트

프로젝트 시작 시:
- [ ] Context7 MCP 활성화
- [ ] 사용 라이브러리 버전 확인
- [ ] `use context7` 명령어 실행

개발 중:
- [ ] Context7 문서 참조하며 코드 작성
- [ ] 주요 기능 완성 시마다 테스트 작성

개발 완료 후:
- [ ] Playwright 테스트 디렉토리 생성
- [ ] 모든 기능에 대한 테스트 작성
- [ ] 테스트 실행 및 결과 확인
- [ ] 테스트 결과 보고서 작성
- [ ] 실패 항목 분석 및 수정
- [ ] 최종 검증 (80% 이상 통과)

---

## 📚 참고 문서

- [Context7 MCP 설정 가이드](./CONTEXT7_MCP_SETUP.md)
- [Playwright 테스트 가이드](./youtube-summarizer/TESTING_GUIDE.md)
- [GitHub MCP 설정 가이드](./GITHUB_MCP_SETUP.md)

---

## � UI/UX 디자인 표준

### 디자인 원칙
- ✅ **프리미엄 디자인**: 사용자를 WOW하게 만드는 첫인상
- ✅ **다크 모드 우선**: 눈에 편한 다크 테마 기본 적용
- ✅ **반응형 디자인**: 모바일/태블릿/데스크톱 모두 지원
- ✅ **마이크로 인터랙션**: 부드러운 애니메이션 및 전환 효과

### 필수 적용 요소
```css
/* 색상 팔레트 */
- 기본 배경: 다크 그라디언트
- 강조 색상: 생동감 있는 그라디언트 (예: 보라-파랑, 주황-분홍)
- 텍스트: 고대비 색상으로 가독성 확보

/* 효과 */
- Glassmorphism: 반투명 유리 효과
- 그라디언트: 생동감 있는 색상 조합
- 그림자: 깊이감 있는 box-shadow
- 호버 효과: transform, scale 활용
```

### 타이포그래피
- **폰트**: Google Fonts (Inter, Roboto, Outfit 등)
- **크기**: 계층적 구조 (h1 > h2 > h3 > p)
- **가독성**: 충분한 line-height 및 letter-spacing

### 금지 사항
- ❌ 기본 브라우저 스타일 사용
- ❌ 단조로운 색상 (순수 빨강, 파랑, 초록)
- ❌ 플레이스홀더 이미지 사용 (generate_image 도구 활용)

---

## 📖 문서화 표준

### README.md 필수 항목
```markdown
# 프로젝트명

## 개요
- 프로젝트 설명
- 주요 기능

## 기술 스택
- Frontend/Backend 기술
- 데이터베이스
- 배포 환경

## 시작하기
### 사전 요구사항
### 설치 방법
### 실행 방법

## 사용 방법
- 스크린샷 포함
- 주요 기능 설명

## 테스트
- 테스트 실행 방법
- 테스트 결과 링크

## 배포
- 배포 방법
- 환경 변수 설정

## 라이선스
```

### 코드 주석 규칙
```javascript
// ✅ 좋은 주석: 왜(Why)를 설명
// 사용자 경험 향상을 위해 300ms 디바운스 적용
const debouncedSearch = debounce(handleSearch, 300);

// ❌ 나쁜 주석: 무엇(What)을 반복
// 검색 함수 호출
handleSearch();
```

### 커밋 메시지 규칙
```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅, 세미콜론 누락 등
refactor: 코드 리팩토링
test: 테스트 코드 추가/수정
chore: 빌드 업무, 패키지 매니저 설정 등

예시:
feat: Playwright 테스트 자동화 추가
fix: Supabase 연결 타임아웃 이슈 해결
docs: README에 설치 가이드 추가
```

---

## 🔧 코드 품질 표준

### 코드 스타일
- ✅ **일관성**: ESLint/Prettier 설정 사용
- ✅ **가독성**: 명확한 변수명, 함수명
- ✅ **모듈화**: 단일 책임 원칙 (SRP)
- ✅ **재사용성**: 공통 로직은 유틸리티 함수로 분리

### 변수명 규칙
```javascript
// ✅ 좋은 변수명
const 사용자_목록 = [];
const isLoading = false;
const handleSubmit = () => {};

// ❌ 나쁜 변수명
const data = [];
const flag = false;
const func = () => {};
```

### 함수 작성 원칙
```javascript
// ✅ 단일 책임 원칙
function 사용자_데이터_가져오기() {
  // 데이터 가져오기만 수행
}

function 사용자_데이터_표시() {
  // 표시만 수행
}

// ❌ 여러 책임
function 사용자_처리() {
  // 가져오기, 표시, 저장 모두 수행
}
```

### 에러 처리
```javascript
// ✅ 명확한 에러 처리
try {
  const data = await fetchData();
  return data;
} catch (error) {
  console.error('데이터 조회 실패:', error);
  showToast('데이터를 불러올 수 없습니다.', 'error');
  throw error;
}

// ❌ 에러 무시
try {
  await fetchData();
} catch (error) {
  // 아무것도 하지 않음
}
```

---

## 🌿 Git 워크플로우

### 브랜치 전략
```
main (또는 master)
  ├── develop
  │   ├── feature/기능명
  │   ├── fix/버그명
  │   └── test/테스트명
  └── hotfix/긴급수정명
```

### 브랜치 명명 규칙
```
feature/playwright-test-automation
fix/supabase-connection-timeout
test/e2e-crud-operations
hotfix/critical-security-patch
```

### Pull Request 규칙
- ✅ 명확한 제목 및 설명
- ✅ 관련 이슈 번호 연결
- ✅ 스크린샷/비디오 첨부 (UI 변경 시)
- ✅ 테스트 결과 포함
- ✅ 리뷰어 지정

---

## 🚀 배포 및 실행 표준

### 실행 스크립트
모든 프로젝트에 간편한 실행 스크립트 제공:

**Windows**: `start.bat`
```batch
@echo off
echo ================================
echo   프로젝트명 시작
echo ================================
echo.
echo 서버를 시작합니다...
npm run dev:all
```

**Linux/Mac**: `start.sh`
```bash
#!/bin/bash
echo "================================"
echo "   프로젝트명 시작"
echo "================================"
echo ""
echo "서버를 시작합니다..."
npm run dev:all
```

### 환경 변수 관리
```
.env.example  # 템플릿 (Git에 포함)
.env          # 실제 값 (Git에서 제외)
```

**.env.example**:
```
# API Keys
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_anon_key_here
GEMINI_API_KEY=your_gemini_key_here

# Server
PORT=3000
```

### package.json 스크립트 표준
```json
{
  "scripts": {
    "dev": "개발 서버 실행",
    "build": "프로덕션 빌드",
    "start": "프로덕션 서버 실행",
    "test": "테스트 실행",
    "lint": "린트 검사",
    "format": "코드 포맷팅"
  }
}
```

---

## 🔒 보안 표준

### API 키 관리
- ✅ 환경 변수 사용 (`.env` 파일)
- ✅ `.gitignore`에 `.env` 추가
- ✅ `.env.example` 제공
- ❌ 코드에 직접 하드코딩 금지

### 민감 정보 보호
```javascript
// ✅ 환경 변수 사용
const apiKey = process.env.GEMINI_API_KEY;

// ❌ 하드코딩
const apiKey = 'AIzaSyC...'; // 절대 금지!
```

### .gitignore 필수 항목
```
# 환경 변수
.env
.env.local

# 의존성
node_modules/

# 빌드 결과
dist/
build/

# 테스트 결과
test-results/
playwright-report/

# IDE 설정
.vscode/
.idea/

# OS 파일
.DS_Store
Thumbs.db
```

---

## 📦 의존성 관리

### package.json 정리
```json
{
  "dependencies": {
    // 프로덕션 필수 패키지만
  },
  "devDependencies": {
    // 개발/테스트 도구
    "@playwright/test": "^1.40.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  }
}
```

### 버전 관리
- ✅ 주요 버전 고정: `"react": "18.2.0"`
- ✅ 마이너 버전 허용: `"react": "^18.2.0"`
- ❌ 와일드카드 사용 금지: `"react": "*"`

---

## 🎬 프로젝트 완료 체크리스트

### 코드 품질
- [ ] ESLint 오류 0개
- [ ] Prettier 포맷팅 완료
- [ ] 콘솔 에러/경고 0개
- [ ] 미사용 코드 제거

### 테스트
- [ ] Playwright 테스트 80% 이상 통과
- [ ] 테스트 결과 보고서 작성
- [ ] 실패 항목 분석 및 개선 방안 문서화

### 문서화
- [ ] README.md 작성 완료
- [ ] 주요 함수/컴포넌트 주석 작성
- [ ] API 문서 작성 (해당 시)
- [ ] 실행 가이드 작성

### 배포 준비
- [ ] 환경 변수 설정 가이드
- [ ] .env.example 파일 제공
- [ ] start.bat / start.sh 스크립트 제공
- [ ] 빌드 테스트 완료

### 보안
- [ ] API 키 환경 변수화
- [ ] .gitignore 설정 확인
- [ ] 민감 정보 하드코딩 제거

---

## �🎯 목표

이 표준 프로세스를 통해:
- ✅ 코드 품질 향상
- ✅ 버그 조기 발견
- ✅ 개발 속도 향상
- ✅ 문서화 자동화
- ✅ 유지보수성 향상
- ✅ 보안 강화
- ✅ 팀 협업 효율성 증대

---

**작성일**: 2026-01-01  
**버전**: 2.0  
**적용 범위**: 모든 신규 및 기존 프로젝트  
**최종 업데이트**: 2026-01-01 22:44







