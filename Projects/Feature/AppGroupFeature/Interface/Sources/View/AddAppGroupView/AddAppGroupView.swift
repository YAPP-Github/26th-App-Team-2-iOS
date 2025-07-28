//
//  AddAppGroupView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import Domain
import Shared
import FamilyControls
import DeviceActivity
import ManagedSettings

public struct AddAppGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AddAppGroupViewModel.self) var addAppGroupViewModel
    @State private var tempText = ""
    @FocusState private var isFocused: Bool
    
    public init() { }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            Color.grey900.edgesIgnoringSafeArea(.all)
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = false
                }
            
            VStack(spacing: 0) {
                AddAppGroupNavigationView {
                    dismiss()
                }
                
                Color.clear.frame(height: 16)
                
                VStack(spacing: 8) {
                    AddAppGroupSectionHeaderView(
                        title: "그룹명:",
                        highlightDesc: "\(tempText.count)",
                        description: "/10"
                    )
                    
                    BrakeTextFieldView(
                        text: $tempText,
                        placeholder: "ex) SNS",
                        backgroundColor: .grey850,
                        textColor: .brakeWhite,
                        placeholderColor: .grey700,
                        cornerRadius: 16
                    )
                    .focused($isFocused)
                }
                .padding(.horizontal, 16)
                
                Color.clear.frame(height: 24)
                
                VStack(spacing: 8) {
                    AddAppGroupSectionHeaderView(
                        title: "목록:",
                        highlightDesc: "\(addAppGroupViewModel.applicationTokens.count)",
                        description: "개"
                    )
                    
                    Group {
                        if addAppGroupViewModel.applicationTokens.isEmpty {
                            AddAppGroupListEmptyView()
                        } else {
                            AddAppGroupListView()
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
                .padding(.horizontal, 16)
                .onTapGesture {
                    self.isFocused = false
                }
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            
            bottomButtonView
                .padding(.bottom, 10)
        }
        .sheet(
            isPresented: Binding(
                get: { addAppGroupViewModel.selectionPresent },
                set: { addAppGroupViewModel.selectionPresent = $0 }),
            content: {
                FamilyActivitySelectionPickerView(
                    selection: addAppGroupViewModel.newSelection
                ) { selection in
                    addAppGroupViewModel.updateSelection(selection)
                }
            }
        )
        .toolbar(.hidden, for: .navigationBar)
    }
}

extension AddAppGroupView {
    @ViewBuilder var bottomButtonView: some View {
        VStack(spacing: 22) {
            if !addAppGroupViewModel.applicationTokens.isEmpty && !isFocused {
                Button {
                    
                } label: {
                    HStack(spacing: 1.5) {
                        Image.iconTrash
                        Text("그룹 삭제")
                            .font(.pretendard(size: 14, type: .medium))
                            .foregroundStyle(Color.grey300)
                            .underline()
                    }
                }
            }
            
            LargeButtonView(
                buttonType: .confirm,
                title: "완료",
                isActive: !addAppGroupViewModel.applicationTokens.isEmpty
            ) {
                addAppGroupViewModel.addBtnTapped()
            }
            .padding(.horizontal, 16)
        }
    }
}


