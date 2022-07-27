import { WebPlugin } from '@capacitor/core';

import type { Plumb5Plugin } from './definitions';

export class Plumb5Web extends WebPlugin implements Plumb5Plugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
