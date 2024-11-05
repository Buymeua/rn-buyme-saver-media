package expo.modules.rnbuymesavermedia

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import kotlinx.coroutines.*
import java.net.URL

class RnBuymeSaverMediaModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("RnBuymeSaverMedia")

    Events("DownloadProgress")

    AsyncFunction("downloadFileToGallery") { url: String ->
      withContext(Dispatchers.IO) {
        try {
          val connection = URL(url).openConnection()
          val totalSize = connection.contentLength
          var downloadedSize = 0

          connection.getInputStream().use { input ->
            val buffer = ByteArray(1024)
            var bytesRead: Int
            while (input.read(buffer).also { bytesRead = it } != -1) {
              downloadedSize += bytesRead
              val progress = (downloadedSize * 100) / totalSize

              // Отправка события прогресса загрузки
              sendEvent("DownloadProgress", mapOf("progress" to progress))
            }
          }
          sendEvent("DownloadProgress", mapOf("progress" to 100)) // Завершение
        } catch (e: Exception) {
          e.printStackTrace()
        }
      }
    }

    Constants("PI" to Math.PI)
    Function("hello") { "Hello world! 👋" }
  }
}
