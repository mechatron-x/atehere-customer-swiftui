//
//  QRMenuView.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import SwiftUI

struct QRMenuView: View {
    @ObservedObject var viewModel: QRScanViewModel = QRScanViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Menu...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ActiveMenuView(viewModel: viewModel)
            }
        }
    }
}
