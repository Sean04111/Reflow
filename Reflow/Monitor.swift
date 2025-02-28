//
//  Monitor.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//
import Foundation
import os



protocol Monitor  {
    func AddWatchItem(key:String,item: [Watchable]) -> RESULT_TYPE
    func AddFlow(key:String, items:[Watchable]) ->RESULT_TYPE
    func StartFlow(key: String) -> RESULT_TYPE
    func EndFlow(key:String) -> RESULT_TYPE
    func GetItems(key:String) -> [Watchable]
    func Run()
    func Kill() -> RESULT_TYPE
}


class Monitor_impl : Monitor{
    private var items :  [String:[Watchable]]
    private var heartbeat : Int
    private var alive : any AtomicFlag
   
    
    /// heartbeat as second
    init(hearbeat: Int) {
        self.items = [:]
        self.heartbeat = hearbeat
        self.alive = AtomicValue(MONITOR_DEAD)
    }
    
    private func working_check(){
        for (key, items) in self.items {
            for item in items {
                if item.GetStatus() != WATCHITEM_STATUS.WORKING_ON{
                   
                    //trying to restart item
                    item.Start()
                    //TODO: delete me
                    Notify(message: "trying to start item : "+item.GetId())
                }
            }
        }
    }
    
    private func write () -> RESULT_TYPE{
        return RESULT_OK
    }
    
    private func load() -> RESULT_TYPE {
        return RESULT_OK
    }
    
    func AddWatchItem(key:String,item : [Watchable]) -> RESULT_TYPE {
        self.items[key]?.append(contentsOf: item)
        return self.write()
    }
    
    func AddFlow(key: String, items: [Watchable]) -> RESULT_TYPE {
        if self.GetItems(key: key).count != 0{
            return RESULT_ADD_ALREADY_EXIST_FLOW
        }
        
        self.items[key]?.append(contentsOf: items)
        return self.write()
    }
    
    func GetItems(key:String) -> [Watchable] {
        return self.items[key] ?? []
    }
    

    func StartFlow(key: String) -> RESULT_TYPE {
        //check already running
        if self.GetItems(key: key).count != 0{
            return RESULT_FLOW_ALREADY_WORKING
        }
        
        // read from persistant layer
        let load_res = self.load()
        if load_res != RESULT_OK{
            return load_res
        }
        
        let items = self.GetItems(key: key)
        if items.count == 0{
            return RESULT_EMPTY_FLOW
        }
        
        for item in items{
            let start_res = item.Start()
            if start_res != RESULT_OK{
                return start_res
            }
        }
        
        return RESULT_OK
    }
    
    func EndFlow(key: String) -> RESULT_TYPE {
        let items = self.GetItems(key: key)
        if items.count == 0{
            return RESULT_EMPTY_FLOW
        }
        
        for item in items {
            let end_res = item.End()
            if end_res != RESULT_OK{
                return end_res
            }
        }
        
        // write to persistant layer
        let write_res = self.write()
        if write_res != RESULT_OK{
            return write_res
        }
        
        self.items.removeValue(forKey: key)
        
        return RESULT_OK
    }
    
    func Run() {
        self.alive.set(value:  MONITOR_ALIVE)
        
        while self.alive.get() == MONITOR_ALIVE{
          
            Thread.sleep(forTimeInterval: TimeInterval(self.heartbeat))
            self.working_check()
        }
    }
    
    func Kill() -> RESULT_TYPE{
        if self.alive.get() == MONITOR_DEAD{
            return RESULT_MONITOR_KILL_DEAD
        }
        self.alive.set(value: MONITOR_DEAD)
        return RESULT_OK
    }
}


