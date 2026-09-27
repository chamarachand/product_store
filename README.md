# Product Store App

## Project Overview

A Flutter application that displays a catalogue of products with a dedicated details page. The app also supports product search and favourite products

The app has two main screens:

- **Product List** — Displays all products in a responsive grid view containing the product image, name, price, category, and favourite toggle. Also includes a search bar that allows users to search products by name in real time
- **Product Details** — Shows a larger image of the selected product with its full description and a favourite toggle that stays synchronized with the list screen.

## Main Features

- Browse products in a catalogue grid view
- Pagination / incremental product loading
- View detailed product information
- Product search with debounce
- Add and remove favourite products with persistence
- Responsive UI for phones, tablets, and landscape mode

---

## Setup Instructions

### Flutter Version

- Flutter SDK: 3.47.5 (stable channel)

Navigate to the project directory.

### Install dependencies

```bash
flutter pub get
```

### Run the project

```bash
flutter run
```

### Build an APK (Optional)

```bash
flutter build apk --release
```

The generated APK will be available at:

`build/app/outputs/flutter-apk/app-release.apk`

---

## Packages & Libraries Used

| Package                  | Purpose                                                            |
| ------------------------ | ------------------------------------------------------------------ |
| `http`                   | HTTP client for communicating with the REST APIs.                  |
| `flutter_bloc`           | State management using Cubits.                                     |
| `cached_network_image`   | Loads and caches network images.                                   |
| `shared_preferences`     | Persists favorite product IDs locally.                             |
| `get_it`                 | Dependency injection.                                              |
| `equatable`              | Simplifies state comparison and prevents unnecessary state updates |
| `flutter_launcher_icons` | Generates the application launcher icon.                           |

## Architecture

The application follows a lightweight layered architecture inspired by Clean Architecture, with clear separation between presentation, state management, and data access.

Full Clean Architecture was intentionally not implemented because the additional abstraction would introduce unnecessary complexity for the scope of this application.

### Folder Structure

```
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── errors/
│   ├── services/
│   └── theme/
├── features/
│   └── products/
│       ├── data/
│       │   ├── models/
│       │   └── repositories/
│       └── presentation/
│           ├── cubit/
│           ├── screens/
│           └── widgets/
└── main.dart
```

---

## State Management Approach

The application uses **Bloc Cubit** for managing application state.

Cubits were chosen because they provide a predictable and convenient way to manage application state while keeping business logic separate from the UI. Cubit provides the benefits of BLoC while avoiding the additional event-handling complexity of pure BLoC, which is unnecessary for the scope of this application.

### ProductCubit manages:

- Loading products
- Searching products
- Pagination
- Favourite management
- Error handling

**setState** is used for simple local UI state

---

## API Integration Approach

The app uses the public **DummyJSON API** (`https://dummyjson.com/products`) to retrieve product data.

The data flow follows a repository-based approach:

```
UI → Cubit → Repository → API Service
```

This keeps API and data-access logic separated from the presentation layer and makes the code easier to maintain and test.

---

## Local Storage

`SharedPreferences` is used to store and manage:

- Favourite product IDs

---

## Assumptions

- The application requires a consistent UI experience across Android and iOS
- Product IDs are unique and suitable for favourite persistence.
- Currency displayed in the application is USD ($).

---

# Future Improvements

- Adding product cart functionality.
- Adding light/dark theme toggle
- Adding widget tests.
- Improving offline support with local product caching.

---

## Demo Video

- [Phone Demo Video (iOS simulator)](https://drive.google.com/drive/folders/1s2-tjYICQ5EWHhj98N-IzFekxGLsGJeB?usp=sharing)

## APK

- [Download APK](https://drive.google.com/drive/folders/1WIorLjr-L5SXbDRDqiVcON2Z53KQyjSw?usp=sharing)
