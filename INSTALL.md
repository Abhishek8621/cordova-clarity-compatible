# Cordova Clarity Plugin

This folder contains the `@microsoft/cordova-clarity` Cordova plugin with **Android and iOS** support.

## Install in your app

From your Cordova project directory:

```bash
cordova plugin remove @microsoft/cordova-clarity
cordova plugin add /Users/avifainfotech/Documents/GitHub/cordova-clarity-compatible
```

Or from GitHub:

```bash
cordova plugin add github:Abhishek8621/cordova-clarity-compatible
```

## iOS

Uses the [Microsoft Clarity iOS SDK](https://learn.microsoft.com/en-us/clarity/mobile-sdk/ios-sdk) via Swift Package Manager (`clarity-apps` 3.3.0).

After install:

```bash
cordova prepare ios
```

## Structure

```
cordova-clarity-compatible/
├── plugin.xml
├── Package.swift          # SPM dependency on clarity-apps
├── package.json
├── www/clarity_plugin.js  # JS bridge (Android + iOS)
├── src/android/           # Android native plugin
└── src/ios/               # iOS native plugin (ClarityPlugin.swift)
```

See [README.md](./README.md) for full API usage.
