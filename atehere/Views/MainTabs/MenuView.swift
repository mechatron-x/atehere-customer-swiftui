//
//  MenuView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var qrViewModel: QRScanViewModel
    
    var body: some View {
        if let qrCodeData = qrViewModel.qrCodeData {
            ActiveMenuView(qrCodeData: qrCodeData)
        } else {
            InactiveQRMenuView()
        }
    }
}
