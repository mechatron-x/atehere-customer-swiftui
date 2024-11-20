//
//  QRScanView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

//struct QRScanView: View {
//    @State var isShowingScanner = true
//    @State private var scannedText = ""
//    @State private var qrCodeData: QRCodeData?
//    @State private var navigateToMenu = false // For future navigation
//    
//    var body: some View {
//        if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
//            ZStack(alignment: .bottom) {
//                DataScannerRepresentable(
//                    shouldStartScanning: $isShowingScanner,
//                    scannedText: $scannedText,
//                    qrCodeData: $qrCodeData,
//                    dataToScanFor: [.barcode(symbologies: [.qr])]
//                )
//                .onChange(of: qrCodeData) { newQRCodeData in
//                    if let qrCodeData = newQRCodeData {
//                        saveQRCodeData(qrCodeData)
//                        // Set flag to navigate to menu
//                        navigateToMenu = true
//                    }
//                }
//                
//                Text(scannedText)
//                    .padding()
//                    .background(Color.white)
//                    .foregroundColor(.black)
//            }
//            // Navigation to MenuView (implement in the future)
//            .background(
//                NavigationLink(
//                    destination: QRMenuView(restaurantID: qrCodeData?.restaurantID ?? "", tableID: qrCodeData?.tableID ?? ""),
//                    isActive: $navigateToMenu
//                ) {
//                    EmptyView()
//                }
//            )
//        } else if !DataScannerViewController.isSupported {
//            Text("This device doesn't support DataScannerViewController.")
//        } else {
//            Text("Camera is not available.")
//        }
//    }
//    
//    private func saveQRCodeData(_ qrCodeData: QRCodeData) {
//        let defaults = UserDefaults.standard
//        defaults.set(qrCodeData.restaurantID, forKey: "restaurantID")
//        defaults.set(qrCodeData.tableID, forKey: "tableID")
//    }
//}
//
//#Preview {
//    QRScanView()
//}

import SwiftUI
import VisionKit

struct QRScanView: View {
    @StateObject private var viewModel = QRScanViewModel()
    @State var isShowingScanner = true

    var body: some View {
        NavigationView {
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
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
                .background(
                    NavigationLink(
                        destination: QRMenuView(restaurantID: viewModel.qrCodeData?.restaurantID ?? "", tableID: viewModel.qrCodeData?.tableID ?? ""),
                        isActive: $viewModel.navigateToMenu
                    ) {
                        EmptyView()
                    }
                )
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Invalid QR Code"),
                          message: Text("The scanned QR code is invalid or not in the correct format."),
                          dismissButton: .default(Text("OK")))
                }
            } else {
                Text("Your device doesn't support QR scanning.")
                    .padding()
            }
        }
    }
}
