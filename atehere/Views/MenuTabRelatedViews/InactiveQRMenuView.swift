//
//  InactiveQRMenuView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 21.11.2024.
//

import SwiftUI

struct InactiveQRMenuView: View {
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Where are you?")
                    .font(.title)
                    .bold()
                    .padding(.top)
                
                Text("Scan a QR to access the restaurant menu.")
                    .font(.title3)
                
                // NavigationLink directly styled as a button
                NavigationLink(destination: QRScanView()) {
                    Text("Scan a QR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("MainColor"))
                        .cornerRadius(8)
                }
                .padding(.top, 8)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
            )
            .frame(maxWidth: UIScreen.main.bounds.width - 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    InactiveQRMenuView()
}
