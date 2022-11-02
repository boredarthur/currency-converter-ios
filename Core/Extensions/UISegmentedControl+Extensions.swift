import UIKit

extension UISegmentedControl {

    func replaceSegments(with segments: Array<CurrencyItemModel>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(with: segment.image, at: self.numberOfSegments, animated: false)
        }
    }
}
