import Foundation

public extension String {
    func trimmingHexPrefix() -> String {
        var str = self
        while str.hasPrefix("0x") {
            str.removeFirst(2)
        }

        return str
    }
}
