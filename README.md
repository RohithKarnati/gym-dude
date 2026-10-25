# Gym Dude

> To track everything.

A fast, calm, **offline-first** personal fitness companion built with Flutter. Plan
your workouts, log your lifts, beat your own numbers, and stay on your daily
routine — all on-device, no account, no network required.

- **Platform:** Flutter (Android first)
- **Storage:** 100% on-device SQLite via [`drift`](https://drift.simonbinder.eu) — no backend, no login, works offline
- **State:** Riverpod
- **Audience:** single user (multi-user / sync is a future phase)

Specs: **[docs/MVP-1-Spec.md](docs/MVP-1-Spec.md)** (shipped scope + data model) and
**[docs/MVP-2-Spec.md](docs/MVP-2-Spec.md)** (the next iteration — partly shipped, see below).

---

## Features

### Train
- **Weekly workout plan (F1)** — define your split per weekday (e.g. Mon = Chest + Triceps), set a usual time, and add planned exercises in order.
  - Each exercise has a **muscle-group category** (Chest, Back, Legs, … + **custom categories** you add inline), a **target weight**, and **target sets up to 100** (type the number directly).
  - **Cardio exercises** — pick a logging mode per exercise: **distance (km)**, **duration (min)**, or **count (reps)** (for running/walking/skipping), instead of weight × reps.
- **Workout logging (F2)** — open today's session, log sets (weight × reps + optional **RPE**, or the cardio field for cardio exercises), and see **last session's numbers inline** with a 🎯 "beat this" target. The weight field **prefills** from the exercise's target. A **"?" explains RPE** (rate of perceived exertion) right in the logger. Tap **Finish workout** to wrap up with a quick summary (sets, exercises, PRs).
- **PR detection & celebration (F3)** — a new personal record fires **confetti + haptics + a "🎉 NEW PR" card**. For lifts, a record counts when you **push the weight up** (more reps at the same weight updates the tracked best quietly). For cardio: **more distance** (ties broken by a **faster** time), **longer duration**, or a **higher count**. The first-ever set seeds the record silently.
- **PR history & shareable cards (F4)** — personal records **grouped by category**, each with a **shareable image card**:
  - **3 templates** — Emerald, Midnight, Minimal
  - an optional **background photo** (your own picture behind the stats, kept legible with a per-template scrim)
  - live preview, then share via the OS share sheet.

### Routine
A flexible system of **user-defined lists** (the tabs). Only **Daily** exists by
default; add more from the **⋮ → Add new list** menu, each either a **checklist**
or a **shopping** list. Rename / delete lists from the same menu.
- **Checklist tasks** — recurring tasks with **per-task day-of-week recurrence** (pick any days; all 7 = every day) and an optional **reminder time**. Grouped by category; only today's tasks are checkable, and the ring shows today's progress. (The old daily-checklist + weekly meal-prep are both just special cases of this now — F5 / F6.)
- **Shopping lists** — simple "to buy" lists: add items, check off, swipe to delete, clear bought. Have as many as you like (Groceries, Supps to buy, …).
- **Hydration** — set a task's category to **Hydration** and it becomes a water tracker instead of a checkbox: pick a **daily goal** (e.g. 3 L) and a **reminder frequency** (every 1 / 1.5 / 2 / 3 / 4 / 6 h). It shows a ring + **+100 / +300 / +500 ml** quick-log buttons (on the task, the Home card, and the reminder notifications), and ticks itself done once you hit the goal.

### Me
- **Bodyweight & progress (F7)** — weekly bodyweight entry, optional progress photo, and a trend chart (`fl_chart`).
- **Settings** — reached via the ⚙ icon:
  - **Appearance** — System / Light / **Dark** mode
  - **Notifications** (see below)
  - **Replay app tour**

### Home & motivation
- **Streaks (F8)** — days trained this week and consecutive-week streak, shown as glanceable chips.
- **Home glance** — today's workout + top "beat this" targets, daily-routine progress ring, and a **Start today's workout** CTA.

### Notifications (F9)
Local, opt-in, calm:
- **Morning summary** — today's actual plan + a nudge at 7:30 (scheduled per weekday so each day shows the right plan)
- **Day-before workout** — the evening before a training day
- **Bedtime nudge** — wind-down reminder at a time you choose
- **Per-task routine reminders** — each checklist task can fire on its own days at its own time, with a **"Mark done" button right on the notification** (checks the task off for today, even from the lock screen)
- **Hydration reminders** — see the Routine section; reminders fire on your chosen frequency with **+100 / +300 / +500 ml** quick-log buttons right on the notification.
- plus a "Send a preview" button.

### Backup & restore
- **Android Auto Backup** — the database is backed up to the user's Google Drive and **restored automatically** on reinstall / new device. No setup, no account in-app. (Progress photos are excluded to stay under the 25 MB cap.)

### Onboarding
- **First-run app tour** — a short 4-page intro carousel on first launch, with **Skip on every page**. Replayable anytime from **Settings → Replay app tour**.

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
  data/          # drift tables, database (migrations), DAOs
  providers/     # Riverpod providers + notification scheduling helper
  screens/       # home, train, routine, me, onboarding + sub-screens
  services/      # notification service
  theme/         # app theme (light/dark)
  utils/         # weekday / category / recurrence helpers
  widgets/       # small shared widgets (e.g. text-input dialog)
docs/
  MVP-1-Spec.md  # shipped specification
  MVP-2-Spec.md  # next-iteration spec (partly shipped)
```

## Roadmap

**MVP-2 (shipped):** custom categories, per-task recurrence routine lists,
per-item reminders (with a notification "Mark done" action), shopping lists,
target sets to 100, **cardio metrics** (km / duration / count with matching PR
logic), **Finish-workout** summary, and **smart hydration reminders**, on top of
Android Auto Backup. See [docs/MVP-2-Spec.md](docs/MVP-2-Spec.md) for the full list.

**Later:** workout auto-progression, cloud sync / multi-device (Firebase), a rest
timer, weight-unit (kg/lb) switching, Health Connect reads, and iOS support.
