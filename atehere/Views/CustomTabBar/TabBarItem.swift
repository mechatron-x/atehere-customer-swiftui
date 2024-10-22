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
    case confession, classforum, post, community, profile
    
    var iconName: String {
        switch self {
        case .confession: return "house"
        case .classforum: return "graduationcap"
        case .post: return "plus.circle"
        case .community: return "person.3"
        case .profile: return "person"
        }
    }
    
    var title: String {
        switch self {
        case .confession: return "Confession"
        case .classforum: return "Class Forum"
        case .post: return "Post"
        case .community: return "Community"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .confession: return Color("KocRed")
        case .classforum: return Color.primary
        case .post: return Color("KocRed")
        case .community: return Color.primary
        case .profile: return Color("KocRed")
        }
    }
}
