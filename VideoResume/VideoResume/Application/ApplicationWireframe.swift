
import Foundation

class ApplicationWireframe: Wireframe {
    
    func showFirstScreen(forLaunchOptions launchOptions: [AnyHashable: Any]?) {
        if ApplicationWireframe.shouldPresentIntro() {
            IntroWireframeImpl.showOnBoardingViewController(inNavigationController: navigationController, delegate:self)
            return
        }
        
        let questionaireVC = QuestionaireViewController.init(nibName: "QuestionaireViewController", bundle: nil)
        navigationController.viewControllers = [questionaireVC]
    }
}

extension ApplicationWireframe {
    
    static func setLoginAsRootViewController() {
    }
}

extension ApplicationWireframe: IntroWireframeDelegate {
   
    func introWireframeDidComplete() {
        ApplicationWireframe.disableIntro()
    }
}

private extension ApplicationWireframe {
    
    // MARK: Intro helper methods
    static let disableIntroKey = UserDefaultConstants.disableIntro.string()
    static func disableIntro() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: disableIntroKey)
        defaults.synchronize()
    }
    
    static func shouldPresentIntro() -> Bool {
        return !UserDefaults.standard.bool(forKey: disableIntroKey)
    }
    
}

