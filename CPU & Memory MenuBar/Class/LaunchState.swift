//
//  State.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import ServiceManagement

class LaunchState: ObservableObject {
    @Published var launchAtLogin: Bool
    
    init() {
        launchAtLogin = SMAppService.mainApp.status == .enabled
    }
    
    func toggleLaunchAtLogin(_ isOn: Bool) {
        do {
            if isOn {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print(error.localizedDescription)
        }
        launchAtLogin = SMAppService.mainApp.status == .enabled
    }
}
