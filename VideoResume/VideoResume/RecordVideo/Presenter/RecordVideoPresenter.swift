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
    
    func getRecordDTO() -> RecordDTO {
        return RecordDTO(fileName: "Intro")
    }
    
    func goToNextScreen() {
        self.wireframe.goToNextScreen()
    }
    
    func goBackToPreviousScreen() {
        self.wireframe.goBackToPreviousScreen()
    }

}

struct RecordDTO {
   
    var fileName:String
    
    init(fileName:String) {
        self.fileName = fileName
    }

}
