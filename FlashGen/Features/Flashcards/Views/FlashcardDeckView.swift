//
//  FlashcardDeckView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/17/25.
//

import SwiftUI

struct FlashcardDeckView: View {
    
    @StateObject var vm : FlashcardsViewModel
    var color: Color = .yellow
    
    var body: some View {
        VStack(spacing: 20) {
            if vm.cards.isEmpty {
                Text("flashcards.empty")
                    .foregroundStyle(.secondary)
                    .padding(.top, 40)
                    .frame(maxHeight: .infinity)
            } else {
                TabView(selection: $vm.currentIndex) {
                    ForEach(vm.cards.indices, id: \.self) { index in
                        FlipCardView(
                            question: vm.cards[index].question ?? "",
                            answer: vm.cards[index].answer ?? "",
                            isRevealed: vm.isRevealed && vm.currentIndex == index,
                            color: color
                        )
                        
                        .tag(index)
                        .padding()
                        .frame(maxWidth: 600, maxHeight: 400) // Constrain size on iPad
                        .aspectRatio(1.5, contentMode: .fit) // Enforce card shape (3:2 ratio)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center in TabView
                        .onTapGesture {
                            withAnimation {
                                vm.flip()
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            controls
        }
        .padding(.vertical)
        .background(Color(.systemBackground)) 
        .navigationTitle("flashcards.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ProgressPill(text: vm.progressText)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .onChange(of: vm.currentIndex) { _ in
            vm.isRevealed = false
        }
    }
    
    private var controls: some View {
        HStack(spacing: 40) {
            // Previous Button
            Button {
                withAnimation { vm.previous() }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2.bold())
                    .frame(width: 60, height: 60)
                    .background(Color(.secondarySystemFill))
                    .clipShape(Circle())
                    .foregroundStyle(.primary)
            }
            .accessibilityLabel(Text(LocalizedStringKey("flashcards.prev")))
            .disabled(vm.currentIndex == 0)
            .opacity(vm.currentIndex == 0 ? 0.3 : 1)

            // Flip Button
            Button {
                withAnimation { vm.flip() }
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.title.bold())
                    .frame(width: 80, height: 60)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
                    .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
            }
            .accessibilityLabel(Text(vm.isRevealed ? LocalizedStringKey("flashcards.hide") : LocalizedStringKey("flashcards.reveal")))
            .disabled(vm.cards.isEmpty)

            // Next Button
            Button {
                withAnimation { vm.next() }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2.bold())
                    .frame(width: 60, height: 60)
                    .background(Color(.secondarySystemFill))
                    .clipShape(Circle())
                    .foregroundStyle(.primary)
            }
            .disabled(vm.currentIndex == vm.cards.count - 1)
            .opacity(vm.currentIndex == vm.cards.count - 1 ? 0.3 : 1)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    

}
