//
//  MemoryView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import SwiftUI

struct MemoryView: View {
    @StateObject private var state = State()
    
    @ObservedObject private var shared = Observed.shared
    
    var body: some View {
        VStack {
            Text("App Memory:\(String(shared.memoryCurrent.app))GB")
            Text("Wired Memory:\(String(shared.memoryCurrent.wired))GB")
            Text("Compressed:\(String(shared.memoryCurrent.compressed))GB")
            Divider()
            Toggle("Launch at login", isOn: Binding<Bool>(
                get: { state.launchAtLogin },
                set: { state.toggleLaunchAtLogin($0) }
            ))
            Button("Quit") {
                NSApp.terminate(nil)
            }
        }
    }
}

#Preview {
    MemoryView()
}
