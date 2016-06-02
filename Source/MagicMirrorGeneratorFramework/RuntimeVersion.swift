//
//  MockeryRuntimeVersion.swift
//  MockeryGenerator
//
//  Created by Tadeas Kriz on 13/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Commandant

public enum RuntimeVersion: String {
    public static let latest: RuntimeVersion = .v0_1_0
    public static let all: [RuntimeVersion] = [.v0_1_0]

    case v0_1_0 = "0.1.0"
    public var generator: Generator.Type {
        switch self {
        case .v0_1_0:
            return Generator_r1.self
        }
    }

    public var tokenizer: Tokenizer.Type {
        switch self {
        case .v0_1_0:
            return Tokenizer_r1.self
        }
    }

    public var fileHeaderHandler: FileHeaderHandler.Type {
        switch self {
        case .v0_1_0:
            return FileHeaderHandler_r1.self
        }
    }
}

extension RuntimeVersion: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

extension RuntimeVersion: ArgumentType {
    public static let name: String = "Runtime version"

    public static func fromString(string: String) -> RuntimeVersion? {
        return RuntimeVersion(rawValue: string)
    }
}
