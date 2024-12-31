//
//  BillingSummaryView.swift
//  atehere
//
//  Created by Berke Bozacı on 24.12.2024.
//

import SwiftUI

struct BillingSummaryView: View {
    @StateObject var billViewModel: BillViewModel

    @State private var selectedItems: [String: Bool] = [:]

    @State private var partialPayments: [String: String] = [:]

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                if billViewModel.isLoading {
                    ProgressView("Loading bills...")
                } else if let errorMessage = billViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if billViewModel.billItems.isEmpty {
                    Text("No bill items to pay.")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(billViewModel.billItems) { item in
                            BillItemRowView(
                                item: item,
                                isSelected: selectedItems[item.id, default: false],
                                onToggle: { newValue in
                                    selectedItems[item.id] = newValue
                                },
                                partialPayment: partialPayments[item.id] ?? "",
                                onPartialPaymentChange: { newText in
                                    partialPayments[item.id] = newText
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())

                    // Pay Bill button
                    Button(action: {
                        paySelectedItems()
                    }) {
                        Text("Pay Bill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Pay Bill")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                billViewModel.fetchBillItems { success, msg in
                    if !success {
                        billViewModel.errorMessage = msg
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private func paySelectedItems() {
        let chosenItems = billViewModel.billItems.filter {
            selectedItems[$0.id] == true
        }

        if chosenItems.isEmpty {
            billViewModel.errorMessage = "No items selected."
            return
        }

        var itemsWithCustomPayments: [BillItem] = []

        for item in chosenItems {
            let typedText = partialPayments[item.id] ?? ""
            var typedValue = Double(typedText) ?? 0.0

            if typedValue <= 0 {
                typedValue = item.remainingPrice
            }

            let customItem = BillItem(
                id: item.id,
                ownerId: item.ownerId,
                itemName: item.itemName,
                unitPrice: item.unitPrice,
                quantity: item.quantity,
                totalDue: item.totalDue,
                remainingPrice: typedValue,
                individualPayment: item.individualPayment,
                currency: item.currency,
                isAllPaid: item.isAllPaid
            )
            itemsWithCustomPayments.append(customItem)
        }

        let totalToPay = itemsWithCustomPayments.reduce(0.0) { $0 + $1.remainingPrice }
        if totalToPay <= 0 {
            billViewModel.errorMessage = "Payment amount cannot be 0."
            return
        }

        billViewModel.paySession(selectedItems: itemsWithCustomPayments) { success, errorMsg in
            if success {
                print("Payment completed.")
                billViewModel.fetchBillItems { success, message in
                    if success {
                        // update the UI
                    }
                }
                presentationMode.wrappedValue.dismiss()
            } else {
                billViewModel.errorMessage = errorMsg
            }
        }
    }

}
