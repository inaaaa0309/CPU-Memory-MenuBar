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
    
    @State private var timerInterval: TimeInterval = 1
    
    @Environment(\.locale) private var locale
    
    private let cpu = CPU()
    private let memory = Memory()
    
    var body: some Scene {
        MenuBarExtra {
            ContentView(cpuInfo: $cpuInfo, memoryInfo: $memoryInfo, cpuTimer: $cpuTimer, memoryTimer: $memoryTimer, timerInterval: $timerInterval)
                .frame(width: viewWidth())
        } label: {
            Label("\(String(describing: cpuInfo.used))%", systemImage: "cpu")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        cpuTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
                            cpuInfo = cpu.getCPU()
                        }
                    }
                }
        }
        .menuBarExtraStyle(.window)
        MenuBarExtra {
            ContentView(cpuInfo: $cpuInfo, memoryInfo: $memoryInfo, cpuTimer: $cpuTimer, memoryTimer: $memoryTimer, timerInterval: $timerInterval)
                .frame(width: viewWidth())
        } label: {
            Label("\(String(describing: memoryInfo.used))GB", systemImage: "memorychip")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        memoryTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
                            if let memoryInfo_ = memory.getMemory() {
                                memoryInfo = memoryInfo_
                            }
                        }
                    }
                }
        }
        .menuBarExtraStyle(.window)
    }
    
    private func viewWidth() -> CGFloat {
        let languageCode = locale.language.languageCode
        
        switch languageCode {
        case "ar":
            return 240
        case "zh":
            return 240
        case "fr":
            return 260
        case "hi":
            return 240
        case "ja":
            return 240
        case "pt":
            return 260
        case "ru":
            return 290
        case "es":
            return 260
        default:
            return 240
        }
    }
}

func Decimal2Double(decimal: Decimal) -> Double {
    return (decimal as NSNumber).doubleValue
}
