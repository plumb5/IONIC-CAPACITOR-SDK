package com.plumb5.plugin.plumb5;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

@CapacitorPlugin(
        name = "Plumb5",
        permissions = {
                @Permission(
                        strings = {Manifest.permission.ACCESS_NETWORK_STATE},
                        alias = "network"
                ),
                @Permission(
                        strings = {Manifest.permission.INTERNET},
                        alias = "internet"
                ),
                @Permission(
                        strings = {Manifest.permission.WAKE_LOCK},
                        alias = "wakelock"
                ),
                @Permission(
                        strings = {Manifest.permission.ACCESS_COARSE_LOCATION},
                        alias = "location"
                ),
                @Permission(
                        strings = {Manifest.permission.ACCESS_FINE_LOCATION},
                        alias = "location-"
                ),
                @Permission(
                        strings = {Manifest.permission.CALL_PHONE},
                        alias = "state"
                ),
                @Permission(
                        strings = {Manifest.permission.READ_PHONE_STATE},
                        alias = "phone"
                ),
                @Permission(
                        strings = {Manifest.permission.SYSTEM_ALERT_WINDOW},
                        alias = "alert"
                ),
        }
)


public class Plumb5Plugin extends Plugin {
    protected static final String TAG = "p5 - Engine";
    static boolean init = false;
    static String projectNumber = null;
    static String packageName = null;
    static String accountId = null;
    static String serviceURL = null;
    static String appKey = null;
    static JSONArray jsonEventDate = new JSONArray();
    static JSONArray jsonFormData = new JSONArray();
    static JSONArray jsonTransData = new JSONArray();
    static int StaticFormId;
    static boolean isAuthenticate = false;
    private static String gcmRegistrationId = "";
    private static String uniqueID = null;
    public ServiceGenerator.API api;


    private static String getScreenResolution(Context context) {
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        Display display = wm.getDefaultDisplay();
        DisplayMetrics metrics = new DisplayMetrics();
        display.getMetrics(metrics);
        int width = metrics.widthPixels;
        int height = metrics.heightPixels;

        return width + "*" + height;
    }

    public static String getCarrierName(Context context) {
        if (Build.VERSION.SDK_INT > 22) {
            //for dual sim mobile
            SubscriptionManager localSubscriptionManager = SubscriptionManager.from(context);

            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {

                TelephonyManager tManager = (TelephonyManager) context
                        .getSystemService(Context.TELEPHONY_SERVICE);


                return tManager.getNetworkOperatorName();

            } else {
                return "";
            }

        } else {
            //below android version 22
            TelephonyManager tManager = (TelephonyManager) context
                    .getSystemService(Context.TELEPHONY_SERVICE);

            return tManager.getNetworkOperatorName();
        }
    }

    public static void p5ChkPermission(Activity activity, String getPermission) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

