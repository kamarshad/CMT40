

import UIKit

protocol IntroWireframe {
    func pushToNextController ()
}

protocol IntroWireframeDelegate: class {
    func introWireframeDidComplete()
}

class IntroWireframeImpl: Wireframe, IntroWireframe {
    
    fileprivate weak var delegate: IntroWireframeDelegate?

    static func showOnBoardingViewController(inNavigationController navigationController: UINavigationController, delegate:IntroWireframeDelegate) {
        let wireframe = IntroWireframeImpl(navigationController: navigationController)
        
        let firstVC = OnboardingContentViewController.content(withTitle: "What A Beautiful Photo", body: "This city background image is so beautiful.", image: UIImage(named: "blue"), buttonText: "NEXT", action: nil)
        
        let secondVC = OnboardingContentViewController.content(withTitle: "I'm so sorry", body: "I can't get over the nice blurry background photo.", image: UIImage(named: "red"), buttonText: "NEXT", action: nil)
        let thirdVC = OnboardingContentViewController.content(withTitle: "What A Beautiful Photo", body: "This city background image is so beautiful.", image: UIImage(named: "yellow"), buttonText: "DONE") {
            wireframe.delegate?.introWireframeDidComplete()
            wireframe.pushToNextController()
        }
        let onboardingVC = OnboardingViewController.init(backgroundImage: UIImage(named: "street"), contents: [firstVC,secondVC,thirdVC])
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.viewControllers = [onboardingVC!]
        wireframe.delegate = delegate
    }
    
    func pushToNextController () {
        RecordVideoWireframeImpl.push(navigationController, animated: true)
    }

}

