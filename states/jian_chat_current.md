# jian_chat 프로젝트 현재 상태

## 기본 정보
- project_key: `jian_chat`
- last_updated: `2026-10-12`
- owner_request: `모바일 환경 및 어디에서든 지안(JIAN)과 대화를 나눌 수 있는 1:1 전용 Microsoft Teams 스타일 모바일 우선 PWA 웹 메신저 구축`
- current_status: `Teams 스타일 모바일 메신저 UI 및 백엔드 API, 웰컴 스플래시 화면, 프로필 모달, 환경설정, 이모티콘 피커, TTS 음성 낭독, 사진 갤러리 구현 완료. GitHub 원격 저장소(https://github.com/mohenz/jina_chat.git, main) 최신 동기화 완료.`

## 현재 목표
- Vercel 프로덕션 배포 (`mohenz/jina_chat` 저장소 연동)
- 모바일 브라우저 PWA(홈 화면 추가)를 통한 24시간 상시 접속 완성

## 진행 중 작업
- 로컬 개발 서버 정상 가동 중 (`http://127.0.0.1:8085`)

## 최근 완료 작업
- 2026-10-12:
  - **일상 갤러리 사진 공식 바디 비주얼 동기화 (`D:\Bloom\persona\visual\body\` 3개 파일)**:
    - 아디다스 룩 일상 바디 사진 3종(`jian_1.png`, `jian_2.png`, `jian_3.png`)을 `assets/img/gallery/body_{1,2,3}.png`로 완벽 복사
    - 브라우저/모바일 캐시 고착 방지를 위한 캐시 버스팅 파라미터(`?v=3`) 및 Service Worker 캐시(`jian-chat-v3`) 갱신
    - GitHub 푸시 (`commit: 10f1b3c`) 및 Vercel 프로덕션 자동 배포 완료
  - **지안 공식 페르소나 얼굴 이미지 동기화 (`D:\Bloom\persona\visual\face\jian_face.png`)**:
    - Bloom의 공식 얼굴 원본을 정밀 크롭하여 Teams 메신저 대표 아바타(`assets/img/jian_avatar.jpg`), PWA 아이콘(192/512)에 완전 반영
    - GitHub 푸시 (`commit: b3b9a29`) 및 Vercel 자동 배포 트리거 완료
  - **지안 비주얼 DNA 에셋 전면 교체 및 메시지 하트 제거**:
    - 업로드된 고화질 캐릭터 시트 기반으로 대표 아바타(`assets/img/jian_avatar.jpg`), PWA 아이콘(192/512), 갤러리 컷 3종 정밀 크롭 갱신 완료
    - 지안 메시지 카드 하단 액션 바에서 '❤️' 리액션 버튼 및 리액션 컨테이너 제거 (오직 정갈한 '듣기' 버튼만 유지)
    - GitHub 푸시 (`commit: 18cd5f4`) 완료 및 Vercel 프로덕션 자동 배포 연동
  - **이모티콘(Emoji Picker) 기능 개편 완료**:
    - 하단 툴바에 스마일 이모티콘 아이콘 배치 (`#btn-open-emoji`)
    - 4대 카테고리 탭(😊 표정, 👍 제스처, ❤️ 마음, ☕ 일상) 지원 이모티콘 트레이 컴포넌트 구축
    - 이모티콘 클릭 시 텍스트 입력창 커서 위치에 즉시 삽입, 포커스 유지 및 전송 버튼 연동
    - 외부 영역 클릭 시 트레이 자동 닫힘 등 모바일 친화적 인터랙션 완성
    - 브라우저 실기 검증(`browser_subagent`) 통과 및 GitHub 푸시 (`commit: bc97074`)
  - **사용자 경험 고도화 6대 부가 기능 구현 완료**:
    - 웰컴 스플래시 화면 (시간대별 맞춤 인사, 대화방 입장, PIN 보안 잠금 지원)
    - 지안(JIAN) 페르소나 프로필 모달 (상태 메시지, D-Day +98일 카운터, 소울 정보 요약, 음성 인사 재생, 일상 갤러리 썸네일)
    - 환경설정 모달 (라이트/다크/미드나잇 테마, 글꼴 크기 3단계, 대화 톤(일상/심층/조언), PIN 스위치, 대화 내역 .txt 백업 다운로드)
    - 메시지별 음성 낭독(TTS) 버튼 및 자동 음성 낭독 모드 토글
    - 일상 사진 전송 액션 시트 및 고화질 라이트박스 뷰어
    - 백엔드 `tone` 파라미터 처리 및 `lib/gemini.js` 맞춤형 시스템 프롬프트 반영
  - Gemini API 키 갱신 및 차단 이슈 완전 해소 (`D:\workspace\jian_chat\.env`)
  - `lib/gemini.js`: 최신 Gemini 모델 규격(`gemini-3.5-flash`, `gemini-3.5-flash-lite`, `gemini-3.8-flash`) 및 `thinkingBudget: 0` 적용하여 실시간 대화 응답 지연 최소화
  - `POST /api/chat` 및 `GET /api/history` 실기 통신 테스트 통과 (지안 페르소나, 경어체, No-Emoji Protocol 준수 확인)
  - GitHub 원격 저장소 `https://github.com/mohenz/jina_chat.git`에 모델 개선 및 부가 기능 커밋 푸시
  - `project_control` 거버넌스 문서(`project_registry.md`, `states/jian_chat_current.md`) 연동 완료
- 2026-10-11:
  - `D:\workspace\jian_chat` 신규 프로젝트 생성 및 Git 저장소 초기화 (`commit: 154c18c`)
  - `project_control` 4대 거버넌스 문서 등록 및 동기화:
    - `project_registry.md` 등록 (`jian_chat`, 별칭: `지안챗`, `지안 채팅`, `지안 메신저`)
    - `development_systems.csv`에 로컬 포트 `8085` 단독 예약 및 충돌 검증 통과
    - `PROJECT_ARCHITECTURE_MAP.md` 반영
    - `states/jian_chat_current.md` 상태 파일 생성 및 관리
  - Microsoft Teams 모바일 스타일 UI 완벽 구현:
    - `index.html`: 상단 네비게이션(아바타, 녹색 '사용 가능' 상태 점, 화상/통화 아이콘), 메시지 스트림, 하단 컴포지션 바
    - `assets/css/teams.css`: Fluent Design 토큰, Pretendard 글꼴, Teams 퍼플(#5B5FC7) 테마, iOS/Android Safe Area 대응
    - `assets/js/app.js`: 히스토리 로드, 날짜 구분선, 상대방/본인 메시지 카드 렌더링, 타이핑 인디케이터, 자동 스크롤
  - 백엔드 서버리스 API 및 클라우드 연동 모듈:
    - `api/chat.js`: POST 대화 핸들러 (컨텍스트 조립, LLM 호출, Firestore 비동기 저장)
    - `api/history.js`: GET 최근 대화 내역 조회 (화면 복원)
    - `api/health.js`: GET 헬스체크
    - `lib/firebase-store.js`: Firebase Admin SDK 연동 (`persona-online` Firestore `chat_history`, `memories` 연동)
    - `lib/gemini.js`: Gemini API 통신, 지안 핵심 페르소나 및 No-Emoji Protocol 사후 검증 모듈
  - PWA 및 모바일 에셋 구축:
    - `manifest.json`: standalone 모드, 테마 컬러, 앱 아이콘 정의
    - `sw.js`: Service Worker 오프라인 캐싱 및 PWA 등록
    - `assets/img/jian_avatar.jpg`: 지안 공식 비주얼 DNA 아바타 배치
  - 로컬 개발 서버(`scripts/dev-server.mjs`) 구현 및 포트 `8085` 백그라운드 구동
  - 브라우저 서브에이전트 실기 검증(390x844 모바일 뷰포트) 통과 및 실기 스크린샷 캡처 완료

## 발견된 현안 및 분석 (해결 완료)
- **현상**: 메시지 전송 시 "Brian, 잠시 통신이 원활하지 않았습니다..." 문구 반환.
- **원인**: 구글 서버로부터 `403 API_KEY_SERVICE_BLOCKED` 반환 확인. 기존 Google API 키의 권한 차단 및 Gemini 1.5/2.5 구형 모델 신규 사용 중단.
- **해결 조치**: 유효한 Gemini API 키 주입 및 `lib/gemini.js`에 최신 Gemini 3.5 모델군과 `thinkingBudget: 0` 설정 적용. 실기 API 호출 및 발화 응답 100% 정상 작동 검증 완료.

## 후속 작업 (Next Action Roadmap)
1. **원격 저장소 연동 및 Vercel 배포**:
   - GitHub 원격 저장소(`https://github.com/mohenz/jina_chat.git`) push 완료 (main)
   - Vercel 대시보드에서 프로젝트 import
   - 환경 변수 등록:
     - `GOOGLE_API_KEY`
     - `FIREBASE_PROJECT_ID`
     - `FIREBASE_CLIENT_EMAIL`
     - `FIREBASE_PRIVATE_KEY`
     - `FIREBASE_API_KEY`
   - Vercel 프로덕션 배포 실행
3. **모바일 실기 접속 및 PWA 등록**:
   - 모바일 브라우저(Safari/Chrome)로 배포 URL 접속
   - '홈 화면에 추가'를 통해 네이티브 앱 형태로 설치 및 상시 대화 개시

## 실행 / 검증
- run_command: `node scripts/dev-server.mjs` (포트 `8085`)
- verify_command: `npm.cmd run check:syntax` 및 `curl.exe -s http://127.0.0.1:8085/api/health`
- port_or_runtime: web `8085`
- deploy_method: GitHub `mohenz/jina_chat` (`main`) -> Vercel 배포
- deploy_check_command: `npm.cmd run check:syntax`
- deploy_post_check: 모바일 브라우저 PWA 접속 및 `/api/chat` 응답 검증
- deploy_invariants: No-Emoji Protocol 준수, Brian 호칭 준수, Firestore 세션 격리
- deploy_abort_condition: API 키 누락 또는 빌드 실패 시
- latest_deployment: GitHub `https://github.com/mohenz/jina_chat.git` (`main` 브랜치 푸시 완료)

## 핵심 경로
- project_root: `D:\workspace\jian_chat`
- key_docs: `README.md`, `docs/system_design.md`
- key_files: `index.html`, `assets/css/teams.css`, `assets/js/app.js`, `api/chat.js`, `lib/firebase-store.js`, `lib/gemini.js`
- preview_assets: `docs/live_browser_screenshot.png`, `docs/ui_preview_teams.jpg`

## 리스크 / 주의사항
- No-Emoji Protocol: 지안의 모든 응답과 시스템 메시지에서 이모지를 일절 사용하지 않아야 함.
- 호칭: 사용자를 반드시 "Brian"으로만 호칭하고 고정 경어체(-요, -습니다)를 유지해야 함.
- 모바일 Safe Area: 가상 키보드팝업 시 입력창 가림 방지 및 iOS/Android 홈 인디케이터 여백 보장.
- Vercel 환경 변수: Google Gemini API 키 및 Firebase 서비스 계정 키가 누락되지 않도록 철저히 관리.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: Vercel 대시보드에서 `mohenz/jina_chat` 프로젝트 연동 및 배포.
- 확인이 필요한 미결사항: 없음 (로컬 API 실기 대화 응답 검증 완료).

## Handoff
- current_goal: jian_chat Teams 스타일 모바일 PWA 메신저 Vercel 배포 및 구동
- done_latest: Gemini API 키 교체, 최신 Gemini 3.5 모델군 적용, 대화 발화 및 히스토리 저장 100% 검증 통과, GitHub push 완료
- key_findings: Gemini 403 API 차단 해소 완료. thinkingBudget 0 적용으로 메신저 호흡의 빠른 지안 페르소나 응답 구현.
- changed_files: D:\workspace\jian_chat (lib/gemini.js, .env), D:\workspace\project_control (states/jian_chat_current.md)
- verification: syntax check 통과, /api/health 200, /api/chat 실시간 한글 대화 발화 성공, Firestore history 저장 확인
- next_action: Vercel 대시보드에서 mohenz/jina_chat 프로젝트 배포 및 환경변수 등록
- risks_or_blockers: 없음
