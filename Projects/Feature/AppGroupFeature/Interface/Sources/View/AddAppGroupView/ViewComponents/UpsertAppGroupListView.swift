//
//  AddAppGroupListView.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 7/29/25.
//

import SwiftUI
import ManagedSettings
import SharedDesignSystem


extension UpsertAppGroupView {
    struct UpsertAppGroupListView: View {
        @Environment(UpsertAppGroupViewModel.self) var addAppGroupViewModel
        
        var body: some View {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [Color.grey900, Color.clear], startPoint: .bottom, endPoint: .top)
                    .frame(height: 40)
                    .allowsHitTesting(false)
                
                ZStack(alignment: .bottom) {
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(addAppGroupViewModel.applicationTokens, id: \.hashValue) { applicationToken in
                                HStack {
                                    HStack(spacing: 0) {
                                        Label(applicationToken).labelStyle(.iconOnly)
                                            .scaleEffect(1.2)
                                        Label(applicationToken)
                                            .labelStyle(.titleOnly)
                                            .scaleEffect(0.8)
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Button {
                                        self.addAppGroupViewModel.deleteApplicationBtnTapped(applicationToken: applicationToken)
                                    } label: {
                                        Image.iconThickCancel
                                            .foregroundStyle(Color.grey300)
                                            .frame(width: 24, height: 24)
                                    }
                                    .contentShape(Rectangle())
                                    .buttonStyle(.plain)
                                }
                                .padding(.trailing, 12)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 7.5)
                            }
                        }
                    }
                }
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

struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(.orange)
            configuration.title
                .foregroundColor(.green)
        }
    }
}
