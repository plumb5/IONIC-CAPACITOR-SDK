package com.plumb5.plugin.plumb5;

import android.content.IntentFilter;
import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

public class P5FirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "P5FCM";
    Plumb5Plugin eng = new Plumb5Plugin();
    String workflowId = null;
    String P5UniqueId = "";

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        Log.d(TAG, "New token: " + token);
        getApplicationContext()
                .getSharedPreferences(P5Constants.P5_INIT_KEY, 0)
                .edit()
                .putString(P5Constants.PROPERTY_REG_ID, token)
                .apply();
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        Log.d(TAG, "==> MyFirebaseMessagingService onMessageReceived");

        if (remoteMessage.getNotification() != null) {
            Log.d(TAG, "\tNotification Title: " + remoteMessage.getNotification().getTitle());
            Log.d(TAG, "\tNotification Message: " + remoteMessage.getNotification().getBody());

        }
        sendNotification(remoteMessage.getData());
    }


    private void sendNotification(Map<String, String> data) {


        if (P5LifeCycle.getactivity == null) {
            String pkg = this.getPackageName();
            P5LifeCycle plyf = new P5LifeCycle();
            this.getApplicationContext().registerReceiver(plyf.pushbroadcastReceiver, new IntentFilter(pkg + ".chatmessage"));
            IntentFilter afilter = new IntentFilter();
            afilter.addAction(pkg + ".0");
            afilter.addAction(pkg + ".1");
            afilter.addAction(pkg + ".2");
            afilter.addAction(pkg + ".3");
            afilter.addAction(pkg + ".4");
            afilter.addAction(pkg + ".5");
            afilter.addAction(pkg + ".6");
            afilter.addAction(pkg + ".7");
            afilter.addAction(pkg + ".8");
            afilter.addAction(pkg + ".9");
            this.getApplicationContext().registerReceiver(plyf.MyActionReceiver, afilter);
            this.getApplicationContext().registerReceiver(plyf.dMyAlarmReceiver, new IntentFilter(pkg + ".alarm"));


            //Log.d("p5", "notification hhh"+p5geo.LatLngList);
        }
        //end activate............

        if (data != null) {
            if (data.containsKey("title") && data.containsKey("message") && data.containsKey("time") && data.containsKey("app")) {
                String title = data.get("title").toString().replace("~A~", "&");
                String message = data.get("message").toString().replace("~A~", "&");
                String date = data.get("time").toString();
                if (data.containsKey("workflowdataId")) {
                    if (data.get("workflowdataId") != null) {
                        workflowId = data.get("workflowdataId").toString();
                    } else {
                        workflowId = "0";
                    }
                } else {
                    workflowId = "0";
                }
                if (data.containsKey("P5UniqueId")) {
                    if (data.get("P5UniqueId") != null) {
                        P5UniqueId = data.get("P5UniqueId").toString();
                    } else {
                        P5UniqueId = "0";
                    }
                } else {
                    P5UniqueId = "0";
                }

                try {
                    String nExtraAction = data.get("extraaction").toString();
                    int nclkAction = Integer.parseInt(data.get("clickaction").toString());
                    int nAction = 1, nPushId = 0;
                    String nTicker = "Lead", nTitle = "Plumb5 - Lead", nIntent = "", nParameter = "";

                    String[] atitle = title.split("\\^");
                    if (atitle.length == 5) {
                        nPushId = Integer.parseInt(atitle[0].toString());
                        nAction = Integer.parseInt(atitle[1].toString());
                        nTicker = atitle[2].toString();
                        nTitle = atitle[3].toString();
                        nIntent = atitle[4].toString();

                        if (nclkAction == 0 || nclkAction == 1) {
                            if (nIntent.contains("|")) {
                                String[] aintent = nIntent.split("\\|");
                                nIntent = aintent[0].toString();
                                nParameter = aintent[1].toString();
                            } else {
                                nIntent = nIntent;
                            }
                        }

                        String nMessage = "", nSubtext = "", nImage = "";
                        String[] amessage = message.split("\\^");
                        if (amessage.length > 0) {
                            nMessage = amessage[0].toString();
                            nSubtext = amessage[1].toString();
                            nImage = amessage[2].toString();
                        }
                        //Log.d("Plumb5", nAction + " ~ " + nTicker + " ~ " + nTitle + " ~ " + message + " ~ " + nIntent);
                        P5SendNotification Noti = new P5SendNotification();
                        Noti.Send(this, nPushId, nAction, nTicker, nTitle, nMessage, nSubtext, nImage, nclkAction, nIntent, nParameter, nExtraAction, "", "", workflowId,P5UniqueId);
                    } else {
                        Log.d(TAG, "Problem with parameters");
                    }

                } catch (Exception ex) {
                    Log.d(TAG, ex.getMessage());
                }
            }


        }

    }
}


