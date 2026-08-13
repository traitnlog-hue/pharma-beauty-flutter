# PHARMA BEAUTY — Flutter

피부 고민과 성분을 중심으로 제품을 탐색하는 반응형 Flutter 프로토타입입니다.

## 2026 Visual Direction

- Bio-digital editorial: 임상적 신뢰감 위에 바이올렛·사이안 신호 컬러 적용
- Material 3 Expressive 기반의 강한 타이포, 유연한 곡률, 명확한 상태 표현
- 기능 레이어에만 제한적으로 적용한 반투명 플로팅 내비게이션
- Ingredient Pulse: 성분 백과를 실시간 트렌드 점수·상승률·궁합 피드로 재구성
- 앱에 내장된 Noto Sans KR 가변 폰트로 Web·Android 한글 품질 통일

## 포함된 흐름

- 홈과 피부 고민 선택
- 맞춤 상품 추천
- 고민·카테고리·성분·브랜드별 SHOP 필터
- 성분 백과사전과 함께 쓰기 좋은/주의 성분 정보
- AM·PM 루틴 등록과 성분 충돌 체크
- 전문가 노트
- 3단계 Skin Profile
- Skin Profile 수정과 개인 대시보드
- 저장한 제품과 최근 본 제품
- 추천 결과와 추천 근거
- 상품 상세
- 최대 3개 상품 비교
- 모바일 하단 내비게이션
- 태블릿·웹 반응형 레이아웃

## 실행

Flutter SDK 3.47.0과 Android·Web 플랫폼 파일이 준비되어 있습니다. 새 터미널을 연 뒤 이 폴더에서 실행하세요.

```bash
flutter pub get
flutter run -d chrome
flutter run -d <android-device-id>
```

Flutter 3.47.0, Android Studio, Android SDK 36, NDK 28.2가 설치되어 있습니다.
현재 정적 분석, 단위·위젯 테스트, Web 릴리스 빌드, Android 디버그 APK 빌드가 정상적으로 통과합니다.

Android 디버그 APK:

```text
build/app/outputs/flutter-apk/app-debug.apk
```
