//
//  LogStrategy.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation
import OSLog

/**
 A protocol that defines a logging strategy for processing and outputting log messages.
 
 Conforming types implement the logic for formatting and handling log messages based on the
 specified log level, category, and other context information. The `LogStrategy` protocol
 provides flexibility to define custom logging behaviors, such as sending logs to the console,
 a file, a remote server, or any other logging destination.

 Conformers to `LogStrategy` must be `Sendable`, ensuring that the implementation is safe for
 concurrent access in Swift's concurrency model.

 - Note: The `formatter` property defines how log messages are formatted before being output.
         It is crucial to define a proper formatter to maintain consistency in log entries.
 */
public protocol LogStrategy: Sendable {
    
    /// The formatter responsible for formatting log messages before they are processed.
    var formatter: LogFormatter { get }
    
    /**
     Logs a message with the specified log level, category, and additional context information.
     
     This method is the main entry point for logging messages. It processes the message,
     applies formatting, and outputs it based on the log strategy's specific implementation.
     
     - Parameters:
        - message: The main content of the log message to be processed.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - category: A string representing the category or source of the log (e.g., the module, class, or feature generating the log).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
        - context: A dictionary containing additional context related to the log. This information is optional and can be used to include extra context in the log output.
     
     - Important: The implementation of this method should be thread-safe to ensure that log
                  messages are correctly handled in concurrent environments.
     
     - Note: The `formatter` property should be used to format the `message` and other parameters
             into a consistent log entry before outputting the log.
     */
    func log(
        message: String,
        level: LogLevel,
        category: String,
        file: String,
        function: String,
        line: Int,
        context: [String: Any]
    )
}
