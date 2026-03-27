# 프로젝트 선택/전환 Command Prompt 규격

## 목적
- 프로젝트 전환과 작업 요청을 자연어 문장 대신 command 스타일로 통일합니다.
- 사용자는 아래 command 형식으로만 요청해도 됩니다.

---

## 1. 기본 규칙

- 모든 command는 `project_control` 기준으로 해석합니다.
- 프로젝트 식별자는 `project_registry.md`의 `aliases` 기준으로 매핑합니다.
- command는 한 줄로 요청합니다.
- 권장 접두어는 `/project` 입니다.

---

## 2. 기본 문법

```text
/project <action> <project_alias> [options]
```

예:
```text
/project use n8n
```

```text
/project use "defect manage"
```

---

## 3. 핵심 Command 세트

### 3-1. 프로젝트 전환
```text
/project use n8n
```

```text
/project use "defect manage"
```

```text
/project use auth_pro
```

### 3-2. 프로젝트 전환 + 상태 요약
```text
/project use n8n --summary
```

```text
/project use "defect manage" --summary
```

### 3-3. 프로젝트 전환 + 최소 점검
```text
/project use n8n --check
```

```text
/project use "defect manage" --check
```

### 3-4. 프로젝트 전환 + 바로 작업 시작
```text
/project use n8n --do "메일 발송 워크플로우 점검"
```

```text
/project use "defect manage" --do "결함 목록 필터 개선"
```

```text
/project use auth_pro --do "로그인 UI 수정"
```

---

## 4. 상태/기록 Command

### 4-1. 현재 상태 확인
```text
/project status n8n
```

```text
/project status "defect manage"
```

### 4-2. 상태 파일 갱신
```text
/project update n8n --done "워크플로우 점검 완료" --next "Gmail credential 확인"
```

```text
/project update "defect manage" --done "대시보드 쿼리 튜닝 반영" --next "배포본 확인"
```

### 4-3. 작업 종료 기록
```text
/project close n8n --done "수정 완료" --verify "manual check" --next "운영 배치 확인"
```

```text
/project close "defect manage" --done "배포 완료" --verify "syntax,test,deploy" --next "추가 개선 대기"
```

---

## 5. 작업 유형별 Command

### 5-1. 기능 개선
```text
/project improve "defect manage" --task "결함 조치 현황 UX 개선"
```

```text
/project improve n8n --task "메일 템플릿 개선"
```

### 5-2. 버그 수정
```text
/project fix "defect manage" --task "조치결과 저장 후 이동 오류 수정"
```

```text
/project fix n8n --task "첨부파일 누락 문제 수정"
```

### 5-3. 신규 작업 시작
```text
/project start n8n --task "신규 리포트 분기 추가"
```

```text
/project start auth_pro --task "회원가입 화면 구현"
```

### 5-4. 배포
```text
/project deploy "defect manage"
```

```text
/project deploy n8n
```

---

## 6. 신규 프로젝트 등록 Command

```text
/project register sales_portal --path "D:\Workspace\sales_portal" --aliases "sales,sales portal"
```

```text
/project register project_04 --path "D:\Workspace\project_04" --aliases "p4,project4"
```

---

## 7. 현재 권장 Command 목록

### defect_manage
```text
/project use "defect manage"
/project use "defect manage" --summary
/project use "defect manage" --do "작업내용"
/project status "defect manage"
/project deploy "defect manage"
```

### n8n_defect_automation
```text
/project use n8n
/project use n8n --summary
/project use n8n --do "작업내용"
/project status n8n
/project deploy n8n
```

### auth_pro
```text
/project use auth_pro
/project use auth_pro --summary
/project use auth_pro --do "작업내용"
/project status auth_pro
```

---

## 8. 에이전트 내부 해석 규칙

### `/project use <alias>`
- 레지스트리에서 프로젝트 식별
- 상태 파일 로드
- 필요 시 최소 점검 수행
- 이후 해당 프로젝트 기준으로 문맥 고정

### `/project use <alias> --summary`
- 상태 파일 요약
- 최근 완료 작업, 현재 목표, 다음 작업 출력

### `/project use <alias> --check`
- 경로, 저장소 상태, 핵심 문서, 실행 포인트 점검

### `/project use <alias> --do "<task>"`
- 상태 복구 후 바로 해당 작업 시작

### `/project update <alias> ...`
- 상태 파일 갱신 요청으로 해석

### `/project deploy <alias>`
- 상태 파일에 등록된 배포 방식을 우선 적용

---

## 9. 가장 짧게 쓰는 추천 Command

```text
/project use n8n
```

```text
/project use "defect manage" --do "작업내용"
```

```text
/project status auth_pro
```
