
import Foundation
import UIKit

class Wireframe: NSObject {

    fileprivate(set) weak var navigationController: UINavigationController!

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

}
