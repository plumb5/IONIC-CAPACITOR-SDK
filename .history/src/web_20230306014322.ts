/* eslint-disable @typescript-eslint/no-unused-vars */
import { WebPlugin } from '@capacitor/core';

import type { Channel, DeliveredNotifications, EventDetails, ListChannelsResult, PermissionStatus, Plumb5Plugin, UserOptions } from './definitions';

export class Plumb5Web extends WebPlugin implements Plumb5Plugin {
  register(): Promise<void> {
   return new Promise((resolve, _reject) => resolve);
  }
  getDeliveredNotifications(): Promise<DeliveredNotifications> {
   return new Promise((resolve, _reject) => resolve);
  }
  removeDeliveredNotifications(_delivered: DeliveredNotifications): Promise<void> {
   return new Promise((resolve, _reject) => resolve);
  }
  removeAllDeliveredNotifications(): Promise<void> {
   return new Promise((resolve, _reject) => resolve);
  }
  createChannel(_channel: Channel): Promise<void> {
   return new Promise((resolve, _reject) => resolve);
  }
  deleteChannel(_args: { id: string; }): Promise<void> {
   return new Promise((resolve, _reject) => resolve);
  }
  listChannels(): Promise<ListChannelsResult> {
   return new Promise((resolve, _reject) => resolve);
  }
  checkPermissions(): Promise<PermissionStatus> {
   return new Promise((resolve, _reject) => resolve);
  }
  requestPermissions(): Promise<PermissionStatus> {
   return new Promise((resolve, _reject) => resolve);
  }

  initializePlumb5(): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  deviceRegistration(): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  setUserDetails(_options: UserOptions):Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  tracking(_options: { ScreenName: string; PageParameter: any; }): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  pushResponse(_options: { ScreenName: string; PageParameter: any; }):Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  eventPost(_options: EventDetails): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  notificationSubscribe():Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }


   
 
}
