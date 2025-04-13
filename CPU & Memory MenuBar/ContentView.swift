//
//  ContentView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2025/02/24.
//

import ServiceManagement
import SwiftUI

struct ContentView: View {
    @Binding var cpuInfo: CPUInfo
    @Binding var memoryInfo: MemoryInfo
    
    @Binding var cpuTimer: Timer?
    @Binding var memoryTimer: Timer?
    
    @Environment(\.locale) private var locale
    
    @StateObject private var launchState = LaunchState()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("rectangle"))
                    .frame(width: rectangleWidth(), height: 70)
                VStack {
                    HStack {
                        Text("System:")
                        Spacer()
                        //Text("\(String(describing: cpuInfo.system))%")
                        Text("99.99%")
                    }
                    HStack {
                        Text("User:")
                        Spacer()
                        //Text("\(String(describing: cpuInfo.user))%")
                        Text("99.99%")
                    }
                    HStack {
                        Text("Idle:")
                        Spacer()
                        //Text("\(String(describing: cpuInfo.idle))%")
                        Text("99.99%")
                    }
                }
                .padding(5)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("rectangle"))
                    .frame(width: rectangleWidth(), height: 70)
                VStack {
                    HStack {
                        Text("App Memory:")
                        Spacer()
                        //Text("\(String(describing: memoryInfo.app))GB")
                        Text("15.99GB")
                    }
                    HStack {
                        Text("Wired Memory:")
                        Spacer()
                        //Text("\(String(describing: memoryInfo.wired))GB")
                        Text("15.99GB")
                    }
                    HStack {
                        Text("Compressed:")
                        Spacer()
                        //Text("\(String(describing: memoryInfo.compressed))GB")
                        Text("15.99GB")
                    }
                }
                .padding(5)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("rectangle"))
                    .frame(width: rectangleWidth(), height: 50)
                HStack {
                    VStack {
                        Toggle("", isOn: Binding<Bool>(
                            get: { SMAppService.mainApp.status == .enabled },
                            set: { launchState.toggleLaunchAtLogin($0) }
                        ))
                        .toggleStyle(.switch)
                        Text("Launch at login")
                            .font(.caption2)
                    }
                    Button {
                        cpuTimer?.invalidate()
                        memoryTimer?.invalidate()
                        cpuTimer = nil
                        memoryTimer = nil
                        
                        NSApp.terminate(nil)
                    } label: {
                        VStack {
                            Image(systemName: "power.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                            Text("Quit")
                                .font(.caption2)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(5)
            }
        }
        .padding()
    }
    
    private func rectangleWidth() -> CGFloat {
        let languageCode = locale.language.languageCode
        
        switch languageCode {
        case "ar":
            return 180
        case "zh":
            return 190
        case "fr":
            return 250
        case "hi":
            return 170
        case "ja":
            return 220
        case "pt":
            return 250
        case "ru":
            return 280
        case "es":
            return 250
        default:
            return 190
        }
    }
}
