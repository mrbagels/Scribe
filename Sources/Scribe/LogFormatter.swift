//
//  LogFormatter.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation

/**
 A protocol that defines the structure for formatting log messages.

 Conforming types to `LogFormatter` must implement methods to format log messages in a customizable way,
 including context information such as the log level, source file, function, line number, and optional context.
 This allows for flexible and consistent log output across different logging strategies.

 - Conforms to:
   - `Sendable`: Ensures that conforming types are safe for concurrent use in Swift's concurrency model.
 */
public protocol LogFormatter: Sendable {
    
    /**
     Formats a log message with basic context information.

     This method formats the provided log message, including the log level, source file, function, and line number.
     Conforming types can implement this method to provide a customized format for log entries.
     
     - Parameters:
        - message: The main content of the log message.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     
     - Returns: A formatted log message as a `String`.
     */
    func format(
        message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int
    ) -> String
    
    /**
     Formats a log message with additional context.

     This method extends the basic formatting by including additional context in the log entry.
     Conforming types can implement this method to provide a detailed and customized format for log entries.
     
     - Parameters:
        - message: The main content of the log message.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
        - context: A dictionary containing additional context related to the log entry.
     
     - Returns: A formatted log message as a `String`, including context.
     */
    func format(
        message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int,
        context: [String: Any]
    ) -> String
}
