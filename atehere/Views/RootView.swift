//
//  NewRootView.swift
//  Kampus

//  Created by Mehmet Kağan Aydoğan on 16.02.2023.
//

import SwiftUI

struct RootView: View {
    
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        ZStack{
            CustomTabBarContainerView(selection: $tabSelection) {
                HomeView()
                    .tabBarItem(tab: .home, selection: $tabSelection)
                
                MenuView()
                    .tabBarItem(tab: .menu, selection: $tabSelection)
                
                QRScanView()
                    .tabBarItem(tab: .qrScan, selection: $tabSelection)
              
                InvoiceView()
                    .tabBarItem(tab: .invoice, selection: $tabSelection)
                
                ProfileView()
                    .tabBarItem(tab: .profile, selection: $tabSelection)
            }
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
