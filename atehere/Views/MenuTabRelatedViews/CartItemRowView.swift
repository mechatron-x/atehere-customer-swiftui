//
//  CartItemRowView.swift
//  atehere
//
//  Created by Berke Bozacı on 22.12.2024.
//

import SwiftUI

struct CartItemRowView: View {
    let cartItem: CartItem
    let menuItem: MenuItem?     // Fetched from menuViewModel
    let onDelete: () -> Void
    let onQuantityChange: (Int) -> Void

    var body: some View {
        HStack {
            // Item Image
            if let imageName = menuItem?.imageUrl,
               let url = URL(string: imageName) {
                // Async image if real image URLs are used
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                // Fallback image or system icon
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray.opacity(0.5))
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            // Item Details
            VStack(alignment: .leading, spacing: 8) {
                Text(menuItem?.name ?? "Unknown Item")
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                HStack(spacing: 16) {
                    // Quantity Stepper
                    HStack(spacing: 4) {
                        Button(action: {
                            let newQuantity = max(cartItem.quantity - 1, 1)
                            onQuantityChange(newQuantity)
                        }) {
                            Text("-")
                                .frame(width: 24, height: 24)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }

                        Text("\(cartItem.quantity)")
                            .frame(minWidth: 30, alignment: .center)

                        Button(action: {
                            let newQuantity = cartItem.quantity + 1
                            onQuantityChange(newQuantity)
                        }) {
                            Text("+")
                                .frame(width: 24, height: 24)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }

                    Spacer()

                    if let price = menuItem?.price {
                        Text(String(format: "%.2f %@", price.amount, price.currency))
                            .font(.headline)
                    } else {
                        Text("No price")
                    }

                }
            }

            Spacer()

            // Delete Button
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.red)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}
