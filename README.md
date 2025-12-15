# Book Finder

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
  → HomeViewModel (Riverpod)
    → BookRepository
      → Naver Book Search API / curated fallback
        → DTO → Book
```

UI and data access responsibilities are separated through `HomePage → HomeViewModel → BookRepository`. API markup such as `<b>` is cleaned while creating the `Book` model so transport-specific formatting does not leak into the UI.

`HomePage → HomeViewModel → BookRepository` 흐름으로 UI와 데이터 접근 책임을 분리했습니다. API 응답의 `<b>` 같은 markup은 `Book` 생성 시 정리해 화면에 그대로 노출되지 않도록 했습니다.

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

## Architecture & Topics / 아키텍처 및 주제

**Architecture / 아키텍처**<br>
[`clean-architecture`](https://github.com/topics/clean-architecture) · [`repository-pattern`](https://github.com/topics/repository-pattern) · [`reactive-state-management`](https://github.com/topics/reactive-state-management) · [`client-server-architecture`](https://github.com/topics/client-server-architecture) · [`api-adapter`](https://github.com/topics/api-adapter) · [`unidirectional-data-flow`](https://github.com/topics/unidirectional-data-flow)

**Project context / 프로젝트 맥락**<br>
[`api`](https://github.com/topics/api) · [`book-search`](https://github.com/topics/book-search) · [`cross-platform`](https://github.com/topics/cross-platform) · [`flutter-app`](https://github.com/topics/flutter-app) · [`flutter-development`](https://github.com/topics/flutter-development) · [`mobile-app`](https://github.com/topics/mobile-app) · [`mobile-development`](https://github.com/topics/mobile-development) · [`naver-api`](https://github.com/topics/naver-api) · [`search-app`](https://github.com/topics/search-app) · [`state-management`](https://github.com/topics/state-management)

**Implementation stack / 구현 스택**<br>
[`dart`](https://github.com/topics/dart) · [`flutter`](https://github.com/topics/flutter) · [`riverpod`](https://github.com/topics/riverpod)
