//
//  ContentView.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import SwiftUI

enum Field: Hashable {
    case storefront(id: UUID)
    case warehouse(id: UUID)
    case registered(id: UUID)
}

struct ContentView: View {
    @StateObject private var viewModel = InventoryViewModel()
    @FocusState private var focusedField: Field?
    @State private var showingResetAlert = false
    @State private var showScrollToTopButton = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(viewModel.cigarettes.indices, id: \.self) { index in
                        CigaretteRowView(
                            cigarette: $viewModel.cigarettes[index],
                            focusedField: $focusedField,
                            onBarcodeTap: {
                                viewModel.selectedCigarette = viewModel.cigarettes[index]
                            },
                            onFocusNext: {
                                // Not used anymore since we handle focus navigation via toolbar
                            }
                        )
                        .id("cigarette-\(index)")
                    }
                }
                .navigationTitle("담배 재고 관리")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("전체 초기화") {
                            showingResetAlert = true
                        }
                    }
                    
                    if focusedField != nil {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("이전") {
                                moveToPreviousField()
                            }
                            .disabled(!canMoveToPrevious())
                            
                            Spacer()
                            
                            Button("다음") {
                                moveToNextField()
                            }
                            .disabled(!canMoveToNext())
                            
                            Button("완료") {
                                focusedField = nil
                            }
                        }
                    }
                }
                .alert("전체 초기화", isPresented: $showingResetAlert) {
                    Button("취소", role: .cancel) { }
                    Button("초기화", role: .destructive) {
                        viewModel.resetAllCounts()
                    }
                } message: {
                    Text("모든 재고 수량을 0으로 초기화하시겠습니까?")
                }
                .sheet(item: $viewModel.selectedCigarette) { cigarette in
                    BarcodeDisplayView(cigarette: cigarette, focusedField: $focusedField)
                }
                .overlay(alignment: .bottomTrailing) {
                    if showScrollToTopButton {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("cigarette-0", anchor: .top)
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
                .onAppear {
                    showScrollToTopButton = true
                }
            }
        }
    }
    
    // MARK: - Focus Navigation Methods
    
    private func moveToNextField() {
        guard let current = focusedField else { return }
        
        let cigarettes = viewModel.cigarettes
        let maxIndex = cigarettes.count - 1
        
        switch current {
        case .storefront(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index < maxIndex {
                let nextCigarette = cigarettes[index + 1]
                focusedField = .storefront(id: nextCigarette.id)
            }
        case .warehouse(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index < maxIndex {
                let nextCigarette = cigarettes[index + 1]
                focusedField = .warehouse(id: nextCigarette.id)
            }
        case .registered(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index < maxIndex {
                let nextCigarette = cigarettes[index + 1]
                focusedField = .registered(id: nextCigarette.id)
            }
        }
    }
    
    private func moveToPreviousField() {
        guard let current = focusedField else { return }
        
        let cigarettes = viewModel.cigarettes
        
        switch current {
        case .storefront(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index > 0 {
                let previousCigarette = cigarettes[index - 1]
                focusedField = .storefront(id: previousCigarette.id)
            }
        case .warehouse(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index > 0 {
                let previousCigarette = cigarettes[index - 1]
                focusedField = .warehouse(id: previousCigarette.id)
            }
        case .registered(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }), index > 0 {
                let previousCigarette = cigarettes[index - 1]
                focusedField = .registered(id: previousCigarette.id)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func canMoveToNext() -> Bool {
        guard let current = focusedField else { return false }
        
        let cigarettes = viewModel.cigarettes
        let maxIndex = cigarettes.count - 1
        
        switch current {
        case .storefront(let id), .warehouse(let id), .registered(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }) {
                return index < maxIndex
            }
            return false
        }
    }
    
    private func canMoveToPrevious() -> Bool {
        guard let current = focusedField else { return false }
        
        let cigarettes = viewModel.cigarettes
        
        switch current {
        case .storefront(let id), .warehouse(let id), .registered(let id):
            if let index = cigarettes.firstIndex(where: { $0.id == id }) {
                return index > 0
            }
            return false
        }
    }
}

#Preview {
    ContentView()
} 