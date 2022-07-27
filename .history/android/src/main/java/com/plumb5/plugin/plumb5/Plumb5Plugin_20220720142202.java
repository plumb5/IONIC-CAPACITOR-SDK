package com.plumb5.plugin.plumb5;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

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

    Log.d(TAG, "inside native code : " + action);
    
        
@PluginMethod
private void setup(PluginCall call) {
  
}
    
}
