# BE:CAUSE — Unofficial Hwahae redesign concept

화해 리디자인 포트폴리오용 Flutter 프로토타입입니다. 이 앱은 화해의 공식 서비스가 아니며, 제품·랭킹·성분 데이터는 경험 검증을 위한 데모 데이터입니다.

사용자가 저장한 성분 기준이 탐색, 비교, 제품 상세까지 이어지도록 설계했습니다. 선택을 대신하지 않고, 어떤 정보에 근거해 비교할 수 있는지를 보여주는 데 초점을 둡니다.

## Design direction

- Warm ivory paper와 gold `#B68A3C`를 중심으로 한 자체 팔레트
- `HOME / DISCOVER / SCAN / SHOP / MY` 5단계 정보 구조
- Daily Beauty Brief: 날씨·내 기준·선택 근거를 한 화면에서 시작
- Ingredient Memory: 피하고 싶은 성분과 관심 성분을 저장해 탐색·비교에 연결
- Decision Stack: Fit · Proof · Formula · Context · Value를 분리해 제시
- 레미: 전역 플로팅 챗봇이 아닌, 제품·성분·루틴 문맥에서 여는 정보 해설 도구

## 포함된 흐름

- 데일리 브리프와 구매·관심·나이대 기준 랭킹
- 통합 DISCOVER 검색: 제품·성분·브랜드·리뷰 키워드
- SCAN 데모: 바코드/OCR 연결 전 제품명 입력 기반 확인 흐름
- 성분 백과와 식약처 연동 결과 표기, 데이터 최신성 안내
- 제품 상세의 Decision Stack, 최대 3개 비교, 저장·최근 본 제품
- 장바구니, 데모 결제, 배송 상태 흐름
- 개인 기준, 루틴·환경 맥락, 레미 성분 정보 해설
- 모바일 우선·반응형 레이아웃

## 코드 구조

- `lib/state`: 비교·저장·최근 본 제품·피부 프로필 상태
- `lib/features/pharmacist_chat`: 챗봇 메시지 모델과 답변 규칙
- `lib/screens/*_screen.dart`: 화면 상태와 사용자 이벤트
- `lib/screens/scan_screen.dart`: 매장 확인을 위한 데모 스캔 흐름
- `lib/widgets`: 여러 화면에서 재사용하는 브랜드·검색 위젯

## 실행

Flutter SDK 3.47.0과 Android·Web 플랫폼 파일이 준비되어 있습니다. 새 터미널을 연 뒤 이 폴더에서 실행하세요.

```bash
flutter pub get
flutter run -d chrome
flutter run -d <android-device-id>
```

Flutter 3.47.0, Android Studio, Android SDK 36, NDK 28.2가 설치되어 있습니다.
단위·위젯 테스트와 Web 릴리스 빌드를 확인했습니다. Flutter 정적 분석은 현재 한글 경로에서 Flutter 분석 서버가 JSON 파싱 오류로 중단되는 환경 이슈가 있습니다.

Android 디버그 APK:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 자동 검사와 빌드

`main` 브랜치 Push와 Pull Request마다 GitHub Actions가 다음 작업을 자동으로 실행합니다.

1. Flutter 정적 분석
2. 단위·위젯 테스트
3. Flutter Web 릴리스 빌드
4. Android 디버그 APK 빌드

성공한 실행의 **Artifacts**에서 `pharma-beauty-android-debug` APK와
`pharma-beauty-web` 웹 빌드를 14일 동안 내려받을 수 있습니다.

공식 데이터·제품 이미지·랭킹을 실제 서비스에 적용하려면 각 데이터 제공처의 API·라이선스·갱신 주기를 별도 검토해야 합니다.
