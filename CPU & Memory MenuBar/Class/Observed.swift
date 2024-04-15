//
//  Observed.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import Foundation

class Observed: ObservableObject {
    static let shared = Observed()
    
    @Published var cpuCurrent: CPUInfo = CPUInfo()
    @Published var memoryCurrent: MemoryInfo = MemoryInfo()
}
