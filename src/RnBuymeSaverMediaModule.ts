import { requireNativeModule, EventEmitter } from "expo-modules-core";
import { DownloadProgressPayload } from "./RnBuymeSaverMedia.types";

const RnBuymeSaverMediaModule = requireNativeModule("RnBuymeSaverMedia");
const emitter = new EventEmitter(RnBuymeSaverMediaModule);

export function downloadFileToGallery(
  url: string,
  onProgress: (progress: number) => void,
): Promise<void> {
  return new Promise((resolve, reject) => {
    // Подписываемся на событие прогресса
    const subscription = emitter.addListener<DownloadProgressPayload>(
      "DownloadProgress",
      ({ progress }) => {
        onProgress(progress);
      },
    );

    // Вызываем нативный метод для загрузки файла
    RnBuymeSaverMediaModule.downloadFileToGallery(url)
      .then(() => {
        subscription.remove();
        resolve();
      })
      .catch((error: any) => {
        subscription.remove();
        reject(error);
      });
  });
}

export default RnBuymeSaverMediaModule;
