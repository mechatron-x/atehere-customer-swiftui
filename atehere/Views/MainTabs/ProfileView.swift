//
//  ProfileView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI


struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode

    // Local state variables for editing
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var gender: String = ""
    @State private var birthDate: Date = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    // Loading indicator
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let profile = viewModel.profile {
                    if viewModel.isEditing {
                        // Edit Mode
                        Form {
                            Section(header: Text("Personal Information")) {
                                TextField("Full Name", text: $fullName)
                                    .autocapitalization(.words)
                                    .disableAutocorrection(true)

                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)

                                TextField("Gender", text: $gender)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)

                                DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                            }

                            Section {
                                Button(action: {
                                    // Update the profile in viewModel
                                    viewModel.profile?.fullName = fullName
                                    viewModel.profile?.email = email
                                    viewModel.profile?.gender = gender.isEmpty ? nil : gender
                                    viewModel.profile?.birthDate = dateFormatter.string(from: birthDate)
                                    viewModel.updateProfile()
                                }) {
                                    Text("Save Changes")
                                }
                                .disabled(viewModel.isLoading)

                                Button(action: {
                                    viewModel.isEditing = false
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    } else {
                        // Display Mode
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Name: \(profile.fullName)")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Email: \(profile.email)")
                                .font(.subheadline)

                            if let gender = profile.gender {
                                Text("Gender: \(gender)")
                                    .font(.subheadline)
                            }

                            Text("Birth Date: \(profile.birthDate)")
                                .font(.subheadline)

                            Spacer()

                            HStack {
                                Button(action: {
                                    // Initialize local state variables with current profile data
                                    fullName = profile.fullName
                                    email = profile.email
                                    gender = profile.gender ?? ""
                                    birthDate = dateFormatter.date(from: profile.birthDate) ?? Date()
                                    viewModel.isEditing = true
                                }) {
                                    Text("Edit Profile")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .disabled(viewModel.isLoading)

                                Button(action: {
                                    viewModel.logout()
                                }) {
                                    Text("Logout")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .disabled(viewModel.isLoading)
                            }
                        }
                        .padding()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    // Error message
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // Empty state
                    Text("No profile data available.")
                        .foregroundColor(.gray)
                }
            }
            .onAppear {
                viewModel.fetchProfile()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Optionally, add a back button if needed
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
            // Navigate to LoginView upon logout or unauthorized
            .background(
                NavigationLink(
                    destination: LoginView(),
                    isActive: $viewModel.navigateToLogin,
                    label: { EmptyView() }
                )
            )
        }
    }
}
#Preview {
    ProfileView()
}
