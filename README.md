# Gym Dude

> To track everything.

A fast, calm, **offline-first** personal fitness companion built with Flutter. Plan
your workouts, log your lifts, beat your own numbers, and stay on your daily
routine — all on-device, no account, no network required.

- **Platform:** Flutter (Android first)
- **Storage:** 100% on-device SQLite via [`drift`](https://drift.simonbinder.eu) — no backend, no login, works offline
- **State:** Riverpod
- **Audience:** single user (multi-user / sync is a future phase)

See **[docs/MVP-1-Spec.md](docs/MVP-1-Spec.md)** for the full specification (scope,
data model, and build milestones).

---

## Features

### Train
- **F1 — Weekly workout plan** — define your split per weekday (e.g. Mon = Chest + Triceps), set a usual time, and add planned exercises in order.
- **F2 — Workout logging** — open today's session, log sets (weight × reps, optional RPE), and see **last session's numbers inline** with a 🎯 "beat this" target.
- **F3 — PR detection & celebration** — new personal records (heavier weight, or more reps at weight) are detected automatically and celebrated with **confetti + haptics + a "🎉 NEW PR" card**.
- **F4 — PR history & shareable cards** — browse your best per exercise and generate a **shareable image card** with:
  - **3 templates** — Emerald, Midnight, Minimal
  - an optional **background photo** (your own picture shows behind the stats, kept legible with a per-template scrim)
  - a live preview, then share via the OS share sheet.

### Routine
- **F5 — Daily routine checklist** — recurring daily items (water, meals, supplements, …) grouped by category, with an end-of-day "you still have X left" summary.
- **F6 — Weekly meal-prep tasks** — recurring weekly prep items you can tick off.

### Me
- **F7 — Bodyweight & progress** — weekly bodyweight entry, optional progress photo, and a trend chart (`fl_chart`).
- **Settings** — reached via the ⚙ icon:
  - **Appearance** — System / Light / **Dark** mode
  - **Notifications** (see F9)
  - **Replay app tour**

### Home & motivation
- **F8 — Streaks** — days trained this week and consecutive-week streak, shown as glanceable chips.
- **Home glance** — today's workout + top "beat this" targets, daily-routine progress ring, and a **Start today's workout** CTA.

### Notifications
- **F9 — Local, opt-in reminders** (each individually toggleable, capped at ~2/day by default):
  - **Morning summary** — today's actual plan + a nudge, at 7:30 (scheduled per weekday so each day shows the right plan)
  - **Day-before workout** — the evening before a training day
  - **Bedtime nudge** — wind-down reminder at a time you choose
  - plus a "Send a preview" button to see what they look like.

### Onboarding
- **First-run app tour** — a short 4-page intro carousel shown on first launch, with **Skip available on every page**. Replayable anytime from **Settings → Replay app tour**.

---

## Tech stack

| Layer | Choice |
|-------|--------|
| UI | Flutter (Material 3, custom theme, light/dark) |
| State | Riverpod |
| Local DB | drift (SQLite) with migrations |
| Notifications | flutter_local_notifications + timezone |
| Celebration | confetti + `HapticFeedback` |
| Shareable card | screenshot (widget → PNG) + share_plus |
| Images | image_picker + app documents dir |
| Charts | fl_chart |

## Getting started

Requires the Flutter SDK (Dart `^3.13.5`).

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift codegen (re-run after table changes)
flutter run                                                 # on a device / emulator
```

Release build:

```bash
flutter build apk --release        # build/app/outputs/flutter-apk/app-release.apk
```

## Project structure

```
lib/
  data/          # drift tables, database, DAOs
  providers/     # Riverpod providers + notification scheduling helper
  screens/       # home, train, routine, me, onboarding + sub-screens
  services/      # notification service
  theme/         # app theme (light/dark)
  utils/         # weekday helpers
docs/
  MVP-1-Spec.md  # full specification
```

## Roadmap (post-MVP-1)

Workout auto-progression, cloud backup / multi-device (Firebase), a rest timer,
weight-unit (kg/lb) switching, Health Connect reads, and iOS support.
