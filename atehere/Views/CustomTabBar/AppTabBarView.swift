//
//  AppTabBarView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

struct AppTabBarView: View {
    
    @State private var tabSelection: TabBarItem = .confession
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.red.ignoresSafeArea(.all)
                .tabBarItem(tab: .confession, selection: $tabSelection)
            
            Color.blue
                .tabBarItem(tab: .classforum, selection: $tabSelection)
            
            Color.green
                .tabBarItem(tab: .profile, selection: $tabSelection)
        }
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppTabBarView()
    }
}
