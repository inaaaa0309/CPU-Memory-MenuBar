//
//  CPUView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import ServiceManagement
import SwiftUI

struct CPUView: View {
    @StateObject private var state = State()
    
    @ObservedObject private var shared = Observed.shared
    
    var body: some View {
        VStack {
            Text("System:\(String(shared.cpuCurrent.system))%")
            Text("User:\(String(shared.cpuCurrent.user))%")
            Text("Idle:\(String(shared.cpuCurrent.idle))%")
            Divider()
            Toggle("Launch at login", isOn: Binding<Bool>(
                get: { SMAppService.mainApp.status == .enabled },
                set: { state.toggleLaunchAtLogin($0) }
            ))
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
    }
}

#Preview {
    CPUView()
}
