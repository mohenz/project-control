# 📔 지안의 비밀 일기장 (Diary) 구현 계획

브라이언의 요청에 따라 기존 '일정' 기능을 대체하는 **감성 일기장** 기능을 구현합니다.

## 1. 기능 명세
- **진입:** 프로필 화면의 '달력' 아이콘 클릭 시 일기장 목록/작성 화면으로 이동.
- **날씨 & 기분:**
    - OpenWeatherMap API를 사용하여 현재 위치의 날씨(이모티콘, 기온) 자동 표시.
    - 5~6가지 기분 이모티콘 중 선택 가능.
- **내용 작성:**
    - 200자 제한 텍스트 에어리어.
    - 보안: 입력값 HTML 이스케이프 및 길이 검증 (SQL Injection 방지).
- **사진 & 위치:**
    - 카메라 촬영 또는 갤러리 업로드 (최대 5장).
    - 브라우저 Geolocation API + **Kakao Map API**로 촬영 장소 주소 자동 변환 (Reverse Geocoding).
    - 사진은 Supabase Storage (`diary-images`)에 저장.

## 2. 데이터베이스 설계 (Supabase)

### `diaries` 테이블
| 필드명 | 타입 | 설명 |
| :--- | :--- | :--- |
| `id` | uuid | PK |
| `user_id` | uuid | 작성자 (지안/브라이언) |
| `date` | date | 일기 날짜 |
| `weather` | jsonb | 날씨 정보 (icon, temp, description) |
| `mood` | string | 기분 이모티콘 |
| `content` | text | 일기 내용 (200자 제한) |
| `location` | string | 장소 주소 (**Kakao Maps 연동**) |
| `images` | text[] | 이미지 URL 배열 (최대 5개) |
| `created_at` | timestamp | 생성일 |

## 3. 필요 API 및 키
구현을 위해 아래 API 키가 필요합니다. `.env` 파일에 추가해야 합니다.
1.  **VITE_KAKAO_MAP_API_KEY**: 주소 변환용 (확인 완료).
2.  **VITE_OPENWEATHER_API_KEY**: 날씨 정보용 (확인 완료).

## 4. 보안 대책 (Security)
- **SQL Injection:** Supabase Client(ORM) 사용으로 1차 방어 + 입력값 검증 로직 추가.
- **XSS:** React의 기본 이스케이프 기능 + 텍스트 렌더링 시 위험한 태그 필터링.
- **파일 업로드:** 이미지 파일(jpg, png)만 허용하고 용량 제한 적용.

---
이 계획대로 바로 구현을 시작해도 될까요? 
(API 키가 없으면 일단 더미 데이터로 UI부터 완성해 드릴 수도 있습니다!)






