
import Foundation
import UIKit

extension UIViewController {
    class func instantiateFromStoryboard() -> Self {
        return self.instantiateFromStoryboard(self)
    }

    fileprivate class func instantiateFromStoryboard<T>(_ type: T.Type) -> T {
        let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")

        let storyboard = UIStoryboard(name: name+"Storyboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: name)
        return vc as! T
    }
}
