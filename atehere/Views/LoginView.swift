//
//  LoginView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 30.10.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var isPasswordVisible = false
    @State private var navigateToSignUp = false
    @State private var navigateToRoot = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()

                VStack {
                    Spacer()

                    HStack {
                        Text("Login")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                    }

                    // Email Field
                    HStack {
                        Image(systemName: "at")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        TextField("Email", text: $loginViewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)

                    Divider()
                        .background(Color.white)
                        .padding(.bottom)

                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .padding(.trailing, 5)
                            .foregroundColor(.white)
                        if isPasswordVisible {
                            TextField("Password", text: $loginViewModel.password)
                                .foregroundColor(.white)
                        } else {
                            SecureField("Password", text: $loginViewModel.password)
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

                    // Login Button
                    Button(action: {
                        loginViewModel.login()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("Secondary").opacity(0.1))
                                .frame(width: UIScreen.main.bounds.size.width - 60, height: 50)
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.size.width - 60, height: 50)
                            Text("Login")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()

                    // Error Message
                    if let errorMessage = loginViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    Spacer()

                    // Navigate to Sign Up
                    HStack {
                        Text("Don't have an account?")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        Button(action: {
                            navigateToSignUp = true
                        }) {
                            Text("Sign Up.")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                }
                .padding()
                .onReceive(loginViewModel.$isAuthenticated) { isAuthenticated in
                    if isAuthenticated {
                        navigateToRoot = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpView()
            }
            .navigationDestination(isPresented: $navigateToRoot) {
                RootView()
            }
            .navigationBarHidden(true)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
