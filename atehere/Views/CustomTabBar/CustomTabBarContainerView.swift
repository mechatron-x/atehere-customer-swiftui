//
//  CustomTabBarContainerView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//
import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .home,
        .invoice,
        .profile
    ]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
