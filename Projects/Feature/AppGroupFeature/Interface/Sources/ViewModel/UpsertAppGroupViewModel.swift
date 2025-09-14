//
//  UpsertAppGroupViewModel.swift
//  FeatureAppGroupFeature
//
//  Created by Greem on 7/28/25.
//

import Foundation
import FamilyControls
import ManagedSettings
import Domain
import Core

@Observable
public final class UpsertAppGroupViewModel {
    // MARK: - Properties
    var appGroupName: String = ""
    var selectionPresent: Bool = false
    var deleteConfirmPresent: Bool = false
    var dismiss: Bool = false
    let blockScheduleManager = BlockScheduleManager()
    var applicationTokens: [ApplicationToken] { newSelection.applicationTokens.map { $0 } }
    
    private(set) var newSelection = FamilyActivitySelection(includeEntireCategory: true)
    let upsertCompletion: (AppGroup) -> ()
    let deleteCompletion: ((AppGroup) -> ())?
    let isCreating: Bool
    
    // MARK: - Private Properties
    private let fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol
    private let createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol
    private let deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol
    private let upsertAppGroupUseCase: UpsertAppGroupUseCase
    private let deleteAppGroupUseCase: DeleteAppGroupUseCase?
    private let appGroup: AppGroup?
    
    
    
    // MARK: - Initialization
    public init(
        appGroup: AppGroup? = nil,
        fetchBlockScheduleUseCase: FetchBlockScheduleUseCaseProtocol,
        createBlockScheduleUseCase: CreateBlockScheduleUseCaseProtocol,
        deleteBlockScheduleUseCase: DeleteBlockScheduleUseCaseProtocol,
        upsertAppGroupUseCase: UpsertAppGroupUseCase,
        upsertCompletion: @escaping (AppGroup) -> (),
        deleteAppGroupUseCase: DeleteAppGroupUseCase? = nil,
        deleteCompletion: ((AppGroup) -> ())? = nil
    ) {
        if let appGroup = appGroup {
            self.newSelection = appGroup.selection
            self.appGroupName = appGroup.name
        }
        self.isCreating = (appGroup == nil)
        self.appGroup = appGroup
        self.fetchBlockScheduleUseCase = fetchBlockScheduleUseCase
        self.createBlockScheduleUseCase = createBlockScheduleUseCase
        self.deleteBlockScheduleUseCase = deleteBlockScheduleUseCase
        self.upsertAppGroupUseCase = upsertAppGroupUseCase
        self.upsertCompletion = upsertCompletion
        self.deleteAppGroupUseCase = deleteAppGroupUseCase
        self.deleteCompletion = deleteCompletion
        let blocks = blockScheduleManager.readAll()
        blocks.forEach { scheudle in
            blockScheduleManager.delete(scheudle)
        }
    }
    
    // MARK: - Public Methods
    public func setAppGroupName(_ name: String) {
        self.appGroupName = String(name.prefix(10))
    }
    
    // MARK: Selection Management
    public func selectionBtnTapped() {
        selectionPresent.toggle()
    }
    
    public func updateSelection(_ selection: FamilyActivitySelection) {
        self.newSelection = selection
    }
    
    public func deleteApplicationBtnTapped(applicationToken: ApplicationToken) {
        self.newSelection.applicationTokens.remove(applicationToken)
    }
    
    // MARK: App Group Management
    public func upsertCompleteBtnTapped() {
        Task {
            do {
                // 기존에 존재하는 앱 그룹의 경우... Blocking하는 것을 명시적으로 제거
                if let appGroup,
                   let scheduleEntity = fetchBlockScheduleUseCase.execute(groupTitle: "\(appGroup.name)") {
                    print("기존 앱 그룹 존재함... blockScheduleEntity 삭제")
                    deleteBlockScheduleUseCase.execute(schedule: scheduleEntity)
                }
                
                
                let newAppGroup = if let appGroup {
                    try await upsertAppGroupUseCase.execute(
                        appGroupID: appGroup.groupID,
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                } else {
                    try await upsertAppGroupUseCase.execute(
                        groupName: appGroupName,
                        activitySelection: newSelection
                    )
                }
                
                let blockScheduleEntity = BlockScheduleEntity(
                    id: "\(newAppGroup.groupID)",
                    title: newAppGroup.name,
                    blockList: newAppGroup.selection,
                    startTime: .init(hour: 00, minute: 00),
                    endTime: .init(hour: 23, minute: 59)
                )
                try createBlockScheduleUseCase.execute(schedule: blockScheduleEntity)
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    upsertCompletion(newAppGroup)
                }
            } catch {
                assertionFailure("Upsert 실패: \(error)")
            }
        }
    }
    
    // MARK: Delete Management
    public func deleteGroupBtnTapped() {
        self.deleteConfirmPresent = true
    }
    
    public func deleteConfirmBtnTapped() {
        Task {
            guard let appGroup, let deleteAppGroupUseCase, let deleteCompletion else { return }
            guard let scheduleEntity = fetchBlockScheduleUseCase.execute(groupTitle: "\(appGroup.name)") else {
                assertionFailure("현재 제거할 실드 대상이 없다.")
                return
            }
            deleteBlockScheduleUseCase.execute(schedule: scheduleEntity)
            
            do {
                try await deleteAppGroupUseCase.execute(appGroupID: appGroup.groupID)
            } catch {
                assertionFailure("Failed to delete app group: \(error)")
            }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                self.deleteConfirmPresent = false
                deleteCompletion(appGroup)
                dismiss = true
            }
        }
    }
}
