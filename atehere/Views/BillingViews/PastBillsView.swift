//
//  PastBillsView.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import SwiftUI

struct PastBillsView: View {
    @StateObject var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Past Bills...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.pastBills.isEmpty {
                    Text("No past bills found.")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.pastBills) { bill in
                        // For each bill, show a section or row
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Bill ID: \(bill.id)")
                                .font(.headline)
                            Text("Restaurant: \(bill.restaurantName)")
                                .font(.subheadline)

                            // Bill Items
                            ForEach(bill.billItems) { billItem in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(billItem.itemName)
                                        .fontWeight(.semibold)
                                    Text("Qty: \(billItem.quantity), " +
                                         String(format: "Unit: %.2f", billItem.unitPrice))
                                        .font(.footnote)
                                    Text(String(format: "Order Price: %.2f, Paid: %.2f %@",
                                                billItem.orderPrice,
                                                billItem.paidPrice,
                                                billItem.currency))
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading, 10)
                                .padding(.vertical, 2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Past Bills")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchPastBills()
            }
        }
    }
}
