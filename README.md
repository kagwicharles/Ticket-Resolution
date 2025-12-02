# Ticket Resolution App (Flutter) - Take Home Test

## Overview
A small Flutter app demonstrating:
- Mocked authentication (email + password) with local persistence.
- Fetching & displaying tickets from https://jsonplaceholder.typicode.com/posts.
- Ticket detail screen with "Mark as Resolved" and persistence.
- Bottom navigation (Tickets, Profile) with logout.
- Clean project layout, Cubit-based state management (flutter_bloc), GoRouter routing.
- Material 3 theme and dark mode support.

## How to run
1. `flutter pub get`
2. `flutter run` (or build an APK with `flutter build apk --release`)

### Mock credentials
- Password: `password123` (any email)

## What I implemented
- Login with persisted state (shared_preferences).
- Tickets list with pull-to-refresh and resolved badge.
- Ticket detail with resolved persistence.
- GoRouter-based navigation and basic redirect rules.
- BLoC/Cubit state management and clear folder structure.
- Material 3 + dark mode.

## Files of interest
- `lib/logic/*` : Cubits and logic
- `lib/data/*` : Models & repository
- `lib/presentation/*` : Screens, widgets, router
- `lib/core/services/local_storage_service.dart` : small wrapper around `shared_preferences`

## APK
Place the generated APK in the root of this repo (e.g. `ticket_resolution_app.apk`)

## Notes & possible improvements
- Add tests.
- Use Hive or sqlite for more robust local storage for complex objects.
- Add animations for mark-resolved and page transitions.
- Add onboarding and better error UI.
