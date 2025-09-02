//
//  GenerateView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 7/15/25.
//

import SwiftUI

struct GenerateView: View {
    @StateObject private var viewModel = GenerateViewModel(service:  MockFlashcardGenerationService())
    
    
    var body: some View {
        VStack(spacing: 0) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
            }
            ZStack{
                
                Form {
                    Section(header: Text("generate.topic.label")){
                        TextField(
                            NSLocalizedString("generate.topic.placeholder", comment: ""),
                            text: $viewModel.topic
                        )
                        .clipShape(
                            RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight])
                        )
                        .shadow(radius: 4)
                        .accessibilityLabel(Text("generate.topic.label"))
                    }
                    
                    Section(header: Text("generate.difficulty.label")){
                        Picker("generate.difficulty.label", selection: $viewModel.difficulty){
                            ForEach(FlashcardDifficulty.allCases, id: \.self){ difficulty in
                                Text(difficulty.displayName)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .clipShape(
                            RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight])
                        )
                        .shadow(radius: 4)
                        .accessibilityLabel(Text("generate.difficulty.label"))
                    }
                    
                    
                    Section(header: Text("generate.count.label")) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(viewModel.numberOfCards) flashcards")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
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
                        }
                    }
                    
                    
                }
                
                .safeAreaInset(edge: .bottom){
                    Button(action: {
                        Task { await viewModel.generate() }
                    }) {
                        Text(LocalizedStringKey("generate.button"))
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(
                                RoundedCornerShape(radius: 18, corners: [.topLeft, .bottomRight])
                            )
                            .shadow(radius: 4)
                            .padding(.horizontal, 2)
                    }
                    .disabled(viewModel.topic.isEmpty || viewModel.isLoading)
                    .opacity(viewModel.topic.isEmpty || viewModel.isLoading ? 0.5 : 1)
                    .accessibilityLabel(Text("generate.button"))
                    .padding(.bottom, 12)
                }
                
            }
        .navigationTitle(Text("generate.title"))
        }
        
        
    }
}

#Preview {
    GenerateView()
}
