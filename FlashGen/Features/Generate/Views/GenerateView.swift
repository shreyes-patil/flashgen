//
//  GenerateView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI

struct GenerateView: View {
    @StateObject private var viewModel = GenerateViewModel(service: FlashcardGeneratorService())
    @State private var showFlashcardSet = false
    @Environment(\.colorScheme) var colorScheme
    
   
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(.systemGroupedBackground)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color(.systemBackground)
    }
    
    private var textFieldBackgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.15) : Color(.systemGray6)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                // Unified Single Column Layout
                ZStack(alignment: .bottom) {
                    ScrollView {
                        VStack(spacing: 24) {
                            errorMessageView
                            
                            // Input Section
                            VStack(spacing: 20) {
                                topicInputView
                                difficultySelectorView
                                cardCountSliderView
                            }
                            
                            // Preview Section
                            previewCardView
                                .frame(minHeight: 200) // Ensure it has some presence
                            
                            Color.clear.frame(height: 100) // Spacing for floating button
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        .frame(maxWidth: 700) // Constrain width for readability on iPad
                        .frame(maxWidth: .infinity) // Center in parent
                    }
                    
                    // Floating Generate Button
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        generateButtonView
                            .frame(maxWidth: 700) // Match content width
                    }
                    .background(backgroundColor)
                    .frame(maxWidth: .infinity) // Ensure full width background for the bar
                }
            }
            .navigationTitle(Text("generate.title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showFlashcardSet) {
                FlashcardSetView(
                    flashcardSetTitle: viewModel.topic,
                    flashcards: viewModel.flashcards,
                    lastReviewed: "Just now",
                    numberOfCards: viewModel.flashcards.count,
                    difficulty: viewModel.difficulty,
                    setId: viewModel.generatedSetId
                )

            }
        }
    }
    
    // MARK: - Subviews
    
    private var errorMessageView: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.15))
                .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
                .padding(.horizontal)
            }
        }
    }
    
    private var topicInputView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("generate.topic.label")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .padding(.leading, 4)
            
            TextField(
                NSLocalizedString("generate.topic.placeholder", comment: ""),
                text: $viewModel.topic
            )
            .font(.body)
            .padding()
            .background(cardBackgroundColor)
            .clipShape(RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight]))
            .overlay(
                RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight])
                    .stroke(viewModel.topic.isEmpty ? Color.gray.opacity(0.3) : Color.blue.opacity(0.5), lineWidth: 1)
            )
            .accessibilityLabel(Text("generate.topic.label"))
        }
        .padding(.horizontal)
    }
    
    private var difficultySelectorView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("generate.difficulty.label")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            HStack(spacing: 2) {
                ForEach(FlashcardDifficulty.allCases, id: \.self) { difficulty in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.difficulty = difficulty
                        }
                    }) {
                        Text(difficulty.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(
                                viewModel.difficulty == difficulty ? .white : .primary
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                viewModel.difficulty == difficulty ?
                                difficulty.color :
                                Color.gray.opacity(0.2)
                            )
                    }
                    .clipShape(
                        difficulty == FlashcardDifficulty.allCases.first ?
                        AnyShape(UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 0
                        )) :
                        difficulty == FlashcardDifficulty.allCases.last ?
                        AnyShape(UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 16,
                            topTrailingRadius: 0
                        )) :
                        AnyShape(Rectangle())
                    )
                }
            }
            .clipShape(RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight]))
            .accessibilityLabel(Text("generate.difficulty.label"))
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(RoundedCornerShape(radius: 20, corners: [.topLeft, .bottomRight]))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .padding(.horizontal)
    }
    
    private var cardCountSliderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("generate.count.label")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            HStack {
                Text("\(viewModel.numberOfCards)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Text(viewModel.numberOfCards == 1 ?
                    NSLocalizedString("flashcard_singular", comment: "") :
                    NSLocalizedString("flashcards_plural", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Slider(
                value: Binding(
                    get: { Double(viewModel.numberOfCards) },
                    set: { viewModel.numberOfCards = Int($0) }
                ),
                in: 5...20,
                step: 1
            )
            .tint(.blue)
            .accessibilityLabel(Text("generate.count.label"))
            .accessibilityValue(Text("\(viewModel.numberOfCards)"))
            
            HStack {
                Text("5")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("20")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(RoundedCornerShape(radius: 20, corners: [.topLeft, .bottomRight]))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .padding(.horizontal)
    }
    
    private var previewCardView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
                Text(LocalizedStringKey("generate.preview.title"))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                Spacer()
            }
            
            HStack {
                if viewModel.topic.isEmpty {
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: "wand.and.stars")
                            .font(.largeTitle)
                            .foregroundColor(.yellow.opacity(0.8))
                        Text(LocalizedStringKey("generate.preview.empty_hint"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.topic)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        HStack(spacing: 8) {
                            Label("\(viewModel.numberOfCards)", systemImage: "rectangle.stack.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text(viewModel.difficulty.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(viewModel.difficulty.color.opacity(0.2))
                                .foregroundColor(viewModel.difficulty.color)
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(cardBackgroundColor)
        .clipShape(RoundedCornerShape(radius: 20, corners: [.topLeft, .bottomRight]))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        .padding(.horizontal)
    }
    
    private var generateButtonView: some View {
        Button(action: {
            Task {
                await viewModel.generate()
                if !viewModel.flashcards.isEmpty {
                    showFlashcardSet = true
                }
            }
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "sparkles")
                        .foregroundColor(.white)
                }
                
                Text(LocalizedStringKey("generate.button"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .clipShape(RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight]))
            .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
        }
        .disabled(viewModel.topic.isEmpty || viewModel.isLoading)
        .opacity(viewModel.topic.isEmpty || viewModel.isLoading ? 0.5 : 1)
        .accessibilityLabel(Text("generate.button"))
        .accessibilityHint(Text(LocalizedStringKey("generate.button.hint")))
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(backgroundColor)
    }
}



#Preview {
    GenerateView()
}
