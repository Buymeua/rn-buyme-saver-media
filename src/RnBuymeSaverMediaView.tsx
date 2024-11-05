import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { RnBuymeSaverMediaViewProps } from './RnBuymeSaverMedia.types';

const NativeView: React.ComponentType<RnBuymeSaverMediaViewProps> =
  requireNativeViewManager('RnBuymeSaverMedia');

export default function RnBuymeSaverMediaView(props: RnBuymeSaverMediaViewProps) {
  return <NativeView {...props} />;
}
