//
//  FamilyActivitySelectionPickerView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import SwiftUI

public struct FamilyActivitySelectionPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection: FamilyActivitySelection
    private let selectCompletion: (FamilyActivitySelection) -> Void
    
    public init(
        selection: FamilyActivitySelection? = nil,
        selectCompletion: @escaping (FamilyActivitySelection) -> Void
    ) {
        self.selection = selection ?? .init()
        self.selectCompletion = selectCompletion
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("사용을 자제할 앱을 선택해주세요")
                        .font(.pretendard(size: 14, type: .medium))
                        .foregroundStyle(Color.grey00)
                    Text("\(selection.applications.count)개")
                        .font(.pretendard(size: 16, type: .medium))
                        .foregroundStyle(Color.grey00)
                }
                
                FamilyActivityPicker(selection: $selection)
                    .colorScheme(.dark)
                
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(Color.grey00)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.selectCompletion(selection)
                        dismiss()
                    } label: {
                        Text("선택 완료")
                    }
                    .tint(Color.grey00)
                }
            }
            .background(Color.grey900)
        }
    }
}
