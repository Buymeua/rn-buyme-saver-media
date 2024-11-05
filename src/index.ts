import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to RnBuymeSaverMedia.web.ts
// and on native platforms to RnBuymeSaverMedia.ts
import RnBuymeSaverMediaModule from './RnBuymeSaverMediaModule';
import RnBuymeSaverMediaView from './RnBuymeSaverMediaView';
import { ChangeEventPayload, RnBuymeSaverMediaViewProps } from './RnBuymeSaverMedia.types';

// Get the native constant value.
export const PI = RnBuymeSaverMediaModule.PI;

export function hello(): string {
  return RnBuymeSaverMediaModule.hello();
}

export async function setValueAsync(value: string) {
  return await RnBuymeSaverMediaModule.setValueAsync(value);
}

const emitter = new EventEmitter(RnBuymeSaverMediaModule ?? NativeModulesProxy.RnBuymeSaverMedia);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { RnBuymeSaverMediaView, RnBuymeSaverMediaViewProps, ChangeEventPayload };
