# Project State

## 기본 정보
- project_key: `schedule_manager`
- last_updated: `2026-07-23`
- owner_request: `D:\workspace\프로젝트일정관리_Detail_초안.xlsx 를 분석해 CRUD와 wizard 관리가 가능한 프로젝트 일정관리 프로그램을 만들어달라`
- current_status: `1차 구현 완료 (로컬 개발/빌드 검증 완료, 배포 전)`

## 현재 목표
- 엑셀 원본(이벤트/일단위 시트)에서 추출한 단계-마일스톤-일별 태스크-트랙 구조를 CRUD로 관리한다.
- 신규 프로젝트 생성과 태스크 추가를 마법사(Wizard) 흐름으로 처리한다.

## 진행 중 작업
- 없음 (1차 스코프 완료)

## 최근 완료 작업
- 데이터 모델 설계: projects → phases(9단계) → tasks(마일스톤 21개 + 일별 태스크 143개, 트랙 7개: 보고/품질/개발/보안/성능테스트/아키텍쳐인프라/오픈준비) → holidays(데이 마커 49개)
- `D:\workspace\프로젝트일정관리_Detail_초안.xlsx`를 파이썬(openpyxl)으로 파싱해 `lib/seedData.json` 생성 (연속 일자·동일 내용 태스크는 기간으로 병합)
- Next.js App Router 기반 CRUD API 전체 구현 (`/api/projects`, `/phases`, `/tracks`, `/tasks`, `/holidays`)
- 신규 프로젝트 생성 마법사(`/projects/new`: 기본정보→단계→트랙→검토/생성), 태스크 추가 마법사(`/projects/[id]/tasks/new`: 유형/분류→기간→상세→검토/생성) 구현
- 프로젝트 상세(단계 타임라인 바 차트), 일별 태스크 테이블(필터+인라인 수정) 화면 구현
- DB: 최초 `better-sqlite3` 채택 시도했으나 이 환경에 Visual Studio Build Tools가 없어 네이티브 빌드 실패 → Node 24 내장 실험적 모듈 `node:sqlite`(`DatabaseSync`)로 전환
- `node:sqlite`가 null-prototype row 객체를 반환해 React Server Component → Client Component 직렬화 시 500 에러 발생 → `lib/db.js`에서 `prepare().get()/all()` 결과를 plain object로 변환하는 래퍼 추가로 해결
- `npm run build` 성공, `npm run seed` 로 샘플 프로젝트 시딩 성공, 전체 화면(홈/상세/태스크/마법사 2종) 200 응답 확인, API 경유 CRUD(생성/수정/삭제) 및 한글 인코딩 왕복 확인 완료

## 다음 작업
- (선택) 공휴일/월력 뷰, 주단위·월단위 집계 화면(원본 엑셀의 빈 시트) 추가 여부 확인
- (선택) 다중 사용자/배포 필요 시 DB를 Supabase 등으로 교체할지 결정
- 사용자 실사용 피드백에 따라 UI/필드 조정

## 실행 / 검증
- run_command: `npm.cmd run dev` (포트 3000)
- verify_command: `npm.cmd run build`
- seed_command: `npm.cmd run seed`
- port_or_runtime: `port: 3000 / Node.js (node:sqlite 실험적 기능 사용, Node 22+ 필요)`
- deploy_method: `미배포 (로컬 전용). 배포 시 Node 서버리스/서버 런타임 필요 - Edge 런타임 불가`

## 핵심 경로
- project_root: `D:\workspace\project_emart\schedule_manager`
- key_docs: `README.md`
- key_files: `lib/db.js`, `lib/repo.js`, `lib/seedData.json`, `scripts/seed.js`, `app/projects/new/page.js`, `app/components/TaskWizard.js`

## 리스크 / 주의사항
- `node:sqlite`는 Node.js의 실험적(Experimental) 기능이라 향후 Node 버전에서 API가 바뀔 수 있다. 안정화되면 재검토 필요.
- 이 환경(Windows, VS Build Tools 미설치)에서는 `better-sqlite3` 등 네이티브 모듈 설치가 실패하므로, 이 프로젝트에 한해서는 순수 JS/내장 모듈 우선 원칙을 유지해야 한다.
- `project_emart` 폴더 자체는 이마트 앱 IA 분석 문서 모음이며, `schedule_manager`는 그 하위의 독립적인 도구(사용자 지정 배치)이지 이마트 앱 분석 작업물이 아니다. 혼동 주의.

## 인수인계 메모
- 다음 시작 시 먼저 볼 것: `D:\workspace\project_emart\schedule_manager\README.md`, `D:\workspace\project_emart\schedule_manager\lib\db.js`, 본 상태 파일
- 확인이 필요한 미결사항: 주단위/월단위 집계 화면 필요 여부, 배포(호스팅) 필요 여부와 그 경우 DB 교체 방향
