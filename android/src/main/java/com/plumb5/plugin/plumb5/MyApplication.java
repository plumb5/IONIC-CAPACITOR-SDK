package com.plumb5.plugin.plumb5;


import android.app.Application;


public class MyApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();


        registerActivityLifecycleCallbacks(new P5LifeCycle());

    }


}