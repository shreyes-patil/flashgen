//
//  MainTabView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            NavigationStack{
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            NavigationStack{
                GenerateView()
            }
            .tabItem{
                Label("Generate", systemImage: "plus.square.on.square")
            }
            
            NavigationStack{
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    MainTabView()
}
