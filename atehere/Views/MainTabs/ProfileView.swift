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
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject var qrScanViewModel = QRScanViewModel()
    
    
    //@EnvironmentObject var loginViewModel: LoginViewModel

    @State private var navigateToPersonalInfo: Bool = false
    @State private var navigateToPastBills: Bool = false
    @State private var navigateToLogin: Bool = false
    
    @State private var showingLoginScreen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    List {
                        Button(action: {
                            navigateToPersonalInfo = true
                        }) {
                            Text("Personal Information")
                                .padding(10)
                                .frame(minWidth: 111, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                        }
                        .background(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .tag(1)
                        
                        Button(action: {
                            navigateToPastBills = true
                        }) {
                            Text("Past Bills")
                                .padding(10)
                                .frame(minWidth: 111, idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
                        }
                        .background(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .tag(2)
                    }
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
                
                VStack {
                    NavigationLink(
                        destination: PersonalInformationView(profileViewModel: profileViewModel),
                        isActive: $navigateToPersonalInfo,
                        label: { EmptyView() }
                    )
                    
                    NavigationLink(
                        destination: PastBillsView(),
                        isActive: $navigateToPastBills,
                        label: { EmptyView() }
                    )
                    
                }
                .hidden()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        profileViewModel.logout()
                        //navigateToLogin = true
                        showingLoginScreen = true

                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                profileViewModel.fetchProfile()
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
            .fullScreenCover(isPresented: $showingLoginScreen) {
                LoginView()
                    .interactiveDismissDisabled(true)
                    
            }
        }
    }
}
