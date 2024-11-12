////
////  RestaurantDetailView.swift
////  atehere
////
////  Created by Mehmet Kağan Aydoğan on 24.10.2024.
////
//
//import SwiftUI
//
//// Restaurant Detail View
//struct RestaurantDetailView: View {
//    let restaurant: Restaurant
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                // Display restaurant image
//                if let imageData = Data(base64Encoded: restaurant.image ?? ""),
//                   let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: .infinity)
//                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: .infinity)
//                }
//                
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(restaurant.name)
//                        .font(.largeTitle)
//                        .padding(.top)
//                    
//                    Text("Phone: \(restaurant.phoneNumber)")
//                        .font(.body)
//                    
//                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
//                        .font(.body)
//                    
//                    Text("Tables:")
//                        .font(.headline)
//                        .padding(.top)
//                    
//                    ForEach(restaurant.tables, id: \.self) { table in
//                        Text(table)
//                            .padding(.leading)
//                    }
//                }
//                .padding()
//            }
//        }
//        .navigationTitle(restaurant.name)
//    }
//}
//
//
//#Preview {
//    
//}

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: restaurant.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(restaurant.name)
                        .font(.largeTitle)
                        .padding(.top)

                    Text("Phone: \(restaurant.phoneNumber)")
                        .font(.body)

                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
                        .font(.body)

                }
                .padding()
            }
        }
        .navigationTitle(restaurant.name)
    }
}
