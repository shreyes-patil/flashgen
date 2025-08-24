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
                Label(LocalizedStringKey("tab_home"), systemImage: "house")
            }
            
            NavigationStack{
                GenerateView()
            }
            .tabItem{
                Label(LocalizedStringKey("tab_generate"), systemImage: "plus.square.on.square")
            }
            
            NavigationStack{
                SettingsView()
            }
            .tabItem {
                Label(LocalizedStringKey("tab_settings"), systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    MainTabView()
}
