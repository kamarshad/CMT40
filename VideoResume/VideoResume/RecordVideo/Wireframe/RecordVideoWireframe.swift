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

protocol VideoRecordDelegate {
    
    func videoRecordedSuccessfully(recordedSuccessfully: Bool)
}

class RecordVideoWireframeImpl: Wireframe, RecordVideoWireframe {
    fileprivate var delegate:VideoRecordDelegate?
    
    static func push(_ navigationController: UINavigationController, animated:Bool, fileNameForVideo: String, delegate: VideoRecordDelegate? = nil) {
        let wireframe = RecordVideoWireframeImpl(navigationController: navigationController)
        wireframe.delegate = delegate
        let view = RecordVideoViewController.instantiateFromStoryboard()
        let screenInteractor = RecordVideoScreenInteractorImpl(name: fileNameForVideo)
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
        self.delegate?.videoRecordedSuccessfully(recordedSuccessfully: true)
        self.navigationController.popViewController(animated: true)
    }

}
