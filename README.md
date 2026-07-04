# Introduction

A Cordova plugin that allows integrating Clarity with your Cordova/Ionic application.

## Installation

### Cordova

```sh
cordova plugin add @microsoft/cordova-clarity
```

### Ionic (Capacitor)

Run these commands to add the package:

```sh
npm i @microsoft/cordova-clarity cordova-plugin-device
ionic cap sync
```

### Ionic (Cordova)

Run this command to add the package:

```sh
ionic cordova plugin add @microsoft/cordova-clarity
```

## Usage

### Cordova

```js
var success = function(message) {}
var failure = function(message) {}
var idCallback = function(id) {}
var urlCallback = function(url) {}

let clarityConfig = {
    logLevel: ClarityPlugin.LogLevel.None
}

// Initialize Clarity.
ClarityPlugin.initialize("<ProjectId>", success, failure, clarityConfig);

// Pause Clarity capturing.
ClarityPlugin.pause(success, failure);

// Resume Clarity capturing if paused.
ClarityPlugin.resume(success, failure);

// Returns true if clarity was paused.
ClarityPlugin.isPaused(success, failure);

// Set custom user id.
ClarityPlugin.setCustomUserId("<CustomUserId>", success, failure);

// Set custom session id.
ClarityPlugin.setCustomSessionId("<CustomSessionId>",success, failure);

// Get current session id to correlate with other tools.
ClarityPlugin.getCurrentSessionId(idCallback, failure);

// Get current session url to correlate with other tools.
ClarityPlugin.getCurrentSessionUrl(urlCallback, failure);

// Set custom tag for the current session.
ClarityPlugin.setCustomTag("key", "value", success, failure);
```

### Ionic

Follows the same pattern as Cordova, but you have to define `ClarityPlugin` and using clarityConfig to set `isIonic` to true:
```js
declare let ClarityPlugin: any;
var success = function(message: string) {}
var failure = function(message: string) {}

let clarityConfig = {
    logLevel: ClarityPlugin.LogLevel.None,
    isIonic: true
}

// Initialize Clarity.
ClarityPlugin.initialize("<ProjectId>", success, failure, clarityConfig);

// If you're using Capacitor by Ionic, you might need to limit the plugin scope to Android platform only.
if(Capacitor.getPlatform() === "android"){
    // Call Clarity initialize.
}
```

### Configuration and Initialization arguments 

```js
/**
 * Initializes the Clarity plugin with the provided parameters.
 * Note: this function has to be called once in your startup page.
 * 
 * @param projectId     [REQUIRED] The Clarity project id to send data to.
 * @param success     [REQUIRED] A callback to invoke when the initialization process succeeds.
 * @param error     [REQUIRED] A callback to invoke when the initialization process fails.
 * @param config     [OPTIONAL] The clarity config, if not provided default values are used.
*/
function initialize(projectId, success, failure, config = {})


/**
 * The configuration that will be used to customize the Clarity behaviour.
 * 
 * @param isIonic        [OPTIONAL default = false] A flag that determines if this plugin is being used in an Ionic application.
 * @param userId        [OPTIONAL default = null] A custom identifier for the current user. If passed as null, the user id
 *                      will be auto generated. The user id in general is sticky across sessions.
 *                      The provided user id must follow these conditions:
 *                          1. Cannot be an empty string.
 *                          2. Should be base36 and smaller than "1Z141Z4".
 * @param logLevel      [OPTIONAL default = LogLevel.None] The level of logging to show in the device logcat stream.
 */

let clarityConfig = {
    isIonic = false,
    userId = null,
    logLevel = ClarityPlugin.LogLevel.None,
}
```

### Notes:
- Clarity requires `cordova-android` version +`14.0.0`.

## License

MIT
