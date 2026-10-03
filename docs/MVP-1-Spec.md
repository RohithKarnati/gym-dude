git checkout -b claude/zealous-mccarthy-x5mah0
mkdir -p docs

cat > docs/MVP-1-SPEC.md <<'SPEC_EOF'
# Gym Dude — MVP-1 Specification

> Single source of truth for the first build. Personal fitness companion:
> plan workouts, log lifts, beat your own numbers, stay on routine.

- **Status:** MVP-1 scope locked (2026-10-03)
- **Platform:** Flutter (Android / Play Store first)
- **Storage:** 100% on-device (SQLite via `drift`) — no backend, no login, works offline
- **Audience:** Single user (me). Multi-user / sharing / sync is Phase 2.

---

## 1. Product vision

A fast, calm, offline app that answers one question every time I open it:
**"What do I do right now, and how do I beat last time?"**

Three jobs:
1. **Train with progressive overload** — know last session's numbers, beat them, celebrate PRs.
2. **Stay on routine** — daily checklist of meals / supplements, weekly meal-prep tasks.
3. **Stay motivated** — PR celebrations, streaks, shareable PR cards — without being nagged.

Design principles:
- **Clean UI** — one glanceable home screen; everything else one tap away. Lots of whitespace, big tap targets, calm palette.
- **Minimal, opt-in notifications** — never more than ~2 pings/day unless I ask. Routine nudges live *inside* the app, not as a notification stream.
- **Offline-first** — instant, no network dependency.

---

## 2. Scope

### In scope (MVP-1)
| # | Feature | Summary |
|---|---------|---------|
| F1 | Weekly workout plan | Define a split (e.g. Mon = Chest + Triceps), usual workout time per day, planned exercises per day. |
| F2 | Workout logging | Open today's session → see planned exercises → log sets (weight × reps, optional RPE). Shows **last session's numbers inline** with a "🎯 beat this" target. |
| F3 | PR detection + celebration | Auto-detect a new PR (weight or reps-at-weight). Fire confetti + haptic + a "🎉 NEW PR" card (old → new). |
| F4 | PR history + shareable card | List of PRs per exercise; generate a shareable image card (save / OS share sheet). |
| F5 | Daily routine checklist | Recurring daily items (water, meals, whey, fish oil, multivitamin, creatine, …). Check off; end-of-day "you missed X" summary. |
| F6 | Weekly meal-prep tasks | Recurring weekly prep items (chop veggies, make masala) with a reminder. |
| F7 | Bodyweight + progress photo | Weekly bodyweight entry + optional progress photo. Simple trend. |
| F8 | Streaks | Days trained this week + consecutive-week streak on home screen. |
| F9 | Notifications (opt-in) | ① day-before workout reminder, ② bedtime nudge, ③ morning "today's plan" summary. Each individually toggleable. |

### Out of scope → Phase 2 (collecting feedback first)
- Workout auto-suggestions / auto-programming.
- Smart motion-gated alarm (OS limits make this a dedicated native effort).
- Weather-based motivation.
- Cloud sync / accounts / multi-device → revisit with **Firebase** (Firestore + Auth) when needed.
- Real social-platform integrations (MVP-1 only generates a local shareable image).
- Health API reads (steps / sleep from Google Fit / Health Connect).
- iOS / App Store release.

---

## 3. Tech stack

| Layer | Choice | Why |
|-------|--------|-----|
| UI | **Flutter** | One codebase, custom clean UI, strong animation + image-gen support. |
| State mgmt | **Riverpod** (recommended) | Testable, no BuildContext gymnastics. (Provider/Bloc are fine alternatives.) |
| Local DB | **drift** (SQLite) | Type-safe, reactive queries (streams → UI auto-updates), migrations. |
| Notifications | **flutter_local_notifications** + **timezone** | Scheduled local notifications, no server. |
| Celebration | **confetti** + Flutter `HapticFeedback` | PR moment. |
| Shareable card | **screenshot** (render widget → PNG) + **share_plus** | PR image + OS share sheet. |
| Images | **image_picker** + app documents dir | Progress / PR photos. |
| Charts (bodyweight) | **fl_chart** | Simple trend line. |

