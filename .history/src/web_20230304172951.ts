/* eslint-disable @typescript-eslint/no-unused-vars */
import { WebPlugin } from '@capacitor/core';

import type { Channel, DeliveredNotifications, EventDetails, ListChannelsResult, PermissionStatus, Plumb5Plugin, UserOptions } from './definitions';

export class Plumb5Web extends WebPlugin implements Plumb5Plugin {
  register(): Promise<void> {
   throw new Error('Method not implemented.');
  }
  getDeliveredNotifications(): Promise<DeliveredNotifications> {
   throw new Error('Method not implemented.');
  }
  removeDeliveredNotifications(delivered: DeliveredNotifications): Promise<void> {
    throw new Error('Method not implemented.');
  }
  removeAllDeliveredNotifications(): Promise<void> {
    throw new Error('Method not implemented.');
  }
  createChannel(channel: Channel): Promise<void> {
    throw new Error('Method not implemented.');
  }
  deleteChannel(args: { id: string; }): Promise<void> {
    throw new Error('Method not implemented.');
  }
  listChannels(): Promise<ListChannelsResult> {
    throw new Error('Method not implemented.');
  }
  checkPermissions(): Promise<PermissionStatus> {
    throw new Error('Method not implemented.');
  }
  requestPermissions(): Promise<PermissionStatus> {
    throw new Error('Method not implemented.');
  }

  initializePlumb5(): Promise<void> {
   throw new Error('Method not implemented.');
  }
  deviceRegistration(): Promise<void> {
   throw new Error('Method not implemented.');
  }
  setUserDetails(_options: UserOptions):Promise<void> {
   throw new Error('Method not implemented.');
  }
  tracking(_options: { ScreenName: string; PageParameter: any; }): Promise<void> {
   throw new Error('Method not implemented.');
  }
  pushResponse(_options: { ScreenName: string; PageParameter: any; }):Promise<void> {
   throw new Error('Method not implemented.');
  }
  eventPost(_options: EventDetails): Promise<void> {
   throw new Error('Method not implemented.');
  }
  notificationSubscribe():Promise<void> {
   throw new Error('Method not implemented.');
  }


   
 
}
