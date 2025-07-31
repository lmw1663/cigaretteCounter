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
    @State private var showingWarehouseTouchUI = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("담배 이름 검색", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // 담배 목록
                ScrollViewReader { proxy in
                    List {
                        ForEach(viewModel.cigarettes.indices, id: \.self) { index in
                            let cigarette = viewModel.cigarettes[index]
                            
                            // 검색 조건에 맞는 경우만 표시
                            if viewModel.searchText.isEmpty || 
                               cigarette.name.localizedCaseInsensitiveContains(viewModel.searchText) {
                                CigaretteRowView(
                                    cigarette: $viewModel.cigarettes[index],
                                    focusedField: $focusedField,
                                    onBarcodeTap: {
                                        viewModel.selectedCigarette = cigarette
                                    },
                                    onFocusNext: {
                                        focusNextField(after: cigarette.id)
                                    }
                                )
                                .contextMenu {
                                    Button(action: {
                                        viewModel.editCigarette(cigarette)
                                    }) {
                                        Label("편집", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        deleteCigarette(cigarette)
                                    }) {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                                .id(cigarette.id)
                            }
                        }
                        .onMove(perform: viewModel.moveItem)
                        .onDelete(perform: viewModel.deleteCigarette)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .onChange(of: showScrollToTopButton) { _, newValue in
                        if newValue {
                            withAnimation {
                                proxy.scrollTo(viewModel.filteredCigarettes.first?.id, anchor: .top)
                                showScrollToTopButton = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("담배 재고 관리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("창고 재고") {
                        showingWarehouseTouchUI = true
                    }
                    .foregroundColor(.blue)
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingNewCigaretteSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                    
                    Menu {
                        Button("전체 재고 초기화", role: .destructive) {
                            showingResetAlert = true
                        }
                        
                        Button("맨 위로") {
                            showScrollToTopButton = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                // 키보드 툴바 추가
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Button("이전") {
                            moveToPreviousField()
                        }
                        .disabled(!canMoveToPrevious())
                        
                        Button("다음") {
                            moveToNextField()
                        }
                        .disabled(!canMoveToNext())
                        
                        Spacer()
                        
                        Button("완료") {
                            focusedField = nil
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingNewCigaretteSheet) {
                NewCigaretteView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingEditCigaretteSheet) {
                if let editingCigarette = viewModel.editingCigarette {
                    EditCigaretteView(viewModel: viewModel, cigarette: editingCigarette)
                }
            }
            .sheet(isPresented: $showingWarehouseTouchUI) {
                WarehouseTouchUIView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.selectedCigarette) { cigarette in
                BarcodeDisplayView(cigarette: cigarette)
            }
            .alert("전체 재고 초기화", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    viewModel.resetAllStocks()
                }
            } message: {
                Text("모든 담배의 재고를 0으로 초기화하시겠습니까?")
            }
        }
    }
    
    private func deleteCigarette(_ cigarette: Cigarette) {
        if let index = viewModel.cigarettes.firstIndex(where: { $0.id == cigarette.id }) {
            viewModel.cigarettes.remove(at: index)
        }
    }
    
    private func focusNextField(after currentId: UUID) {
        let sortedCigarettes = viewModel.filteredCigarettes
        if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
           currentIndex + 1 < sortedCigarettes.count {
            let nextCigarette = sortedCigarettes[currentIndex + 1]
            focusedField = .storefront(id: nextCigarette.id)
        }
    }
    
    // MARK: - 키보드 네비게이션 헬퍼 메소드들
    
    private func getAllFields() -> [Field] {
        var fields: [Field] = []
        let sortedCigarettes = viewModel.filteredCigarettes
        
        // 매대 재고 필드들
        for cigarette in sortedCigarettes {
            fields.append(.storefront(id: cigarette.id))
        }
        
        // 창고 재고 필드들
        for cigarette in sortedCigarettes {
            fields.append(.warehouse(id: cigarette.id))
        }
        
        // 전산 재고 필드들
        for cigarette in sortedCigarettes {
            fields.append(.registered(id: cigarette.id))
        }
        
        return fields
    }
    
    private func moveToNextField() {
        guard let currentField = focusedField else { return }
        let sortedCigarettes = viewModel.filteredCigarettes
        
        switch currentField {
        case .storefront(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex + 1 < sortedCigarettes.count {
                // 다음 담배의 매대 재고로 이동
                let nextCigarette = sortedCigarettes[currentIndex + 1]
                focusedField = .storefront(id: nextCigarette.id)
            }
            
        case .warehouse(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex + 1 < sortedCigarettes.count {
                // 다음 담배의 창고 재고로 이동
                let nextCigarette = sortedCigarettes[currentIndex + 1]
                focusedField = .warehouse(id: nextCigarette.id)
            }
            
        case .registered(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex + 1 < sortedCigarettes.count {
                // 다음 담배의 전산 재고로 이동
                let nextCigarette = sortedCigarettes[currentIndex + 1]
                focusedField = .registered(id: nextCigarette.id)
            }
        }
    }
    
    private func moveToPreviousField() {
        guard let currentField = focusedField else { return }
        let sortedCigarettes = viewModel.filteredCigarettes
        
        switch currentField {
        case .storefront(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex > 0 {
                // 이전 담배의 매대 재고로 이동
                let previousCigarette = sortedCigarettes[currentIndex - 1]
                focusedField = .storefront(id: previousCigarette.id)
            }
            
        case .warehouse(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex > 0 {
                // 이전 담배의 창고 재고로 이동
                let previousCigarette = sortedCigarettes[currentIndex - 1]
                focusedField = .warehouse(id: previousCigarette.id)
            }
            
        case .registered(let currentId):
            // 현재 담배의 인덱스 찾기
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }),
               currentIndex > 0 {
                // 이전 담배의 전산 재고로 이동
                let previousCigarette = sortedCigarettes[currentIndex - 1]
                focusedField = .registered(id: previousCigarette.id)
            }
        }
    }
    
    private func canMoveToNext() -> Bool {
        guard let currentField = focusedField else { return false }
        let sortedCigarettes = viewModel.filteredCigarettes
        
        switch currentField {
        case .storefront(let currentId), .warehouse(let currentId), .registered(let currentId):
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }) {
                return currentIndex + 1 < sortedCigarettes.count
            }
        }
        
        return false
    }
    
    private func canMoveToPrevious() -> Bool {
        guard let currentField = focusedField else { return false }
        let sortedCigarettes = viewModel.filteredCigarettes
        
        switch currentField {
        case .storefront(let currentId), .warehouse(let currentId), .registered(let currentId):
            if let currentIndex = sortedCigarettes.firstIndex(where: { $0.id == currentId }) {
                return currentIndex > 0
            }
        }
        
        return false
    }
}

#Preview {
    ContentView()
} 