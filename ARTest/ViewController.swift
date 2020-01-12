//
//  ViewController.swift
//  ARTest
//
//  Created by McCoy Zhu on 1/10/20.
//  Copyright © 2020 McCoy Zhu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    public let undergroundVid = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let plasticVid = AVPlayer(url: Bundle.main.url(forResource: "Plastic", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let laserVid = AVPlayer(url: Bundle.main.url(forResource: "Laser", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        for vid in [self.undergroundVid, self.plasticVid, self.laserVid] {
            loopVideo(videoPlayer: vid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main)!
        
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 3
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            var vid: AVPlayer
            switch imageAnchor.referenceImage.name {
            case "Underground":
                vid = self.undergroundVid
            case "Plastic":
                vid = self.plasticVid
            case "Laser":
                vid = self.laserVid
            default:
                return SCNNode()
            }
            
            let imagePlane = SCNPlane(width: max(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01, height: min(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01)
            imagePlane.firstMaterial?.diffuse.contents = vid
            vid.play()
            vid.volume = 0
            
            let imageNode = SCNNode(geometry: imagePlane)
            imageNode.eulerAngles.x = -.pi / 2
            imageNode.eulerAngles.y = (imageAnchor.referenceImage.physicalSize.width > imageAnchor.referenceImage.physicalSize.height ? 0 : -.pi/2)
            imageNode.opacity = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                vid.seek(to: .zero)
                vid.volume = 1
                imageNode.opacity = 0.01
            }
            
            node.addChildNode(imageNode)
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        if let currentVid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
            if (anchor as? ARImageAnchor == nil) || !(anchor as? ARImageAnchor)!.isTracked {
                currentVid.pause()
                currentVid.seek(to: .zero)
            } else if currentVid.rate == 0 {
                node.childNodes[0].opacity = 0
                currentVid.play()
                currentVid.volume = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    currentVid.seek(to: .zero)
                    currentVid.volume = 1
                    node.childNodes[0].opacity = 0.01
                }
            } else if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 1 {
                node.childNodes[0].opacity += 0.035
            }
        }
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        for vid in [self.undergroundVid, self.plasticVid, self.laserVid] {
            if vid.rate != 0 {
                vid.pause()
            }
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
