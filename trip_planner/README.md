# Trip Planner – Flutter App

A lightweight, offline-friendly mobile assistant for planning, tracking and packing your trips.  
Built for the _Mobile Applications_ university module but designed to be a tidy real-world codebase you can keep extending.

---

## ✨ Core features

| Screen                     | Highlights                                                                                                                       |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Trips** (home)           | Scrollable list of Trip cards with coloured tags, floating “＋” button to create a trip                                          |
| **New Trip**               | Simple form (title, dates) – extend with tags, origin/destination and attachments                                                |
| **Trip details → Luggage** | Drill-in checklist with check-boxes for packing items                                                                            |
| **Settings**               | Dark-mode switch stored in `SharedPreferences`; imprint tile                                                                     |
| Global                     | Material 3 styling, light/dark themes, persistent bottom navigation, in-memory state via Riverpod (swap to Hive/Isar when ready) |

---

## 🛠️ Tech stack

| Purpose              | Package                                           |
| -------------------- | ------------------------------------------------- |
| State management     | `flutter_riverpod`                                |
| Theming + Material 3 | Flutter SDK ≥ 3.22                                |
| Local prefs          | `shared_preferences`                              |
| IDs                  | `uuid`                                            |
| (optional) Local DB  | `hive`, `hive_flutter`                            |
| Navigation           | `Navigator` + `IndexedStack` (no external router) |

---

## 📁 Folder structure

```
lib/
├── app.dart               # MaterialApp + themes
├── main.dart
├── core/
│   └── theme/             # ThemeModeNotifier, AppTheme
├── home/                  # HomePage with IndexedStack + bottom nav
│   └── home_page.dart
├── features/
│   ├── trips/
│   │   ├── domain/        # Trip model
│   │   ├── data/          # TripRepository (in-memory or Hive)
│   │   └── presentation/  # TripsPage, TripCard, NewTripPage
│   ├── luggage/           # LuggagePage stub
│   └── settings/          # SettingsPage
└── shared/
    └── widgets/           # AdaptiveFab
```

---

## 🚀 Getting started

```bash
# clone / download
flutter pub get            # install dependencies

# run on connected emulator / device
flutter run

# build release apk / ipa
flutter build apk    # or flutter build ios
```

### Creating the folder tree (+ empty files) from scratch

```bash
bash scripts/setup.sh      # see `/scripts` for the one-liner mkdir/touch script
```

---

## 🧩 Extending the app

- **Add tags & origin/destination** – extend `Trip` model; update form & card
- **Persist trips** – replace `TripRepository` list with Hive box or Isar collection
- **Search bar** – add `TextField` in `TripsPage` and filter via `where()`
- **Infinite scroll** – wrap list in `Scrollbar` + load older trips on demand
- **Maps integration** – `google_maps_flutter` in the New-Trip form
- **Cloud sync** – swap local repo for Supabase or Firebase Firestore

---

## 📸 Screenshots

| List                   | New Trip form | Dark-mode |
| ---------------------- | ------------- | --------- |
| _add screenshots here_ |               |           |

---

## 📜 License

MIT – feel free to study, remix and use for your own coursework or side-projects.
