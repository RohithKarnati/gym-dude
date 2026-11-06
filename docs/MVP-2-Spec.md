# Gym Dude — MVP-2 Specification (draft / parking lot)

> Forward-looking feature set for the second iteration. Captured during MVP-1
> development so it's ready to pick up next. Nothing here is built yet — scope,
> data model, and priorities are still open and will be refined when MVP-2 starts.

- **Status:** Largely **shipped** as of 2026-10-10 (schema at **v7**). Ideas
  captured 2026-10-04; see the shipped list below.
- **Builds on:** MVP-1 (see [MVP-1-Spec.md](MVP-1-Spec.md)) — same stack (Flutter,
  Riverpod, drift/SQLite, offline-first)
- **Guiding principle (unchanged):** clean, calm, offline-first; minimal nagging.

---

## 0. Shipped (2026-10-10)

- ✅ **F-M2-5** — target-sets cap raised to 100 (direct entry) **and cardio
  metrics** (distance / duration / count per exercise, with cardio PR logic:
  more distance / faster / longer / higher count).
- ✅ **F-M2-6** — custom categories.
- ✅ **F-M2-7** — editable routine checklist (unified routine-list model).
- ✅ **F-M2-8** — per-item reminders, **plus a "Mark done" notification action**.
- ✅ **F-M2-9** — shopping / "to buy" lists.
- ✅ **F-M2-11** — **Finish-workout** action + summary (`workout_sessions.completed_at`).
- ✅ **F-M2-12** — **Hydration**, modelled as a routine item of category
  "Hydration" (per-item goal + frequency, +100/+300/+500 ml logging & notification
  actions, tracker on Routine + Home). See F-M2-12 below for the details.

Still open (parking lot): F-M2-1 sharing, F-M2-2 body composition, F-M2-3
calories, F-M2-4 suggestions tile, plus the carried-over items in §2.

---

## 1. New features (requested)

### F-M2-1 — Sharing (plans & helpful items)
Share more than just PR cards (MVP-1 already ships PR card sharing).
- **Workout plan** — share a weekly split / a single day's plan as a nicely
  formatted image and/or text, via the OS share sheet.
- **Meal plan** — share a meal plan / day's meals similarly.
- **Other helpful items** — e.g., supplement routine, a progress summary.
- *Open question:* share as an **image** (pretty, social), **text** (editable),
  and/or a **file** another Gym Dude user can **import**? Import implies a small
  interchange format (JSON) and a safe merge/preview on the receiving side.

### F-M2-2 — Body composition sheet (BMI + metrics with graphs)
Expand MVP-1's bodyweight tracking (F7) into a fuller body dashboard.
- Track per-metric over time: **weight**, **BMI**, **body-fat %**, **muscle
  mass / %**, and a few more (e.g., water %, waist/measurements) — TBD.
- A **trend graph per metric** (reuse `fl_chart`), plus the current value and
  change delta.
- BMI is derived (needs **height** — add to profile/settings).
- *Open question:* manual entry only, or optional import from a smart scale /
  Health Connect later (Health APIs were parked in MVP-1).

### F-M2-3 — Approximate calories on meals
Give the routine/meal side a nutrition signal.
- Each added meal / meal item carries an **approx calorie** value (and maybe
  basic macros: protein / carbs / fat).
- Show a **daily calorie total** and progress vs. an optional target.
- *Open question:* source of calorie data — manual per-item, a small built-in
  common-foods table, or an external food DB/API (offline-first means a bundled
  table or cached lookups are preferable to a live API).

### F-M2-4 — Suggestions tile (first open & ongoing)
A friendly, non-nagging nudge surface.
- On **first open** (and periodically on Home), show a **suggestions tile**:
  contextual tips, e.g. "You haven't logged legs this week", "Add a target
  weight to Incline Press", "Log today's bodyweight", "Try beating last Bench".
- Rules-based, local, dismissible; respects the "calm, minimal" principle.
- *Open question:* purely heuristic (recommended for MVP-2) vs. anything smarter.

### F-M2-5 — Training tweaks (found during real use, 2026-10-04)
- **Raise target-sets cap to 100** — the plan editor currently caps at 20. Raise
  to 100. Note: a +/- stepper is painful at high counts → also allow **direct
  numeric entry**. *(Small; could be pulled into MVP-1 as a quick fix.)*
- **Cardio metrics** — for **Cardio / Running** (and similar) categories, the
  weight × reps model doesn't fit. Add **optional** fields appropriate to the
  exercise: **distance (km)** for running/walking, **count** for skipping,
  **duration (min)**, etc. Likely a per-exercise "metric type" that changes what
  the logger asks for. Affects PR logic too (a running PR = longer distance /
  faster time, not heavier weight).

### F-M2-6 — Custom categories
- Let the user **add their own categories** beyond the preset list
  (Chest / Back / … / Other), and manage (rename / delete) them.
- Stored categories (a small table) instead of the current hard-coded list in
  `lib/utils/categories.dart`.

### F-M2-7 — Editable routine checklist
- Today daily checklist items can be added and deleted; add the ability to
  **edit** an existing item (rename, change category/time). Same for meal-prep
  tasks. *(Smallish; partly doable in MVP-1.)*

