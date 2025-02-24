//
//  CPUView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import ServiceManagement
import SwiftUI

struct CPUView: View {
    @Binding var cpuInfo: CPUInfo
    @Binding var timer: Timer?
    
    @StateObject private var launchState = LaunchState()
    
    var body: some View {
        VStack {
            Text("System:\(String(describing: cpuInfo.system))%")
            Text("User:\(String(describing: cpuInfo.user))%")
            Text("Idle:\(String(describing: cpuInfo.idle))%")
            Divider()
            Toggle("Launch at login", isOn: Binding<Bool>(
                get: { SMAppService.mainApp.status == .enabled },
                set: { launchState.toggleLaunchAtLogin($0) }
            ))
            Button("Quit") {
                timer?.invalidate()
                timer = nil
                NSApp.terminate(nil)
            }
        }
    }
}
