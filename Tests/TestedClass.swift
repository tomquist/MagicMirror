//
//  TestedClass.swift
//  MagicMirrorGenerator
//
//  Created by Tom Quist on 26.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import MagicMirrorFramework

class TestedClass {
    
    var test: String
    private(set) var bla: Int
    var anotherVar: NSObject
    var testClass: MyTestClass
    
    init(test: String) {
        self.test = test
        bla = 10
        anotherVar = NSString(string: "")
        testClass = MyTestClass()
    }
    
    func testMethod(string: String, int: Int) -> String {
        return string + "\(int)"
    }
    
    func anotherTestFunction(string string: String, another: AnotherClass? = nil, callback: (Int) -> Int) {
        print(string)
    }
}

class MyTestClass {
    
    var myProperty: String = "value"
    func myFunction(parameter1: String, parameter2: Int) -> String {
        return "\(parameter1)\(parameter2)"
    }
}


class AnotherClass {
    var variable: String = ""
}

struct TestStruct {
    var test: String
}

protocol TestProtocol: MagicMirrorable {
    var test: String { get }
}