//
//  DefaultLogStrategy.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation
import OSLog

/**
 A default implementation of the `LogStrategy` protocol that logs messages using the `os.Logger` system.

 `DefaultLogStrategy` provides a basic logging mechanism using Apple's unified logging system. It uses a `LogFormatter`
 to format log messages before they are passed to the underlying `os.Logger`. This implementation outputs logs to the
 system console and the unified logging system, which can be accessed using Console.app on macOS.

 - Important: This struct is designed to be used in a concurrent environment. The `formatter` used should be thread-safe.
 */
public struct DefaultLogStrategy: LogStrategy {
    
    /// The formatter used to format log messages before they are logged.
    public var formatter: LogFormatter = DefaultLogFormatter()
    
    /**
     Initializes a new instance of `DefaultLogStrategy` with the default formatter.
     
     - Returns: A new instance of `DefaultLogStrategy`.
     */
    public init() {}
    
    /**
     Logs a message with the specified log level, category, and context information.
     
     This method formats the log message using the provided `formatter` and then logs it using the `os.Logger`
     associated with the specified `category`. The log is recorded with the appropriate log level and includes
     contextual information such as the source file, function, line number, and context.

     - Parameters:
        - message: The main content of the log message.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - category: A string representing the category or source of the log (e.g., the module, class, or feature generating the log).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
        - context: A dictionary containing additional context related to the log. This information is optional and can provide extra context.
     
     - Note: The log message is formatted using the strategy's `formatter` before being sent to the `os.Logger`.
             The `os.Logger` is initialized with the app's bundle identifier as the subsystem and the specified
             `category`.

     - Important: Ensure that the `LogFormatter` used is thread-safe, as this method may be called from different
                  threads in a concurrent environment.
     */
    public func log(
        message: String,
        level: LogLevel,
        category: String,
        file: String,
        function: String,
        line: Int,
        context: [String: Any]
    ) {
        let formattedMessage = formatter.format(
            message: message,
            level: level,
            file: file,
            function: function,
            line: line,
            context: context
        )
        
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.myEmbrace.logger", category: category)
        logger.log(level: level.osLogType, "\(formattedMessage)")
    }
}
