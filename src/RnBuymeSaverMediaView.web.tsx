import * as React from "react";

import { RnBuymeSaverMediaViewProps } from "./RnBuymeSaverMedia.types";

export default function RnBuymeSaverMediaView(
  props: RnBuymeSaverMediaViewProps,
) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
