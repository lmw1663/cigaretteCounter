//
//  Cigarette.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import Foundation

struct Cigarette: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let barcodeImageName: String
    var storefrontStock: Int = 0
    var warehouseStock: Int = 0
    var registeredStock: Int = 0
    
    // 계산 프로퍼티: 전산 재고 - 창고 수량 - 매대 수량
    var difference: Int {
        return registeredStock - warehouseStock - storefrontStock
    }
} 