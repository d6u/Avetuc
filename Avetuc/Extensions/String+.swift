import Foundation

extension String {

    func substringToIndex(index: Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }

    func substringFromIndex(index: Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }

    func substringBetweenIndexes(begin: Int, _ end: Int) -> String {
        let substring = self.substringToIndex(end)
        return substring.substringFromIndex(begin)
    }
}
