//
//  File.swift
//  
//
//  Created by Philipp Wallrich on 01.12.21.
//

import Foundation

protocol Day {
    func runPart1() async throws
    func runPart2() async throws
}

class InputGetter {
    static func getInput(for day: Int, part: Part) throws -> String {
        let inputURL = try inputURL(for: day, part: part)
        return try String(contentsOf: inputURL)
    }

    static func getInputData(for day: Int, part: Part) throws -> Data {
        let inputURL = try inputURL(for: day, part: part)
        return try Data(contentsOf: inputURL)
    }

    private static func inputURL(for day: Int, part: Part) throws -> URL {
         let name = "input_\(day)_\(part.rawValue)"
        guard let inputURL = Bundle.module.url(forResource: name, withExtension: "txt") else {
            print("couldn't find input named: \(name)")
            throw DayError.noInputFound
        }
        return inputURL
    } 
}

enum DayError: Error {
    case notImplemented
    case noInputFound
    case invalidInput
}
