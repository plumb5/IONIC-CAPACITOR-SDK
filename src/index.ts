import { registerPlugin } from '@capacitor/core';

import type { Plumb5Plugin } from './definitions';

const Plumb5 = registerPlugin<Plumb5Plugin>('Plumb5', {
  web: () => import('./web').then(m => new m.Plumb5Web()),
});

export * from './definitions';
export { Plumb5 };
