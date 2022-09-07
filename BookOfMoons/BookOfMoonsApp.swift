//
//  BookOfMoonsApp.swift
//  BookOfMoons
//
//  Created by Handy Hasan on 14/7/2022.
//

import SwiftUI

@main
struct BookOfMoonsApp: App {
    var settingStore = SettingStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(self.settingStore)
        }
    }
}
