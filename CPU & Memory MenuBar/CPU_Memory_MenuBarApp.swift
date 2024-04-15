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
    private let memory = Memory()
    
    @ObservedObject private var shared = Observed.shared
    
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
            MemoryView()
        } label: {
            Label("\(String(format: "%.2f", shared.memoryCurrent.total))GB", systemImage: "memorychip")
                .labelStyle(.titleAndIcon)
                .onAppear() {
                    DispatchQueue.main.async {
                        activateMemory()
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
    
    private func activateMemory() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            memory.update()
            
            shared.memoryCurrent = memory.current
        }
    }
}
