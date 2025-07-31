//
//  BarcodeDisplayView.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import SwiftUI

struct BarcodeDisplayView: View {
    let cigarette: Cigarette
    @Environment(\.dismiss) var dismiss
    @State private var barcodeImage: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(cigarette.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Group {
                    if isLoading {
                        ProgressView("바코드 로드 중...")
                            .frame(height: 200)
                    } else if let barcodeImage = barcodeImage {
                        Image(uiImage: barcodeImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                            .padding()
                    } else {
                        // Assets에서 이미지를 가져오려고 시도
                        Image(cigarette.barcodeImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                            .padding()
                            .onAppear {
                                // Assets에서도 이미지를 찾을 수 없는 경우를 위한 fallback
                                if UIImage(named: cigarette.barcodeImageName) == nil {
                                    generateBarcodeImage()
                                }
                            }
                    }
                }
                
                Text("바코드 번호: \(cigarette.barcodeNumber)")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadBarcodeImage()
            }
        }
    }
    
    private func loadBarcodeImage() {
        isLoading = true
        
        // 1. Documents 디렉토리에서 저장된 이미지 확인
        if let savedImage = DataManager.shared.loadBarcodeImage(imageName: cigarette.barcodeImageName) {
            barcodeImage = savedImage
            isLoading = false
            return
        }
        
        // 2. Assets에서 이미지 확인
        if let assetImage = UIImage(named: cigarette.barcodeImageName) {
            barcodeImage = assetImage
            isLoading = false
            return
        }
        
        // 3. 둘 다 없으면 동적으로 바코드 생성
        generateBarcodeImage()
    }
    
    private func generateBarcodeImage() {
        guard !cigarette.barcodeNumber.isEmpty else {
            isLoading = false
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let generatedImage = BarcodeGenerator.generateBarcode(from: cigarette.barcodeNumber)
            
            DispatchQueue.main.async {
                barcodeImage = generatedImage
                isLoading = false
                
                // 생성된 이미지를 Documents 디렉토리에 저장
                if let image = generatedImage, let imageData = image.pngData() {
                    _ = DataManager.shared.saveBarcodeImage(imageData, imageName: cigarette.barcodeImageName)
                }
            }
        }
    }
}

#Preview {
    BarcodeDisplayView(
        cigarette: Cigarette(
            name: "말보루 화이트",
            barcodeImageName: "product_001",
            order: 1,
            barcodeNumber: "8801047019510"
        )
    )
} 