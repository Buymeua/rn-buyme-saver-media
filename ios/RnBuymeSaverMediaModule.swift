import ExpoModulesCore
import Photos
import AVFoundation

public class RnBuymeSaverMediaModule: Module {
  public func definition() -> ModuleDefinition {
    Name("RnBuymeSaverMedia")

    Events("DownloadProgress")

    AsyncFunction("downloadFileToGallery") { (urlString: String) in
      guard let url = URL(string: urlString) else {
        throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
      }

      let downloader = FileDownloader()
      downloader.startDownload(from: url) { progress in
        self.sendEvent("DownloadProgress", ["progress": progress])
      } completion: { fileURL, error in
        if let fileURL = fileURL {
          self.saveToGallery(fileURL: fileURL)
        } else if let error = error {
          print("Download failed with error: \(error.localizedDescription)")
        }
      }
    }
  }

  private func saveToGallery(fileURL: URL) {
    PHPhotoLibrary.requestAuthorization { status in
      if status == .authorized {
        // Проверка на тип файла (видео или изображение)
        let fileExtension = fileURL.pathExtension.lowercased()
        if ["mp4", "mov", "webm"].contains(fileExtension) {
          self.saveVideoToGallery(fileURL: fileURL)
        } else {
          self.saveImageToGallery(fileURL: fileURL)
        }
      } else {
        print("No permission to save to gallery.")
      }
    }
  }

  private func saveImageToGallery(fileURL: URL) {
    if let image = UIImage(contentsOfFile: fileURL.path) {
      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
      print("Image saved to gallery successfully.")
    } else {
      print("Failed to load image from URL for saving.")
    }
  }

  private func saveVideoToGallery(fileURL: URL) {
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
    }) { success, error in
      if success {
        print("Video saved to gallery successfully.")
      } else {
        print("Failed to save video to gallery: \(String(describing: error))")
      }
    }
  }
}
