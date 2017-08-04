//
//  MergeVideoController.swift
//  VideoResume
//
//  Created by LC-NikhilLihla on 04/08/17.
//  Copyright © 2017 Mohd Kamar Shad. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AssetsLibrary
import MediaPlayer
import CoreMedia

class MergeVideoController: NSObject {
    
    var firstAsset: AVAsset?
    var secondAsset: AVAsset?
    var thirdAsset: AVAsset?
    var fourthAsset: AVAsset?
    var fifthAsset: AVAsset?

    //        var audioAsset: AVAsset?
    //    var loadingAssetOne = false
    
    override init() {
        super.init()
        // Do any additional setup after loading the view.
        
        let tempDirectoryPath = NSTemporaryDirectory()
        
        self.firstAsset = AVAsset(url: URL(fileURLWithPath: tempDirectoryPath.appending("/Video1.mov")))
        self.secondAsset = AVAsset(url: URL(fileURLWithPath: tempDirectoryPath.appending("/Video2.mov")))
        self.thirdAsset = AVAsset(url: URL(fileURLWithPath: tempDirectoryPath.appending("/Video3.mov")))
        self.fourthAsset = AVAsset(url: URL(fileURLWithPath: tempDirectoryPath.appending("/Video4.mov")))
        self.fifthAsset = AVAsset(url: URL(fileURLWithPath: tempDirectoryPath.appending("/Video5.mov")))
    }
    
    
    func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
        var assetOrientation = UIImageOrientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
    func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let assetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let transform = assetTrack.preferredTransform
        let assetInfo = orientationFromTransform(transform: transform)
        
        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
        if assetInfo.isPortrait {
            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                     at: kCMTimeZero)
        } else {
            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
            if assetInfo.orientation == .down {
                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi))
                let windowBounds = UIScreen.main.bounds
                let yFix = assetTrack.naturalSize.height + windowBounds.height
                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
            }
            instruction.setTransform(concat, at: kCMTimeZero)
        }
        
        return instruction
    }
    
    func merge(sender: AnyObject?, completionHandler: @escaping (_ videoURL: URL) -> ()) {
        if let firstAsset = firstAsset, let secondAsset = secondAsset {
            //            activityMonitor.startAnimating()
            
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            let mixComposition = AVMutableComposition()
            
            // 2 - Create two video tracks
            let firstTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                try firstTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, (self.firstAsset?.duration)!), of: (self.firstAsset?.tracks(withMediaType: AVMediaTypeVideo)[0])!, at: kCMTimeZero)
            } catch {
                print("Failed to load first track")
            }
            
            let secondTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                try secondTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, (self.secondAsset?.duration)!), of: (self.secondAsset?.tracks(withMediaType: AVMediaTypeVideo)[0])!, at: (self.firstAsset?.duration)!)
            } catch {
                print("Failed to load first track")
            }
            
            // 2 - Create two video tracks
            let thirdTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            do {
                try thirdTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, (self.thirdAsset?.duration)!), of: (self.thirdAsset?.tracks(withMediaType: AVMediaTypeVideo)[0])!, at: CMTimeAdd(firstAsset.duration, secondAsset.duration))
            } catch {
                print("Failed to load first track")
            }
            
            let fourthTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let timeForThird = CMTimeAdd(firstAsset.duration, secondAsset.duration)
            do {
                try fourthTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, (self.fourthAsset?.duration)!), of: (self.fourthAsset?.tracks(withMediaType: AVMediaTypeVideo)[0])!, at: CMTimeAdd(timeForThird, thirdAsset!.duration))
            } catch {
                print("Failed to load first track")
            }
            
            let fifthTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let timeForFourth = CMTimeAdd(timeForThird, (thirdAsset?.duration)!)
            do {
                try fifthTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, (self.fifthAsset?.duration)!), of: (self.fifthAsset?.tracks(withMediaType: AVMediaTypeVideo)[0])!, at: CMTimeAdd(timeForFourth, fourthAsset!.duration))
            } catch {
                print("Failed to load first track")
            }
            
            
            let totalTime = CMTimeAdd(timeForFourth, (fifthAsset?.duration)!)
            
            // 2.1
            let mainInstruction = AVMutableVideoCompositionInstruction()
            mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, totalTime)
            
            
            // 2.2
            let firstInstruction = videoCompositionInstructionForTrack(track: firstTrack, asset: firstAsset)
            firstInstruction.setOpacity(0.0, at: firstAsset.duration)
            let secondInstruction = videoCompositionInstructionForTrack(track: secondTrack, asset: secondAsset)
            let thirdInstruction = videoCompositionInstructionForTrack(track: thirdTrack, asset: thirdAsset!)
            let fourthInstruction = videoCompositionInstructionForTrack(track: fourthTrack, asset: fourthAsset!)
            let fifthInstruction = videoCompositionInstructionForTrack(track: fifthTrack, asset: fifthAsset!)
            
            // 2.3
            mainInstruction.layerInstructions = [firstInstruction, secondInstruction, thirdInstruction, fourthInstruction, fifthInstruction]
            let mainComposition = AVMutableVideoComposition()
            mainComposition.instructions = [mainInstruction]
            mainComposition.frameDuration = CMTimeMake(1, 30)
            mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            //            CMTimeAdd(firstAsset.duration, secondAsset.duration)
            // 3 - Audio track
            if let loadedAudioAsset = self.firstAsset {
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: 0)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, firstAsset.duration),
                                                   of: loadedAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                                   at: kCMTimeZero)
                } catch _ {
                    print("Failed to load Audio track")
                }
            }
            
            // 3.1 - Audio track
            if let loadedAudioAsset = self.secondAsset {
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: 0)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(firstAsset.duration, secondAsset.duration),
                                                   of: loadedAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                                   at: firstAsset.duration)
                } catch _ {
                    print("Failed to load Audio track")
                }
            }
            
            // 3.2 - Audio track
            if let loadedAudioAsset = self.thirdAsset {
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: 0)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(CMTimeAdd(firstAsset.duration, secondAsset.duration), (thirdAsset?.duration)!),
                                                   of: loadedAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                                   at: CMTimeAdd(firstAsset.duration, secondAsset.duration))
                } catch _ {
                    print("Failed to load Audio track")
                }
            }
            
            // 3.3 - Audio track
            if let loadedAudioAsset = self.fourthAsset {
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: 0)
                let newTime = CMTimeAdd(timeForThird, (thirdAsset?.duration)!)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(newTime, (fourthAsset?.duration)!),
                                                   of: loadedAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                                   at: newTime)
                } catch _ {
                    print("Failed to load Audio track")
                }
            }
            
            // 3.4 - Audio track
            if let loadedAudioAsset = self.fifthAsset {
                let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: 0)
                let newTime = CMTimeAdd(timeForThird, (thirdAsset?.duration)!)
                let newTime1 = CMTimeAdd(newTime, (fourthAsset?.duration)!)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(newTime1, (fifthAsset?.duration)!),
                                                   of: loadedAudioAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                                   at: newTime1)
                } catch _ {
                    print("Failed to load Audio track")
                }
            }
            
            
            // 4 - Get path
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
//            let date = dateFormatter.string(from: NSDate() as Date)
            let randomNumber = arc4random_uniform(100)
            let savePath = (documentDirectory as NSString).appendingPathComponent("mergeVideo\(String(randomNumber)).mov")
            let url = NSURL(fileURLWithPath: savePath)
            
            print("SavePath : \(savePath)")
            
            // 5 - Create Exporter
            guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
            exporter.outputURL = url as URL
            exporter.outputFileType = AVFileTypeQuickTimeMovie
            exporter.shouldOptimizeForNetworkUse = true
            exporter.videoComposition = mainComposition
            
            // 6 - Perform the Export
            //            exporter.exportAsynchronouslyWithCompletionHandler() {
            //                dispatch_async(dispatch_get_main_queue()) { _ in
            //                    self.exportDidFinish(exporter)
            //                }
            //            }
            
            exporter.exportAsynchronously(completionHandler: {
                print("video saved at path: \(savePath)")
                
                completionHandler(videoURL: url)
//                
//                self.firstAsset = nil
//                self.secondAsset = nil
//                self.thirdAsset = nil
//                self.fourthAsset = nil
//                self.fifthAsset = nil
            })
        }
    }
    
    //    func exportDidFinish(session: AVAssetExportSession) {
    //        if session.status == AVAssetExportSessionStatus.completed {
    //            let outputURL = session.outputURL
    //            let library = ALAssetsLibrary()
    //            if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: outputURL) {
    //                library.writeVideoAtPathToSavedPhotosAlbum(outputURL,
    //                                                           completionBlock: { (assetURL:NSURL!, error:NSError!) -> Void in
    //                                                            var title = ""
    //                                                            var message = ""
    //                                                            if error != nil {
    //                                                                title = "Error"
    //                                                                message = "Failed to save video"
    //                                                            } else {
    //                                                                title = "Success"
    //                                                                message = "Video saved"
    //                                                            }
    //                                                            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    //                                                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
    //                                                            self.presentViewController(alert, animated: true, completion: nil)
    //                })
    //            }
    //        }
    //
    ////        activityMonitor.stopAnimating()
//            firstAsset = nil
//            secondAsset = nil
//            audioAsset = nil
    //    }
}
