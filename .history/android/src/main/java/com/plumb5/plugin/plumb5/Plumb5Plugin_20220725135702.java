package com.plumb5.plugin.plumb5;

import android.Manifest;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;

import org.json.JSONArray;
import org.json.JSONObject;

@CapacitorPlugin(
  name = "Plumb5",
  permissions = {
    @Permission(
      strings = { Manifest.permission.ACCESS_NETWORK_STATE },
      alias = "network"
    ),
    @Permission(strings = { Manifest.permission.INTERNET }, alias = "internet"),
    @Permission(
      strings = { Manifest.permission.WAKE_LOCK },
      alias = "wakelock"
    ),
  }
)
public class Plumb5Plugin extends Plugin {
    protected static final String TAG = "p5 - Engine";
    private static String gcmRegistrationId = "";
    static String projectNumber = null;
    static String packageName = null;
    static String accountId = null;
    static String serviceURL = null;
    static String appKey = null;
    static JSONArray jsonEventDate = new JSONArray();
    static JSONArray jsonFormData = new JSONArray();
    static JSONArray jsonTransData = new JSONArray();
    static int StaticFormId;
    private static String uniqueID = null;
    static boolean isAuthenticate = false;
  

    @PluginMethod
    public void setUserDetails(PluginCall call) {
        JSONObject params = call.getData();


        Log.v(TAG, "Please check apiKey or service url "+params);
  
}
}
