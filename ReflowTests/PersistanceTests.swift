//
//  PersistanceTests.swift
//  Reflow
//
//  Created by Sean on 3/1/25.
//

import Foundation
@testable import Reflow
import Testing

@Test func PersistanceTest(){
    let p : Persister = File_Persistance()
    // test
    #expect(p.Test()==RESULT_OK)
    
    // read and write
    for i in 0...10 {
        let key = PERSISTANT_PREFIX_METADATA + String(i)
        #expect(p.Append(key: key, data: String(i))==(String(i),RESULT_OK))
    }
    
    for i in 0...10 {
        let key = PERSISTANT_PREFIX_METADATA + String(i)
        #expect(p.Read(key: key)==(String(i),RESULT_OK))
    }
    
    // append
    for i in 20...30 {
        let key = PERSISTANT_PREFIX_METADATA + String(i)
        #expect(p.Append(key: key, data: String(i))==(String(i),RESULT_OK))
    }
    
    for i in 0...10 {
        let key = PERSISTANT_PREFIX_METADATA + String(i)
        #expect(p.Read(key: key)==(String(i),RESULT_OK))
    }
    
    // remove
    for i in 0...10 {
        let key = PERSISTANT_PREFIX_METADATA + String(i)
        #expect(p.Remove(key: key)==(String(i),RESULT_OK))
    }
}
