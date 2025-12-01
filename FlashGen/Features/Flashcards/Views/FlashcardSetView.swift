//
//  FlashcardSetView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 8/5/25.
//

import SwiftUI

struct FlashcardSetView: View {
    let flashcardSetTitle : String
    @State var flashcards : [Flashcard]
    @State private var lastReviewed: String
    
    let numberOfCards: Int
    let difficulty: FlashcardDifficulty
    let isSavedInitial: Bool
    @State private var hasUpdatedReviewTime = false
    @State var setId: String
    let color: Color
    @State private var isSaving = false
    @State private var saveSuccess = false
    @State private var isSaved: Bool = false
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showLoginSheet = false
    @State private var isLoading = false
    @State private var generationError: String?
    @Environment(\.dismiss) var dismiss
    
    // Optional closure for generating cards on load
    let generationAction: (() async throws -> ([Flashcard], String))?
    
    private let repository: FlashcardRepository = CachedFlashcardRepository()
    
    init(
        flashcardSetTitle: String,
        flashcards: [Flashcard],
        lastReviewed: String,
       
        numberOfCards: Int,
        difficulty: FlashcardDifficulty = .medium,
        isSavedInitial: Bool = false,
        setId: String = "",
        color: Color = .yellow,
        generationAction: (() async throws -> ([Flashcard], String))? = nil
    ) {
        self.flashcardSetTitle = flashcardSetTitle
        self._flashcards = State(initialValue: flashcards)
        self._lastReviewed = State(initialValue: lastReviewed)
        self.numberOfCards = numberOfCards
        self.difficulty = difficulty
        self.isSavedInitial = isSavedInitial
        self._setId = State(initialValue: setId)
        self.color = color
        self.generationAction = generationAction
        
        // If we have a generation action, we start in loading state
        self._isLoading = State(initialValue: generationAction != nil)
    }
    @MainActor
    private func saveSet() async {
        guard !isSaving && !saveSuccess else { return }
        
        if !authManager.isAuthenticated {
            showLoginSheet = true
            return
        }
        
        isSaving = true
        
        // Use the passed setId (which should be stable from GenerateViewModel)
        // If setId is somehow empty (shouldn't happen for new sets now), we generate one, but this is a fallback.
        let idToUse = setId.isEmpty ? UUID().uuidString.lowercased() : setId
        
        let newSet = FlashcardSet(
            id: idToUse,
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
            // Handle error
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
                    if isLoading {
                        VStack(spacing: 12) {
                            ForEach(0..<numberOfCards, id: \.self) { _ in
                                SkeletonFlashcardRow()
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                        .frame(maxWidth: 700)
                        .frame(maxWidth: .infinity)
                    } else {
                        FlashcardListView(flashcards: flashcards, color: color)
                            .padding()
                            .padding(.bottom, 100)
                            .frame(maxWidth: 700) // Keep the content centered and readable
                            .frame(maxWidth: .infinity) // Fill the screen background
                    }
                }
                
                .safeAreaInset(edge: .bottom) {
                    if !isLoading {
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
                        .accessibilityLabel(Text(LocalizedStringKey("start_practicing_accessibility_label")))
                        .accessibilityHint(Text(LocalizedStringKey("start_practicing_accessibility_hint")))
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isSaved && !isLoading {
                        Button(action: {
                            Task { await saveSet() }
                        }) {
                            if isSaving {
                                ProgressView()
                            } else if saveSuccess {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Text(LocalizedStringKey("save"))
                            }
                        }
                        .disabled(isSaving || saveSuccess)
                    }
                }
            }
            .alert("Generation Failed", isPresented: Binding(
                get: { generationError != nil },
                set: { if !$0 { generationError = nil; dismiss() } }
            )) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text(generationError ?? "Unknown error")
            }
            .onAppear {
                self.isSaved = isSavedInitial
                if isSavedInitial {
                    self.saveSuccess = true
                }
            }
            .task {
                // Handle Generation if needed
                if let action = generationAction, flashcards.isEmpty {
                    isLoading = true
                    do {
                        let (generatedCards, generatedId) = try await action()
                        self.flashcards = generatedCards
                        self.setId = generatedId
                        self.isLoading = false
                        
                        // Auto-save if needed? For now, we just show them.
                        // User can click save.
                    } catch {
                        self.generationError = error.localizedDescription
                        self.isLoading = false
                    }
                }
                
                guard !hasUpdatedReviewTime && !isLoading else { return }
                hasUpdatedReviewTime = true
                
                do {
                    if !setId.isEmpty {
                        try await repository.updateLastReviewed(setId: setId)
                        // Update local state to reflect change immediately
                        self.lastReviewed = NSLocalizedString("just_now", comment: "Relative time for just now")
                    }
                } catch {
                    // Fail silently or log to analytics in production
                }
            }
            .sheet(isPresented: $showLoginSheet) {
                LoginView()
                    .environmentObject(authManager)
            }
            .onChange(of: authManager.isAuthenticated) { isAuthenticated in
                if isAuthenticated && showLoginSheet {
                    showLoginSheet = false
                    Task {
                        await saveSet()
                    }
                }
            }
                }
            }
            // Title removed to allow custom header to take precedence
//            .navigationBarBackButtonHidden(true)
        }
    



