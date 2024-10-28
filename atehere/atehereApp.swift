//
//  atehereApp.swift
//  atehere
//
//  Created by Berke Bozacı on 21.10.2024.
//

import SwiftUI
import Firebase

@main
struct atehereApp: App {
    
    init (){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
