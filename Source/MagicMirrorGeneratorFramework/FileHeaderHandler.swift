//
//  FileHeaderHandler.swift
//  Mockery-Generator
//
//  Created by Tadeas Kriz on 12/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol FileHeaderHandler {
    static func getHeader(testableFrameworks: [String], file: FileRepresentation) -> [String]
}

extension FileHeaderHandler {
    
    static func minimumIndex(currentValue: Int, declarations: [Token]) -> Int {
        return declarations.reduce(currentValue) { minimum, declaration in
            switch declaration {
            case let containerToken as ContainerToken where minimum > containerToken.range.startIndex:
                return containerToken.range.startIndex
            case let method as Method where minimum > method.range.startIndex:
                return method.range.startIndex
            default:
                return minimum
            }
        }
    }
}