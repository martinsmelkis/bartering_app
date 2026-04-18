# Bartering App: iOS & macOS Local Setup Guide

This document explains the specific configurations and fixes applied to allow the application to build and run locally on Apple Silicon Macs for both the iOS Simulator and macOS desktop environments.

## iOS Simulator Setup & Rive Fix

When building for the iOS Simulator on Apple Silicon Macs (arm64 architecture), the `rive_native` dependency (v0.1.4) exhibited severe linker errors (`Undefined Symbol`). 

### The Problem
1. **Missing Symbols**: The pre-compiled Harfbuzz C++ libraries (`librive_harfbuzz.a`) provided in the `emulator/` slice lacked definitions for several subsetting symbols (e.g., `_rive_hb_face_builder_add_table`, `rebase_tent`). 
2. **Linker Optimization Skipping**: The default CocoaPods setup failed to propagate the transitive dependencies, causing the `Runner` target's linker to silently drop the Rive object scopes.

### The Solution
We implemented a two-fold "brute-force" solution that guarantees a successful simulator build without modifying the package source directly:

1. **Symbol Stubbing (`ios/Runner/RiveLinkerFix.cpp`)**: 
   We created a C++ file within the Runner target that provides empty shell implementations of the missing Harfbuzz functions. Because these specific font sub-setting features are rarely triggered during simulator debugging, the stubs safely satisfy the linker without causing runtime crashes.

2. **Aggressive Force-Load (`ios/Podfile`)**: 
   A custom ruby script inside the `post_install` hook now dynamically crawls the `rive_native` emulator output directories. It finds all 17 `.a` static libraries and explicitly appends them to the `Pods-Runner.debug.xcconfig` using `-Wl,-force_load`. This physically forces Xcode to ingest the symbols it previously ignored. The hook also ensures `RiveLinkerFix.cpp` is linked if missing from the `pbxproj`.

> **Note to Developers**: If you update `rive_native` in `pubspec.yaml` in the future, check if the linker errors return. If they are officially fixed by Rive, you can safely remove `RiveLinkerFix.cpp`.

## macOS Local Development

To run the application natively on macOS for rapid UI development, a few compromises had to be made to bypass Apple's strict local sandbox restrictions:

### Sandbox Entitlements
The target `macOS/Runner/DebugProfile.entitlements` has the App Sandbox disabled (`com.apple.security.app-sandbox` -> `NO`). This is strictly for the `Debug` profile and allows the application boundless network requests (e.g., to the local/staging Backend) without needing granular network capability declarations.

### Keychain & Secure Storage
When the macOS Sandbox is disabled in development, the `flutter_secure_storage` plugin immediately crashes with an OSStatus `-34018` error, as the system prevents non-sandboxed apps from reading or writing to the secure application Keychain.
We patched the `SecureStorageService` to cleanly trap this error and silently fallback to an in-memory key-value dictionary. This means your session tokens will reset when you restart the macOS app in debug mode, but the application will not crash.

## Environment & Server Connection

### API Configuration
To point the app to the backend, set the following property in your `.env` files (`env_properties.dev.env`):
```env
SERVICE_BASE_URL_MOBILE=https://barters.lv
```
If connecting to a locally running instance of `bartering_app_backend` instead, update the URL to `http://10.0.2.2:8081` (for emulators) or `http://localhost:8081` (for macOS/simulators).
