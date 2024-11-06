# Book Finder

Flutter와 Riverpod으로 만든 작은 **모바일 Book Discovery 앱**입니다. 책을 검색하고, 2열 discovery shelf에서 표지와 메타데이터를 비교한 뒤, 상세 화면에서 책 소개와 ISBN을 확인하고 온라인 상세 페이지로 이어지는 흐름을 구현했습니다.

Naver Book Search API를 연결할 수 있지만 credential은 앱 소스에 저장하지 않습니다. credential이 없는 포트폴리오 실행에서는 재현 가능한 curated shelf를 사용해 검색·empty state·detail flow를 그대로 확인할 수 있습니다.

## Mobile preview

| Discovery | Search results | Book detail |
| --- | --- | --- |
| ![Book discovery home](.github/assets/portfolio/01-book-discovery.png) | ![Book search results](.github/assets/portfolio/02-search-results.png) | ![Book detail](.github/assets/portfolio/03-book-detail.png) |

모든 대표 이미지는 Flutter Web이 아니라 **Android 15 / API 35 Emulator**에서 실제 앱을 실행하고 interaction한 뒤 캡처했습니다.

## Product experience

- `Book Finder` branding + discovery hero
- 제목·저자·출판사 기반 검색 입력
- `Flutter`, `Architecture`, `Data`, `Design` 빠른 탐색 chip
- 검색 결과 count와 curated/live 상태 표시
- 실제 cover thumbnail을 `BoxFit.contain`으로 표시해 과도한 crop 방지
- title / author / publisher / publication date hierarchy를 갖춘 2-column card grid
- 검색 transition을 보여주는 loading skeleton
- 매칭 결과가 없을 때 별도 empty result UI
- 큰 표지, 저자, 출판사, 출간일, ISBN, 소개를 갖춘 full detail page
- 관심 목록 demo action + 온라인 상세 페이지 CTA
- 네트워크 이미지 실패 시 앱이 무너지지 않는 cover fallback

추가 empty-state 캡처는 [`.github/assets/portfolio/04-empty-or-loading.png`](.github/assets/portfolio/04-empty-or-loading.png)에 포함되어 있습니다.

## Architecture

```text
lib/
├── data/
│   ├── dto/                  # Naver API response mapping
│   ├── model/                # Book domain model + display helpers
│   └── repository/           # live API / curated fallback policy
├── ui/pages/
│   ├── home/
│   │   ├── home_page.dart    # discovery/search/grid/loading/empty UI
│   │   └── home_view_model.dart
│   └── detail/
│       └── detail_page.dart  # product detail + optional web detail
└── main.dart                 # app theme and ProviderScope
```

`HomePage → HomeViewModel → BookRepository → DTO/Book` 흐름으로 UI와 데이터 접근 책임을 분리했습니다. API 응답의 `<b>` 같은 markup은 domain model 생성 시 정리해 화면에 API 표현이 그대로 노출되지 않도록 했습니다.

## Search modes

### Curated portfolio mode

별도 설정 없이 실행하면 deterministic curated shelf를 사용합니다. 검색 자체는 실제로 동작하며, 존재하지 않는 검색어는 전체 sample 데이터를 다시 보여주는 대신 자연스러운 **0 result state**로 연결됩니다.

```bash
flutter run
```

### Naver live mode

live credential은 `--dart-define`으로만 전달합니다.

```bash
flutter run \
  --dart-define=NAVER_CLIENT_ID=... \
  --dart-define=NAVER_CLIENT_SECRET=...
```

`NAVER_CLIENT_ID` / `NAVER_CLIENT_SECRET` 실제 값은 repository에 저장하지 않습니다. live 요청이 불가능한 경우에도 curated fallback으로 앱의 탐색 흐름이 유지됩니다.

## Validation

2026-08-20 기준 아래 항목을 다시 검증했습니다.

```bash
flutter pub get
flutter analyze
flutter test
```

- `flutter analyze`: **0 issues**
- `flutter test`: **4 tests passed**
- Android Emulator debug build/install/run: **PASS**
- 실제 `Design` query interaction: **3 results 확인**
- no-match query: **empty result state 확인**
- result card → detail navigation: **PASS**
- runtime log scan: **RenderFlex overflow / image exception / fatal exception 없음**

## Portfolio captures

```text
.github/assets/portfolio/
├── 01-book-discovery.png
├── 02-search-results.png
├── 03-book-detail.png
└── 04-empty-or-loading.png
```
