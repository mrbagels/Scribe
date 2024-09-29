//
//  LogConfig.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation
import OSLog

/**
 A configuration object for setting up the logging behavior.

 `LogConfig` holds various settings that control the logging process, such as whether logging is enabled,
 the severity level of logs to capture, and the formatter used to format log messages. This configuration
 can be used to customize the logging behavior dynamically at runtime.

 - Conforms to:
   - `Sendable`: Ensures that `LogConfig` can be safely used in concurrent environments.

 */
public struct LogConfig: Sendable {
    
    /// A Boolean indicating whether logging is enabled.
    public var isEnabled: Bool
    
    /// The minimum log level to capture. Log messages below this level will be ignored.
    public var logLevel: LogLevel
    
    /// The formatter used to format log messages before they are processed.
    public var formatter: LogFormatter
    
    /**
     Initializes a new `LogConfig` instance with the specified settings.
     
     - Parameters:
        - isEnabled: A Boolean indicating whether logging is enabled. The default value is `true`.
        - logLevel: The minimum log level to capture. Defaults to `.info`.
        - formatter: An object conforming to `LogFormatter` that formats log messages. The default is an instance of `DefaultLogFormatter`.
     
     - Returns: A new `LogConfig` instance with the specified settings.
     */
    public init(
        isEnabled: Bool = true,
        logLevel: LogLevel = .info,
        formatter: LogFormatter = DefaultLogFormatter()
    ) {
        self.isEnabled = isEnabled
        self.logLevel = logLevel
        self.formatter = formatter
    }
}
