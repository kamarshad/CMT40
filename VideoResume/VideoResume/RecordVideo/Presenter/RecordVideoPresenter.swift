//
//  RecordVideoPresenter.swift
//  VideoResume
//
//  Created by Mohd Kamar on 03/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit

class RecordVideoPresenter: NSObject {

    fileprivate var screenInteractor : RecordVideoScreenInteractor
    fileprivate var wireframe : RecordVideoWireframe
    
    init(wireframe: RecordVideoWireframe, screenInteractor:RecordVideoScreenInteractor) {
        self.screenInteractor = screenInteractor
        self.wireframe = wireframe
    }
}
