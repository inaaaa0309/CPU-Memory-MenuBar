//
//  State.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import ServiceManagement

final class LaunchState: ObservableObject {
    final func toggleLaunchAtLogin(_ isOn: Bool) {
        do {
            if isOn {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
