# Book Finder v2

> **2024 → 2026 UX renewal** · [`v1` original portfolio version](https://github.com/oosuhada/flutter_book_search_app/tree/v1) · [`main` v2 renewal](https://github.com/oosuhada/flutter_book_search_app)

This project began as a feature-focused Flutter book search app. In 2026 I revisited the same product around **content/control hierarchy, adaptive interaction, motion/accessibility fallbacks, platform conventions, and rendering cost** rather than applying a visual skin to every card.

기능 구현 중심으로 만들었던 초기 Flutter 책 검색 앱을 2026년에 다시 열어, 모든 카드에 효과를 입히는 대신 **책 표지를 중심으로 한 content hierarchy와 search/filter/detail action의 control hierarchy**를 분리해 리뉴얼했습니다.

## v1 → v2 / 성장 과정

| | v1 · 2024 | v2 · 2026 |
| --- | --- | --- |
| Main goal | Search/detail implementation | Product discovery UX renewal |
| Content | Material card-centric shelf | Covers and metadata remain solid/readable |
| Controls | Standard search + chips + AppBar | Adaptive glass search, segmented discovery controls, floating detail actions |
| Accessibility | Basic Material defaults | High-contrast transparency fallback, selected semantics, minimum tap targets |
| Motion | Default transitions | Reduced-motion-aware control transitions |
| Rendering | Styling-first | Blur restricted to compact controls, never each book card |

A mobile **Book Discovery app** built with Flutter and Riverpod. Search for books, compare covers and metadata in a two-column discovery shelf, then open a detailed view with description, ISBN, and a link to the online book page.

Flutter와 Riverpod으로 만든 모바일 **Book Discovery 앱**입니다. 책을 검색하고 2열 discovery shelf에서 표지와 메타데이터를 비교한 뒤, 상세 화면에서 책 소개와 ISBN을 확인하고 온라인 상세 페이지로 이어지는 흐름을 구현했습니다.

<p align="center"><sub>· · ·</sub></p>

The app can connect to the Naver Book Search API, while a deterministic curated dataset keeps the same search, empty-state, and detail flow available without credentials.

Naver Book Search API를 연결할 수 있으며, credential이 없는 환경에서도 재현 가능한 curated sample 데이터로 동일한 검색·empty state·detail flow를 확인할 수 있습니다.

## Preview / 미리보기

<p align="center">
  <img src=".github/assets/portfolio/01-book-discovery.png" width="45%" alt="Book discovery home" />
  <img src=".github/assets/portfolio/02-search-results.png" width="45%" alt="Book search results" />
</p>

<p align="center">
  <img src=".github/assets/portfolio/03-book-detail.png" width="45%" alt="Book detail" />
  <img src=".github/assets/portfolio/04-empty-or-loading.png" width="45%" alt="Book search empty state" />
</p>

All preview images were captured from the actual app running on an **Android 15 / API 35 Emulator**, not from Flutter Web.

모든 대표 이미지는 Flutter Web이 아니라 **Android 15 / API 35 Emulator**에서 실제 앱을 실행하고 interaction한 뒤 캡처했습니다.

## What it does / 주요 기능

- **Book discovery** — discovery hero와 `Flutter`, `Architecture`, `Data`, `Design` 빠른 탐색
- **Search** — 제목·저자·출판사 기반 검색과 검색 결과 count 표시
- **Browse** — cover / title / author / publisher / publication date를 비교하는 2-column card grid
- **State feedback** — 검색 중 loading skeleton과 검색 결과가 없을 때 empty state 제공
- **Book detail** — 큰 표지, 저자, 출판사, 출간일, ISBN, 소개를 보여주는 상세 화면
- **Actions** — 관심 목록 demo action과 온라인 상세 페이지 CTA
- **Resilience** — 네트워크 이미지 실패 시 cover fallback 제공
- **Offline-friendly demo** — API credential이 없거나 live 요청이 실패해도 curated fallback으로 탐색 흐름 유지

## Architecture / 구조

```text
HomePage
  → v2 glass control layer
    → search / discovery segments / detail toolbar & action bar
  → HomeViewModel (Riverpod)
    → BookRepository
      → Naver Book Search API / curated fallback
        → DTO → Book
```

UI and data access responsibilities are separated through `HomePage → HomeViewModel → BookRepository`. API markup such as `<b>` is cleaned while creating the `Book` model so transport-specific formatting does not leak into the UI.

`HomePage → HomeViewModel → BookRepository` 흐름으로 UI와 데이터 접근 책임을 분리했습니다. API 응답의 `<b>` 같은 markup은 `Book` 생성 시 정리해 화면에 그대로 노출되지 않도록 했습니다.

The v2 control renderer lives behind `lib/v2/v2_glass.dart`. `MediaQuery.highContrast` removes expensive translucency in favor of an opaque surface, while `MediaQuery.disableAnimations` shortens segmented-control motion to zero. Book covers, result cards, metadata panels, and editorial copy remain solid surfaces.

v2 control renderer는 `lib/v2/v2_glass.dart`에 분리했습니다. `highContrast`에서는 blur를 제거하고 opacity를 높이며, `disableAnimations`에서는 control transition을 0으로 줄입니다. 반대로 책 표지, 검색 결과 카드, metadata panel, 설명문은 solid surface로 유지합니다.

## Tech Stack / 기술 스택

- Flutter / Dart
- Material 3
- Riverpod
- `http` — Naver Book Search REST API
- `flutter_inappwebview` — online book detail / 온라인 상세 페이지
- Flutter Test

## Run / 실행

Run in curated portfolio mode without credentials. / Credential 없이 curated portfolio mode로 실행:

```bash
flutter pub get
flutter run
```

To use the Naver Book Search API, pass credentials with `--dart-define` instead of storing them in source. / Naver Book Search API를 사용하는 경우 credential은 source에 저장하지 않고 `--dart-define`으로 전달합니다.

```bash
flutter run \
  --dart-define=NAVER_CLIENT_ID=... \
  --dart-define=NAVER_CLIENT_SECRET=...
```
