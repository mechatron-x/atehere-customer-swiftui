//
//  SignUpView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 30.10.2024.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var isPasswordVisible = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background view (customize as needed)
                
                Color("MainColor").ignoresSafeArea()

                VStack {
                    
                    Spacer()
                    
                    // Sign Up title
                    HStack {
                        Text("Sign Up")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                    }

                    // Email field
                    HStack {
                        Image(systemName: "at")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        TextField("Email", text: $signUpViewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    Divider()
                        .background(Color.white)
                        .padding(.bottom)

                    // Full Name field
                    HStack {
                        Image(systemName: "person.text.rectangle")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        TextField("Full Name", text: $signUpViewModel.fullName)
                            .autocapitalization(.words)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    Divider()
                        .background(Color.white)
                        .padding(.bottom)

                    // Password field
                    HStack {
                        Image(systemName: "lock")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        if isPasswordVisible {
                            TextField("Password", text: $signUpViewModel.password)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Password", text: $signUpViewModel.password)
                                .foregroundColor(.white)
                        }
                        Spacer()
                
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .padding(.trailing, 5)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    Divider()
                        .background(Color.white)
                        .padding(.bottom)


                    // Birth Date Picker
                    HStack {
                        Image(systemName: "calendar")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        DatePicker("Birth Date", selection: $signUpViewModel.birthDate, displayedComponents: .date)
                            .foregroundColor(.white)
                            .accentColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    Divider()
                        .background(Color.white)
                        .padding(.bottom)

                    // Error message display
                    if let errorMessage = signUpViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    // Sign Up button
                    Button(action: {
                        signUpViewModel.signUp()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("MainColor").opacity(0.1))
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            Text("Sign Up")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()

                    // Loading indicator
                    if signUpViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

// Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
