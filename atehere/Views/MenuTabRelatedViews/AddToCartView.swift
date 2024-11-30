//
//  AddToCartView.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import SwiftUI

struct AddToCartView: View {
    let menuItem: MenuItem
    @ObservedObject var cartViewModel: CartViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var quantity: Int = 1

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(menuItem.name)
                    .font(.title)
                    .bold()

                Text(menuItem.description)
                    .font(.body)
                    .multilineTextAlignment(.center)

                HStack {
                    Text("Quantity:")
                        .font(.headline)

                    Stepper(value: $quantity, in: 1...100) {
                        Text("\(quantity)")
                    }
                    .frame(width: 150)
                }

                Button(action: {
                    cartViewModel.addToCart(menuItem: menuItem, quantity: quantity)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add \(quantity) to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .navigationTitle("Add to Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
