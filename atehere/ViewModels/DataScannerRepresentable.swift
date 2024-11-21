//
//  DataScannerRepresentable.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import Foundation
import VisionKit
import SwiftUI

struct DataScannerRepresentable: UIViewControllerRepresentable {
    @Binding var shouldStartScanning: Bool
    @Binding var scannedText: String
    var onScanned: (String) -> Void
    var dataToScanFor: Set<DataScannerViewController.RecognizedDataType>

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScannerRepresentable

        init(_ parent: DataScannerRepresentable) {
            self.parent = parent
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .barcode(let barcode):
                if let scannedText = barcode.payloadStringValue {
                    parent.scannedText = scannedText
                    parent.onScanned(scannedText)
                }
            default:
                print("Unsupported item scanned.")
            }
        }
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerVC = DataScannerViewController(
            recognizedDataTypes: dataToScanFor,
            qualityLevel: .fast,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: false,
            isGuidanceEnabled: false,
            isHighlightingEnabled: true
        )
        dataScannerVC.delegate = context.coordinator
        return dataScannerVC
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if shouldStartScanning {
            try? uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
