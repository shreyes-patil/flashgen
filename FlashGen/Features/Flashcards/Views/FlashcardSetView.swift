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
    @State private var lastReviewed: String
    
    let numberOfCards: Int
    let difficulty: FlashcardDifficulty
    let isSavedInitial: Bool
    @State private var hasUpdatedReviewTime = false
    let setId: String
    let color: Color
    @State private var isSaving = false
    @State private var saveSuccess = false
    @State private var isSaved: Bool = false
    
    private let repository: FlashcardRepository = SupabaseFlashcardRepository()
    
    init(
        flashcardSetTitle: String,
        flashcards: [Flashcard],
        lastReviewed: String,
       
        numberOfCards: Int,
        difficulty: FlashcardDifficulty = .medium,
        isSavedInitial: Bool = false,
        setId: String = "",
        color: Color = .yellow
    ) {
        self.flashcardSetTitle = flashcardSetTitle
        self.flashcards = flashcards
        self._lastReviewed = State(initialValue: lastReviewed)
        self.numberOfCards = numberOfCards
        self.difficulty = difficulty
        self.isSavedInitial = isSavedInitial
        self.setId = setId
        self.color = color
    }
    
    private func saveSet() async {
        isSaving = true
        
        let newSet = FlashcardSet(
            id: UUID().uuidString,
            title: flashcardSetTitle,
          
            difficulty: self.difficulty,
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
                FlashcardSetHeaderView(title: flashcardSetTitle, numberOfCards: numberOfCards, lastReviewed: lastReviewed, color: color)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView{
                    FlashcardListView(flashcards: flashcards, color: color)
                        .padding()
                        .padding(.bottom, 100)
                }
                
                .safeAreaInset(edge: .bottom) {
                    NavigationLink {
                        FlashcardDeckView(vm: .init(cards: flashcards), color: color)   // push the deck
                    } label: {
                        Text(LocalizedStringKey("start_practicing"))
                            .font(.headline)
                            .foregroundColor(.white)
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
            .task {
                guard !hasUpdatedReviewTime else { return }
                hasUpdatedReviewTime = true
                
                do {
                    try await repository.updateLastReviewed(setId: setId)
                    print("Updated last reviewed time")
                    // Update local state to reflect change immediately
                    self.lastReviewed = NSLocalizedString("Just now", comment: "Relative time for just now")
                } catch {
                    print("Failed to update last reviewed: \(error)")
                }
            }
                }
            }
            // Title removed to allow custom header to take precedence
//            .navigationBarBackButtonHidden(true)
        }
    



