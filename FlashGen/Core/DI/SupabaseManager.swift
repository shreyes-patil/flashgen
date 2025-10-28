//
//  SupabaseManager.swift
//  FlashGen
//
//  Created by Shreyas Patil on 10/24/25.
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let supabaseURL = URL(string: "https://crveplvgtcftgivxhwbz.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNydmVwbHZndGNmdGdpdnhod2J6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYyNzExNjIsImV4cCI6MjA3MTg0NzE2Mn0.CYf8vgGCwFJqpjgCZMZCM92AhjJ8IANUtARfrT1JvJA"
        
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
