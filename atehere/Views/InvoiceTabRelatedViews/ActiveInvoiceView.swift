//
//  ActiveInvoiceView.swift
//  atehere
//
//  Created by Berke Bozacı on 3.12.2024.
//

import SwiftUI

struct ActiveInvoiceView: View {
    let qrCodeData: QRCodeData
    @StateObject private var invoiceViewModel: InvoiceViewModel
    @EnvironmentObject var tabSelectionManager: TabSelectionManager
    @EnvironmentObject var qrViewModel: QRScanViewModel

        
    init(qrCodeData: QRCodeData) {
        self.qrCodeData = qrCodeData
        _invoiceViewModel = StateObject(wrappedValue: InvoiceViewModel(tableID: qrCodeData.tableID ?? ""))
    }

    
    var body: some View {
        VStack {
            if invoiceViewModel.isLoading {
                ProgressView("Loading orders...")
            } else if let errorMessage = invoiceViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if invoiceViewModel.orderItems.isEmpty {
                Text("You haven’t ordered yet.")
                    .font(.title)
                    .bold()
                    .padding(.top)

                Text("Go to the restaurant menu to order some delicious foods.")
                    .font(.title3)
                    .padding(.top, 8)
            } else {
                List(invoiceViewModel.orderItems) { order in
                    HStack {
                        Text(order.menuItemName)
                            .font(.headline)
                        Spacer()
                        Text("Quantity: \(order.quantity)")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            if let tableID = qrCodeData.tableID {
                invoiceViewModel.tableID = tableID
                invoiceViewModel.fetchOrders()
            } else {
                invoiceViewModel.errorMessage = "Table ID is missing."
            }
        }
        .onReceive(tabSelectionManager.$tabSelection) { newSelection in
                    if newSelection == .invoice {
                        fetchOrdersIfNeeded()
                    }
                }
        
    }
    private func fetchOrdersIfNeeded() {
           if let tableID = qrViewModel.qrCodeData?.tableID, !tableID.isEmpty {
               invoiceViewModel.tableID = tableID
               invoiceViewModel.fetchOrders()
           } else {
               invoiceViewModel.errorMessage = "Table ID is missing."
           }
       }
    

}
