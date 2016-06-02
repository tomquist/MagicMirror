//
//  Generator_r1.swift
//  MagicMirrorGenerator
//
//  Created by Tadeas Kriz on 10/02/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

struct Generator_r1: Generator {
    
    static func generateWithIndentation(indentation: String, token: Token) -> [String] {
        var output: [String] = []
        
        if let containerToken = token as? ContainerToken {
            output += generateExtension(containerToken)
        }
        return output.map { "\(indentation)\($0)" }
    }
    
    private static func generateExtension(token: ContainerToken) -> [String] {
        let name = token.name
        let accessibility = token.accessibility
        let children = token.children
        
        guard accessibility != .Private else { return [] }
        
        let properties = children.flatMap { $0 as? InstanceVariable }.filter { $0.accessibility != .Private }
        let functions = children.flatMap { $0 as? ClassMethod }.filter { $0.accessibility != .Private && !$0.name.hasPrefix("init(") }
        
        var output: [String] = []
        output += ""
        output += "extension \(name): MagicMirrorable {"
        output += ""
        output += "    private static let properties: [AnyProperty] = ["
        output += properties.flatMap { generateProperty(name, property: $0) }
        output += "    ]"
        output += generateFunctions(name, functions: functions)
        output += "    static var magicMirror: MagicMirror {"
        output += "        return MagicMirror(properties: properties, methods: methods)"
        output += "    }"
        output += ""
        output += "}"
        return output
    }
    
    private static func generateProperty(typeName: String, property: InstanceVariable) -> [String] {
        var output: [String] = []
        output += "        _RefTypeProperty(name: \"\(property.name)\","
        output += "            visibility: .\(property.accessibility.sourceName.uppercaseFirst),"
        output += "            getter: { (t: \(typeName)) in t.\(property.name) },"
        if property.readOnly || property.setterAccessibility == .Private {
            output += "            setter: nil"
        } else {
            output += "            setter: { $0.\(property.name) = $1 }"
        }
        output += "        ),"
        return output
    }
    
    private static func generateFunctions(typeName: String, functions: [ClassMethod]) -> [String] {
        var output: [String] = functions.enumerate().flatMap { (funcIndex, f) in
            return f.parameters.enumerate().map { (paramIndex, p) in
                return "    private typealias Func\(funcIndex)Param\(paramIndex) = \(p.type)"
            }
        }
        output += "    private static let methods: [AnyMethod] = ["
        output += functions.enumerate().flatMap {
            generateFunction(typeName, index: $0, token: $1)
        }
        output += "    ]"
        return output
    }
    
    private static func generateFunction(typeName: String, index: Int, token: Method) -> [String] {
        let parameterTypes = token.parameters.enumerate().map { (paramIndex, _) in
            "Func\(index)Param\(paramIndex).self"
        }.joinWithSeparator(", ")
        var returnType = extractReturnType(token.returnSignature) ?? "Void"
        if returnType.isEmpty {
            returnType = "Void"
        }
        let rawName = token.name.takeUntilStringOccurs("(") ?? ""
        let parametersSignature = token.parameters.enumerate().map {
            if let label = $1.label {
                return "\(label): param\($0)"
            } else {
                return "param\($0)"
            }
        }.joinWithSeparator(", ")
        let isThrowing = token.returnSignature.containsString("throws")
        let tryPrefix = isThrowing ? "try " : ""
        return [
            "        _RefTypeMethod(name: \"\(token.name)\",",
            "           visibility: .\(token.accessibility.sourceName.uppercaseFirst),",
            "           parameterTypes: [\(parameterTypes)],",
            "           caller: { (t: \(typeName), params: [Any]) throws -> \(returnType) in",
        ] + token.parameters.enumerate().map { (index, param) in
            return "               let param\(index): \(param.type) = try _castParam(params[\(index)])"
        } + [
            "               return \(tryPrefix)t.\(rawName)(\(parametersSignature))",
            "           }",
            "        ),"
        ]
    }
    
    private static func extractReturnType(returnSignature: String) -> String? {
        return returnSignature.trimmed.takeAfterStringOccurs("->")
    }
    
}