# KhelBhai — Mobile Performance Test Plan (Profile Mode)

## 1. Objectives & Scope
This test plan defines the methodology, tools, environments, and metrics used to benchmark and profile the KhelBhai Flutter mobile application on Android and iOS in **Profile mode**.

- **Scope**: Android and iOS phone layouts.
- **Out of Scope**: Tablet/iPad layouts (per project rules), backend schema/RLS changes.
- **Rule**: All commands must use Flutter Version Management (`fvm flutter`, `fvm dart`).

---

## 2. Test Environment & Device Profile

### Flutter & Runtime Environment
- **Flutter Version**: `3.47.5` (channel stable)
- **Dart SDK**: `3.13.4`
- **DevTools**: `2.60.0`
- **Build Mode**: Profile (`--profile`)
- **Default Flavor / Environment**: `dev` (`AppEnv.environment == 'dev'`, `AppEnv.appName == 'KhelBhai'`)
- **App Version & Build**: `1.0.0+1`

### Benchmark Hardware Profile
- **Primary Tested Device**: `sdk_gphone16k_arm64` (Android 17 / API 37, ARM64)
- **Screen Resolution**: 1080 x 2424 px
- **Refresh Rate**: 60 Hz (Frame Budget: 16.67 ms)
- **Power State**: High performance (Battery Saver disabled)
- **Device Storage**: > 500 MB clean storage in `/data` partition

---

## 3. Profiling Tools & Measurement Protocol

| Tool | Purpose | Metrics Captured |
|---|---|---|
| **Flutter DevTools (Performance View)** | Frame times & timeline events | UI Thread Time, Raster Thread Time, Janky Frames, Shader Compilation, Widget Rebuilds |
| **Flutter DevTools (Memory View)** | Heap tracking & allocations | Dart VM Heap, Resident Memory, Retained Objects, Garbage Collection events |
| **Android `gfxinfo` (`dumpsys`)** | Frame rendering stats & percentiles | Total Frames, Janky Frames %, 50th/90th/95th/99th percentiles, Draw/Execute timings |
| **Android `meminfo` (`dumpsys`)** | Native & Dalvik memory consumption | Total PSS, Native Heap, Dalvik Heap, Code, Mapped Bitmaps |
| **Android `am start -W`** | Activity startup latency | Cold Launch Time, Warm Launch Time |

---

## 4. Key Performance Targets (SLOs)

| Metric | Target (60 Hz) | Critical Threshold |
|---|---|---|
| **Frame Render Time** | < 16.67 ms | > 33.33 ms (consecutive dropped frames) |
| **Janky Frame Ratio** | < 10% during active scroll | > 25% |
| **95th Percentile Frame Time** | < 25 ms | > 60 ms |
| **Cold App Startup (`am start`)** | < 2,500 ms | > 3,500 ms |
| **Warm App Startup** | < 150 ms | > 300 ms |
| **Baseline Heap Memory (PSS)** | < 180 MB | > 300 MB |
| **Image Heap Overhead** | Bounded to display size * DPR | Unconstrained raw bitmap decoding |

---

## 5. Test Scenarios & Execution Procedures

### Scenario 1: App Startup (Cold & Warm)
1. Kill background app processes: `adb shell am force-stop com.lastspot.app`.
2. Measure cold launch: `adb shell am start -W -n com.lastspot.app/.MainActivity`.
3. Press Home (`KEYCODE_HOME`), wait 1s, and measure warm launch.
4. Repeat 3 times to verify consistency.

### Scenario 2: Home Screen Feed & Carousel Scrolling
1. Launch Home screen and wait for data load (`HomeSuccess`).
2. Reset frame statistics: `adb shell dumpsys gfxinfo com.lastspot.app reset`.
3. Perform 3 smooth vertical swipe gestures (500,1500 -> 500,500).
4. Perform horizontal carousel drags across `PopularSportsGrid` and `AchievementsCarousel`.
5. Dump frame statistics: `adb shell dumpsys gfxinfo com.lastspot.app`.

### Scenario 3: Explore Search & Category Filtering
1. Tap Search / Explore navigation.
2. Type queries with debounce testing.
3. Switch sports category filter in 3D perspective carousel.
4. Measure memory growth and frame stability during search filtering.

### Scenario 4: Activity Details Transition
1. Tap an activity card from the feed.
2. Verify Hero image transition smoothness and host avatar loading.
3. Check memory allocation of full-width banner images.
4. Pop back to Home and verify memory reclaim.

### Scenario 5: Multi-Step Navigation Stability (5x Cycle)
1. Execute navigation sequence 5 consecutive times:
   `Home -> Explore -> Activity Details -> Back -> Profile -> Back -> Activities -> Back -> Home`.
2. Measure heap memory before and after to verify zero unbounded memory retention or controller leaks.
