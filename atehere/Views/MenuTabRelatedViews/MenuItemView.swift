//
//  MenuItemView.swift
//  MenuAteHere
//
//  Created by Mehmet Kağan Aydoğan on 18.11.2024.
//

import SwiftUI

struct MenuItemView: View {
    let menuItem: MenuItem
    var addToCartAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(menuItem.name)
                    .font(.headline)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(menuItem.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .truncationMode(.tail)

                HStack {
                    Button(action: addToCartAction) {
                        Text("Add to Cart")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    Text("\(menuItem.price.amount, specifier: "%.2f") \(menuItem.price.currency)")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)

                    Spacer()
                }
            }

            Spacer()

            if let imageUrl = menuItem.imageUrl,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                         .frame(width: 100, height: 100)
                         .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .foregroundColor(.gray)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