### F-M2-8 — Per-item reminders (daily checklist & meal prep)
- Add an optional **reminder time** to individual daily-checklist items and
  meal-prep tasks, with a local notification at that time (extends F9).
- Respect the "calm / minimal" principle — these are opt-in per item, and we
  should still avoid a flood (maybe a cap or a digest).

### F-M2-9 — Shopping / "to buy" list
- A list of **items required to buy** (groceries / supplements), likely tied to
  meal prep. Check off as purchased; optionally a reminder.

### F-M2-10 — "…and a couple more" (to be added)
The real-use list above was still being added to ("…and" — truncated). Capture
further items here as they come up.

### F-M2-11 — Finish-workout action ✅ (shipped 2026-10-10)
- A **Finish workout** button on the session logger marks the session complete
  (`workout_sessions.completed_at`) and shows a summary (sets, exercises, PRs).
- RPE got an inline **"?" explainer** in the logger (what it is / why log it).

### F-M2-12 — Hydration (shipped 2026-10-10, reworked to category-driven 2026-10-10)
Hydration is **a routine item whose category is "Hydration"** — not a separate
feature or Settings page. Setting that category reveals a **daily goal** + a
**reminder frequency** (every 1 / 1.5 / 2 / 3 / 4 / 6 h) on the item, and it then
renders as a water tracker (ring + **+100 / +300 / +500 ml**) on the Routine
checklist and the Home card, instead of a plain checkbox. It auto-ticks "done"
once intake reaches the goal.
- Reminders fire across a fixed 08:00–22:00 window at the item's frequency, with
  the +ml actions on the notification (background-isolate write; works from the
  lock screen). Payload carries the item id so the drink logs to the right item.
- Data: `routine_items.hydration_goal_ml` + `hydration_interval_min`;
  `hydration_logs` rows carry `item_id`. (The earlier v7 global `app_settings`
  hydration columns are now **dormant**.) Reminder text is generic — live totals
  live in-app — to avoid the frozen-text pitfall scheduled notifications have.

---

## 2. Carried over from MVP-1 (deferred items worth doing in MVP-2)

These came up during MVP-1 and were intentionally deferred:

- **Manual backup export/import** — a user-facing "Backup now / Restore" in
  Settings (JSON or `.zip`) that the user can save/share anywhere (incl. email).
  Complements MVP-1's **Android Auto Backup** (which is automatic, Android-only,
  DB-only, ≤25 MB, and excludes photos). This would add user control, visibility,
  cross-platform portability, and **photo** backup.
- **Weight unit switching (kg / lb)** — `weightUnit` already exists in the DB
  but every screen is hard-coded to kg; needs unit-aware display + input + a
  Settings toggle.
- **First-ever PR celebration (optional)** — today the first set for an exercise
  seeds the PR silently; MVP-2 could add a "first PR!" moment.
- **Rest timer** between sets (was a MVP-1 stretch goal).
- **Cloud sync / accounts (Firebase)** — the real multi-device story; enables
  app-managed cloud backup and sharing-with-import. Was MVP-1's Phase-2 marker.

---

## 3. Likely data-model additions (high level, TBD)

To be designed properly at MVP-2 kickoff; sketch only:
- `MealItems` (per meal: name, calories, optional protein/carbs/fat) + link to a
  day/plan; a `MealPlans` concept if meal planning goes beyond the current
  weekly meal-prep tasks.
- `BodyMetrics` — generalize `BodyLogs` to multiple metric types
  (weight / bodyfat / muscle / …) with `date`, `metric`, `value`, or add columns.
- Profile fields: **height** (for BMI), optional targets (calorie / weight).
- `Suggestions` likely needs no table (computed from existing data), maybe a
  "dismissed suggestions" record.
- `Categories` table (for F-M2-6 custom categories) to replace the hard-coded
  list in `lib/utils/categories.dart`.
- `PlannedExercises` / `SetLogs`: a **metric type** + optional distance/duration/
  count columns (F-M2-5 cardio), and PR logic branched per metric type.
- `RoutineItems` / `MealPrepTasks`: optional **reminder time** column (F-M2-8).
- `ShoppingItems` table (F-M2-9): label, quantity, bought flag, optional reminder.
- Interchange/export format (JSON schema) for sharing & manual backup.

Remember: every schema change is a **drift migration** (`schemaVersion` is at **8**
after the 2026-10-10 cardio/hydration work; it was 4 after MVP-1). The v5→v8
upgrade path is covered by `test/migration_test.dart`. Note the v8 migration guards
`hydration_logs.item_id` with `if (from == 7)` — for earlier versions the v7 step's
`createTable(hydrationLogs)` already builds the table with the current (v8) schema.

---

## 4. Open questions / decisions for MVP-2 kickoff
- Sharing: image vs text vs importable file (and whether cross-user import is in
  scope for MVP-2 or waits for accounts).
- Calories: data source (manual / bundled table / API) given offline-first.
- Body metrics: manual-only vs. Health Connect / smart-scale import.
- Suggestions: heuristic rule set — which signals, how often, how surfaced.
- Prioritization & cut line for MVP-2 (which of the above make the first cut).
