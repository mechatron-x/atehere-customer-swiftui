//
//  DisplayMenuItemView.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import SwiftUI

struct DisplayMenuItemView: View {
    let menuItem: MenuItem

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

                Text("\(menuItem.price.amount, specifier: "%.2f") \(menuItem.price.currency)")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
            }

            Spacer()

            if let imageUrl = menuItem.imageUrl,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 100, height: 100)
                             .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .foregroundColor(.gray)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
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

