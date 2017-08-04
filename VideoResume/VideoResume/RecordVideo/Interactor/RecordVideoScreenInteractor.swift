//
//  RecordVideoScreenInteractor.swift
//  VideoResume
//
//  Created by Mohd Kamar on 03/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit

protocol RecordVideoScreenInteractor {

    func getVideoFileName() -> String
}

class RecordVideoScreenInteractorImpl: RecordVideoScreenInteractor {
    
    fileprivate var fileName:String
    
    init(name:String) {
        self.fileName = name
    }
    
    func getVideoFileName() -> String {
        return self.fileName
    }
}
