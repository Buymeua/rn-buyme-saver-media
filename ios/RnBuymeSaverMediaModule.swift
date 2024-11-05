import ExpoModulesCore
import Photos

public class RnBuymeSaverMediaModule: Module {
  public func definition() -> ModuleDefinition {
    Name("RnBuymeSaverMedia")

    Constants([
      "PI": Double.pi
    ])

    Events("DownloadProgress")

    Function("hello") {
      return "Hello world! 👋"
    }

    AsyncFunction("downloadFileToGallery") { (urlString: String) in
      guard let url = URL(string: urlString) else {
        throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
      }

      try await self.downloadFile(from: url)
    }
  }

  private func downloadFile(from url: URL) async throws {
    let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    let downloadTask = session.downloadTask(with: url)
    downloadTask.resume()
  }
}

extension RnBuymeSaverMediaModule: URLSessionDownloadDelegate {
  public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) * 100
    sendEvent("DownloadProgress", [
      "progress": progress
    ])
  }

  public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    let fileManager = FileManager.default
    let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let cachedFileURL = cachesDirectory.appendingPathComponent(location.lastPathComponent)

    do {
      // Удаляем файл, если он уже существует в кэше
      if fileManager.fileExists(atPath: cachedFileURL.path) {
        try fileManager.removeItem(at: cachedFileURL)
      }

      // Перемещаем файл в кэш
      try fileManager.moveItem(at: location, to: cachedFileURL)

      // Сохраняем файл в галерею
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: cachedFileURL)
      }) { success, error in
        if success {
          self.sendEvent("DownloadProgress", [
            "progress": 100
          ])
        } else {
          print("Ошибка сохранения в галерею: \(String(describing: error))")
        }
      }
    } catch {
      print("Ошибка перемещения файла в кэш: \(error)")
    }
  }
}
