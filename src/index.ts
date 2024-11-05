import {
  NativeModulesProxy,
  EventEmitter,
  Subscription,
} from "expo-modules-core";

import {
  ChangeEventPayload,
  RnBuymeSaverMediaViewProps,
} from "./RnBuymeSaverMedia.types";
import RnBuymeSaverMediaModule, {
  downloadFileToGallery,
} from "./RnBuymeSaverMediaModule";
import RnBuymeSaverMediaView from "./RnBuymeSaverMediaView";

export const PI = RnBuymeSaverMediaModule.PI;

export function hello(): string {
  return RnBuymeSaverMediaModule.hello();
}

export async function setValueAsync(value: string) {
  return await RnBuymeSaverMediaModule.setValueAsync(value);
}

const emitter = new EventEmitter(
  RnBuymeSaverMediaModule ?? NativeModulesProxy.RnBuymeSaverMedia,
);

export function addChangeListener(
  listener: (event: ChangeEventPayload) => void,
): Subscription {
  return emitter.addListener<ChangeEventPayload>("onChange", listener);
}

export { RnBuymeSaverMediaView, RnBuymeSaverMediaViewProps, ChangeEventPayload, downloadFileToGallery };
