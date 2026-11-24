# KhelBhai — Flutter Profile Mode Testing & Benchmarking Guide

## 1. Overview

This guide provides instructions for engineers and QA teams to reproduce, measure, and verify mobile application performance in **Flutter Profile mode** across Android and iOS devices.

### Why Profile Mode?
- **Debug mode** enables assertions, hot reload, Dart observatory checks, and unoptimized JIT compilation that cause artificial jank and inaccurate memory figures.
- **Release mode** strips timeline tracing, DevTools observability, and profiling hooks.
- **Profile mode** compiles Ahead-of-Time (AOT) with full optimization while retaining DevTools timeline events, memory tracking, and tracing capabilities.

---

## 2. Environment Setup & Prerequisites

Always execute commands through Flutter Version Management:
```bash
# Verify FVM Flutter version (must be 3.47.5 stable)
fvm flutter --version

# Verify connected devices
fvm flutter devices
```

### Device Preparation
1. **Disable Battery Saver / Low Power Mode**: Power saving throttles CPU/GPU frequencies.
2. **Lock Refresh Rate**: Set display to standard 60 Hz or 120 Hz to avoid dynamic refresh rate jitter.
3. **Clean Cache/Temporary Files**:
   ```bash
   adb shell "rm -rf /data/local/tmp/*"
   ```

---

## 3. Running & Profiling on Android

### Step 3.1: Build and Launch Profile APK
```bash
# Build profile APK
fvm flutter build apk --profile

# Run directly on attached Android device with DevTools observatory
fvm flutter run --profile -d <device-id>
```

### Step 3.2: Measuring App Startup (Cold & Warm)
```bash
# 1. Force stop the application
adb shell am force-stop com.lastspot.app

# 2. Measure Cold Launch Time
adb shell am start -W -n com.lastspot.app/.MainActivity

# Output to inspect:
# Status: ok
# Activity: com.lastspot.app/.MainActivity
# ThisTime: <ms>
# TotalTime: <ms>  <-- Cold startup latency (Target: < 2,500 ms)
# WaitTime: <ms>

# 3. Press Home to send to background
adb shell input keyevent 3

# 4. Measure Warm Launch Time
adb shell am start -W -n com.lastspot.app/.MainActivity
# TotalTime: <ms>  <-- Warm startup latency (Target: < 150 ms)
```

### Step 3.3: Capturing Frame Rendering Statistics (`dumpsys gfxinfo`)
```bash
# 1. Reset graphics info counter before test run
adb shell dumpsys gfxinfo com.lastspot.app reset

# 2. Perform manual or automated scrolling gestures on the target screen
# Example: vertical scroll swipe
adb shell input swipe 500 1500 500 500 300

# 3. Dump and analyze frame statistics
adb shell dumpsys gfxinfo com.lastspot.app

# Key metrics to record:
# - Total frames rendered
# - Janky frames (percentage)
# - 50th, 90th, 95th, 99th percentile frame times
# - Number Slow UI thread
# - Number Slow issue draw commands
# - Number Slow bitmap uploads
```

### Step 3.4: Capturing Memory Consumption (`dumpsys meminfo`)
```bash
# Dump memory breakdown for running process
adb shell dumpsys meminfo com.lastspot.app

# Key metrics to record:
# - Total PSS (Target: < 180 MB)
# - Native Heap
# - Dalvik Heap (Allocated / Free)
# - Dalvik Other
```

---

## 4. Running & Profiling on iOS

### Step 4.1: Launching Profile on Physical iOS Device
```bash
# Connect physical iPhone via USB and launch in Profile mode
fvm flutter run --profile -d <ios-device-id>
```

### Step 4.2: Using Xcode Instruments
1. Open the project in Xcode: `open ios/Runner.xcworkspace`.
2. Select **Product > Profile** (`Cmd + I`).
3. Choose the appropriate Instrument template:
   - **Time Profiler**: For CPU bottlenecks, UI thread stalls, and micro-benchmarks.
   - **Allocations**: For object allocation churn, unreleased instances, and native memory growth.
   - **Core Animation**: For real-world display FPS, dropped frames, and offscreen rendered surfaces.

---

## 5. Using Flutter DevTools

When launching `fvm flutter run --profile`, Flutter outputs a DevTools observatory URL:
```text
The Flutter DevTools debugger and profiler is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:51342/...
```

Open the link in Chrome to access:

### 1. Performance View
- **Frame Analysis**: Click on red/amber frame bars to inspect whether the delay occurred on the **UI thread** (widget building, layout, business logic) or **Raster thread** (GPU draw commands, texture uploads).
- **Track Rebuilds**: Enable "Track widget rebuilds" to detect components rebuilding without state changes.
- **Shader Compilation**: Identify initial frame shader compilation stutters.

### 2. Memory View
- **Dart Heap**: Monitor active Dart heap growth during navigation cycles.
- **Snapshot & Diff**: Take a heap snapshot on the Home screen, navigate to Explore and Details, pop back to Home, take a second snapshot, and click **Diff** to ensure no screens or controllers remain retained.

---

## 6. Automated Profiling Checklist

Before approving any performance-critical pull request:
- [ ] Run `fvm flutter test` to ensure zero regressions.
- [ ] Build in Profile mode (`fvm flutter build apk --profile`).
- [ ] Cold launch is under 2,500 ms on reference hardware.
- [ ] Warm launch is under 150 ms.
- [ ] Resting Total PSS memory is under 180 MB.
- [ ] Dalvik Heap size is under 20 MB.
- [ ] No unconstrained network image decodes (always use `AppCachedNetworkImage`).
- [ ] Zero unnecessary `Clip.antiAlias` on list items and cards.
- [ ] All `BlocBuilder` widgets in frequently updated parents have `buildWhen` filters.
