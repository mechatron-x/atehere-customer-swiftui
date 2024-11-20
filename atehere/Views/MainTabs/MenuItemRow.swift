//
//  MenuItemRow.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import SwiftUI

struct MenuItemRow: View {
    let menuItem: MenuItem

    var body: some View {
        HStack(alignment: .top) {
            if let imageUrlString = menuItem.imageUrl, let url = URL(string: imageUrlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name)
                    .font(.headline)
                Text(menuItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                Text("Price: \(menuItem.price.amount, specifier: "%.2f") \(menuItem.price.currency)")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                if menuItem.discountPercentage > 0 {
                    Text("Discount: \(menuItem.discountPercentage, specifier: "%.0f")%")
                        .font(.subheadline)
                        .foregroundColor(.green)
                    Text("Discounted Price: \(menuItem.discountedPrice.amount, specifier: "%.2f") \(menuItem.discountedPrice.currency)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
