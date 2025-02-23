//
//  MemoryView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import Foundation
import ServiceManagement
import SwiftUI

struct MemoryView: View {
    @Binding var memoryInfo: MemoryInfo
    
    @StateObject private var launchState = LaunchState()
    
    var body: some View {
        VStack {
            Text("App Memory:\(String(describing: memoryInfo.app))GB")
            Text("Wired Memory:\(String(describing: memoryInfo.wired))GB")
            Text("Compressed:\(String(describing: memoryInfo.compressed))GB")
            Divider()
            Toggle("Launch at login", isOn: Binding<Bool>(
                get: { SMAppService.mainApp.status == .enabled },
                set: { launchState.toggleLaunchAtLogin($0) }
            ))
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
    }
}
