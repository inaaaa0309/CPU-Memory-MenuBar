//
//  CPU.swift
//  CPU & Memory MenuBar
//
//  Created by 稲谷究 on 2024/04/14.
//

import Foundation

struct CPUInfo {
    public var used: Decimal = 0
    public var system: Decimal = 0
    public var user: Decimal = 0
    public var idle: Decimal = 0
}

final class CPU {
    private let size = UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
    private let machHost = mach_host_self()
    private var loadPrevious = host_cpu_load_info()
    
    final private func hostCPULoadInfo() -> host_cpu_load_info {
        var size: mach_msg_type_number_t = size
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)
        
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) { (pointer) -> kern_return_t in
            return host_statistics(machHost, HOST_CPU_LOAD_INFO, pointer, &size)
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        return data
    }
    
    final func getCPU() -> CPUInfo {
        let load = hostCPULoadInfo()
        
        let user = load.cpu_ticks.0 - loadPrevious.cpu_ticks.0
        let system = load.cpu_ticks.1 - loadPrevious.cpu_ticks.1
        let idle = load.cpu_ticks.2 - loadPrevious.cpu_ticks.2
        let nice = load.cpu_ticks.3 - loadPrevious.cpu_ticks.3
        
        loadPrevious = load
        
        let total = user + system + idle + nice
        let used = user + system + nice
        
        return CPUInfo(
            used: Decimal(round(Decimal2Double(decimal: Decimal(used) / Decimal(total) * Decimal(10000)))) / Decimal(100),
            system: Decimal(round(Decimal2Double(decimal: Decimal(system) / Decimal(total) * Decimal(10000)))) / Decimal(100),
            user: Decimal(round(Decimal2Double(decimal: Decimal(user) / Decimal(total) * Decimal(10000)))) / Decimal(100),
            idle: Decimal(round(Decimal2Double(decimal: Decimal(idle) / Decimal(total) * Decimal(10000)))) / Decimal(100)
        )
    }
}
