import type { PluginListenerHandle } from '@capacitor/core';
export interface Plumb5Plugin extends PluginListenerHandle {
  addListener(eventName: 'onPushNotification', listenerFunc: ({ routeUrl: string }) => void): PluginListenerHandle;
  initializePlumb5(): Promise<void>;
  deviceRegistration(): Promise<void>;
  setUserDetails(options: UserOptions): Promise<void>;
  tracking(options: {
    ScreenName: string;
    PageParameter: any;
  }): Promise<void>;
  pushResponse(options: {
    ScreenName: string;
    PageParameter: any;
  }): Promise<void>;
  eventPost(options: EventDetails): Promise<void>;
}
export interface UserOptions {
  Name: string;
  EmailId: string;
  PhoneNumber: string;
  LeadType: number;
  Gender: string;
  Age: string;
  AgeRange: string;
  MaritalStatus: string;
  Education: string;
  Occupation: string;
  Interests: string;
  Location: string;
}
export interface EventDetails {
  Type: string;
  Name: string;
  PhoneNumber: string;
  Value: number;
}
export interface PluginsConfig {
  Plumb5?: {
    PLUMB5_ACCOUNT_ID?: number;
    PLUMB5_BASE_URL?: string;
    PLUMB5_API_KEY?: string;
  };
}
