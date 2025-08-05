//
//  HomeView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20){
                    ForEach(viewModel.flashcardSets) { set in
                        NavigationLink(destination:
                                        FlashcardSetView(flashcardSetTitle: set.title, flashcards: set.flashcards, lastReviewed: set.lastReviewed.relativeFormattedString(), numberOfCards: set.numberofCards)
                        ){
                            FlashacardSetTileView(set: set)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                }
                .navigationTitle("Saved Flashcard Sets")
            }}
    }
}

#Preview {
    HomeView()
}
