import { NativeModules, NativeEventEmitter, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-barcodeoldarch' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const Barcodeoldarch = NativeModules.Barcodeoldarch
  ? NativeModules.Barcodeoldarch
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return Barcodeoldarch.multiply(a, b);
}

export function scan() {
  return Barcodeoldarch.scan();
}

export function InitEvents(): NativeEventEmitter {
  return new NativeEventEmitter(NativeModules.Barcodeoldarch)
}
