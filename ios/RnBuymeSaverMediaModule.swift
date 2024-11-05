import ExpoModulesCore
import Photos
import UIKit

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
        if let image = UIImage(contentsOfFile: fileURL.path) {
          UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          print("Image saved to gallery successfully.")
        } else {
          print("Failed to load image from URL for saving.")
        }
      } else {
        print("No permission to save to gallery.")
      }
    }
  }
}

class FileDownloader: NSObject, URLSessionDownloadDelegate {
  private var onProgress: ((Double) -> Void)?
  private var onComplete: ((URL?, Error?) -> Void)?

  func startDownload(from url: URL, onProgress: @escaping (Double) -> Void, completion: @escaping (URL?, Error?) -> Void) {
    self.onProgress = onProgress
    self.onComplete = completion
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    let downloadTask = session.downloadTask(with: url)
    downloadTask.resume()
  }

  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) * 100
    onProgress?(progress)
  }

  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    let fileManager = FileManager.default
    let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let cachedFileURL = cachesDirectory.appendingPathComponent(location.lastPathComponent)

    do {
      if fileManager.fileExists(atPath: cachedFileURL.path) {
        try fileManager.removeItem(at: cachedFileURL)
      }

      try fileManager.moveItem(at: location, to: cachedFileURL)
      onComplete?(cachedFileURL, nil)
    } catch {
      onComplete?(nil, error)
    }
  }
}
