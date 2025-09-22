//
//  FlashcardDeckView.swift
//  FlashGen
//
//  Created by Shreyas Patil on 9/17/25.
//

import SwiftUI

struct FlashcardDeckView: View {
    
    @StateObject var vm : FlashcardsViewModel
    @State private var drag : CGSize = .zero
    
    private let commit : CGFloat = 100
    private let maxTilt : Double = 8
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                            header

                            if let card = vm.current {
                                GlassCard {
                                    FlipCardView(question: card.question ?? "", answer: card.answer ?? "", isRevealed: vm.isRevealed)
                                }
                                .offset(x: drag.width)
                                .rotationEffect(.degrees(clampedTilt))
                    .animation(.spring(response: 0.32, dampingFraction: 0.88), value: drag)
                    .contentShape(RoundedCornerShape(radius: 16, corners: [.topLeft, .bottomRight]))
                    .onTapGesture {
                        vm.flip()
                    }
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged { value in
                                guard !vm.isPaging else {return}
                                let resistance : CGFloat = vm.isRevealed ? 1 : 2.2
                                drag = CGSize(width: value.translation.width / resistance, height: 0)
                                
                            }
                            .onEnded { value in
                                guard !vm.isPaging else { return }

                                let dx = value.translation.width
                                let vx = value.predictedEndTranslation.width

                                let shouldGoNext = (dx < -commit) || (vx < -commit)
                                let shouldGoPrev = (dx > commit)  || (vx > commit)    

                                if shouldGoNext {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                                        drag.width = -600
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                        vm.next()
                                        drag = .zero
                                    }
                                } else if shouldGoPrev {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                                        drag.width = 600
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                        vm.previous()
                                        drag = .zero
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                        drag = .zero
                                    }
                                }
                            }
                                                )
                                            }else {
                                Text("flashcards.empty")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 40)
                            }
                controls
            }.padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var controls: some View {
            HStack(spacing: 12) {
                Button {
                    withAnimation { vm.previous() }
                } label: {
                    Label("flashcards.prev", systemImage: "chevron.left")
                }
                .buttonStyle(.bordered)

                Button {
                    withAnimation { vm.flip() }
                } label: {
                    Label(vm.isRevealed ? "flashcards.hide" : "flashcards.reveal",
                          systemImage: "rectangle.on.rectangle")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    withAnimation { vm.next() }
                } label: {
                    Label("flashcards.next", systemImage: "chevron.right")
                }
                .buttonStyle(.bordered)
            }
            .labelStyle(.titleAndIcon)
        }
    
    private var clampedTilt: Double {
        let raw = Double(drag.width / 12)
        return min(max(raw, -maxTilt), maxTilt)
    }
                                                
    private var header: some View {
        HStack{
            Text("flashcards.title")
                .font(.title2).bold()
            Spacer()
            ProgressPill(text: vm.progressText)
        }}
}

