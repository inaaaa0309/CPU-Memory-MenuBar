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
    
    @Binding var timerInterval: TimeInterval
    
    @Environment(\.locale) private var locale
    
    @StateObject private var launchState = LaunchState()
    
    private let cpu = CPU()
    private let memory = Memory()
    
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
                        Text("\(String(describing: cpuInfo.system))%")
                    }
                    HStack {
                        Text("User:")
                        Spacer()
                        Text("\(String(describing: cpuInfo.user))%")
                    }
                    HStack {
                        Text("Idle:")
                        Spacer()
                        Text("\(String(describing: cpuInfo.idle))%")
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
                        Text("\(String(describing: memoryInfo.app))GB")
                    }
                    HStack {
                        Text("Wired Memory:")
                        Spacer()
                        Text("\(String(describing: memoryInfo.wired))GB")
                    }
                    HStack {
                        Text("Compressed:")
                        Spacer()
                        Text("\(String(describing: memoryInfo.compressed))GB")
                    }
                }
                .padding(5)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("rectangle"))
                    .frame(width: rectangleWidth(), height: 110)
                VStack {
                    HStack {
                        VStack {
                            Text("Display Interval: \(timerInterval, specifier: "%.0f") seconds")
                                .font(.callout)
                                .multilineTextAlignment(.center)
                            Slider(value: $timerInterval, in: 1...30, step: 1) {
                            } minimumValueLabel: {
                                Text("1")
                            } maximumValueLabel: {
                                Text("30")
                            }
                        }
                        Button("Apply") {
                            cpuTimer?.invalidate()
                            memoryTimer?.invalidate()
                            DispatchQueue.main.async {
                                cpuTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
                                    cpuInfo = cpu.getCPU()
                                }
                                memoryTimer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
                                    if let memoryInfo_ = memory.getMemory() {
                                        memoryInfo = memoryInfo_
                                    }
                                }
                            }
                        }
                    }
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
            return 230
        case "zh":
            return 230
        case "fr":
            return 250
        case "hi":
            return 230
        case "ja":
            return 230
        case "pt":
            return 250
        case "ru":
            return 280
        case "es":
            return 250
        default:
            return 230
        }
    }
}
