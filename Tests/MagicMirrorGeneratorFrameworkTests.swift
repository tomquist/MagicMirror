//
//  MockeryGeneratorFrameworkTests.swift
//  MockeryGeneratorFrameworkTests
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import MagicMirror

class MagicMirrorGeneratorFrameworkTests: XCTestCase {
    
    func testPropertyCount() {
        XCTAssertEqual(TestedClass.magicMirror.properties.count, 4)
    }
    
    func testMethodCount() {
        XCTAssertEqual(TestedClass.magicMirror.methods.count, 2)
    }
    
    func testGetProperty() {
        let obj = TestedClass(test: "testString")
        do {
            let value = try obj.value(forKey: "test") as? String
            XCTAssertEqual("testString", value)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetProperty() {
        var obj = TestedClass(test: "testString")
        do {
            try obj.set("otherString", forKey: "test")
            XCTAssertEqual("otherString", obj.test)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testCallMethod() {
        var obj = TestedClass(test: "testString")
        do {
            guard let method = TestedClass.magicMirror.methods.filter({ $0.name == "testMethod(_:int:)" }).first else {
                XCTFail("Method does not exist")
                return
            }
            let result: String = try method.call(&obj, params: ["test", 123])
            XCTAssertEqual("test123", result)
        } catch {
            XCTFail("\(error)")
        }
    }
        
}
