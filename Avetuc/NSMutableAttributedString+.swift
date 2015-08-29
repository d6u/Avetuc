import Foundation

extension NSMutableAttributedString {

    func replaceOccurrencesOfString(target: String, withString replacement: String) -> Int {
        return self.mutableString.replaceOccurrencesOfString(target,
            withString: replacement,
            options: nil,
            range: NSMakeRange(0, self.mutableString.length))
    }

}
