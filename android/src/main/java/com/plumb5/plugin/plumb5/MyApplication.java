package com.plumb5.plugin.plumb5;


import android.app.Application;


public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();


        registerActivityLifecycleCallbacks(new com.plumb5.plugin.plumb5.P5LifeCycle());

    }


}