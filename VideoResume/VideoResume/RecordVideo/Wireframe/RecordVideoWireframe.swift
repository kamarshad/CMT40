//
//  RecordVideoWireframe.swift
//  VideoResume
//
//  Created by Mohd Kamar on 03/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit

protocol RecordVideoWireframe {

    func goBackToPreviousScreen()
    func goToNextScreen()
}


class RecordVideoWireframeImpl: Wireframe, RecordVideoWireframe {
    
    static func push(_ navigationController: UINavigationController, animated:Bool) {
        let wireframe = RecordVideoWireframeImpl(navigationController: navigationController)
        let view = RecordVideoViewController.instantiateFromStoryboard()
        let screenInteractor = RecordVideoScreenInteractorImpl()
        let presenter = RecordVideoPresenter(wireframe: wireframe, screenInteractor: screenInteractor)
        view.presenter = presenter
        navigationController.pushViewController(view, animated: animated)
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func goBackToPreviousScreen() {
        self.navigationController.popViewController(animated: false)
    }
    
    func goToNextScreen() {
        //Call delegate methods
        self.navigationController.popViewController(animated: true)
    }

}
