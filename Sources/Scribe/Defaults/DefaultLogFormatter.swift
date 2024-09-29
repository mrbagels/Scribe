//
//  DefaultLogFormatter.swift
//  Scribe
//
//  Created by Kyle Begeman on 9/29/24.
//

import Foundation

/**
 A default implementation of the `LogFormatter` protocol that formats log messages with timestamps and context information.

 `DefaultLogFormatter` provides a basic log formatting mechanism that includes a timestamp, log level, message content,
 source location, and optional context. It uses a `DateFormatter` to generate timestamps for each log entry, and
 offers a straightforward way to create consistent log messages.

 - Conforms to:
   - `LogFormatter`: Implements the required methods to format log messages.
   - `Sendable`: Ensures thread-safe usage in concurrent environments.
 */
public struct DefaultLogFormatter: LogFormatter {
    
    /// A `DateFormatter` used to generate timestamps for log messages.
    private let dateFormatter: DateFormatter
    
    /**
     Initializes a new instance of `DefaultLogFormatter` with a specified date format.
     
     - Parameter dateFormat: A string representing the date format to use for timestamps. Defaults to `"yyyy-MM-dd HH:mm:ss.SSS"`.
     */
    public init(dateFormat: String = "yyyy-MM-dd HH:mm:ss.SSS") {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = dateFormat
    }
    
    /**
     Formats a log message with basic context information.

     This method formats the log message by including a timestamp, log level, and source location.
     
     - Parameters:
        - message: The main content of the log message.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
     
     - Returns: A formatted log message as a `String` that includes the timestamp, log level, message, and location.
     */
    public func format(
        message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int
    ) -> String {
        let location = "\(file) - \(function) @ line \(line)"
        let timestamp = dateFormatter.string(from: Date())
        return "[\(timestamp)] \(level.label)\n\(message) (\(location))"
    }
    
    /**
     Formats a log message with additional context.

     This method extends the basic formatting by including context in the log entry. context is presented as a
     key-value pair string at the end of the log message.
     
     - Parameters:
        - message: The main content of the log message.
        - level: The severity level of the log (e.g., debug, info, warning, error).
        - file: The file name where the log call was made. Automatically captured using `#file`.
        - function: The function name where the log call was made. Automatically captured using `#function`.
        - line: The line number in the source file where the log call was made. Automatically captured using `#line`.
        - context: A dictionary containing additional context related to the log entry.
     
     - Returns: A formatted log message as a `String`, including the timestamp, log level, message, location, and context.
     */
    public func format(
        message: String,
        level: LogLevel,
        file: String,
        function: String,
        line: Int,
        context: [String: Any]
    ) -> String {
        let fileName = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        let timestamp = dateFormatter.string(from: Date())

        // Build the basic log message
        var formattedMessage = "\(timestamp)\n"
        formattedMessage += "\(level.label) (\(fileName).\(function) @ line \(line))\n"
        formattedMessage += "\(message)\n"

        // Add context if it exists, formatted as JSON
        if !context.isEmpty {
            if let jsonData = try? JSONSerialization.data(withJSONObject: context, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                formattedMessage += "\ncontext: \(jsonString)"
            }
        }

        return formattedMessage
    }
}
