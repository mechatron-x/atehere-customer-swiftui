//
//  TabSelectionManager.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 27.11.2024.
//

import Foundation
import SwiftUI

class TabSelectionManager: ObservableObject {
    @Published var tabSelection: TabBarItem = .home
}
