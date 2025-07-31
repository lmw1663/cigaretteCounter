//
//  CigaretteRowView.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import SwiftUI

struct CigaretteRowView: View {
    @Binding var cigarette: Cigarette
    @FocusState.Binding var focusedField: Field?
    let onBarcodeTap: () -> Void
    let onFocusNext: () -> Void
    
    @State private var storefrontText: String = ""
    @State private var warehouseText: String = ""
    @State private var registeredText: String = ""
    
    var body: some View {
        HStack {
            // 왼쪽 VStack - 담배 정보 및 재고 입력
            VStack(alignment: .leading, spacing: 12) {
                Text(cigarette.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                storefrontSection
                warehouseSection
                registeredSection
            }
            
            Spacer()
            
            // 오른쪽 바코드 보기 버튼
            Button(action: onBarcodeTap) {
                Image(systemName: "barcode")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            updateTextFields()
        }
        .onChange(of: cigarette.storefrontStock) {
            updateTextFields()
        }
        .onChange(of: cigarette.warehouseStock) {
            updateTextFields()
        }
        .onChange(of: cigarette.registeredStock) {
            updateTextFields()
        }
    }
    
    private func updateTextFields() {
        // 매대 재고는 개비 단위로 표시 (0인 경우 빈 문자열)
        storefrontText = cigarette.storefrontStock == 0 ? "" : "\(cigarette.storefrontStock)"
        
        // 창고 재고는 보루 단위로 표시 (0인 경우 빈 문자열)
        warehouseText = cigarette.warehouseStockInBoru == 0 ? "" : "\(cigarette.warehouseStockInBoru)"
        
        // 전산 재고는 개비 단위로 표시
        registeredText = cigarette.registeredStock == 0 ? "" : "\(cigarette.registeredStock)"
    }
    
    private var storefrontSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("매대")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("(개비)")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(4)
            }
            
            TextField("매대 수량 (개비)", text: $storefrontText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .storefront(id: cigarette.id))
                .onTapGesture {
                    if cigarette.storefrontStock == 0 {
                        storefrontText = ""
                    }
                }
                .onChange(of: storefrontText) { _, newValue in
                    if let value = Int(newValue) {
                        cigarette.storefrontStock = value
                    } else if newValue.isEmpty {
                        cigarette.storefrontStock = 0
                    }
                }
                .onChange(of: focusedField) { _, newFocus in
                    if case .storefront(let id) = newFocus, id == cigarette.id {
                        if cigarette.storefrontStock == 0 {
                            storefrontText = ""
                        }
                    } else if storefrontText.isEmpty {
                        cigarette.storefrontStock = 0
                    }
                }
        }
    }
    
    private var warehouseSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("창고")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("(보루)")
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            TextField("창고 수량 (보루)", text: $warehouseText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .warehouse(id: cigarette.id))
                .onTapGesture {
                    if cigarette.warehouseStockInBoru == 0 {
                        warehouseText = ""
                    }
                }
                .onChange(of: warehouseText) { _, newValue in
                    if let value = Int(newValue) {
                        cigarette.warehouseStockInBoru = value
                    } else if newValue.isEmpty {
                        cigarette.warehouseStockInBoru = 0
                    }
                }
                .onChange(of: focusedField) { _, newFocus in
                    if case .warehouse(let id) = newFocus, id == cigarette.id {
                        if cigarette.warehouseStockInBoru == 0 {
                            warehouseText = ""
                        }
                    } else if warehouseText.isEmpty {
                        cigarette.warehouseStockInBoru = 0
                    }
                }
        }
    }
    
    private var registeredSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("전산 재고")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("(개비)")
                    .font(.caption2)
                    .foregroundColor(.purple)
                    .padding(.horizontal, 4)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(4)
            }
            
            HStack {
                TextField("전산 재고 (개비)", text: $registeredText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .registered(id: cigarette.id))
                    .onTapGesture {
                        if cigarette.registeredStock == 0 {
                            registeredText = ""
                        }
                    }
                    .onChange(of: registeredText) { _, newValue in
                        if let value = Int(newValue) {
                            cigarette.registeredStock = value
                        } else if newValue.isEmpty {
                            cigarette.registeredStock = 0
                        }
                    }
                    .onChange(of: focusedField) { _, newFocus in
                        if case .registered(let id) = newFocus, id == cigarette.id {
                            if cigarette.registeredStock == 0 {
                                registeredText = ""
                            }
                        } else if registeredText.isEmpty {
                            cigarette.registeredStock = 0
                        }
                    }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("차이: \(cigarette.difference)")
                        .font(.caption)
                        .foregroundColor(differenceColor)
                        .fontWeight(.medium)
                    
                    // 차이 설명
                    Text("창고+매대-전산")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    private var differenceColor: Color {
        if cigarette.difference == 0 {
            return .green
        } else if cigarette.difference > 0 {
            return .blue
        } else {
            return .red
        }
    }
} 