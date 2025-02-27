//
//  Common.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import os

//types

typealias RESULT_TYPE = String

let RESULT_OK : RESULT_TYPE = "OK"
let RESULT_UNKNOWN : RESULT_TYPE = "unknown error !"
let RESULT_SCRIPT_NOT_FOUND : RESULT_TYPE = "script not found !"
let RESULT_SCRIPT_EXECUTE_ERROR : RESULT_TYPE = "script execute error : "
let RESULT_SCRIPT_OK_NO_OUTPUT : RESULT_TYPE = "OK"
let RESULT_SCRIPT_OK_WITH_OUTPUT : RESULT_TYPE = "OK"

let RESULT_STATUS_INVALID : RESULT_TYPE = "watch item status invalid !"

let RESULT_META_DATA_PARSE_FAILED : RESULT_TYPE = "watch item metadata parse failed !"
let RESULT_META_RECORD_FILE_NOT_FOUND : RESULT_TYPE = "watch item metadata file not found !"

let RESULT_EMPTY_FLOW : RESULT_TYPE = "start a empty flow"
let RESULT_FLOW_ALREADY_WORKING : RESULT_TYPE = "flow already working"
let RESULT_ADD_ALREADY_EXIST_FLOW : RESULT_TYPE = "add already exsit flow !"

let RESULT_MONITOR_KILL_DEAD : RESULT_TYPE = "kill dead monitor !"


enum WATCHITEM_STATUS {
    case WORKING_ON
    case UNSTARTED
}

typealias MONITOR_LIVE_STATUS = Int

let MONITOR_DEAD = 0
let MONITOR_ALIVE = 1




// utils

//TODO: fuck swift generic!
protocol AtomicFlag {
    func get() -> Int
    func set(value:Int)
}

final class AtomicValue : AtomicFlag{
    
    private var  value : Int
    private var locker : os_unfair_lock_s
    
    init(_ flag: Int) {
        self.value = flag
    }
    
    func get() -> Int {
        os_unfair_lock_lock(&self.locker)
        defer {
            os_unfair_lock_unlock(&self.locker)
        }
        return self.value
    }
    
    func set (value: Int){
        os_unfair_lock_lock(&self.locker)
        defer {os_unfair_lock_unlock(&self.locker)}
        self.value = value
    }
}




