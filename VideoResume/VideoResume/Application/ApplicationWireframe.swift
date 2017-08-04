
import Foundation

class ApplicationWireframe: Wireframe {
    
    func showFirstScreen(forLaunchOptions launchOptions: [AnyHashable: Any]?) {
        if ApplicationWireframe.shouldPresentIntro() {
            IntroWireframeImpl.showOnBoardingViewController(inNavigationController: navigationController, delegate:self)
            return
        }
        RecordVideoWireframeImpl.push(navigationController, animated: false)
    }
}

extension ApplicationWireframe {
    
    static func setLoginAsRootViewController() {
        let navigationController = NavigationController()
        RecordVideoWireframeImpl.push(navigationController, animated: false)
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = navigationController
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

