//
//  AuthViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    
}
