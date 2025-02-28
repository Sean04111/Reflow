//
//  ReflowTests.swift
//  ReflowTests
//
//  Created by Sean on 2/27/25.
//

import Testing
import Foundation
@testable import Reflow

class Worker:Thread {
    
    private var monitor : Monitor
    
    init(monitor: Monitor) {
        self.monitor = monitor
    }
    
    override func main(){
        if !isCancelled {
            monitor.Run()
        }
    }
}


@Test func MonitorBasic() {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let monitor : Monitor = Monitor_impl(hearbeat: 1)
    
    let res1 = monitor.AddFlow(key: "Odd", items: [])
    let res2 = monitor.AddFlow(key: "Even", items: [])
    #expect(res1==RESULT_OK && res2==RESULT_OK)
   
    
    for i in 0...10 {
        let item : Watchable = WatchItem(String(i), start_script: "start_script_"+String(i), end_script: "end_script_"+String(i))
        let res:RESULT_TYPE
        if i % 2 == 0{
            res = monitor.AddWatchItem(key: "Even", item: [item])
        }else{
            res = monitor.AddWatchItem(key: "Odd", item: [item])
        }
        #expect(res==RESULT_OK)
    }
    
    let t = Worker(monitor: monitor)
    t.start()
    Thread.sleep(forTimeInterval: TimeInterval(5))
    
}
