//
//  AddAppGroupView.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/27/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

@Observable
public final class AddAppGroupViewModel {
    
    var newSelection: FamilyActivitySelection = .init()
    var selectionPresent: Bool = false
    var applicationTokens: [ApplicationToken] { newSelection.applicationTokens.map { $0 } }
    public init() {
        
    }
    
    public func selectionBtnTapped() {
        selectionPresent.toggle()
    }
    
    public func updateSelection(_ selection: FamilyActivitySelection) {
        print("받은 selection: \(selection)")
        self.newSelection = selection
    }
    
}

public struct AddAppGroupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AddAppGroupViewModel.self) var addAppGroupViewModel
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 20) {
            Button {
                addAppGroupViewModel.selectionBtnTapped()
            } label: {
                Text("사용을 자제할 앱을 선택해주세요.")
            }
            VStack{
                Text("목록: \(addAppGroupViewModel.applicationTokens.count)개")
                HStack {
                    ForEach(addAppGroupViewModel.applicationTokens, id: \.hashValue) { applicationToken in
                        Label(applicationToken).labelStyle(.iconOnly)
                    }
                }.background(.green)
                ZStack(alignment: .bottom) {
                    List(addAppGroupViewModel.applicationTokens, id: \.hashValue) { applicationToken in
                        HStack {
                            Label(applicationToken)
                            Spacer()
                            Button {
                                print("탭탭탭 xmark")
                            } label: {
                                Image(systemName: "xmark")
                                    .background(.blue)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Color.gray
                        )
                    }
                    
                    // 그라데이션 오버레이 - 포인터 이벤트 무시
                    LinearGradient(colors: [Color.black, Color.clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 40)
                        .allowsHitTesting(false)
                }
                .selectionDisabled()
                .listStyle(.plain)
                .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                    Button {
                        
                    } label: {
                        HStack {
                            Spacer()
                            Text("추가")
                            Spacer()
                        }.background(.red)
                    }
                }
                .background(content: {
                    RoundedRectangle(cornerRadius: 8).fill(Color.gray)
                })
                .frame(height: 340)
                .padding(.horizontal)
                
            }
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("닫기")
                }
            }
        }
    }
}

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
            VStack {
                VStack {
                    Text("사용을 자제할 앱을 선택해주세요")
                    Text("\(selection.applications.count)개")
                }
                
                FamilyActivityPicker(selection: $selection)
                
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("닫기")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.selectCompletion(selection)
                        dismiss()
                    } label: {
                        Text("선택 완료")
                    }
                }
            }
        }
    }
}
