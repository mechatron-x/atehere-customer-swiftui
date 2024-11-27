//
//  NewRootView.swift
//  Kampus

//  Created by Mehmet Kağan Aydoğan on 16.02.2023.
//

import SwiftUI

struct RootView: View {
    @StateObject var tabSelectionManager = TabSelectionManager()
    
    var body: some View {
        ZStack{
            CustomTabBarContainerView(selection: $tabSelectionManager.tabSelection) {
                HomeView()
                    .tabBarItem(tab: .home, selection: $tabSelectionManager.tabSelection)
                
                MenuView()
                    .tabBarItem(tab: .menu, selection: $tabSelectionManager.tabSelection)
                
                QRScanView()
                    .tabBarItem(tab: .qrScan, selection: $tabSelectionManager.tabSelection)
                
                InvoiceView()
                    .tabBarItem(tab: .invoice, selection: $tabSelectionManager.tabSelection)
                
                ProfileView()
                    .tabBarItem(tab: .profile, selection: $tabSelectionManager.tabSelection)
            }
        }
        .navigationBarHidden(true)
        .environmentObject(tabSelectionManager) // Inject into environment
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
