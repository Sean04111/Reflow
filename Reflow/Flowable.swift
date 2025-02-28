//
//  Flow.swift
//  Reflow
//
//  Created by Sean on 2/28/25.
//

import Foundation



protocol Flowable {
    // basic info
    func GetId ()-> String
    func GetName()->String
    func UpdateName(newName:String) -> RESULT_TYPE
    func GetStatus()->FLOW_STATUS
  
    // watachable management
    func AddWatchable(item:any Watchable)
    func DeleteWatchable(id:String) -> RESULT_TYPE
    func UpdateWatchableMetaData(id:String, meta: MetaData) -> RESULT_TYPE
    func GetWatchable(id:String) -> (Watchable?,RESULT_TYPE)
    func GetAllWatchable()-> [Watchable]
    
    // work flow
    func StartFlow()->RESULT_TYPE
    func EndFlow()->RESULT_TYPE
    func WorkCheck()->(RESULT_TYPE,[String])
}


class Flow : Flowable {
    private var items :  [String:Watchable]
    private var status : FLOW_STATUS
    private var id : UUID
    private var name : String
    
    init(name : String){
        self.items = [:]
        self.status = FLOW_STATUS.FLOW_STOPPED
        self.id = UUID()
        self.name = name
    }
    
    func AddWatchable(item: any Watchable) {
        self.items[item.GetId()] = item
    }
    
    func DeleteWatchable(id: String) -> RESULT_TYPE {
        if let _ = self.items[id] {
            self.items.removeValue(forKey: id)
            return RESULT_OK
        }else{
            return RESULT_FLOW_NOT_EXIST_WATCHABLE
        }
    }
    
    func UpdateWatchableMetaData(id: String, meta: MetaData) -> RESULT_TYPE {
        if let item = self.items[id] {
            return item.UpdateMeta(newMeta: meta)
        }else{
            return RESULT_FLOW_NOT_EXIST_WATCHABLE
        }
    }
    
    func GetWatchable(id: String) -> (Watchable?,RESULT_TYPE) {
        if let item = self.items[id] {
            return (item,RESULT_OK)
        }else {
            return (nil,RESULT_FLOW_NOT_EXIST_WATCHABLE)
        }
    }
    
    func GetAllWatchable() -> [any Watchable] {
        return Array(self.items.values)
    }
    
    func GetName() -> String {
        return self.name
    }
    
    func GetId() -> String {
        return self.id.uuidString
    }
    
    func UpdateName(newName:String) -> RESULT_TYPE {
        self.name = newName
        return RESULT_OK
    }
    
    func GetStatus() -> FLOW_STATUS {
        let total_items = self.items.count
        var working_count = 0
        var stopped_count = 0
        
        
        for (_, item) in self.items{
            switch item.GetStatus() {
            case WATCHITEM_STATUS.UNSTARTED:
                stopped_count += 1
            case WATCHITEM_STATUS.WORKING_ON:
                working_count += 1
            default:
                return FLOW_STATUS.FLOW_WORKS_WIRED_UNKNOWN_WATCHABLE_STATUS
            }
        }
        
        if working_count == total_items {
            return FLOW_STATUS.FLOW_WORKS_FINE
        }else if stopped_count == total_items {
            return FLOW_STATUS.FLOW_STOPPED
        }else{
            return FLOW_STATUS.FLOW_WORKS_WIRED_WATCHABLE_STATUS_SPLITED
        }
    }
    
    func StartFlow() -> RESULT_TYPE {
        for (_, item) in self.items{
            item.Start()
            // TODO: Add Notify bus here
        }
        return RESULT_OK
    }
    
    func EndFlow() -> RESULT_TYPE {
        for (_, item) in self.items{
            item.End()
            // TODO: Add Notify bus here
        }
        return RESULT_OK
    }
    
    func WorkCheck() -> (RESULT_TYPE,[String]) {
        var wired_items : [String] = []
        
        for (_,item) in self.items{
            if item.GetStatus() != WATCHITEM_STATUS.WORKING_ON {
                wired_items.append(item.GetId())
            }
        }
        
        if wired_items.count != 0 {
            return (RESULT_FLOW_WORK_CHECK_WIRED,wired_items)
        }else{
            return (RESULT_OK,[])
        }
    }
}
