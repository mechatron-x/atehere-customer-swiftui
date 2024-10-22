//
//  TabBarItem.swift
//  Kampus Components
//
//  Created by Mehmet Kağan Aydoğan on 16.02.2023.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    case home, menu, qrScan, invoice, profile
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .menu : return "fork.knife"
        case .qrScan: return "qrcode"
        case .invoice: return "menucard"
        case .profile: return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .menu: return "Menu"
        case .qrScan: return "Scan QR"
        case .invoice: return "Invoice"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color("MainColor")
        case .menu: return Color("MainColor")
        case .qrScan: return Color("MainColor")
        case .invoice: return Color("MainColor")
        case .profile: return Color("MainColor")
        }
    }
}
