//
//  AppDelegate.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2025/05/05.
//

import Foundation
import SwiftData
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @Environment(\.locale) private var locale
    
    var modelContainer: ModelContainer!
    var items: [Item] = []
    
    @Published var cpuInfo = CPUInfo() {
        didSet {
            updateCPUStatusItemTitle()
        }
    }
    
    @Published var memoryInfo = MemoryInfo() {
        didSet {
            updateMemoryStatusItemTitle()
        }
    }
    
    @Published var timer: Timer?
    @Published var timerInterval: TimeInterval = 1
    
    private var CPUStatusBarItem: NSStatusItem!
    private var memoryStatusBarItem: NSStatusItem!
    
    private var CPUPopover = NSPopover()
    private var memoryPopover = NSPopover()
    
    private let cpu = CPU()
    private let memory = Memory()
    
    private let monoFont = NSFont.monospacedSystemFont(ofSize: NSFont.menuFont(ofSize: 0).pointSize, weight: .regular)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        do {
            modelContainer = try ModelContainer(for: Item.self)
        } catch {
            fatalError("Failed to create model container: \(error)")
        }

        let context = ModelContext(modelContainer)
        
        do {
            items = try context.fetch(FetchDescriptor<Item>())
            timerInterval = items.first?.timerInterval ?? 1
        } catch {
            print("Failed to load the data: \(error)")
        }
        
        let contentView = ContentView()
            .frame(width: viewWidth())
            .environmentObject(self)
            .modelContainer(modelContainer)
        
        CPUPopover.behavior = .transient
        memoryPopover.behavior = .transient
        
        CPUPopover.contentViewController = NSHostingController(rootView: contentView)
        memoryPopover.contentViewController = NSHostingController(rootView: contentView)
        
        self.CPUStatusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        self.memoryStatusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        guard let CPUButton = self.CPUStatusBarItem.button else { return }
        guard let memoryButton = self.memoryStatusBarItem.button else { return }
        
        CPUButton.image = NSImage(systemSymbolName: "cpu", accessibilityDescription: nil)
        memoryButton.image = NSImage(systemSymbolName: "memorychip", accessibilityDescription: nil)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: monoFont
        ]
        
        let CPUAttrTitle = NSAttributedString(string: "00.00%", attributes: attributes)
        let memoryAttrTitle = NSAttributedString(string: "00.00GB", attributes: attributes)
        
        CPUButton.attributedTitle = CPUAttrTitle
        memoryButton.attributedTitle = memoryAttrTitle
        
        CPUButton.action = #selector(CPUMenuButtonAction(sender:))
        memoryButton.action = #selector(MemoryMenuButtonAction(sender:))
        
        self.cpuInfo = self.cpu.getCPU()
        if let memoryInfo_ = self.memory.getMemory() {
            self.memoryInfo = memoryInfo_
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { _ in
            self.cpuInfo = self.cpu.getCPU()
            if let memoryInfo_ = self.memory.getMemory() {
                self.memoryInfo = memoryInfo_
            }
        }
    }
    
    @objc func CPUMenuButtonAction(sender: AnyObject) {
        guard let button = self.CPUStatusBarItem.button else { return }
        if self.CPUPopover.isShown {
            self.CPUPopover.performClose(sender)
        } else {
            self.CPUPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.CPUPopover.contentViewController?.view.window?.makeKey()
        }
    }
    
    @objc func MemoryMenuButtonAction(sender: AnyObject) {
        guard let button = self.memoryStatusBarItem.button else { return }
        if self.memoryPopover.isShown {
            self.memoryPopover.performClose(sender)
        } else {
            self.memoryPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.memoryPopover.contentViewController?.view.window?.makeKey()
        }
    }
    
    private func updateCPUStatusItemTitle() {
        if let button = CPUStatusBarItem.button {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: monoFont
            ]
            let attrTitle = NSAttributedString(string: "\(String(format: "%5.2f", Decimal2Double(decimal: cpuInfo.used)))%", attributes: attributes)
            button.attributedTitle = attrTitle
        }
    }
    
    private func updateMemoryStatusItemTitle() {
        if let button = memoryStatusBarItem.button {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: monoFont
            ]
            let attrTitle = NSAttributedString(string: "\(String(format: "%5.2f", Decimal2Double(decimal: memoryInfo.used)))GB", attributes: attributes)
            button.attributedTitle = attrTitle
        }
    }
    
    private func viewWidth() -> CGFloat {
        let languageCode = locale.language.languageCode
        
        switch languageCode {
        case "ar":
            return 240
        case "zh":
            return 240
        case "fr":
            return 260
        case "hi":
            return 240
        case "ja":
            return 240
        case "pt":
            return 260
        case "ru":
            return 290
        case "es":
            return 260
        default:
            return 240
        }
    }
}

func Decimal2Double(decimal: Decimal) -> Double {
    return (decimal as NSNumber).doubleValue
}
