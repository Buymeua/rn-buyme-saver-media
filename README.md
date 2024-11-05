# rn-buyme-saver-media

``rn-buyme-saver-media`` — это нативный модуль для React Native, позволяющий скачивать файлы из сети и сохранять их в галерею на устройствах iOS и Android. Модуль поддерживает отслеживание прогресса загрузки.

# Установка

1. Добавьте модуль в ваш проект:
```bash
yarn add rn-buyme-saver-media
```
2. Если вы используете Expo, настройте Expo Development Client:
```bash 
expo install expo-dev-client
```
3. Выполните pod install для установки зависимостей iOS:
```bash
cd ios
pod install
```

# Настройка для iOS

Чтобы модуль мог сохранять файлы в галерею, добавьте следующие разрешения в Info.plist:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Требуется доступ к галерее для сохранения изображений</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Требуется разрешение для добавления изображений в галерею</string>
```

# Использование

Импортируйте и используйте функцию downloadFileToGallery, передавая URL файла и коллбэк для отслеживания прогресса загрузки.

## Пример

```typescript
import React, { useState } from 'react';
import { Button, View, Text } from 'react-native';
import { downloadFileToGallery } from 'rn-buyme-saver-media';

export default function App() {
  const [progress, setProgress] = useState(0);

  const handleDownload = () => {
    downloadFileToGallery("https://example.com/image.jpg", setProgress)
      .then(() => alert("Download completed!"))
      .catch(error => alert(`Download failed: ${error.message}`));
  };

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Button title="Download File" onPress={handleDownload} />
      <Text>{`Download Progress: ${progress}%`}</Text>
    </View>
  );
}
```

# API

``downloadFileToGallery(url: string, onProgress: (progress: number) => void): Promise<void>``

* ``url`` - URL загружаемого файла.
* ``onProgress`` - функция коллбэк, вызываемая с текущим прогрессом загрузки в процентах.

## Примечание

Для работы на iOS с сохранением файлов в галерею модуль использует PHPhotoLibrary, поэтому требуется разрешение на доступ к фото-библиотеке.


## Поддержка
Для вопросов и предложений свяжитесь с нами.

---

- [Documentation for the latest stable release](https://docs.expo.dev/versions/latest/sdk/rn-buyme-saver-media/)

# Installation in managed Expo projects

For [managed](https://docs.expo.dev/archive/managed-vs-bare/) Expo projects, please follow the installation instructions in the [API documentation for the latest stable release](#api-documentation). If you follow the link and there is no documentation available then this library is not yet usable within managed projects &mdash; it is likely to be included in an upcoming Expo SDK release.

# Installation in bare React Native projects

For bare React Native projects, you must ensure that you have [installed and configured the `expo` package](https://docs.expo.dev/bare/installing-expo-modules/) before continuing.

### Configure for iOS

Run `npx pod-install` after installing the npm package.
