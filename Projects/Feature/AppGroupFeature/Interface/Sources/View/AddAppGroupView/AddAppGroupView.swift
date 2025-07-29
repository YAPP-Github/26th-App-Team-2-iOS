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
    @Environment(UpsertAppGroupViewModel.self) var addAppGroupViewModel
    @FocusState private var isFocused: Bool
    
    public init() { }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.grey900.edgesIgnoringSafeArea(.all)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isFocused = false
                    }
                
                VStack(spacing: 0) {
                    UpsertAppGroupNavigationView(isCreating: addAppGroupViewModel.isCreating) {
                        dismiss()
                    }
                    
                    Color.clear.frame(height: 16)
                    
                    VStack(spacing: 8) {
                        @Bindable var viewModel = addAppGroupViewModel
                        AddAppGroupSectionHeaderView(
                            title: "그룹명:",
                            highlightDesc: "\(addAppGroupViewModel.appGroupName.count)",
                            description: "/10"
                        )
                        
                        BrakeTextFieldView(
                            text: $viewModel.appGroupName,
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
            .toolbar(.hidden, for: .navigationBar)
        }
        .onChange(of: addAppGroupViewModel.dismiss, { oldValue, newValue in
            if newValue {
                isFocused = false
                self.dismiss()
            }
        })
        .alert(
            "삭제하기",
            isPresented: Binding(
                get: { addAppGroupViewModel.deleteConfirmPresent },
                set: { addAppGroupViewModel.deleteConfirmPresent = $0 }
               ),
               actions: {
                   Button("취소", role: .cancel) { }
                   Button("확인") {
                       addAppGroupViewModel.deleteConfirmBtnTapped()
                   }
               }
        )
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
    }
}

extension AddAppGroupView {
    @ViewBuilder var bottomButtonView: some View {
        VStack(spacing: 22) {
            if !addAppGroupViewModel.isCreating && !isFocused {
                Button {
                    self.addAppGroupViewModel.deleteGroupBtnTapped()
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
                isActive: !addAppGroupViewModel.applicationTokens.isEmpty && !addAppGroupViewModel.appGroupName.isEmpty
            ) {
                addAppGroupViewModel.upsertCompleteBtnTapped()
            }
            .padding(.horizontal, 16)
        }
    }
}


