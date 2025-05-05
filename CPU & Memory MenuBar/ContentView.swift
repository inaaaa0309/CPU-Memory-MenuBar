//
//  ContentView.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2025/02/24.
//

import ServiceManagement
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @EnvironmentObject private var delegate: AppDelegate
    
    @Environment(\.locale) private var locale
    
    @StateObject private var launchState = LaunchState()
    
    private let monoFont = Font(NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular))
    
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
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.cpuInfo.system)))%")
                            .font(monoFont)
                    }
                    HStack {
                        Text("User:")
                        Spacer()
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.cpuInfo.user)))%")
                            .font(monoFont)
                    }
                    HStack {
                        Text("Idle:")
                        Spacer()
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.cpuInfo.idle)))%")
                            .font(monoFont)
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
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.memoryInfo.app)))GB")
                            .font(monoFont)
                    }
                    HStack {
                        Text("Wired Memory:")
                        Spacer()
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.memoryInfo.wired)))GB")
                            .font(monoFont)
                    }
                    HStack {
                        Text("Compressed:")
                        Spacer()
                        Text("\(String(format: "%.2f", Decimal2Double(decimal: delegate.memoryInfo.compressed)))GB")
                            .font(monoFont)
                    }
                }
                .padding(5)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("rectangle"))
                    .frame(width: rectangleWidth(), height: rectangleHeight())
                VStack {
                    HStack {
                        VStack {
                            Text("Display Interval: \(delegate.timerInterval, specifier: "%.0f") seconds")
                                .font(.callout)
                                .multilineTextAlignment(.center)
                            Slider(value: $delegate.timerInterval, in: 1...30, step: 1) {
                            } minimumValueLabel: {
                                Text("1")
                            } maximumValueLabel: {
                                Text("30")
                            }
                        }
                        Button("Apply") {
                            delegate.timer?.invalidate()
                            delegate.timer = Timer.scheduledTimer(withTimeInterval: delegate.timerInterval, repeats: true) { _ in
                                delegate.cpuInfo = cpu.getCPU()
                                if let memoryInfo_ = memory.getMemory() {
                                    delegate.memoryInfo = memoryInfo_
                                }
                            }
                            
                            if items.count == 0 {
                                withAnimation {
                                    let newItem = Item(timerIntarval: delegate.timerInterval)
                                    modelContext.insert(newItem)
                                }
                            } else {
                                items[0].timerInterval = delegate.timerInterval
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
                            delegate.timer?.invalidate()
                            delegate.timer = nil
                            
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
    
    private func rectangleHeight() -> CGFloat {
        let languageCode = locale.language.languageCode
        
        switch languageCode {
        case "fr":
            return 130
        case "pt":
            return 130
        case "ru":
            return 130
        case "es":
            return 130
        default:
            return 110
        }
    }
}
