//
//  ActiveInvoiceView.swift
//  atehere
//
//  Created by Berke Bozacı on 3.12.2024.
//

import SwiftUI

struct ActiveInvoiceView: View {
    let qrCodeData: QRCodeData
    @State private var isPending: Bool = false
    @StateObject private var invoiceViewModel: InvoiceViewModel
    @EnvironmentObject var tabSelectionManager: TabSelectionManager
    @EnvironmentObject var qrViewModel: QRScanViewModel

    @StateObject private var billViewModel = BillViewModel()
    
    @State private var showBottomSheet = false
    
    init(qrCodeData: QRCodeData) {
        self.qrCodeData = qrCodeData
        _invoiceViewModel = StateObject(wrappedValue: InvoiceViewModel(tableID: qrCodeData.tableID ?? ""))
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
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
                            customerOrdersSection
                            Divider().padding(.vertical)
                            tableOrdersSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            fetchAllOrdersIfNeeded()
            
            let storedSessionID = UserDefaults.standard.string(forKey: "session_id") ?? ""
            print(storedSessionID)
            if !storedSessionID.isEmpty {
                billViewModel.checkSessionState(sessionID: storedSessionID) { success, errorMsg, state in
                    if success, let state = state {
                        print(state)
                        DispatchQueue.main.async {
                            if state == "CHECKOUT_PENDING" {
                                billViewModel.sessionID = storedSessionID
                                showBottomSheet = true
                            }
                            else if state == "COMPLETED" {
                                qrViewModel.removeQRCodeData()
                            }
                        }
                    } else {
                        billViewModel.errorMessage = errorMsg
                    }
                }
            }
        }
        .onReceive(tabSelectionManager.$tabSelection) { newSelection in
            if newSelection == .invoice {
                fetchAllOrdersIfNeeded()
            }
            let storedSessionID = UserDefaults.standard.string(forKey: "session_id") ?? ""
            print(storedSessionID)
            if !storedSessionID.isEmpty {
                billViewModel.checkSessionState(sessionID: storedSessionID) { success, errorMsg, state in
                    if success, let state = state {
                        print(state)
                        DispatchQueue.main.async {
                            if state == "CHECKOUT_PENDING" {
                                billViewModel.sessionID = storedSessionID
                                showBottomSheet = true
                            }
                            else if state == "COMPLETED" {
                                qrViewModel.removeQRCodeData()
                            }
                        }
                    } else {
                        billViewModel.errorMessage = errorMsg
                    }
                }
            }
        }

        .sheet(isPresented: $showBottomSheet, onDismiss: {
            invoiceViewModel.fetchAllOrders()
            print("Show Bottom Sheet")
        }) {

            BillingSummaryView(billViewModel: billViewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    /// MARK: - Customer Orders Section
    private var customerOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
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
        }
    }
    
    /// MARK: - Table Orders Section
    private var tableOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Table Orders")
                .font(.title2)
                .bold()

            if invoiceViewModel.tableOrderItems.isEmpty {
                Text("No orders have been placed at this table yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                let groupedByCustomer = Dictionary(
                    grouping: invoiceViewModel.tableOrderItems,
                    by: { $0.customerFullName }
                )
                
                ForEach(Array(groupedByCustomer.keys), id: \.self) { customerName in
                    Text(customerName)
                        .font(.title3)
                        .bold()
                        .padding(.top, 8)
                    
                    let customerOrders = groupedByCustomer[customerName]!
                    let customerTotal = customerOrders.reduce(0.0) { $0 + $1.totalPrice }
                    
                    ForEach(customerOrders) { order in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(order.menuItemName)
                                    .font(.headline)
                                Spacer()
                                Text("Quantity: \(order.quantity)")
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
                            .font(.headline).bold()
                    }
                    .padding(.vertical, 8)
                }
                
                // Table total
                if invoiceViewModel.tableTotalPrice > 0 {
                    HStack {
                        Text("Table Total Price:")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f %@", invoiceViewModel.tableTotalPrice, invoiceViewModel.tableCurrency))
                            .font(.headline).bold()
                    }
                    .padding(.top, 8)
                }
                
                // The Checkout button
                Button(action: {
                    print("Checkout")
                    let storedSessionID = UserDefaults.standard.string(forKey: "session_id") ?? ""
                    if storedSessionID.isEmpty {
                        billViewModel.errorMessage = "No session. Place an order first."
                        return
                    }
                                        
                    if billViewModel.sessionState == "ACTIVE" || billViewModel.sessionState == nil {
                        let tableID = qrCodeData.tableID ?? ""
                        billViewModel.checkoutTable(tableID: tableID) { success, checkoutError in
                            if success {
                                billViewModel.sessionID = storedSessionID
                                isPending = true
                                showBottomSheet = true
                            } else {
                                billViewModel.errorMessage = checkoutError
                            }
                        }
                    } else {
                        isPending = true
                        billViewModel.errorMessage = "Cannot checkout. Session state: \(billViewModel.sessionState ?? "")"
                    }
                    }) {
                        Text("Checkout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isPending ? Color.gray : Color.green)
                            .cornerRadius(10)
                            .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
            }
        }
    }
    
    
    /// MARK: - Helper
    private func fetchAllOrdersIfNeeded() {
        guard let tableID = qrCodeData.tableID, !tableID.isEmpty else {
            invoiceViewModel.errorMessage = "Table ID is missing."
            return
        }
        invoiceViewModel.tableID = tableID
        invoiceViewModel.fetchAllOrders()
    }
}
