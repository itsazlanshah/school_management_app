# School Management App (EduManager)

## Description

EduManager is a Flutter application for managing school students and teachers. It provides a complete authentication flow, a dashboard, and full CRUD (Create, Read, Update, Delete) operations for both students and teachers.

## Features

- **Authentication:** Sign-in, sign-up, and logout with session handling.
- **Dashboard:** Home screen with quick-action cards for all major functions.
- **Student Management:** Add, view, edit, and delete student records.
- **Teacher Management:** Add, view, edit, and delete teacher records.
- **Logout:** Secure sign-out that clears the navigation stack.

## Architecture

The project follows a **Feature-First Clean Architecture** approach. Shared code and reusable components live in `core/`, while each feature is organized into:
- `data/` — Repositories and data access.
- `domain/` — Models and business logic.
- `presentation/` — Screens and UI widgets.

## Tech Stack

- Flutter
- Dart

## Current Limitations

The app currently uses static, in-memory data and does not yet connect to a database. The repository pattern is already in place, making it ready for a future Firebase or SQLite integration without changing the UI.

## How to Run

From the project directory, run:

```bash
flutter pub get
flutter run