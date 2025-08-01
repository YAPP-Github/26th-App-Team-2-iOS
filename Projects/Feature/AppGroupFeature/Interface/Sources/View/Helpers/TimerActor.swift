//
//  TimerActor.swift
//  FeatureAppGroupFeatureInterface
//
//  Created by Greem on 8/1/25.
//

import Foundation

public actor TimerActor {
    private var isRunning = false
    
    public func startTimer(
        until endDate: Date,
        onTick: @escaping (TimeInterval) async -> Void,
        onEnd: @escaping () async -> Void
    ) async {
        
        guard !isRunning else { return }
        isRunning = true
        
        let clock = ContinuousClock()
        
        while isRunning {
            let now = Date()
            let remaining = endDate.timeIntervalSince(now)
            
            if remaining <= 0 {
                isRunning = false
                await onTick(0)
                await onEnd()
                break
            }
            
            await onTick(remaining)
            try? await clock.sleep(for: .seconds(1))
        }
    }
    
    public func stop() {
        isRunning = false
    }
}

private let asyncStreamDouble: (Date) -> AsyncStream<Double> = { endDate in
    return AsyncStream { continuation in
        let clock = ContinuousClock()
        Task {
            var isRunning = true
            while isRunning {
                let now = Date()
                let remaining = endDate.timeIntervalSince(now)
                
                if remaining <= 0 {
                    isRunning = false
                    continuation.finish()
                    break
                }
                
                continuation.yield(remaining)
                try? await clock.sleep(for: .seconds(1))
            }
        }
    }
}

