//
//  WatchableTests.swift
//  Reflow
//
//  Created by Sean on 2/28/25.
//

import Testing
import Foundation
@testable import Reflow

@Test func WatchableBasic(){
    var item : Watchable = WatchItem("test", start_script: "test.scpt", end_script: "test.scpt")
    
    #expect(item.GetStatus() == WATCHITEM_STATUS.UNSTARTED)
    
   
    var meta = MetaData(data: "fuck", key: item.GetId())
    
    #expect(meta.Get_data()=="fuck")
    
    #expect(meta.Update(new: "fuck you")==RESULT_OK)
    
    #expect(meta.Get_data()=="fuck you")
    
    #expect(item.UpdateMeta(newMeta:meta)==RESULT_OK)
    
    #expect(item.GetMeta().Get_data() == "fuck you")
    
    #expect(item.Start() == RESULT_OK)
}
