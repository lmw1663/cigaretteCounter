import SwiftUI

struct EditCigaretteView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.dismiss) var dismiss
    
    let cigarette: Cigarette
    
    @State private var cigaretteName: String = ""
    @State private var barcodeNumber: String = ""
    @State private var generatedBarcodeImage: UIImage?
    @State private var isGeneratingBarcode = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 헤더
                VStack(spacing: 8) {
                    Text("담배 정보 수정")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("담배 이름과 바코드 번호를 수정할 수 있습니다")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                .padding(.bottom, 10)
                
                Form {
                    Section(header: Text("기본 정보").font(.headline)) {
                        VStack(alignment: .leading, spacing: 12) {
                            // 담배 이름
                            VStack(alignment: .leading, spacing: 4) {
                                Text("담배 이름")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                TextField("예: 말보루 화이트", text: $cigaretteName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .autocapitalization(.none)
                            }
                            
                            // 바코드 번호
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("바코드 번호")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if isGeneratingBarcode {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    } else if !barcodeNumber.isEmpty {
                                        Text(barcodeFormat)
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(4)
                                    }
                                }
                                
                                TextField("13자리 숫자 권장 (EAN-13)", text: $barcodeNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .onChange(of: barcodeNumber) { _, newValue in
                                        generateBarcodeWithDelay()
                                    }
                                
                                Text("8자리(EAN-8), 13자리(EAN-13) 또는 임의 길이(Code128) 지원")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // 바코드 미리보기 - 더 눈에 띄게 개선
                    if let barcodeImage = generatedBarcodeImage {
                        Section(header: HStack {
                            Image(systemName: "qrcode")
                                .foregroundColor(.blue)
                            Text("바코드 미리보기")
                                .font(.headline)
                            Spacer()
                            Text("실시간 생성됨")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(4)
                        }) {
                            VStack(spacing: 16) {
                                // 바코드 이미지
                                VStack(spacing: 8) {
                                    Image(uiImage: barcodeImage)
                                        .interpolation(.none)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 80)
                                        .padding(.horizontal)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    
                                    VStack(spacing: 4) {
                                        Text("바코드 번호: \(barcodeNumber)")
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        
                                        Text("형식: \(barcodeFormat)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // 안내 메시지
                                HStack {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                    
                                    Text("저장 시 이 바코드가 기존 바코드를 대체합니다")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding(.vertical, 8)
                        }
                    } else if !barcodeNumber.isEmpty && !isGeneratingBarcode {
                        Section(header: HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text("바코드 생성 실패")
                                .font(.headline)
                        }) {
                            VStack(spacing: 8) {
                                Text("입력한 바코드 번호로 바코드를 생성할 수 없습니다")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                
                                Text("• 숫자만 입력해주세요\n• EAN-13: 정확히 13자리\n• EAN-8: 정확히 8자리\n• Code128: 임의 길이")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    // 현재 재고 정보 표시 (읽기 전용)
                    Section(header: Text("현재 재고 정보").font(.headline)) {
                        VStack(spacing: 12) {
                            HStack {
                                Label("매대 재고", systemImage: "storefront")
                                    .foregroundColor(.orange)
                                Spacer()
                                Text("\(cigarette.storefrontStock) 개비")
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Label("창고 재고", systemImage: "building.2")
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("\(cigarette.warehouseStockInBoru) 보루 (\(cigarette.warehouseStock) 개비)")
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Label("전산 재고", systemImage: "desktopcomputer")
                                    .foregroundColor(.purple)
                                Spacer()
                                Text("\(cigarette.registeredStock) 개비")
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            
                            Divider()
                            
                            HStack {
                                Label("재고 차이", systemImage: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(cigarette.difference)")
                                    .foregroundColor(differenceColor(cigarette.difference))
                                    .fontWeight(.bold)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
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
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        updateCigarette()
                    }
                    .disabled(cigaretteName.isEmpty || barcodeNumber.isEmpty || isGeneratingBarcode)
                    .foregroundColor(cigaretteName.isEmpty || barcodeNumber.isEmpty || isGeneratingBarcode ? .gray : .blue)
                    .fontWeight(.semibold)
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
    
    private var barcodeFormat: String {
        if barcodeNumber.allSatisfy({ $0.isNumber }) {
            switch barcodeNumber.count {
            case 8:
                return "EAN-8"
            case 13:
                return "EAN-13"
            default:
                return "Code128"
            }
        } else {
            return "Code128"
        }
    }
    
    private func generateBarcodeWithDelay() {
        isGeneratingBarcode = true
        
        // 사용자 입력이 끝날 때까지 기다린 후 바코드 생성
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            generateBarcode()
            isGeneratingBarcode = false
        }
    }
    
    private func generateBarcode() {
        guard !barcodeNumber.isEmpty else {
            generatedBarcodeImage = nil
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let image = BarcodeGenerator.generateBarcode(from: barcodeNumber)
            
            DispatchQueue.main.async {
                generatedBarcodeImage = image
            }
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
        
        guard generatedBarcodeImage != nil else {
            showAlert(message: "올바른 바코드 번호를 입력해주세요.")
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