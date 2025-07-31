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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(cigarette.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Image(cigarette.barcodeImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
                    .padding()
                
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