//
//  CPU_Memory_MenuBarApp.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import Foundation
import SwiftUI

@main
struct CPU_Memory_MenuBarApp: App {
    @State private var cpuInfo = CPUInfo()
    @State private var memoryInfo = MemoryInfo()
    
    @State private var cpuTimer: Timer?
    @State private var memoryTimer: Timer?
    
    private let cpu = CPU()
    private let memory = Memory()
    
    var body: some Scene {
        MenuBarExtra {
            CPUView(cpuInfo: $cpuInfo, timer: $cpuTimer)
        } label: {
            Label("\(String(describing: cpuInfo.used))%", systemImage: "cpu")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        cpuTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            cpuInfo = cpu.getCPU()
                        }
                    }
                }
        }
        MenuBarExtra {
            MemoryView(memoryInfo: $memoryInfo, timer: $memoryTimer)
        } label: {
            Label("\(String(describing: memoryInfo.used))GB", systemImage: "memorychip")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        memoryTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            if let memoryInfo_ = memory.getMemory() {
                                memoryInfo = memoryInfo_
                            }
                        }
                    }
                }
        }
    }
}

func Decimal2Double(decimal: Decimal) -> Double {
    return (decimal as NSNumber).doubleValue
}
