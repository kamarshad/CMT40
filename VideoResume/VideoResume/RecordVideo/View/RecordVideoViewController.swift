//
//  ViewController.swift
//  VideoResume
//
//  Created by Mohd Kamar on 03/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit
import MZTimerLabel

class RecordVideoViewController : SwiftyCamViewController {

    fileprivate var captureButton: SwiftyRecordButton!
    fileprivate var flipCameraButton: UIButton!
    fileprivate var cancel: UIButton!
    var presenter: RecordVideoPresenter!

    fileprivate var timer: MZTimerLabel!
    @IBOutlet fileprivate weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUp() {
        self.cameraDelegate = self
        self.maximumVideoDuration = 10 
        self.audioEnabled = true
        self.outputFileName = self.presenter.getOutputFileName()
        self.configureOverylayOptions()
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        self.switchCamera()
    }
    
    @objc private func cancelVideoRecording(_ sender: Any) {
        self.presenter.goBackToPreviousScreen()
    }
    
    fileprivate func configureOverylayOptions() {
        
        self.captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(self.captureButton)
        self.captureButton.delegate = self
        
        self.flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        self.flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        self.flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.flipCameraButton)

        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)

        self.cancel = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 60, height: 30.0))
        self.cancel.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        self.cancel.addTarget(self, action: #selector(cancelVideoRecording(_:)), for: .touchUpInside)
        self.view.addSubview(self.cancel)

        timer = MZTimerLabel(frame: self.timerLabel.frame)
        timer.isHidden = true
        timer.timeFormat = "mm:ss"
        timer.font = UIFont.boldSystemFont(ofSize: 24.0)
        timer.textAlignment = .center
        timer.textColor = UIColor.white
        self.view.addSubview(timer)
        
    }

    fileprivate func showVideoRecoredAlert() {
        
        let title = NSLocalizedString("Alert", comment: "")
        let message = NSLocalizedString("That was the fantastic video if you are not satisfied", comment: "")
        let recordAgainActionTitle = NSLocalizedString("Record Again", comment: "")
        let nextActionTitle = NSLocalizedString("Next", comment: "")

        let alert = UIAlertController (title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: recordAgainActionTitle, style: .default, handler: { (action) in
            self.captureButton.startStopVideoRecording()
        }))
        alert.addAction(UIAlertAction(title: nextActionTitle, style: .default, handler: { (action) in
            self.presenter.goToNextScreen()
        }))
        
        present(alert, animated: true, completion: nil)

    }
}

extension RecordVideoViewController : SwiftyCamViewControllerDelegate {

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        timer.isHidden = false
        self.timer.reset()
        self.timer.start()
        self.captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flipCameraButton.alpha = 0.0
            self.cancel.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        self.captureButton.shrinkButton()
        self.timer.pause()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.flipCameraButton.alpha = 1.0
            self.cancel.alpha = 1.0
            self.showVideoRecoredAlert()
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
   
}
