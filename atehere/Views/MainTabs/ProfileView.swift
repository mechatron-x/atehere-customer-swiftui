//
//  ProfileView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var tabSelectionManager: TabSelectionManager
    @EnvironmentObject var qrViewModel: QRScanViewModel
    
    @State private var showingPastBills = false
    @State private var showingPersonalInfo = false
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Personal Information Button
                NavigationLink(destination: PersonalInformationView(profileViewModel: profileViewModel)) {
                    Text("Personal Information")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Past Bills Button
                NavigationLink(destination: PastBillsView()) {
                    Text("Past Bills")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        profileViewModel.logout()
                        navigateToLogin = true
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .background(
                Group {
                    if profileViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding()
                    } else if let errorMessage = profileViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            )
            .navigationBarBackButtonHidden(true)
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
            .onAppear {
                profileViewModel.fetchProfile()
            }
            .background(
                NavigationLink(
                    destination: LoginView(),
                    isActive: $navigateToLogin,
                    label: { EmptyView() }
                )
            )
        }
    }
}
