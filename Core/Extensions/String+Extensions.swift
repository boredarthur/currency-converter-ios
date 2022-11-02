import Foundation

extension String {

    var number: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
    }

    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self).isSubset(of: nums)
    }

    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
