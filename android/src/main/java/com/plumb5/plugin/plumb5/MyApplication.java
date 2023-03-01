package com.plumb5.plugin.plumb5;


import static com.plumb5.plugin.plumb5.P5LifeCycle.TAG;


import android.app.Application;
import android.util.Log;


public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();


        registerActivityLifecycleCallbacks(new P5LifeCycle());

    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        Log.d(TAG,"onTerminate");
    }


}