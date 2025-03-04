//
//  Persistance.swift
//  Reflow
//
//  Created by Sean on 2/27/25.
//

import Foundation

let PERSISTANT_PREFIX_METADATA = "metadata"
let PERSISTANT_PREFIX_FLOW = "flow"
let PERSISTANT_PREFIX_MONITOR = "monitor"

// use single String for data first
protocol Persister {
    func Read(key:String) -> (data:String, result:RESULT_TYPE)
    func Append(key:String,data:String) -> (data:String,result:RESULT_TYPE)
    func Remove(key:String) -> (data:String,result:RESULT_TYPE)
    func Update(key:String) -> (data:String, result:RESULT_TYPE)
    func Test()-> RESULT_TYPE
}

// json data type
struct JsonData:Codable{
    let key:String
    let data:[String]
}

class File_Persistance : Persister{
    private var filepath : String

    
    init(_ filepath:String){
        self.filepath = filepath
    }
    
    private func readJSONFile<T:Decodable>()->T{
        let data: Data
        
        guard let file = Bundle.main.url(forResource: self.filepath, withExtension: nil)
        else {
            fatalError("can not find data.json in main bundle")
        }
        
        do {
            data = try Data(contentsOf: file)
        }catch{
            fatalError("could not load file from main bundle: \n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        }catch{
            fatalError("can not parse data.json as \(T.self):\n\(error)")
        }

        
    }
    
    private func writeJSONFile() -> RESULT_TYPE{
        return RESULT_OK
    }
    
    func Test() -> RESULT_TYPE {
        let filemanager = FileManager.default
        if !filemanager.fileExists(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_EXIST
        }
        
        if !filemanager.isReadableFile(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_READABLE
        }
        
        if !filemanager.isWritableFile(atPath: self.filepath){
            return RESULT_PERSISTANCE_FILE_NOT_WRITABLE
        }
        
        return RESULT_OK
    }
    
    func Append(key: String, data: String) -> (data: String, result: RESULT_TYPE) {
        
        return (data,RESULT_OK)
    }
    
    func Remove(key: String) -> (data: String, result: RESULT_TYPE) {
        return ("",RESULT_OK)
    }
    
    func Read(key: String) -> (data: String, result: RESULT_TYPE) {
        let datas:[JsonData] = self.readJSONFile()
        for data in datas {
            if data.key == key{
                return (data.data[0],RESULT_OK)
            }
        }
        return ("", RESULT_PERSISTANCE_DATA_NOT_EXSIT)
    }
    
    func Update(key: String) -> (data: String, result: RESULT_TYPE) {
        return ("",RESULT_OK)
    }
}
