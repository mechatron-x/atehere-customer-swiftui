//
//  PersonalInformationView.swift
//  atehere
//
//  Created by Berke Bozacı on 29.12.2024.
//

import SwiftUI

struct PersonalInformationView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var birthDate: Date = Date()
    @State private var isPasswordVisible = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    
                    if profileViewModel.isLoading {
                        // Loading Indicator
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            .padding()
                    } else if let errorMessage = profileViewModel.errorMessage {
                        // Error Message
                        Text(errorMessage)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if let profile = profileViewModel.profile {
                        // Display or Edit Profile Information
                        Group {
                            // Subheading
                            HStack {
                                Text("Personal Information")
                                    .frame(alignment: .leading)
                                    .font(.headline)
                                    .padding(.leading)
                                
                                Spacer()
                            }
                            
                            // Email field (Non-editable)
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.black)
                                
                                Text(profile.email)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.trailing)
                            .padding(.horizontal)
                            
                            // Full Name field
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.black)
                                
                                if profileViewModel.isEditing {
                                    TextField("Full Name", text: Binding(
                                        get: { profile.fullName },
                                        set: { newValue in profileViewModel.profile?.fullName = newValue }
                                    ))
                                    .autocapitalization(.words)
                                    .foregroundColor(.black)
                                } else {
                                    Text(profile.fullName)
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(profileViewModel.isEditing ? Color.clear : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.trailing)
                            .padding(.horizontal)
                            
                        }
                        
                        // Gender field
                        if profileViewModel.isEditing || profile.gender != nil {
                            withAnimation {
                                HStack {
                                    Image(systemName: "person.crop.circle.badge.questionmark")
                                        .foregroundColor(.black)
                                    
                                    if profileViewModel.isEditing {
                                        Picker(selection: Binding(
                                            get: { profile.gender ?? "" },
                                            set: { newValue in
                                                profileViewModel.profile?.gender = newValue.isEmpty ? nil : newValue
                                            }
                                        ), label: Text("Gender")
                                            .foregroundColor(.black)) {
                                                Text("Select Gender").tag("")
                                                Text("MALE").tag("MALE")
                                                Text("FEMALE").tag("FEMALE")
                                                Text("OTHER").tag("OTHER")
                                            }
                                            .pickerStyle(MenuPickerStyle())
                                            .foregroundColor(.black)
                                    } else {
                                        if let gender = profile.gender {
                                            Text(gender)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(profileViewModel.isEditing ? Color.clear : Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.trailing)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Date Field
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.black)
                            
                            if profileViewModel.isEditing {
                                // Editing Mode: Show DatePicker
                                DatePicker("", selection: $birthDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .foregroundColor(.black)
                                    .accentColor(.black)
                            } else {
                                // Non-Editing Mode: Display formatted birth date
                                Text(profile.birthDate)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(profileViewModel.isEditing ? Color.clear : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.trailing)
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        //Edit Button
                        Button(action: {
                            if profileViewModel.isEditing {
                                // Save changes and exit editing mode
                                profileViewModel.profile?.birthDate = stringFromDate(birthDate)
                                profileViewModel.updateProfile()
                                profileViewModel.isEditing = false
                            } else {
                                // Enter editing mode
                                profileViewModel.isEditing = true
                                // Initialize birthDate from profile.birthDate when editing starts
                                if let birthDateString = profileViewModel.profile?.birthDate,
                                   let date = dateFromString(birthDateString) {
                                    birthDate = date
                                }
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color("MainColor"))
                                    .frame(width: UIScreen.main.bounds.size.width - 60, height: 50)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    .frame(width: UIScreen.main.bounds.size.width - 60, height: 50)
                                
                                Text(profileViewModel.isEditing ? "Save Changes" : "Edit")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()             }
                }
                .onAppear() {
                    profileViewModel.fetchProfile()
                }
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Personal Information")
        }
    }
        
    // Helper functions to convert between String and Date
    func dateFromString(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // Adjusted to "dd-MM-yyyy" format
        return formatter.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // Adjusted to "dd-MM-yyyy" format
        return formatter.string(from: date)
    }
}


