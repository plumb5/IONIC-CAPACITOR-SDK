import Foundation

@objc public class Plumb5: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
