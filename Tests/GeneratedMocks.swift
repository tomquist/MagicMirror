// MARK: - Mocks generated from file: /Users/tquist/Dropbox/dev/MagicMirror/Tests/TestedClass.swift at 2016-06-02 22:20:33 +0000

//
//  TestedClass.swift
//  MagicMirrorGenerator
//
//  Created by Tom Quist on 26.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation


import MagicMirrorFramework

extension TestedClass: MagicMirrorable {

    private static let properties: [AnyProperty] = [
        _RefTypeProperty(name: "test",
            visibility: .Internal,
            getter: { (t: TestedClass) in t.test },
            setter: { $0.test = $1 }
        ),
        _RefTypeProperty(name: "bla",
            visibility: .Internal,
            getter: { (t: TestedClass) in t.bla },
            setter: nil
        ),
        _RefTypeProperty(name: "anotherVar",
            visibility: .Internal,
            getter: { (t: TestedClass) in t.anotherVar },
            setter: { $0.anotherVar = $1 }
        ),
        _RefTypeProperty(name: "testClass",
            visibility: .Internal,
            getter: { (t: TestedClass) in t.testClass },
            setter: { $0.testClass = $1 }
        ),
    ]
    private typealias Func0Param0 = String
    private typealias Func0Param1 = Int
    private typealias Func1Param0 = String
    private typealias Func1Param1 = AnotherClass?
    private typealias Func1Param2 = (Int) -> Int
    private static let methods: [AnyMethod] = [
        _RefTypeMethod(name: "testMethod(_:int:)",
           visibility: .Internal,
           parameterTypes: [Func0Param0.self, Func0Param1.self],
           caller: { (t: TestedClass, params: [Any]) throws ->  String in
               let param0: String = try _castParam(params[0])
               let param1: Int = try _castParam(params[1])
               return t.testMethod(param0, int: param1)
           }
        ),
        _RefTypeMethod(name: "anotherTestFunction(string:another:callback:)",
           visibility: .Internal,
           parameterTypes: [Func1Param0.self, Func1Param1.self, Func1Param2.self],
           caller: { (t: TestedClass, params: [Any]) throws -> Void in
               let param0: String = try _castParam(params[0])
               let param1: AnotherClass? = try _castParam(params[1])
               let param2: (Int) -> Int = try _castParam(params[2])
               return t.anotherTestFunction(string: param0, another: param1, callback: param2)
           }
        ),
    ]
    static var magicMirror: MagicMirror {
        return MagicMirror(properties: properties, methods: methods)
    }

}

extension MyTestClass: MagicMirrorable {

    private static let properties: [AnyProperty] = [
        _RefTypeProperty(name: "myProperty",
            visibility: .Internal,
            getter: { (t: MyTestClass) in t.myProperty },
            setter: { $0.myProperty = $1 }
        ),
    ]
    private typealias Func0Param0 = String
    private typealias Func0Param1 = Int
    private static let methods: [AnyMethod] = [
        _RefTypeMethod(name: "myFunction(_:parameter2:)",
           visibility: .Internal,
           parameterTypes: [Func0Param0.self, Func0Param1.self],
           caller: { (t: MyTestClass, params: [Any]) throws ->  String in
               let param0: String = try _castParam(params[0])
               let param1: Int = try _castParam(params[1])
               return t.myFunction(param0, parameter2: param1)
           }
        ),
    ]
    static var magicMirror: MagicMirror {
        return MagicMirror(properties: properties, methods: methods)
    }

}

extension AnotherClass: MagicMirrorable {

    private static let properties: [AnyProperty] = [
        _RefTypeProperty(name: "variable",
            visibility: .Internal,
            getter: { (t: AnotherClass) in t.variable },
            setter: { $0.variable = $1 }
        ),
    ]
    private static let methods: [AnyMethod] = [
    ]
    static var magicMirror: MagicMirror {
        return MagicMirror(properties: properties, methods: methods)
    }

}