//
//  LogLevel.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation
import OSLog

/**
 An enumeration representing the different levels of logging severity.

 The `LogLevel` enum defines various levels of log severity, ranging from `debug` to `fault`.
 It also provides additional functionalities, such as retrieving a label for each log level
 and mapping to Apple's `OSLogType`. Each case has an associated integer value that allows
 for comparisons between log levels using the `Comparable` protocol.

 - Conforms to:
    - `Int`: Allows raw integer values for each log level.
    - `CaseIterable`: Enables iteration over all possible `LogLevel` values.
    - `Comparable`: Provides the ability to compare log levels to determine their severity.
    - `Sendable`: Ensures `LogLevel` can be safely used in concurrent environments.

 - Note: The `osLogType` computed property maps `LogLevel` values to their corresponding
   `OSLogType`. Since `OSLog` does not have a specific warning type, `.warning` is mapped
   to `.error`.
 */
public enum LogLevel: Int, CaseIterable, Comparable, Sendable {
    
    /// General informational messages about the application's operation.
    case info = 1
    
    /// Indicates a warning about potential issues that do not cause immediate problems.
    case warning
    
    /// Represents error conditions that usually require attention.
    case error

    /// A label describing the log level, including an emoji for visual distinction.
    public var label: String {
        switch self {
        case .info:     return "[🔵 INFO]"
        case .warning:  return "[🟠 WARNING]"
        case .error:    return "[🔴 ERROR]"
        }
    }

    /**
     Maps the log level to the corresponding `OSLogType`.
     
     - Returns: An `OSLogType` value that represents the current log level.
     
     - Note: Since `OSLog` does not have a specific type for warnings, `.warning` is mapped to `.error`.
     */
    public var osLogType: OSLogType {
        switch self {
        case .info:
            return .info
        case .warning:
            return .error
        case .error:
            return .fault
        }
    }

    /**
     Compares two `LogLevel` values to determine their relative severity.
     
     - Parameters:
        - lhs: The left-hand side `LogLevel` to compare.
        - rhs: The right-hand side `LogLevel` to compare.
     
     - Returns: `true` if the `lhs` is less severe than `rhs`; otherwise, `false`.
     */
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension LogLevel {
    
    /**
     Converts an `OSLogType` to a corresponding `LogLevel`.
     
     This method provides a way to map Apple's `OSLogType` values back to a `LogLevel`.
     Since `OSLogType` does not have direct representations for all `LogLevel` cases,
     the `.error` and `.fault` cases in `OSLogType` map to their respective `LogLevel`
     values, while other types default to `.info`.

     - Parameter osLogType: The `OSLogType` to be converted to a `LogLevel`.
     - Returns: A `LogLevel` value corresponding to the provided `OSLogType`.
     */
    public static func from(_ osLogType: OSLogType) -> LogLevel {
        switch osLogType {
        case .info:
            return .info
        case .error:
            return .error
        default:
            return .info
        }
    }
}
