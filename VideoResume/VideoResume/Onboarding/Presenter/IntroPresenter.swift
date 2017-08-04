
import UIKit

class IntroPresenter: Presenter {

    fileprivate weak var view: IntroViewAdapter?
    fileprivate let wireframe: IntroWireframe
    fileprivate let screenInteractor: IntroScreenInteractor

    init(view: IntroViewAdapter, wireframe: IntroWireframe, screenInteractor: IntroScreenInteractor) {
        self.view = view
        self.wireframe = wireframe
        self.screenInteractor = screenInteractor
        super.init()
    }
    
}
