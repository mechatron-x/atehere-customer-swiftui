//
//  QRScanView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI
import VisionKit

struct QRScanView: View {
    @EnvironmentObject var viewModel: QRScanViewModel
    @State var isShowingScanner = true
    @EnvironmentObject var tabSelectionManager: TabSelectionManager

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                DataScannerRepresentable(
                    shouldStartScanning: $isShowingScanner,
                    scannedText: $viewModel.scannedText,
                    onScanned: viewModel.handleScannedText,
                    dataToScanFor: [.barcode(symbologies: [.qr])]
                )

                Text(viewModel.scannedText)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding()
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.navigateToMenu, { oldValue, newValue in
                tabSelectionManager.tabSelection = .menu
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Invalid QR Code"),
                      message: Text("The scanned QR code is invalid or not in the correct format."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}
