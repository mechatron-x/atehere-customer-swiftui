//
//  BillItemRowView.swift
//  atehere
//
//  Created by Berke Bozacı on 27.12.2024.
//

import SwiftUI

struct BillItemRowView: View {
    let item: BillItem

    let isSelected: Bool
    let onToggle: (Bool) -> Void

    @State var partialPayment: String
    let onPartialPaymentChange: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    onToggle(!isSelected)
                }) {
                    Image(systemName: isSelected ? "checkmark.square" : "square")
                        .foregroundColor(isSelected ? .green : .gray)
                }
                .buttonStyle(PlainButtonStyle())

                Text("\(item.itemName) (\(item.currency))")
                    .font(.headline)
                
                Spacer()
            }

            Text(String(format: "Remaining: %.2f %@", item.remainingPrice, item.currency))
                .font(.subheadline)
                .foregroundColor(.secondary)

            HStack {
                Text("Enter Payment:")
                TextField("0.0", text: $partialPayment)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 80)
                    .onChange(of: partialPayment) { newVal in
                        onPartialPaymentChange(newVal)
                    }
            }
            .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}
