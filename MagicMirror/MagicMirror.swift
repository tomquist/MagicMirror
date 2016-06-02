//
//  MagicMirror.swift
//  MagicMirrorGenerator
//
//  Created by Tom Quist on 30.05.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum MagicMirrorError: ErrorType {
    case InvalidTargetType(expected: Any.Type, actual: Any.Type)
    case InvalidResultType(expected: Any.Type, actual: Any.Type)
    case InvalidValueType(expected: Any.Type, actual: Any.Type)
    case InvalidParameterType(expected: Any.Type, actual: Any.Type)
    case InvalidParameterCount(expected: Int, actual: Int)
}

public enum Visibility {
    case Private
    case Internal
    case Public
}

public protocol AnyProperty {
    var name: String { get }
    var visibility: Visibility { get }
    var type: Any.Type { get }
    var canSet: Bool { get }
    
    func get<T, P>(target: T) throws -> P
    func set<T, P>(inout target: T, value: P) throws
    
}

public protocol _PropertyType: AnyProperty {
    associatedtype Owner
    associatedtype Type
    
    func get(target: Owner) -> Type
    func set(inout target: Owner, value: Type)
}

/// Protocol for methods
public protocol AnyMethod {
    
    /// Full method name without type information
    var name: String { get }
    var visibility: Visibility { get }
    
    /// List of parameter types
    var parameterTypes: [Any.Type] { get }
    
    /// The return type
    var returnType: Any.Type { get }
    
    /// Calls the method with the specified parameters.
    /// - parameters:
    ///   - target: Value to call method on
    ///   - params: Parameters to pass to the method call
    /// - returns: Result of the method
    /// - throws: Errors will be thrown, when the target type, parameter types or return type is wrong
    func call<T, R>(inout target: T, params: [Any]) throws -> R
}

/// Method for reference types. This doesn
public protocol AnyReferenceTypeMethod: AnyMethod {
    func call<T, R>(on target: T, params: [Any]) throws -> R
}

extension AnyReferenceTypeMethod {
    public func call<T, R>(on target: T, params: [Any]) throws -> R {
        var t = target
        return try self.call(&t, params: params)
    }
}

public protocol _MethodType: AnyMethod {
    associatedtype Owner
    associatedtype Result
    func call(inout target: Owner, params: [Any]) throws -> Result
}

public func _castOrThrow<T>(value: Any, @autoclosure error: () -> ErrorType) throws -> T {
    guard let castedValue = value as? T else {
        throw error()
    }
    return castedValue
}

public func _castParam<T>(value: Any) throws -> T {
    return try _castOrThrow(value, error: MagicMirrorError.InvalidParameterType(expected: T.self, actual: value.dynamicType))
}

extension _MethodType {
    public var returnType: Any.Type {
        return Result.self
    }
    public func call<T, R>(inout target: T, params: [Any]) throws -> R {
        var t: Owner = try _castOrThrow(target, error: MagicMirrorError.InvalidTargetType(expected: Owner.self, actual: target.dynamicType))
        let result: Result = try call(&t, params: params)
        let r: R = try _castOrThrow(result, error: MagicMirrorError.InvalidResultType(expected: R.self, actual: result.dynamicType))
        target = t as! T
        return r
    }
}

extension _PropertyType {
    public func get<T, P>(target: T) throws -> P {
        let t: Owner = try _castOrThrow(target, error: MagicMirrorError.InvalidTargetType(expected: Owner.self, actual: target.dynamicType))
        let result = get(t)
        return try _castOrThrow(result, error: MagicMirrorError.InvalidResultType(expected: P.self, actual: result.dynamicType))
    }
    public func set<T, P>(inout target: T, value: P) throws {
        var t: Owner = try _castOrThrow(target, error: MagicMirrorError.InvalidTargetType(expected: Owner.self, actual: target.dynamicType))
        let v: Type = try _castOrThrow(value, error: MagicMirrorError.InvalidValueType(expected: Type.self, actual: value.dynamicType))
        set(&t, value: v)
        target = t as! T
    }
}

extension _PropertyType {
    public var type: Any.Type {
        return Type.self
    }
}

public struct _RefTypeProperty<T, P> {
    public let name: String
    public let visibility: Visibility
    public let getter: (T) -> P
    public let setter: ((T, P) -> Void)?
    public init(name: String, visibility: Visibility, getter: (T) -> P, setter: ((T, P) -> Void)?) {
        self.name = name
        self.visibility = visibility
        self.getter = getter
        self.setter = setter
    }
}

public struct _ValueTypeProperty<T, P> {
    public let name: String
    public let visibility: Visibility
    public let getter: (target: T) -> P
    public let setter: ((inout T, P) -> Void)?
    public init(name: String, visibility: Visibility, getter: (T) -> P, setter: ((inout T, P) -> Void)?) {
        self.name = name
        self.visibility = visibility
        self.getter = getter
        self.setter = setter
    }
}

extension _RefTypeProperty: _PropertyType {
    public func get(target: T) -> P {
        return self.getter(target)
    }
    public func set(inout target: T, value: P) {
        setter?(target, value)
    }
    public var canSet: Bool {
        return setter != nil
    }
}
extension _ValueTypeProperty: _PropertyType {
    public func get(target: T) -> P {
        return self.getter(target: target)
    }
    public func set(inout target: T, value: P) {
        setter?(&target, value)
    }
    public var canSet: Bool {
        return setter != nil
    }
}

public struct _RefTypeMethod<T, R> {
    public let name: String
    public let visibility: Visibility
    public let parameterTypes: [Any.Type]
    public let caller: (T, [Any]) throws -> R
    
    public init(name: String, visibility: Visibility, parameterTypes: [Any.Type], caller: (T, [Any]) throws -> R) {
        self.name = name
        self.visibility = visibility
        self.parameterTypes = parameterTypes
        self.caller = caller
    }
}

public struct _ValueTypeMethod<T, R> {
    public let name: String
    public let visibility: Visibility
    public let parameterTypes: [Any.Type]
    public let caller: (inout T, [Any]) throws -> R
}

extension _RefTypeMethod: _MethodType, AnyReferenceTypeMethod {
    public func call(inout target: T, params: [Any]) throws -> R {
        guard params.count == parameterTypes.count else {
            throw MagicMirrorError.InvalidParameterCount(expected: parameterTypes.count, actual: params.count)
        }
        return try caller(target, params)
    }
}

extension _ValueTypeMethod: _MethodType {
    public func call(inout target: T, params: [Any]) throws -> R {
        guard params.count == parameterTypes.count else {
            throw MagicMirrorError.InvalidParameterCount(expected: parameterTypes.count, actual: params.count)
        }
        return try caller(&target, params)
    }
}

public struct MagicMirror {
    public let properties: [AnyProperty]
    public let methods: [AnyMethod]
    public init(properties: [AnyProperty], methods: [AnyMethod]) {
        self.properties = properties
        self.methods = methods
    }
}

public protocol MagicMirrorable {
    static var magicMirror: MagicMirror { get }
}

