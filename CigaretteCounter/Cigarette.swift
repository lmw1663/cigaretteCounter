//
//  Cigarette.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import Foundation

struct Cigarette: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    var barcodeImageName: String
    var storefrontStock: Int = 0        // 개비 단위로 저장 (일반 입력)
    var warehouseStock: Int = 0         // 개비 단위로 저장 (내부)
    var registeredStock: Int = 0
    var order: Int = 0                  // 사용자 정의 순서
    var barcodeNumber: String = ""      // 바코드 번호
    
    // 창고 재고를 보루 단위로 표시 (1보루 = 10개비)
    var warehouseStockInBoru: Int {
        get { warehouseStock / 10 }
        set { warehouseStock = newValue * 10 }
    }
    
    // 계산 프로퍼티: 전산 재고 - (창고 재고 + 매대 재고)
    var difference: Int {
        return registeredStock - (warehouseStock + storefrontStock)
    }
    
    // Codable을 위한 커스텀 키
    private enum CodingKeys: String, CodingKey {
        case id, name, barcodeImageName, storefrontStock, warehouseStock, registeredStock, order, barcodeNumber
    }
} 