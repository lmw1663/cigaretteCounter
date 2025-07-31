import SwiftUI

struct EditCigaretteView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.dismiss) var dismiss
    
    let cigarette: Cigarette
    
    @State private var cigaretteName: String = ""
    @State private var barcodeNumber: String = ""
    @State private var generatedBarcodeImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 헤더
                Text("담배 정보 수정")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Form {
                    Section(header: Text("담배 정보")) {
                        TextField("담배 이름", text: $cigaretteName)
                            .autocapitalization(.none)
                        
                        TextField("바코드 번호", text: $barcodeNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: barcodeNumber) { _, newValue in
                                generateBarcode()
                            }
                    }
                    
                    // 바코드 미리보기
                    if let barcodeImage = generatedBarcodeImage {
                        Section(header: Text("바코드 미리보기")) {
                            VStack {
                                Image(uiImage: barcodeImage)
                                    .interpolation(.none)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 60)
                                    .padding()
                                
                                Text("바코드 번호: \(barcodeNumber)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // 현재 재고 정보 표시 (읽기 전용)
                    Section(header: Text("현재 재고 정보")) {
                        HStack {
                            Text("매대 재고")
                            Spacer()
                            Text("\(cigarette.storefrontStock) 개비")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("창고 재고")
                            Spacer()
                            Text("\(cigarette.warehouseStockInBoru) 보루 (\(cigarette.warehouseStock) 개비)")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("전산 재고")
                            Spacer()
                            Text("\(cigarette.registeredStock) 개비")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("차이")
                            Spacer()
                            Text("\(cigarette.difference)")
                                .foregroundColor(differenceColor(cigarette.difference))
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        updateCigarette()
                    }
                    .disabled(cigaretteName.isEmpty || barcodeNumber.isEmpty)
                }
            }
            .alert("알림", isPresented: $showingAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                cigaretteName = cigarette.name
                barcodeNumber = cigarette.barcodeNumber
                generateBarcode()
            }
        }
    }
    
    private func generateBarcode() {
        guard !barcodeNumber.isEmpty else {
            generatedBarcodeImage = nil
            return
        }
        
        // 바코드 번호 길이에 따라 적절한 바코드 형식 선택
        if barcodeNumber.count == 13 {
            generatedBarcodeImage = BarcodeGenerator.generateEAN13Barcode(from: barcodeNumber)
        } else if barcodeNumber.count == 8 {
            generatedBarcodeImage = BarcodeGenerator.generateEAN8Barcode(from: barcodeNumber)
        } else {
            generatedBarcodeImage = BarcodeGenerator.generateCode128Barcode(from: barcodeNumber)
        }
    }
    
    private func updateCigarette() {
        // 유효성 검사
        guard !cigaretteName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "담배 이름을 입력해주세요.")
            return
        }
        
        guard !barcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "바코드 번호를 입력해주세요.")
            return
        }
        
        // 중복 검사 (현재 담배 제외)
        if viewModel.isDuplicateName(cigaretteName.trimmingCharacters(in: .whitespacesAndNewlines), excludingId: cigarette.id) {
            showAlert(message: "이미 존재하는 담배 이름입니다.")
            return
        }
        
        if viewModel.isDuplicateBarcodeNumber(barcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines), excludingId: cigarette.id) {
            showAlert(message: "이미 존재하는 바코드 번호입니다.")
            return
        }
        
        // 바코드 이미지 데이터 변환
        let imageData = generatedBarcodeImage?.pngData()
        
        // 담배 정보 업데이트
        viewModel.updateCigarette(
            id: cigarette.id,
            name: cigaretteName.trimmingCharacters(in: .whitespacesAndNewlines),
            barcodeNumber: barcodeNumber.trimmingCharacters(in: .whitespacesAndNewlines),
            generatedImage: imageData
        )
        
        dismiss()
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
    
    private func differenceColor(_ difference: Int) -> Color {
        if difference == 0 {
            return .green
        } else if difference > 0 {
            return .blue
        } else {
            return .red
        }
    }
}

#Preview {
    EditCigaretteView(
        viewModel: InventoryViewModel(),
        cigarette: Cigarette(
            name: "말보루 화이트",
            barcodeImageName: "product_001",
            order: 1,
            barcodeNumber: "8801047019510"
        )
    )
} 