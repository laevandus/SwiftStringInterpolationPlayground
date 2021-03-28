import UIKit

// MARK: Entry Storage

struct EntryStorage {
    private(set) var entries: [Entry] = []
    
    mutating func add(_ entry: Entry) {
        entries.append(entry)
    }
}

struct Entry: ExpressibleByStringInterpolation {
    // typealias StringInterpolation = EntryInterpolation
    
    private(set) var value: String
    
    init(stringLiteral value: String) {
        self.value = value
    }
    
    init(stringInterpolation: EntryInterpolation) {
        self.value = stringInterpolation.values.joined()
    }
}

// MARK: Custom Interpolation Type

struct EntryInterpolation: StringInterpolationProtocol {
    private(set) var values: [String]
    
    init(literalCapacity: Int, interpolationCount: Int) {
        self.values = []
    }
    
    mutating func appendLiteral(_ literal: StringLiteralType) {
        values.append(literal)
    }
}

var entryStorage = EntryStorage()
entryStorage.add("Entry 1")

// MARK: CustomStringConvertible

extension EntryInterpolation {
    mutating func appendInterpolation<T: CustomStringConvertible>(_ value: T) {
        values.append(value.description)
    }
}

let index = 2
let items = ["Item 1", "Item 2"]
entryStorage.add("Entry \(index): items=\(items)")

// MARK: JSON

extension EntryInterpolation {
    mutating func appendInterpolation<T: Encodable>(_ value: T, jsonFormat: JSONEncoder.OutputFormatting = [.prettyPrinted, .sortedKeys]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = jsonFormat
        let data = try? encoder.encode(value)
        values.append(String(data: data ?? Data(), encoding: .utf8) ?? "invalid")
    }
}

struct User: Encodable {
    let name: String
    let age: Int
}
let user = User(name: "Appleseed", age: 20)
entryStorage.add("Entry 3: \(user, jsonFormat: .prettyPrinted)")
entryStorage.add("Entry 3: \(user, jsonFormat: .sortedKeys)")

// MARK: Entry to String

print(entryStorage.entries.map(\.value).joined(separator: "\n"))
