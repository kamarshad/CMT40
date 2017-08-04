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
}

protocol VideoRecordDelegate {
    
    func videoRecordedSuccessfully(recordedSuccessfully: Bool)
}

class RecordVideoWireframeImpl: RecordVideoWireframe {
    
    static func push(_ navigationController: UINavigationController, animated:Bool, fileNameForVideo: String, delegate: VideoRecordDelegate? = nil) {
        let wireframe = RecordVideoWireframeImpl()
        let view = RecordVideoViewController.instantiateFromStoryboard()
        let screenInteractor = RecordVideoScreenInteractorImpl()
        let presenter = RecordVideoPresenter(wireframe: wireframe, screenInteractor: screenInteractor)
        view.presenter = presenter
        
        if navigationController.viewControllers.count>0 {
            navigationController.pushViewController(view, animated: animated)
        }
        else {
            navigationController.viewControllers = [view]
        }
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func goBackToPreviousScreen() {
    
    }
    
}
