import Foundation

// TODO: Introduce Pattern super-protocol?
// TODO: Maybe `replace` should be a string extension?
// TODO: Try to make similar to DatePattern
// TODO: Add isMatching

// https://jayeshkawli.ghost.io/regular-expressions-in-swift-ios/

public struct RegExp: StringPattern {    
    private let nsRegExp: NSRegularExpression
    // private let options: NSRegularExpression.Options

    public init(_ pattern: String) {
        do {
            nsRegExp = try NSRegularExpression(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    public func matches(in string: String) -> [StringMatch] {
        let results = nsRegExp.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        return results.map { result in
            let range = Range(result.range, in: string)!
            return StringMatch(value: String(string[range]), range: range)
        }
    }

    public func replace(in string: String, handler: (StringMatch) -> String?) -> String {
        var string = string
        
        matches(in: string).reversed().forEach { match in
            if let replacement = handler(match) {
                string = string.replacingCharacters(in: match.range, with: replacement)
            }
        }
        
        return string
    } 
}
