#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(Plumb5Plugin, "Plumb5",
           CAP_PLUGIN_METHOD(setUserDetails, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(deviceRegistration, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(tracking, CAPPluginReturnPromise);

           CAP_PLUGIN_METHOD(eventPost, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserDetails, CAPPluginReturnPromise);
           
)
