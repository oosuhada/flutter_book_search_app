# Flutter Book Search App

책 검색 API 결과를 Flutter UI에 연결하면서 Riverpod 기반 상태 관리, 검색 입력, grid rendering, 상세 bottom sheet 흐름을 연습한 프로젝트입니다.

A Flutter practice app for connecting a book-search API to a Riverpod-managed search UI, grid results, and a detail bottom sheet.

## UI Preview / 구현 화면

![Flutter book search interface](.github/assets/ui-preview.png)

이 이미지는 현재 저장소를 Flutter Web release 모드로 빌드해 실제 렌더링한 화면입니다. 초기 상태에서는 검색 결과가 비어 있으므로 검색창 중심의 UI가 먼저 표시됩니다.

This screenshot comes from the current Flutter Web release build. The initial state intentionally starts without result cards until a search is submitted.

## Features / 주요 구현

- 검색어 입력 및 submit/search action
- Riverpod ViewModel 상태 구독
- 검색 결과를 3-column `GridView`로 표시
- 책 표지 이미지를 네트워크 이미지로 렌더링
- 결과 선택 시 상세 정보를 bottom sheet로 표시
- DTO → domain model → repository → ViewModel → UI 흐름 연습

## Structure / 구조

```text
lib/
├── data/
│   ├── dto/                 # API response DTO
│   ├── model/               # Book domain model
│   └── repository/          # search repository
├── ui/pages/home/
│   ├── home_page.dart       # search + result grid
│   ├── home_view_model.dart # Riverpod state
│   └── widgets/             # detail bottom sheet
└── main.dart
```

## Run / 실행

```bash
flutter pub get
flutter run
```

## Validate / 검증

```bash
flutter build web --release
```

2026-08-20 기준 `flutter pub get`과 Flutter Web release build를 다시 통과했습니다. 외부 검색 API의 실제 응답은 네트워크/API 상태에 따라 달라질 수 있습니다.

As of 2026-08-20, dependency resolution and the Flutter Web release build pass again. Live search results still depend on the external API/network path used by the practice repository.
