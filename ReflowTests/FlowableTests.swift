//
//  FlowableTests.swift
//  Reflow
//
//  Created by Sean on 2/28/25.
//

import Testing
import Foundation
@testable import Reflow

@Test func FlowBasic() {
    let flow : Flowable = Flow(name: "test")
    
    #expect(flow.GetName()=="test")
    
    var item_count = 0
    for i in 0...9 {
        let item : Watchable = WatchItem("item_name_"+String(i), start_script: "start_script_"+String(i), end_script: "end_script_"+String(i))
        flow.AddWatchable(item: item)
        item_count += 1
    }
    
    #expect(flow.GetAllWatchable().count == item_count)
    
    #expect(flow.StartFlow() == RESULT_OK)
    
    #expect(flow.GetStatus() == FLOW_STATUS.FLOW_WORKS_FINE)
    
    #expect(flow.WorkCheck().0 == RESULT_OK)
    
    #expect(flow.EndFlow() == RESULT_OK)
    
    #expect(flow.GetStatus() == FLOW_STATUS.FLOW_STOPPED)
    
    let items = flow.GetAllWatchable()
    let total = items.count
    var idx = 0
    
    for item in items{
        if idx % 2 == 0 {
           _ = flow.DeleteWatchable(id: item.GetId())
        }
        idx += 1
    }
    #expect(flow.GetAllWatchable().count == total/2)
}


@Test func FlowMetaOps(){
    
}
