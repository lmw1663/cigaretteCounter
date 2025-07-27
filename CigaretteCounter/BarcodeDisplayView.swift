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
    @FocusState.Binding var focusedField: Field?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(cigarette.name)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                Image(cigarette.barcodeImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .onTapGesture {
                        // 시트 닫기
                        dismiss()
                        
                        // 전산 재고 필드로 포커스 이동
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            focusedField = .registered(id: cigarette.id)
                        }
                    }
                
                Text("외부 스캐너로 바코드를 스캔한 후\n이미지를 탭하여 전산 재고를 입력하세요")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
} 