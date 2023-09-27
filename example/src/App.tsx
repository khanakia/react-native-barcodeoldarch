import * as React from 'react';

import { StyleSheet, View, Text, Button } from 'react-native';
import { multiply, scan, InitEvents } from 'react-native-barcodeoldarch';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  const ScanEvents = InitEvents()
  React.useEffect(() => {
    // console.log(scan)

    ScanEvents.addListener("onBarcodeScanned", (result: any ) => {
      console.log("result", result)
    })
    
    multiply(3, 7).then(setResult);

    return () => {
      ScanEvents.removeAllListeners("onBarcodeScanned");
    }
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Button onPress={() => {
        scan()
      }} title="Scan" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
