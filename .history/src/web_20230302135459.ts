/* eslint-disable @typescript-eslint/no-unused-vars */
import { WebPlugin } from '@capacitor/core';

import type { EventDetails, Plumb5Plugin, UserOptions } from './definitions';

export class Plumb5Web extends WebPlugin implements Plumb5Plugin {

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
  notificationSubscribe(_options: { Data: any;  }):Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }

   
 
}
