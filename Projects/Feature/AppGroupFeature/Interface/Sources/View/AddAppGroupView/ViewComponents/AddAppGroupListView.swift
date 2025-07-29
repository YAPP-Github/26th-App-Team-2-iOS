//
//  AddAppGroupListView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import ManagedSettings
import SharedDesignSystem


extension AddAppGroupView {
    struct AddAppGroupListView: View {
        @Environment(UpsertAppGroupViewModel.self) var addAppGroupViewModel
        
        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [Color.grey900, Color.clear], startPoint: .bottom, endPoint: .top)
                    .frame(height: 40)
                    .allowsHitTesting(false)
                
                ZStack(alignment: .bottom) {
                    List(addAppGroupViewModel.applicationTokens, id: \.hashValue) { applicationToken in
                        HStack {
                            Label(applicationToken)
                                .font(.pretendard(size: 16, type: .medium))
                            Spacer()
                            Button {
                                print("탭탭탭 xmark")
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 11, height: 11)
                                    .foregroundStyle(Color.grey300)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.trailing, 12)
                        .listRowInsets(.init(top: 8, leading: 7.5, bottom: 8, trailing: 7.5))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.grey850)
                    }
                }
                .selectionDisabled()
                .listStyle(.plain)
                .safeAreaPadding(.top, 16)
                .safeAreaPadding(.horizontal, 16)
                .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
                    Button(
                        action: {
                            addAppGroupViewModel.selectionBtnTapped()
                        },
                        label: {
                            HStack {
                                Spacer()
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                    Text("추가")
                                }
                                .tint(Color.grey00)
                                Spacer()
                            }
                            .frame(height: 45)
                            .background(Color.grey800)
                            .cornerRadius(12)
                        }
                    )
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                    .background(Color.grey850)
                    .cornerRadius(8)
                }
                .background(content: {
                    RoundedRectangle(cornerRadius: 8).fill(Color.grey850)
                })
            }
        }
    }
}
