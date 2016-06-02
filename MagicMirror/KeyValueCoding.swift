//
//  KeyValueCoding.swift
//  MagicMirrorGenerator
//
//  Created by Tom Quist on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public enum KeyValueCodingError: ErrorType {
    case UnknownProperty(String)
}

extension MagicMirrorable {
    
    private func property(forKey key: String) throws -> AnyProperty {
        let mirror = Self.magicMirror
        guard let index = mirror.properties.indexOf({ $0.name == key }) else {
            throw KeyValueCodingError.UnknownProperty(key)
        }
        return mirror.properties[index]
    }
    
    public func value(forKey key: String) throws -> Any {
        return try property(forKey: key).get(self)
    }
    
    public mutating func set(value: Any, forKey key: String) throws {
        var target = self
        try property(forKey: key).set(&target, value: value)
        self = target
    }
    
}