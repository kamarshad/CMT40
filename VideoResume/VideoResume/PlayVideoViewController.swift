
import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playVideo()
    }
    
    fileprivate func doSetUp() {
        self.view.backgroundColor = UIColor.gray
        
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = true
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame

        //NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)

        let shareVideo = UIButton(frame: CGRect(x: self.view.frame.width-60, y: 10.0, width: 40.0, height: 30.0))
        shareVideo.setImage(#imageLiteral(resourceName: "shareIcon"), for: UIControlState())
        shareVideo.addTarget(self, action: #selector(shareResume), for: .touchUpInside)
        view.addSubview(shareVideo)

    }

    func playVideo() {
        player?.play()
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
    
    func shareResume() {
        let sharableObject = [self.videoURL]
        let activityVC = UIActivityViewController(activityItems: sharableObject, applicationActivities: nil)
        activityVC.setValue("Video", forKey: "subject")
        
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]
        self.present(activityVC, animated: true, completion: nil)
    }
}
