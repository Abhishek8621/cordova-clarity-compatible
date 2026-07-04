function isClarityUnavailable() {
  if (device.platform !== "Android") {
    let message = "Clarity supports Android only for now.";
    console.warn(message);
    error(message);
    return true;
  }

  return false;
}

module.exports = {
  /**
   * Initializes the Clarity plugin with the provided parameters.
   * Note: this function has to be called once in your startup page.
   *
   * @param projectId     The Clarity project id to send data to.
   * @param success   A callback to invoke when the initialization process succeeds.
   * @param error   A callback to invoke when the initialization process fails.
   */
  initialize: function (projectId, success, error, config = {}) {
    if (
      typeof projectId !== "string" ||
      !(typeof config === "object" || typeof config === "undefined") ||
      typeof success !== "function" ||
      typeof error !== "function"
    ) {
      throw Error(
        "Invalid Clarity initialization arguments. Please check the docs for assitance."
      );
    }

    // applying default values
    let {
      isIonic = false,
      userId = null,
      logLevel = this.LogLevel.None
    } = config ?? {};

    console.warn(
      "Note: the Clarity.initialize() function has to be called once in your startup page."
    );

    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(success, error, "ClarityPlugin", "initialize", [
      projectId,
      userId,
      logLevel,
      isIonic,
    ]);
  },

  /**
   * Pauses the Clarity capturing processes until the next resume() is called.
   */
  pause: function (success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (message) {
        success(message);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "pause",
      []
    );
  },

  /**
   * Resumes the Clarity capturing processes if they are not already resumed.
   * Note: Clarity starts capturing data right on initialization.
   */
  resume: function (success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (message) {
        success(message);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "resume",
      []
    );
  },

  /**
   * Returns true if Clarity has been paused by the user.
   */
  isPaused: function (success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (paused) {
        success(paused);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "isPaused",
      []
    );
  },

  /**
   * Sets a custom user id that can be used to identify the user. It has less
   * restrictions than the userId parameter. You can pass any string and
   * you can filter on it on the dashboard side. If you need the most efficient
   * filtering on the dashboard, use the userId parameter if possible.
   * <p>
   * Note: custom user id cannot be null or empty, or consists only of whitespaces.
   * </p>
   * @param success   A callback to invoke when the process succeeds.
   * @param error   A callback to invoke when the process fails.
   */
  setCustomUserId: function (customUserId, success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (message) {
        success(message);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "setCustomUserId",
      [customUserId]
    );
  },

  /**
   * Sets a custom session id that can be used to identify the session.
   * <p>
   * Note: custom session id cannot be null or empty, or consists only of whitespaces.
   * </p>
   * @param success   A callback to invoke when the process succeeds.
   * @param error   A callback to invoke when the process fails.
   */
  setCustomSessionId: function (customSessionId, success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (message) {
        success(message);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "setCustomSessionId",
      [customSessionId]
    );
  },

  /**
   * Sets a custom tag for the current session.
   * <p>
   * Note: custom tag key and value cannot be null or empty, or consists only of whitespaces.
   * </p>
   * @param success   A callback to invoke when the process succeeds.
   * @param error   A callback to invoke when the process fails.
   */
  setCustomTag: function (key, value, success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (message) {
        success(message);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "setCustomTag",
      [key, value]
    );
  },

  /**
   * Returns the active session id. This can be used to correlate the Clarity session with other
   * analytics tools that the developer may be using.
   * @param success   A callback to invoke with the current session id.
   * @param error   A callback to invoke when the process fails.
   */
  getCurrentSessionId: function (success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (id) {
        success(id);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "getCurrentSessionId",
      []
    );
  },

  /**
   * Returns the active session url. This can be used to correlate the Clarity session with other
   * analytics tools that the developer may be using..
   * @param success   A callback to invoke with the current session id.
   * @param error   A callback to invoke when the process fails.
   */
  getCurrentSessionUrl: function (success, error) {
    if (isClarityUnavailable()) {
      return;
    }

    cordova.exec(
      function (url) {
        success(url);
      },
      function (message) {
        error(message);
      },
      "ClarityPlugin",
      "getCurrentSessionUrl",
      []
    );
  },

  /**
   * The level of logging to show in the device logcat stream.
   */
  LogLevel: (function (LogLevel) {
    LogLevel["Verbose"] = "Verbose";
    LogLevel["Debug"] = "Debug";
    LogLevel["Info"] = "Info";
    LogLevel["Warning"] = "Warning";
    LogLevel["Error"] = "Error";
    LogLevel["None"] = "None";
    return LogLevel;
  })({}),
};
