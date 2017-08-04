//
//  QuestionaireViewController.swift
//  VideoResume
//
//  Created by Ashish Chopra on 04/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit

class QuestionaireViewController: UIViewController, VideoRecordDelegate {

    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var btnGoToNextScreen: UIButton!
    
    var counter: Int = 0
    let questionArray = ["Tell us something about yourself?", "Tell us something about your educational background?", "Tell us something about your professional background?", "Tell us something about your skill set?", "Tell us something about your achievements?"]
    let allVideosRecorded = "Yay!! Thanks for recording all the videos"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if counter < 5 {
            self.QuestionLabel.text = questionArray[counter]
            self.btnGoToNextScreen.setTitle("Lets record!", for: .normal)
        } else {
            self.QuestionLabel.text = allVideosRecorded
            self.btnGoToNextScreen.setTitle("Create my video resume!", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goToNextScreen(_ sender: Any) {
        if counter < 5 {
            //Go to recording screen with data
            let videoCounterText = String(counter+1)
            let videoFileName = "Video"+videoCounterText
            RecordVideoWireframeImpl.push(navigationController!, animated: true, fileNameForVideo: videoFileName, delegate: self)
        } else {
        
            //Go to video merging screen
        }
    }
    
    func videoRecordedSuccessfully(recordedSuccessfully: Bool) {
        
        if recordedSuccessfully {
            counter = counter + 1
        }
    }

}
