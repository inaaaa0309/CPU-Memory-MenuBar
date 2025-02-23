//
//  CPU_Memory_MenuBarApp.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import SwiftUI

@main
struct CPU_Memory_MenuBarApp: App {
    private let cpu = CPU()
    
    @ObservedObject private var shared = Observed.shared
    
    @State private var memoryInfo = MemoryInfo(used: 0, app: 0, wired: 0, compressed: 0)
    
    var body: some Scene {
        MenuBarExtra {
            CPUView()
        } label: {
            Label("\(String(format: "%.2f", shared.cpuCurrent.total))%", systemImage: "cpu")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        activateCPU()
                    }
                }
        }
        MenuBarExtra {
            MemoryView(memoryInfo: $memoryInfo)
        } label: {
            Label("\(String(format: "%.2f", decimal2double(decimal: memoryInfo.used)))GB", systemImage: "memorychip")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            if let memoryInfo_ = getMemoryUsage() {
                                memoryInfo = memoryInfo_
                            }
                        }
                    }
                }
        }
    }
    
    private func activateCPU() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            cpu.update()
            
            shared.cpuCurrent = cpu.current
        }
    }
}

struct MemoryInfo {
    var used: Decimal = 0
    var app: Decimal = 0
    var wired: Decimal = 0
    var compressed: Decimal = 0
    
    init(used: Decimal, app: Decimal, wired: Decimal, compressed: Decimal) {
        self.used = used
        self.app = app
        self.wired = wired
        self.compressed = compressed
    }
}

func decimal2double(decimal: Decimal) -> Double {
    return Double(truncating: decimal as NSNumber)
}
