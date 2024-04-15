//
//  State.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import ServiceManagement

class State: ObservableObject {
    @Published var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled

    init() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.launchAtLogin = SMAppService.mainApp.status == .enabled
        }
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
    }
}
