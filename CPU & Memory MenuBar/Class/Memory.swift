//
//  Memory.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import Darwin

public struct MemoryInfo {
    public var total: Double = 0.0
    public var app: Double = 0.0
    public var wired: Double = 0.0
    public var compressed: Double = 0.0
    
    init() {}
    
    init(
        total: Double,
        app: Double,
        wired: Double,
        compressed: Double
    ) {
        self.total = total
        self.app = app
        self.wired = wired
        self.compressed = compressed
    }
}

final public class Memory {
    public internal(set) var current = MemoryInfo()
    
    private let gigaByte: Double = 1_073_741_824 // 2^30
    private let hostVmInfo64Count: mach_msg_type_number_t!
    private let hostBasicInfoCount: mach_msg_type_number_t!
    
    init() {
        hostVmInfo64Count = UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        hostBasicInfoCount = UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
    }
    
    private var maxMemory: Double {
        var size: mach_msg_type_number_t = hostBasicInfoCount
        let hostInfo = host_basic_info_t.allocate(capacity: 1)
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int()) { (pointer) -> kern_return_t in
            return host_info(mach_host_self(), HOST_BASIC_INFO, pointer, &size)
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
        return Double(data.max_mem) / gigaByte
    }
    
    private var vmStatistics64: vm_statistics64 {
        var size: mach_msg_type_number_t = hostVmInfo64Count
        let hostInfo = vm_statistics64_t.allocate(capacity: 1)
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) { (pointer) -> kern_return_t in
            return host_statistics64(mach_host_self(), HOST_VM_INFO64, pointer, &size)
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
        return data
    }
    
    public func update() {
        var result = MemoryInfo()
        
        defer {
            current = result
        }
        
        let load = vmStatistics64
        
        let unit = Double(vm_kernel_page_size) / gigaByte
        let active = Double(load.active_count) * unit
        let speculative = Double(load.speculative_count) * unit
        let inactive = Double(load.inactive_count) * unit
        let wired = Double(load.wire_count) * unit
        let compressed = Double(load.compressor_page_count) * unit
        let purgeable = Double(load.purgeable_count) * unit
        let external = Double(load.external_page_count) * unit
        let using = active + inactive + speculative + wired + compressed - purgeable - external
        
        result.total = round(using * 100.0) / 100.0
        result.app = round((using - wired - compressed) * 100.0) / 100.0
        result.wired = round(wired * 100.0) / 100.0
        result.compressed = round(compressed * 100.0) / 100.0
    }
}
