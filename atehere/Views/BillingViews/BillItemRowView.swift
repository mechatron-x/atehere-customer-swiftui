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
    
    private var isFullyPaid: Bool {
        item.remainingPrice <= 0 || item.isAllPaid
    }
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Checkbox
                    Button(action: {
                        if !isFullyPaid {
                            onToggle(!isSelected)
                        }
                    }) {
                        Image(systemName: isSelected && !isFullyPaid ? "checkmark.square" : "square")
                            .foregroundColor(isSelected && !isFullyPaid ? .green : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Text("\(item.itemName) (\(item.currency))")
                        .font(.headline)
                        .strikethrough(isFullyPaid, color: .gray)

                    Spacer()
                }

                Text(String(format: "Remaining: %.2f %@", item.remainingPrice, item.currency))
                    .font(.subheadline)
                    .foregroundColor(isFullyPaid ? .gray : .secondary)

                HStack {
                    Text("Enter Payment:")
                    TextField("0.0", text: $partialPayment)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                        .onChange(of: partialPayment) { newVal in
                            onPartialPaymentChange(newVal)
                        }
                        .disabled(isFullyPaid)
                }
                .font(.subheadline)
            }
            .padding(.vertical, 8)
            .foregroundColor(isFullyPaid ? .gray : .primary)
        }
        .disabled(isFullyPaid)
    }
}