### Suggested `pubspec.yaml` dependencies
\`\`\`yaml
dependencies:
flutter:
sdk: flutter
flutter_riverpod: ^2.5.1
drift: ^2.19.0
sqlite3_flutter_libs: ^0.5.0
path_provider: ^2.1.0
path: ^1.9.0
flutter_local_notifications: ^17.2.0
timezone: ^0.9.0
confetti: ^0.7.0
screenshot: ^3.0.0
share_plus: ^10.0.0
image_picker: ^1.1.0
fl_chart: ^0.69.0
intl: ^0.19.0

dev_dependencies:
flutter_test:
sdk: flutter
drift_dev: ^2.19.0
build_runner: ^2.4.0
flutter_lints: ^4.0.0
\`\`\`
> After adding deps: `flutter pub get` then `dart run build_runner build --delete-conflicting-outputs` (drift codegen).

---

## 4. Data model (drift tables)

\`\`\`
WorkoutDays            # the weekly split template
id            int pk
weekday       int          # 1=Mon .. 7=Sun
title         text         # "Chest + Triceps"
usualTime     text?        # "18:30" — drives day-before + morning reminders
isRestDay     bool

PlannedExercises       # exercises belonging to a WorkoutDay (ordered)
id            int pk
workoutDayId  int fk -> WorkoutDays
name          text         # "Barbell Bench Press"
targetSets    int
orderIndex    int

WorkoutSessions        # an actual training session instance
id            int pk
workoutDayId  int fk -> WorkoutDays
date          datetime
notes         text?

SetLogs                # one logged set
id            int pk
sessionId     int fk -> WorkoutSessions
exerciseName  text         # denormalized so history survives plan edits
setNumber     int
weightKg      real
reps          int
rpe           real?        # optional 1..10
isPr          bool         # set true when this beats prior best

PersonalRecords        # current best per exercise (fast lookup + history)
id            int pk
exerciseName  text
weightKg      real
reps          int
achievedAt    datetime
photoPath     text?        # optional PR photo

RoutineItems           # daily checklist template (recurring)
id            int pk
label         text         # "Creatine"
category      text         # meal | supplement | hydration | other
defaultTime   text?        # optional time for ordering / reminder
orderIndex    int
isActive      bool

RoutineChecks          # per-day completion of a RoutineItem
id            int pk
routineItemId int fk -> RoutineItems
date          date
isDone        bool
doneAt        datetime?

MealPrepTasks          # weekly recurring prep tasks
id            int pk
label         text         # "Chop veggies for 3 days"
weekday       int          # which day it's scheduled
isActive      bool

MealPrepChecks
id            int pk
mealPrepTaskId int fk -> MealPrepTasks
weekStart     date         # Monday of the week
isDone        bool

BodyLogs               # weekly bodyweight + photo
id            int pk
date          date
weightKg      real
photoPath     text?
note          text?

Settings               # single-row app settings
id            int pk        # always 1
notifyDayBefore   bool
notifyBedtime     bool
notifyMorning     bool
bedtimeTarget     text?     # computed from earliest usualTime, overridable
weightUnit        text      # "kg" | "lb"
\`\`\`

### PR rule (F2/F3)
On saving a `SetLog` for an exercise, compare against `PersonalRecords` for that `exerciseName`:
- **New PR if** `weightKg > best.weightKg`, **or** `weightKg == best.weightKg && reps > best.reps`.
- On PR: set `SetLog.isPr = true`, upsert `PersonalRecords`, trigger celebration.
- "Beat this" target shown while logging = current PR for that exercise (or last session's top set if no PR yet).

---

## 5. Screens

Bottom nav with 4 tabs: **Home · Train · Routine · Me**.

1. **Home** (glance)
    - Today's workout title + time (or "Rest day").
    - Top "beat this" targets for today's key lifts.
    - Daily checklist progress ring (e.g. 4/9 done).
    - Streak chip (🔥 days this week / weeks in a row).
    - Primary CTA: **Start today's workout**.

2. **Train**
    - **Plan editor** (F1): weekly split, per-day exercises, usual time.
    - **Session logger** (F2): list planned exercises → tap → log sets with weight/reps/RPE; inline previous numbers + target; "+ set" quick-add.
    - **PR celebration** overlay (F3) on PR.
    - **PR history** (F4): per-exercise best + history + share button.

3. **Routine**
    - **Daily checklist** (F5): today's items grouped by category, check off; end-of-day missed summary.
    - **Meal prep** (F6): this week's prep tasks, check off.

4. **Me**
    - **Body** (F7): bodyweight entry + photo + trend chart.
    - **Settings** (F9): notification toggles, bedtime target, units.

---

## 6. Notifications (F9)

Local-only, scheduled via `flutter_local_notifications`. All **opt-in**, each toggleable:
- **Day-before workout** — evening before a training day: "Tomorrow: Chest + Triceps at 6:30 PM. Plan your meals/sleep."
- **Bedtime nudge** — computed backward from earliest `usualTime` (default ~8h before wake); overridable.
- **Morning summary** — one ping: today's workout + top targets + "don't forget creatine".

Everything else (per-supplement nudges) stays **in-app only**. Hard cap the default experience at ~2 notifications/day.

---

## 7. Suggested build order (milestones)

- **M0 — Scaffold:** `flutter create`, add deps, Riverpod + drift wired, theme, bottom-nav shell, empty screens. Run `build_runner`.
- **M1 — Plan + Log (core loop):** F1 + F2. Define split, log sets, show previous numbers + target. *This is the heartbeat — get it feeling great first.*
- **M2 — PR + Celebrate:** F3 + F8 (PR rule, confetti/haptic, streaks).
- **M3 — Routine:** F5 + F6 (daily checklist, meal prep).
- **M4 — Body + Share:** F7 + F4 (bodyweight/photo/trend, shareable PR card).
- **M5 — Notifications + polish:** F9, settings, empty states, Android release build.

---

## 8. Local setup (continue from here)

\`\`\`bash
# from repo root, after pulling this branch
flutter create . --org com.gymdude --platforms=android   # generate android/ + flutter shell (keep docs/)
flutter pub get
dart run build_runner build --delete-conflicting-outputs # drift codegen (re-run after table changes)
flutter run                                               # on device/emulator
\`\`\`
Android notification + photo permissions go in `android/app/src/main/AndroidManifest.xml` (POST_NOTIFICATIONS on Android 13+, exact-alarm if needed, READ_MEDIA_IMAGES for picker).

---

## 9. Open questions / parking lot (for MVP-2)
- Motion-gated smart alarm (native modules, Health Connect).
- Workout suggestions / auto-progression engine.
- Cloud backup + multi-device (Firebase).
- Social sharing integrations.
- Weather-aware motivation.
- Rest timer between sets (small — could sneak into MVP-1 if time allows).
  SPEC_EOF

cat > README.md <<'README_EOF'
# Gym Dude

A personal, offline-first fitness companion — plan workouts, log lifts, beat your own
numbers, and stay on your daily routine.

- **Platform:** Flutter (Android first)
- **Storage:** on-device SQLite (`drift`) — no backend, no login
- **Status:** MVP-1 scope locked

See **[docs/MVP-1-SPEC.md](docs/MVP-1-SPEC.md)** for the full MVP-1 specification:
features, screens, data model, and build milestones.

## Getting started (local)
\`\`\`bash
flutter create . --org com.gymdude --platforms=android
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
\`\`\`
README_EOF

git add -A
git commit -m "Add MVP-1 specification for Gym Dude fitness app"
git push -u origin claude/zealous-mccarthy-x5mah0