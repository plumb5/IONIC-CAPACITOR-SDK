#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(Plumb5Plugin, "Plumb5",
           CAP_PLUGIN_METHOD(setUserDetails, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(initializePlumb5, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(deviceRegistration, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(tracking, CAPPluginReturnPromise);

           CAP_PLUGIN_METHOD(eventPost, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserDetails, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(pushResponse, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(register, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(checkPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(requestPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getDeliveredNotifications, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeAllDeliveredNotifications, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeAllListeners, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeDeliveredNotifications, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(createChannel, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(listChannels, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(deleteChannel, CAPPluginReturnPromise);
           
)
