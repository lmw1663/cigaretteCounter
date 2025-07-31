import SwiftUI

struct WarehouseTouchUIView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var showingResetAlert = false
    
    // 그리드 레이아웃 설정 - 3개 고정 컬럼
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var filteredCigarettes: [Cigarette] {
        if searchText.isEmpty {
            return viewModel.cigarettes.sorted { $0.order < $1.order }
        } else {
            return viewModel.cigarettes
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { $0.order < $1.order }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 헤더와 검색 바
                VStack(spacing: 12) {
                    Text("창고 재고 터치 입력")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("각 담배를 탭하여 창고 재고를 1보루씩 추가하세요")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // 검색 바
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("담배 이름 검색", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
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
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // 담배 그리드
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(filteredCigarettes, id: \.id) { cigarette in
                            CigaretteWarehouseCardView(
                                cigarette: cigarette,
                                onTap: {
                                    addWarehouseStock(for: cigarette.id)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 80)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("초기화") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .alert("창고 재고 초기화", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    resetWarehouseStocks()
                }
            } message: {
                Text("모든 창고 재고를 0으로 초기화하시겠습니까?")
            }
        }
    }
    
    private func addWarehouseStock(for cigaretteId: UUID) {
        if let index = viewModel.cigarettes.firstIndex(where: { $0.id == cigaretteId }) {
            // 보루 단위로 1 증가 (내부적으로는 10개비 증가)
            viewModel.cigarettes[index].warehouseStockInBoru += 1
            
            // 햅틱 피드백
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func resetWarehouseStocks() {
        for index in viewModel.cigarettes.indices {
            viewModel.cigarettes[index].warehouseStock = 0
        }
    }
}

struct CigaretteWarehouseCardView: View {
    let cigarette: Cigarette
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // 담배 이름
                Text(cigarette.name)
                    .font(.system(size: 11, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                // 창고 재고 (보루 단위로 표시, "보루" 텍스트 제거)
                Text("\(cigarette.warehouseStockInBoru)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(1.0)
            .animation(.easeInOut(duration: 0.1), value: cigarette.warehouseStock)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    WarehouseTouchUIView(viewModel: InventoryViewModel())
} 