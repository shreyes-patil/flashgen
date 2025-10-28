//
//  FlashcardSetView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct FlashcardSetView: View {
    let flashcardSetTitle : String
    let flashcards : [Flashcard]
    let lastReviewed: String
    let numberOfCards: Int
    let isSavedInitial: Bool
    
    @State private var isSaving = false
    @State private var saveSuccess = false
    @State private var isSaved: Bool = false
    
    private let repository: FlashcardRepository = SupabaseFlashcardRepository()
    
    init(
        flashcardSetTitle: String,
        flashcards: [Flashcard],
        lastReviewed: String,
        numberOfCards: Int,
        isSavedInitial: Bool = false
    ) {
        self.flashcardSetTitle = flashcardSetTitle
        self.flashcards = flashcards
        self.lastReviewed = lastReviewed
        self.numberOfCards = numberOfCards
        self.isSavedInitial = isSavedInitial
    }
    
    private func saveSet() async {
        isSaving = true
        
        let newSet = FlashcardSet(
            id: UUID().uuidString,
            title: flashcardSetTitle,
            difficulty: .easy,
            cards: flashcards,
            createdAt: Date(),
            updatedAt: Date(),
            lastReviewed: Date(),
            sourceType: .text,
            sourceURL: nil,
            pdfPageRange: nil,
            notes: nil
        )
        
        do {
            try await repository.upsertSet(newSet)
            saveSuccess = true
            isSaved = true
        } catch {
            print("Save error: \(error)")
        }
        
        isSaving = false
    }
    var body: some View {
        ZStack(alignment: .bottom){
            
            VStack{
                FlashcardSetHeaderView(title: flashcardSetTitle, numberOfCards: numberOfCards, lastReviewed: lastReviewed)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    .padding(.top, 8)
                    .padding()
                    .padding(.bottom, 50)
                
                ScrollView{
                    FlashcardListView(flashcards: flashcards)
                        .padding()
                        .padding(.bottom, 100)
                }
                
                .safeAreaInset(edge: .bottom) {
                    NavigationLink {
                        FlashcardDeckView(vm: .init(cards: flashcards))   // push the deck
                    } label: {
                        Text(LocalizedStringKey("start_practicing"))
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
                            .shadow(radius: 4)
                            .padding(.horizontal, 2)
                    }
                    .buttonStyle(.plain) // preserves your custom background
                    .accessibilityLabel(Text("Start practicing"))
                    .accessibilityHint(Text("Begin going through the flashcards in this set"))
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isSaved {
                        Button(action: {
                            Task { await saveSet() }
                        }) {
                            if isSaving {
                                ProgressView()
                            } else if saveSuccess {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Text("Save")
                            }
                        }
                        .disabled(isSaving || saveSuccess)
                    }
                }
            }
            .onAppear {
                self.isSaved = isSavedInitial
                if isSavedInitial {
                    self.saveSuccess = true
                }
            }
            .navigationBarTitle(Text(String.localizedStringWithFormat(NSLocalizedString("flashcard_set_title", comment: "Flashcard Set Screen Title"), flashcardSetTitle)))
            .navigationBarBackButtonHidden(true)
        }
    }
}

