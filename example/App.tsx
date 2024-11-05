import { StyleSheet, Text, View } from 'react-native';

import * as RnBuymeSaverMedia from 'rn-buyme-saver-media';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{RnBuymeSaverMedia.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
