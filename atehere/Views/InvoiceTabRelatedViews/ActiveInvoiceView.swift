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
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Customer Orders Section
                        Text("Your Orders")
                            .font(.title2)
                            .bold()

                        if invoiceViewModel.orderItems.isEmpty {
                            Text("You haven’t ordered yet.")
                                .font(.title3)
                            Text("Go to the restaurant menu to order some delicious foods.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(invoiceViewModel.orderItems) { order in
                                HStack {
                                    Text(order.menuItemName)
                                        .font(.headline)
                                    Spacer()
                                    Text("Qty: \(order.quantity)")
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        Divider().padding(.vertical)

                        // Table Orders Section
                        Text("Total Table Orders")
                            .font(.title2)
                            .bold()

                        if invoiceViewModel.tableOrderItems.isEmpty {
                            Text("No orders have been placed at this table yet.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            // Group orders by customerFullName
                            let groupedByCustomer = Dictionary(grouping: invoiceViewModel.tableOrderItems, by: { $0.customerFullName })

                            ForEach(Array(groupedByCustomer.keys), id: \.self) { customerName in
                                // Customer Name Heading
                                Text(customerName)
                                    .font(.title3)
                                    .bold()
                                    .padding(.top, 8)

                                let customerOrders = groupedByCustomer[customerName]!
                                let customerTotal = customerOrders.reduce(0.0) { $0 + $1.totalPrice }

                                // Orders for this customer
                                ForEach(customerOrders) { order in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(order.menuItemName)
                                                .font(.headline)
                                            Spacer()
                                            Text("Qty: \(order.quantity)")
                                                .font(.subheadline)
                                        }

                                        HStack {
                                            Text("Unit Price:")
                                            Text(String(format: "%.2f %@", order.unitPrice, invoiceViewModel.tableCurrency))
                                                .fontWeight(.medium)
                                        }
                                        .font(.subheadline)

                                        HStack {
                                            Text("Line Total:")
                                            Text(String(format: "%.2f %@", order.totalPrice, invoiceViewModel.tableCurrency))
                                                .fontWeight(.medium)
                                        }
                                        .font(.subheadline)
                                        .padding(.bottom, 8)
                                    }
                                    .padding(.vertical, 4)
                                }

                                // Customer total line
                                HStack {
                                    Text("Total for \(customerName):")
                                        .font(.headline)
                                    Spacer()
                                    Text(String(format: "%.2f %@", customerTotal, invoiceViewModel.tableCurrency))
                                        .font(.headline)
                                        .bold()
                                }
                                .padding(.vertical, 8)
                            }

                            // Table total price line (if available)
                            if invoiceViewModel.tableTotalPrice > 0 {
                                HStack {
                                    Text("Table Total Price:")
                                        .font(.headline)
                                    Spacer()
                                    Text(String(format: "%.2f %@", invoiceViewModel.tableTotalPrice, invoiceViewModel.tableCurrency))
                                        .font(.headline)
                                        .bold()
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchAllOrdersIfNeeded()
        }
        .onReceive(tabSelectionManager.$tabSelection) { newSelection in
            if newSelection == .invoice {
                fetchAllOrdersIfNeeded()
            }
        }
    }

    private func fetchAllOrdersIfNeeded() {
        if let tableID = qrCodeData.tableID, !tableID.isEmpty {
            invoiceViewModel.tableID = tableID
            invoiceViewModel.fetchAllOrders()
        } else {
            invoiceViewModel.errorMessage = "Table ID is missing."
        }
    }
}