                String[] permission = getPermission.split(",");   //{"android.permission.CALL_PHONE", "android.permission.ACCESS_FINE_LOCATION"};
                if (permission.length > 0)
                    ActivityCompat.requestPermissions(activity, permission, 1);
            }
        } catch (Throwable e) {
            Log.d(TAG, "Permission error - " + e.getLocalizedMessage());
            e.printStackTrace();
        }

    }

    public static synchronized String getDeviceId(Context context) {
        if (uniqueID == null) {
            SharedPreferences sharedPrefs = context.getSharedPreferences(
                    P5Constants.PREF_UNIQUE_ID, Context.MODE_PRIVATE);
            uniqueID = sharedPrefs.getString(P5Constants.PREF_UNIQUE_ID, null);
            if (uniqueID == null) {
                uniqueID = UUID.randomUUID().toString();
                SharedPreferences.Editor editor = sharedPrefs.edit();
                editor.putString(P5Constants.PREF_UNIQUE_ID, uniqueID);
                editor.commit();
            }
        }
        return uniqueID;
    }

    @PluginMethod
    public void setUserDetails(PluginCall callbackContext) {

        if (isSdkValid()) {
            JSONObject params = callbackContext.getData();

            Map<String, Object> userDetails = new HashMap<>();

            try {

                userDetails = new ObjectMapper().readValue(params.toString(), HashMap.class);
                userDetails.put(P5Constants.DEVICE_ID, getDeviceId(this.bridge.getActivity()));

            } catch (Exception e) {
                Log.v(TAG, "Please check the parameters \n error -");
                e.printStackTrace();
                callbackContext.reject("Please check the parameters \n error -" + e.getLocalizedMessage());
            }
            if (userDetails != null) {
                Call<ResponseBody> responseBodyCall = api.ContactDetails(userDetails);
                responseBodyCall.enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        if (response.isSuccessful()) {


                            Log.v(TAG, "User details sent successful");
                            callbackContext.resolve();
                        } else {

                            Log.e(TAG, "User details  failed");
                            callbackContext.reject("User details  failed");
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        Log.e(TAG, "User details failed");
                        Log.e(TAG, t.getMessage());
                        callbackContext.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                        t.printStackTrace();
                    }
                });
            }
        } else {
            callbackContext.reject("PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
        }


    }

    @Override
    public void load() {
        SharedPreferences.Editor sharedPreferences = this.getBridge().getActivity()
                .getSharedPreferences(P5Constants.P5_INIT_KEY, 0)
                .edit();
        // your init code here
        P5LifeCycle.getactivity = this.getBridge().getActivity();

        FirebaseMessaging.getInstance().getToken().addOnSuccessListener(this.bridge.getActivity(), new OnSuccessListener<String>() {
            @Override
            public void onSuccess(@NonNull String s) {


                sharedPreferences
                        .putString(P5Constants.PROPERTY_REG_ID, s)
                        .apply();
            }
        });


        accountId = getConfig().getString(P5Constants.PLUMB5_ACCOUNT_ID);
        serviceURL = getConfig().getString(P5Constants.PLUMB5_BASE_URL);
        appKey = getConfig().getString(P5Constants.PLUMB5_API_KEY);
        api = ServiceGenerator.createService(ServiceGenerator.API.class, appKey, accountId, serviceURL);
        verify();
    }

    void verify() {
        Call<ResponseBody> call = api.PackageInfo();
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                if (response.isSuccessful()) {
                    JSONObject jsonArr = null;
                    try {
                        String array = response.body().string();


                        jsonArr = new JSONArray(array).getJSONObject(0);

                        if (null != jsonArr && jsonArr.length() > 0) {

                            try {
                                SharedPreferences.Editor sharedPreferences = getContext()
                                        .getSharedPreferences(P5Constants.P5_INIT_KEY, 0)
                                        .edit();
                                projectNumber = jsonArr.getString("GcmProjectNo");
                                packageName = jsonArr.getString("PackageName");
                                if (packageName.equals(getAppId())) {

                                    sharedPreferences.putBoolean("isSDK-Valid", true).apply();
                                    Log.i(TAG, "PLUMB5 SDK  INITIATED");
                                } else {
                                    sharedPreferences.putBoolean("isSDK-Valid", false).apply();
                                    Log.i(TAG, "PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
                                }

                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {

            }
        });
    }

    @PluginMethod
    public void initializePlumb5(PluginCall plugin) {
        SharedPreferences pref = this.bridge.getActivity().getSharedPreferences(P5Constants.P5_INIT_KEY, 0);
        if (appKey != null && appKey.length() > 0) {
            String value = pref.getString(P5Constants.PLUMB5_API_KEY, null);
            String servicevalue = pref.getString(P5Constants.PLUMB5_BASE_URL, null);
            if ((value == null || !value.equals(appKey)) && (servicevalue == null || !servicevalue.equals(serviceURL))) {
                SharedPreferences.Editor editor = pref.edit();
                editor.putString(P5Constants.PLUMB5_API_KEY, appKey);
                editor.putString(P5Constants.PLUMB5_BASE_URL, serviceURL);
                editor.putString(P5Constants.PLUMB5_ACCOUNT_ID, accountId);
                editor.putString("packageName", "");
                editor.apply();

            } else {
                Log.v(TAG, "Plumb5 initialized succusfuly");
            }
            Call<ResponseBody> call = api.PackageInfo();
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                    if (response.isSuccessful()) {
                        JSONObject jsonArr = null;
                        try {
                            String array = response.body().string();


                            jsonArr = new JSONArray(array).getJSONObject(0);

                            checkUser(plugin, jsonArr);


                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        // user object available
//                        if (pref.getBoolean("isNew", true)) {
//                            Log.v(TAG, "New user");
//
////                                deviceRegistration(callbackContext);
////
//
//                        } else {
//                            Log.v(TAG, "Existing user");
//
//                        }

                    } else {
                        Log.v(TAG, "Network call fail error ");
                        plugin.reject("Network call fail error ");
                    }
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e(TAG, "PackageInfo failed");
                    Log.e(TAG, t.getMessage());
                    plugin.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                    t.printStackTrace();

                }
            });


        } else {
            Log.d(TAG, "Please provide apiKey");
            plugin.reject("Expected valid apiKey");


        }
    }

    @PluginMethod
    public void tracking(PluginCall callbackContext) {
        if (isSdkValid()) {
            Map<String, Object> tracking = null;
            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
            Date date = new Date();

            try {
                tracking = new ObjectMapper().readValue(callbackContext.getData().toString(), HashMap.class);
                tracking.put("SessionId", P5LifeCycle.getP5Session());
                tracking.put("CarrierName", getCarrierName(this.bridge.getActivity()));
                tracking.put("CampaignId", 0);
                tracking.put("WorkFlowDataId", 0);
                tracking.put("IsNewSession", P5LifeCycle.isExpired);
                tracking.put("DeviceId", getDeviceId(this.bridge.getActivity()));
                tracking.put("Offline", 0);
                tracking.put("TrackDate", dateFormat.format(date));
                tracking.put("GeofenceId", "0");
                tracking.put("Locality", P5LifeCycle.Locality);
                tracking.put("City", P5LifeCycle.City);
                tracking.put("State", P5LifeCycle.State);
                tracking.put("Country", P5LifeCycle.Country);
                tracking.put("CountryCode", P5LifeCycle.CountryCode);
                tracking.put("Latitude", String.valueOf(P5LifeCycle.Latitude));
                tracking.put("Longitude", String.valueOf(P5LifeCycle.Longitude));


            } catch (Exception e) {
                Log.v(TAG, "Please check the parameters \n error -");
                e.printStackTrace();
                callbackContext.reject("Please check the parameters \n error -" + e.getLocalizedMessage());
            }
            if (tracking != null) {
                Call<String> responseBodyCall = api.Tracking(tracking);
                responseBodyCall.enqueue(new Callback<String>() {
                    @Override
                    public void onResponse(Call<String> call, retrofit2.Response<String> response) {
                        if (response.isSuccessful()) {


                            Log.v(TAG, "Tracking details sent successful");
                            callbackContext.resolve();
                        } else {

                            Log.e(TAG, "Tracking details  failed");
                            callbackContext.reject("Tracking details  failed");
                        }
                    }

                    @Override
                    public void onFailure(Call<String> call, Throwable t) {
                        Log.e(TAG, "Tracking details failed");
                        Log.e(TAG, t.getMessage());
                        callbackContext.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                        t.printStackTrace();
                    }
                });
            }
        } else {
            callbackContext.reject("PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
        }
    }

    @PluginMethod
    public void notificationSubscribe(String notificationSubscribeVF, PluginCall callbackContext) {
        callbackContext.resolve();
    }

    @PluginMethod
    public void eventPost(PluginCall callbackContext) {

        if (isSdkValid()) {
            Map<String, Object> eventDetails = new HashMap<>();

            try {
                eventDetails = new ObjectMapper().readValue(callbackContext.getData().toString(), HashMap.class);
                Date date = new Date();
                DateFormat dateFormat = new SimpleDateFormat(P5Constants.SAMPLE_DATE, Locale.ENGLISH);
                eventDetails.put(P5Constants.SESSION_ID, P5LifeCycle.getP5Session());
                eventDetails.put(P5Constants.DEVICE_ID, getDeviceId(this.bridge.getActivity()));
                eventDetails.put(P5Constants.OFFLINE, 0);
                eventDetails.put(P5Constants.TRACK_DATE, dateFormat.format(date));

            } catch (Exception e) {
                e.printStackTrace();
                callbackContext.reject("Please check the parameters \n error -" + e.getLocalizedMessage());
            }


            Call<String> responseBodyCall = api.EventResponses(eventDetails);
            responseBodyCall.enqueue(new Callback<String>() {
                @Override
                public void onResponse(Call<String> call, retrofit2.Response<String> response) {
                    if (response.isSuccessful()) {

                        //  new P5GetDialogHttpRequest(activity, eng.p5GetServiceUrl(activity), Name, Value, "").execute();
                        Log.v(TAG, "Event details sent successful");
                        callbackContext.resolve();
                    } else {

                        Log.e(TAG, "Event details  failed");
                        callbackContext.reject("Event details  failed");
                    }
                }

                @Override
                public void onFailure(Call<String> call, Throwable t) {
                    Log.e(TAG, "Event details failed");
                    Log.e(TAG, t.getMessage());
                    callbackContext.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                    t.printStackTrace();
                }
            });
        } else {
            callbackContext.reject("PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
        }
    }

    @PluginMethod
    public void pushResponse(PluginCall callbackContext) {
        if (isSdkValid()) {
            Map<String, Object> inAppDetails = new HashMap<>();

            try {
                inAppDetails = new ObjectMapper().readValue(callbackContext.getData().toString(), HashMap.class);
                inAppDetails.put(P5Constants.DEVICE_ID, getDeviceId(this.bridge.getActivity()));
                inAppDetails.put(P5Constants.SESSION_ID, P5LifeCycle.getP5Session());
                inAppDetails.put(P5Constants.EVENT_ID, "");
                inAppDetails.put(P5Constants.EVENT_VALUE, "");


            } catch (Exception e) {
                e.printStackTrace();
                callbackContext.reject("Please check the parameters \n error -" + e.getLocalizedMessage());
            }


            Call<ResponseBody> responseBodyCall = api.InAppDetails(inAppDetails);
            responseBodyCall.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                    if (response.isSuccessful()) {
                        try {
                            JSONObject jsonObject = new JSONObject(response.body().string());
                            final String getContent = jsonObject.get("FormContent").toString();
                            String WidgetName = jsonObject.get("WidgetName").toString();
                            int MobileFormId = Integer.parseInt(jsonObject.get("MobileFormId").toString());
                            Log.v(TAG, "InApp details sent successful");
                            if (!getContent.equals("")) {
                                P5DialogBox v = new P5DialogBox();
                                v.dialogBox(bridge.getActivity(), getContent, serviceURL, MobileFormId, WidgetName);
                                callbackContext.resolve();
                            } else {
                                Log.d(TAG, "There is no data or status is inactive for in-app campaign");
                                callbackContext.reject("There is no data or status is inactive for in-app campaign");
                            }


                        } catch (Exception ex) {
                            Log.e(TAG, "InApp details json failed");
                            Log.e(TAG, ex.getMessage());
                            callbackContext.reject("JSON failed - " + ex.getMessage() + "\n stack trace - ");
                            ex.printStackTrace();
                        }
                    } else {

                        Log.e(TAG, "InApp details  failed");
                        Log.e(TAG, response.errorBody().toString());
                        callbackContext.reject("InApp details  failed");
                    }
                }

                @Override
                public void onFailure(Call<ResponseBody> call, Throwable t) {
                    Log.e(TAG, "InApp details failed");
                    Log.e(TAG, t.getMessage());
                    callbackContext.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                    t.printStackTrace();
                }
            });
        } else {

        }
    }

    public void screenRoute(JSObject jsonObject) {
        notifyListeners("appUrlOpen", jsonObject);
    }

    private void checkUser(PluginCall callbackContext, JSONObject jsonObject) {

        if (null != jsonObject && jsonObject.length() > 0) {

            try {

                projectNumber = jsonObject.getString("GcmProjectNo");
                packageName = jsonObject.getString("PackageName");
                if (packageName.equals(this.bridge.getActivity().getPackageName())) {

                    deviceRegistration(callbackContext);
                } else {
                    callbackContext.reject("PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

//    public String getMetadata(Context context, String key) {
//
//
//        try {
//            return Objects.requireNonNull(context.getPackageManager().getApplicationInfo(
//                    context.getPackageName(), PackageManager.GET_META_DATA).metaData.get(key)).toString();
//
//        } catch (PackageManager.NameNotFoundException e) {
//            Log.e(TAG,
//                    "Failed to load meta-data, NameNotFound: " + e.getMessage());
//            return null;
//        } catch (NullPointerException e) {
//            Log.e(TAG,
//                    "Failed to load meta-data, NullPointer: " + e.getMessage());
//            return null;
//        }
//    }

    @PluginMethod
    public void deviceRegistration(PluginCall callbackContext) {
        if (isSdkValid()) {

            SharedPreferences pref = this.getBridge().getActivity().getSharedPreferences(P5Constants.P5_INIT_KEY, 0);
            gcmRegistrationId = pref.getString(P5Constants.PROPERTY_REG_ID, "");
            SharedPreferences.Editor editor = pref.edit();
            editor.putString(P5Constants.PACKAGE_NAME, packageName);
            editor.apply();
            checkPlayServices(callbackContext);

            Map<String, Object> json = new HashMap<>();
            try {
                PackageManager manager = this.getBridge().getActivity().getPackageManager();
                PackageInfo info = manager.getPackageInfo(this.getBridge().getActivity().getPackageName(), PackageManager.GET_ACTIVITIES);
                json.put("DeviceId", getDeviceId(this.bridge.getActivity()));
                json.put("Manufacturer", Build.MANUFACTURER);
                json.put("DeviceName", Build.MODEL);
                json.put("OS", "Android");
                json.put("OsVersion", String.valueOf(android.os.Build.VERSION.SDK_INT));
                json.put("AppVersion", info.versionCode);
                json.put("CarrierName", getCarrierName(this.bridge.getActivity()));
                json.put("DeviceDate", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH).format(new Date()));
                json.put("GcmRegId", gcmRegistrationId);
                json.put("Resolution", getScreenResolution(this.getBridge().getActivity()));
                json.put("InstalledStatus", true);
                json.put("GcmSettingsId", 0);
                json.put("IsInstalledStatusDate", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH).format(new Date()));

            } catch (Exception e) {
                Log.v(TAG, "Please check the parameters \n error -");
                Log.d(TAG, "Please check json" + e.getLocalizedMessage());
                callbackContext.reject("Please check the parameters \n error -" + e.getLocalizedMessage());
            }

            Call<String> responseBodyCall = api.DeviceRegistration(json);
            responseBodyCall.enqueue(new Callback<String>() {
                @Override
                public void onResponse(Call<String> call, retrofit2.Response<String> response) {
                    if (response.isSuccessful()) {

                        editor.putBoolean(P5Constants.IS_NEW, true);
                        Log.v(TAG, "Device registration successful");

                        callbackContext.resolve();
                    } else {
                        editor.putBoolean(P5Constants.IS_NEW, false);
                        Log.e(TAG, "Device registration failed");
                        callbackContext.reject("Device registration failed");
                    }
                }

                @Override
                public void onFailure(Call<String> call, Throwable t) {
                    Log.e(TAG, "Device registration failed");
                    Log.e(TAG, t.getMessage());
                    callbackContext.reject("Network call fail error - " + t.getMessage() + "\n stack trace - ");
                    t.printStackTrace();
                }
            });
        } else {
            callbackContext.reject("PLUMB5 SDK CANNOT BE INITIATED, PACKAGE NAME DOES NOT MATCH");
        }

    }

    private boolean checkPlayServices(PluginCall callbackContext) {
        GoogleApiAvailability googleAPI = GoogleApiAvailability.getInstance();
        int result = googleAPI.isGooglePlayServicesAvailable(this.bridge.getActivity());
        if (result != ConnectionResult.SUCCESS) {
            if (googleAPI.isUserResolvableError(result)) {
                callbackContext.reject(googleAPI.getErrorString(result));
                Log.i(TAG, "Google Play Services are not available.");
            }

            return false;
        }

        return true;
    }

    public String p5GetScreenName(Activity activity) {
        return "";
    }

    public String p5GetAppKey() {


        if (appKey != null) {
            return appKey;
        } else {
            Log.d(TAG, "Please provide appkey.");
            return "";
        }
    }

    public boolean isP5IntentAvailable(Context ctx, Intent intent) {
        final PackageManager mgr = ctx.getPackageManager();
        List<ResolveInfo> list =
                mgr.queryIntentActivities(intent,
                        PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }

    public boolean isSdkValid() {
        return getContext().getSharedPreferences(P5Constants.P5_INIT_KEY, 0).getBoolean("isSDK-Valid", false);

    }


}







