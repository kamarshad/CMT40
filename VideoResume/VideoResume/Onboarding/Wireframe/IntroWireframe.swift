

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
        
        let firstVC = OnboardingContentViewController.content(withTitle: "Get ready to create most fascinationating Video Resume", body: "", image: UIImage(named: "blue"), buttonText: "NEXT", action: nil)
        
        let secondVC = OnboardingContentViewController.content(withTitle: "You will be asked few questions for which you need to record a video of yours", body: "", image: UIImage(named: "red"), buttonText: "NEXT", action: nil)
        let thirdVC = OnboardingContentViewController.content(withTitle: "I am ready to create my Video Resume", body: "", image: UIImage(named: "yellow"), buttonText: "DONE") {
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

