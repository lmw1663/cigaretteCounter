import SwiftUI

struct NewCigaretteView: View {
    @ObservedObject var viewModel: InventoryViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var cigaretteName: String = ""
    @State private var barcodeNumber: String = ""
    @State private var generatedBarcodeImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 헤더
                Text("신규 담배 등록")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Form {
                    Section(header: Text("담배 정보")) {
                        TextField("담배 이름", text: $cigaretteName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("바코드 번호", text: $barcodeNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: barcodeNumber) { _, newValue in
                                generateBarcodePreview()
                            }
                    }
                    
                    Section(header: Text("바코드 미리보기")) {
                        VStack {
                            if let barcodeImage = generatedBarcodeImage {
                                Image(uiImage: barcodeImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 100)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 100)
                                    .cornerRadius(8)
                                    .overlay(
                                        Text("바코드 번호를 입력하세요")
                                            .foregroundColor(.gray)
                                    )
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Spacer()
                
                // 버튼들
                HStack(spacing: 20) {
                    Button("취소") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    Button("등록") {
                        addNewCigarette()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!isFormValid)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
        .alert("알림", isPresented: $showingAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isFormValid: Bool {
        !cigaretteName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !barcodeNumber.trimmingCharacters(in: .whitespaces).isEmpty &&
        generatedBarcodeImage != nil
    }
    
    private func generateBarcodePreview() {
        guard !barcodeNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            generatedBarcodeImage = nil
            return
        }
        
        generatedBarcodeImage = BarcodeGenerator.generateBarcode(from: barcodeNumber)
    }
    
    private func addNewCigarette() {
        let trimmedName = cigaretteName.trimmingCharacters(in: .whitespaces)
        let trimmedBarcodeNumber = barcodeNumber.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty && !trimmedBarcodeNumber.isEmpty else {
            alertMessage = "모든 필드를 입력해주세요."
            showingAlert = true
            return
        }
        
        // 중복 확인
        let existingCigarette = viewModel.cigarettes.first { cigarette in
            cigarette.name.lowercased() == trimmedName.lowercased() ||
            cigarette.barcodeNumber == trimmedBarcodeNumber
        }
        
        if let existing = existingCigarette {
            if existing.name.lowercased() == trimmedName.lowercased() {
                alertMessage = "이미 존재하는 담배 이름입니다."
            } else {
                alertMessage = "이미 존재하는 바코드 번호입니다."
            }
            showingAlert = true
            return
        }
        
        // 바코드 이미지 데이터 생성
        let barcodeImageData = BarcodeGenerator.barcodeImageData(from: trimmedBarcodeNumber)
        
        // 신규 담배 추가
        viewModel.addNewCigarette(
            name: trimmedName,
            barcodeNumber: trimmedBarcodeNumber,
            generatedImage: barcodeImageData
        )
        
        // 성공 메시지 표시 후 닫기
        alertMessage = "새로운 담배가 등록되었습니다."
        showingAlert = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dismiss()
        }
    }
}

#Preview {
    NewCigaretteView(viewModel: InventoryViewModel())
} 