import Foundation

extension String {

    func substringToIndex(index: Int) -> String {
        return self.substringToIndex(advance(self.startIndex, index))
    }

    func substringFromIndex(index: Int) -> String {
        return self.substringFromIndex(advance(self.startIndex, index))
    }

    func substringBetweenIndexes(begin: Int, _ end: Int) -> String {
        let substring = self.substringToIndex(end)
        return substring.substringFromIndex(begin)
    }
}
