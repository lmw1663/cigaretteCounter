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
        storefrontText = cigarette.storefrontStock == 0 ? "" : "\(cigarette.storefrontStock)"
        warehouseText = cigarette.warehouseStock == 0 ? "" : "\(cigarette.warehouseStock)"
        registeredText = cigarette.registeredStock == 0 ? "" : "\(cigarette.registeredStock)"
    }
    
    private var storefrontSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("매대")
                .font(.caption)
                .foregroundColor(.secondary)
            TextField("매대 수량", text: $storefrontText)
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
            Text("창고")
                .font(.caption)
                .foregroundColor(.secondary)
            TextField("창고 수량", text: $warehouseText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .warehouse(id: cigarette.id))
                .onTapGesture {
                    if cigarette.warehouseStock == 0 {
                        warehouseText = ""
                    }
                }
                .onChange(of: warehouseText) { _, newValue in
                    if let value = Int(newValue) {
                        cigarette.warehouseStock = value
                    } else if newValue.isEmpty {
                        cigarette.warehouseStock = 0
                    }
                }
                .onChange(of: focusedField) { _, newFocus in
                    if case .warehouse(let id) = newFocus, id == cigarette.id {
                        if cigarette.warehouseStock == 0 {
                            warehouseText = ""
                        }
                    } else if warehouseText.isEmpty {
                        cigarette.warehouseStock = 0
                    }
                }
        }
    }
    
    private var registeredSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("전산 재고")
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                TextField("전산 재고", text: $registeredText)
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
                
                Text("차이: \(cigarette.difference)")
                    .font(.caption)
                    .foregroundColor(differenceColor)
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