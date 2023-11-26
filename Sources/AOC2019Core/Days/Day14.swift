import Foundation

class Day14: Day {
    var day: Int { 14 }
    let input: [String: Instruction]

    init(testInput: Bool) throws {
        let inputString: String

        if testInput {
//            inputString = """
//10 ORE => 10 A
//1 ORE => 1 B
//7 A, 1 B => 1 C
//7 A, 1 C => 1 D
//7 A, 1 D => 1 E
//7 A, 1 E => 1 FUEL
//"""
//            inputString = """
//9 ORE => 2 A
//8 ORE => 3 B
//7 ORE => 5 C
//3 A, 4 B => 1 AB
//5 B, 7 C => 1 BC
//4 C, 1 A => 1 CA
//2 AB, 3 BC, 4 CA => 1 FUEL
//"""
//            inputString = """
//157 ORE => 5 NZVS
//165 ORE => 6 DCFZ
//44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
//12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
//179 ORE => 7 PSHF
//177 ORE => 5 HKGWZ
//7 DCFZ, 7 PSHF => 2 XJWVT
//165 ORE => 2 GPVTF
//3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
//"""
            inputString = """
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
"""
        } else {
            inputString = try InputGetter.getInput(for: 14, part: .first)
        }
        var input: [String: Instruction] = [:]
        for row in inputString.split(separator: "\n") {
            let in_out = row.split(separator: " => ")
            let inputsStr = in_out[0].split(separator: ", ")
            var inputs: [(Int, String)] = []
            for input in inputsStr {
                let values = input.split(separator: " ")
                inputs.append((Int(String(values[0]))!, String(values[1])))
            }
            let outputStr = in_out[1].split(separator: " ")
            input[String(outputStr[1])] = .init(input: inputs, outputs: (Int(String(outputStr[0]))!, String(outputStr[1])))
        }
        self.input = input
    }

    struct Instruction {
        let input: [(Int, String)]
        let outputs: (Int, String)
    }

    func runPart1() throws {
        build(element: "FUEL", count: 1)
        print(1000000000000 - material["ORE"]!)
    }

    struct LeftoverKey: Hashable {
        let val: [String: UInt64]
    }
    func runPart2() throws {
        build(element: "FUEL", count: 1)
        let neededForOne = 1000000000000 - material["ORE"]!
        var lowerBound = 1000000000000 / Int(neededForOne)
        var upperBound = 1000000000000
        var idx = (upperBound + lowerBound) / 2
        while lowerBound + 1 < upperBound && idx > 0  {
            print(idx)
            material = ["ORE": 1000000000000]
            if !buildPart2(element: "FUEL", count: Int(idx)) {
                print("we ran out of Ore \(idx)")
                upperBound = idx
            } else {
                lowerBound = idx
            }
            idx = (upperBound + lowerBound) / 2
        }
        if buildPart2(element: "FUEL", count: upperBound) {
            print("RESULT: \(upperBound)")
        } else {
            print("RESULT: \(lowerBound)")
        }
    }

    var material: [String: UInt64] = ["ORE": 1000000000000]

    func build(element: String, count: Int) {

        let recipe = input[element]!
        let iterationsNeeded = (recipe.outputs.0 / count) + recipe.outputs.0 % count == 0 ? 0 : 1
        while true {
            for element in recipe.input {
                while material[element.1] ?? 0 < element.0 * iterationsNeeded {
                    let stillNeeded = element.0 * iterationsNeeded - Int(material[element.1] ?? 0)
                    build(element: element.1, count: stillNeeded)
                }
            }
            let canBuild = recipe.input.filter { material[$0.1] ?? 0 < $0.0 * iterationsNeeded }.count == 0
            if canBuild {
                break
            }
        }
//        print("starting actual build for \(count) \(element)")
        // build
        for element in recipe.input {
            material[element.1]! -= UInt64(element.0 * iterationsNeeded)
            if material[element.1] == 0 {
                material[element.1] = nil
            }
        }
        if element == "FUEL" {
            print()
        }
        material[element, default: 0] += UInt64(recipe.outputs.0 * iterationsNeeded)
    }

    func buildPart2(element: String, count: Int) -> Bool {
        if element == "ORE" {
            // we ran out of ore
            print("we ran out of ore")
            return false
        }
        let recipe = input[element]!
        let iterationsNeeded = count / recipe.outputs.0 + ( count % recipe.outputs.0 == 0 ? 0 : 1)

        while true {
            for element in recipe.input {
                while material[element.1] ?? 0 < element.0 * iterationsNeeded {
                    let stillNeeded = element.0 * iterationsNeeded - Int(material[element.1] ?? 0)
                    if !buildPart2(element: element.1, count: stillNeeded) {
                        return false
                    }
                }
            }
            let canBuild = recipe.input.filter { material[$0.1] ?? 0 < $0.0 * iterationsNeeded }.count == 0
            if canBuild {
                break
            }
        }
//        print("starting actual build for \(count) \(element)")
        // build
        for element in recipe.input {
            material[element.1]! -= UInt64(element.0 * iterationsNeeded)
            if material[element.1] == 0 {
                material[element.1] = nil
            }
        }
        if element == "FUEL" {
            print()
        }
        material[element, default: 0] += UInt64(recipe.outputs.0 * iterationsNeeded)
        return true
    }
}
