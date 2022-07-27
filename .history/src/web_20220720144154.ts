import { WebPlugin } from '@capacitor/core';

import type { Plumb5Plugin, UserOptions } from './definitions';

export class Plumb5Web extends WebPlugin implements Plumb5Plugin {
  initializePlumb5(): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  deviceRegistration(): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  setUserDetails(options: UserOptions):Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  tracking(options: { ScreenName: string; PageParameter: any; }): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  pushResponse(options: { ScreenName: string; PageParameter: any; }):Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  eventPost(options: UserOptions): Promise<void> {
    return new Promise((resolve, _reject) => resolve);
  }
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
   
 
}
