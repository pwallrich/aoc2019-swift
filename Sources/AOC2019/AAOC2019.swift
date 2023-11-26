import ArgumentParser
import AOC2019Core

@main
struct AOC2019: ParsableCommand, AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Runs the AOC for 2022"
    )

    @Argument(help: "The day that should be run (1-25)")
    private var day: Int

    @Argument(help: "The part of the day that should be run (either 1 or 2)")
    private var part: Int

    @Flag(name: [.customShort("t"), .customLong("testInput")])
    private var useTestInput: Bool = false

    func run() async throws {
        print("running AOC2021 day \(day) part \(part). Using Test Input? \(useTestInput)")
        guard 1...25 ~= day  else {
            throw Error.invalidDay
        }
        guard let part = AOC2019Core.Part(rawValue: part) else {
            throw Error.invalidPart
        }
        try await AOC2019Core.AOC2019(testInput: useTestInput).run(day: day, part: part)
    }
}

extension AOC2019 {
    enum Error: Swift.Error {
        case invalidDay
        case invalidPart
    }
}
