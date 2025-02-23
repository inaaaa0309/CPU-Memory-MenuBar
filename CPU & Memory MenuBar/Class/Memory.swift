import Foundation

func getMemoryUsage() -> MemoryInfo? {
    var size = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.stride / MemoryLayout<integer_t>.stride)
    var vmStats = vm_statistics64()

    let host = mach_host_self()
    let result = withUnsafeMutablePointer(to: &vmStats) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics64(host, HOST_VM_INFO64, $0, &size)
        }
    }

    guard result == KERN_SUCCESS else {
        return nil
    }

    let pageSize = UInt64(vm_kernel_page_size)
    
    let free = UInt64(vmStats.free_count)
    let wire = UInt64(vmStats.wire_count)
    let purgeable = UInt64(vmStats.purgeable_count)
    let speculative = UInt64(vmStats.speculative_count)
    let compressor = UInt64(vmStats.compressor_page_count)
    let external = UInt64(vmStats.external_page_count)
    let `internal` = UInt64(vmStats.internal_page_count)
    
    let total = UInt64(ProcessInfo.processInfo.physicalMemory)

    let used = total - pageSize * (free + external - speculative)
    let app = pageSize * (`internal` - purgeable)
    let wired = pageSize * wire
    let compressed = pageSize * compressor
    
    return (MemoryInfo(
        used: Decimal(round(decimal2double(decimal: Decimal(used) / Decimal(10737418.24)))) / Decimal(100),
        app: Decimal(round(decimal2double(decimal: Decimal(app) / Decimal(10737418.24)))) / Decimal(100),
        wired: Decimal(round(decimal2double(decimal: Decimal(wired) / Decimal(10737418.24)))) / Decimal(100),
        compressed: Decimal(round(decimal2double(decimal: Decimal(compressed) / Decimal(10737418.24)))) / Decimal(100)
    ))
}
