import Foundation
import VisionKit
import React
import UIKit


@objc(Barcodeoldarch)
class Barcodeoldarch: RCTEventEmitter, DataScannerViewControllerDelegate {

    @objc(multiply:withB:withResolver:withRejecter:)
        func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        sendEvent(withName: "onBarcodeScanned", body: ["test"])
        resolve(a*b)
    }
    
    let viewController = DataScannerViewController(
      recognizedDataTypes: [.barcode()],
      qualityLevel: .fast,
      recognizesMultipleItems: false,
      isHighFrameRateTrackingEnabled: false,
      isHighlightingEnabled: true)

    var scannerAvailable: Bool {
      DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }

    @objc
    func scan(){
      print("Test")
        if(!scannerAvailable) {
            print("Scanner not available")
            return
        }
      viewController.delegate = self

      DispatchQueue.main.async {
        let rootViewController = RCTPresentedViewController()
        rootViewController!.present(self.viewController, animated: true) {
          try? self.viewController.startScanning()
        }
      }
    }

    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
          switch item {
             case .text(let text):
               print("text: \(text.transcript)")
             case .barcode(let barcode):
                 print("barcode: \(barcode.payloadStringValue ?? "unknown")")
                dataScanner.stopScanning()
                dataScanner.dismiss(animated: true)
                sendEvent(withName: "onBarcodeScanned", body: [barcode.payloadStringValue])
             default:
                 print("unexpected item")
                sendEvent(withName: "onScanError", body: ["unable to scan"])
           }
        }
    }
    
    override func supportedEvents() -> [String]! {
        return ["onBarcodeScanned", "onScanError"]
    }
}
