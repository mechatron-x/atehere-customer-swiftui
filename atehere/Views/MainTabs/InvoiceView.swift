//
//  InvoiceView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

struct InvoiceView: View {
    @EnvironmentObject var qrViewModel: QRScanViewModel

    var body: some View {
        if let qrCodeData = qrViewModel.qrCodeData {
            ActiveInvoiceView(qrCodeData: qrCodeData)
        } else {
            InactiveQRInvoiceView()
        }
    }
}

#Preview {
    InvoiceView()
}
