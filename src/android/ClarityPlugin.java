package com.microsoft.clarity.cordova;

import android.app.Activity;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.RequiresApi;
import com.microsoft.clarity.Clarity;
import com.microsoft.clarity.ClarityConfig;
import com.microsoft.clarity.models.ApplicationFramework;
import com.microsoft.clarity.models.LogLevel;
import java.util.ArrayList;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.RunnableFuture;
import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;


@RequiresApi(api = Build.VERSION_CODES.Q)
public class ClarityPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {
        try {
            switch (action) {
                case "initialize":
                    if (initialize(data)) {
                        callbackContext.success("Clarity initialized.");
                    } else {
                        callbackContext.error("Failed to initialize Clarity, domain may not be allowed. Please check logs for more details!");
                    }
                    return true;
                case "pause":
                    Clarity.pause();
                    if(Clarity.isPaused()) {
                        callbackContext.success("Clarity paused.");
                    } else {
                        callbackContext.error("Failed to pause Clarity, please check logs for more details!");
                    }
                    return true;
                case "resume":
                    Clarity.resume();
                    if(!Clarity.isPaused()) {
                        callbackContext.success("Resume succeeded.");
                    } else {
                        callbackContext.error("Failed to resume Clarity, please check logs for more details!");
                    }
                    return true;
                case "isPaused":
                    // CallbackContext.success doesn't accept Boolean.
                    callbackContext.success(Clarity.isPaused() ? 1 : 0);
                    return true;
                case "setCustomUserId":
                    String customUserId = data.get(0).equals(null) ? null : data.getString(0);

                    if (Clarity.setCustomUserId(customUserId)) {
                        callbackContext.success("Setting custom user id succeeded.");
                    } else {
                        callbackContext.error("Setting custom user id failed, please check logs for more details!");
                    }
                    return true;
                case "setCustomSessionId":
                    String customSessionId = data.get(0).equals(null) ? null : data.getString(0);

                    if (Clarity.setCustomSessionId(customSessionId)) {
                        callbackContext.success("Setting custom session id succeeded.");
                    } else {
                        callbackContext.error("Setting custom session id failed, please check logs for more details!");
                    }
                    return true;
                case "setCustomTag":
                    String key = data.get(0).equals(null) ? null : data.getString(0);
                    String value = data.get(1).equals(null) ? null : data.getString(1);

                    if (Clarity.setCustomTag(key, value)) {
                        callbackContext.success("Setting custom tag succeeded.");
                    } else {
                        callbackContext.error("Setting custom tag failed, please check logs for more details!");
                    }
                    return true;
                case "getCurrentSessionId":
                    callbackContext.success(Clarity.getCurrentSessionId());
                    return true;
                case "getCurrentSessionUrl":
                    callbackContext.success(Clarity.getCurrentSessionUrl());
                    return true;
            }

        } catch (Exception e) {
            callbackContext.error(e.getMessage());
        }

        return false;
    }

    private boolean initialize(JSONArray data) throws JSONException {
        Activity activity = this.cordova.getActivity();

        String projectId = data.getString(0);
        String userId = data.get(1).equals(null) ? null : data.getString(1);
        LogLevel logLevel = LogLevel.valueOf(data.getString(2));
        Boolean isIonic = data.getBoolean(3);

        ApplicationFramework applicationFramework = !isIonic ? ApplicationFramework.Cordova : ApplicationFramework.Ionic;

        ClarityConfig config = new ClarityConfig(
            projectId,
            userId,
            logLevel,
            applicationFramework,
            null
        );

        Callable<Boolean> callable = () -> {
            return Clarity.initialize(activity, config);
        };

        RunnableFuture<Boolean> task = new FutureTask<>(callable);

        // Run on the main thread as recommended by the native Clarity SDK.
        new Handler(Looper.getMainLooper()).post(task);
        try {
            return task.get(); // this will block until Runnable completes
        } catch (InterruptedException | ExecutionException e) {
            return false;
        }
    }

    private ArrayList<String> jsonArrayToList(JSONArray arr) throws JSONException {
        ArrayList<String> ret = new ArrayList<String>();

        for (int i = 0; i < arr.length(); i++) {
            ret.add(arr.getString(i));
        }

        return ret;
    }
}
