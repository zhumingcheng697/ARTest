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
        sceneView.showsStatistics = false
        
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
            
            let vidPlane = SCNPlane(width: max(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01, height: min(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01)
            vidPlane.firstMaterial?.diffuse.contents = vid
            vid.volume = 0
            
            let vidNode = SCNNode(geometry: vidPlane)
            vidNode.eulerAngles.x = -.pi / 2
            vidNode.eulerAngles.y = (imageAnchor.referenceImage.physicalSize.width > imageAnchor.referenceImage.physicalSize.height ? 0 : -.pi/2)
            vidNode.opacity = 0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                vid.play()
                vidNode.opacity = 0.01
            }
            
            let imgPlaneUp = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            imgPlaneUp.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)_")
            let imgPlaneDown = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            imgPlaneDown.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)")
//            let imgPlaneLeft = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
//            imgPlaneLeft.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)_")
//            let imgPlaneRight = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
//            imgPlaneRight.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)")
            
            let imgNodeUp = SCNNode(geometry: imgPlaneUp)
            let imgNodeDown = SCNNode(geometry: imgPlaneDown)
//            let imgNodeLeft = SCNNode(geometry: imgPlaneLeft)
//            let imgNodeRight = SCNNode(geometry: imgPlaneUp)
            
            node.addChildNode(vidNode)
            node.addChildNode(imgNodeUp)
            node.addChildNode(imgNodeDown)
//            node.addChildNode(imgNodeLeft)
//            node.addChildNode(imgNodeRight)
            
            node.opacity = 0
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        if let currentVid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
            if (anchor as? ARImageAnchor == nil) || !(anchor as? ARImageAnchor)!.isTracked {
                currentVid.pause()
                currentVid.seek(to: .zero)
            } else {
                let dist = sqrt(pow(anchor.transform.columns.3[0], 2.0) + pow(anchor.transform.columns.3[1], 2.0) + pow(anchor.transform.columns.3[2], 2.0))
                let h = Float((anchor as! ARImageAnchor).referenceImage.physicalSize.height) * 1.01
                node.childNodes[1].position.y = (h + 0.01) / 2 * sin(atan(h / dist))
                node.childNodes[2].position.y = (h + 0.01) / 2 * sin(atan(h / dist))
                node.childNodes[1].position.z = (h + 0.01) / 2 * (-cos(atan(h / dist)) - 1)
                node.childNodes[2].position.z = (h + 0.01) / 2 * (cos(atan(h / dist)) + 1)
                node.childNodes[1].eulerAngles.x = -.pi / 2 + atan(h / dist)
                node.childNodes[2].eulerAngles.x = -.pi / 2 - atan(h / dist)

                if currentVid.rate == 0 {
                    node.childNodes[0].opacity = 0
                    node.opacity = 0
                    currentVid.volume = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        currentVid.play()
                        node.childNodes[0].opacity = 0.01
                    }
                } else if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 1 {
                    node.childNodes[0].opacity += 0.035
                    node.opacity = node.childNodes[0].opacity
                    currentVid.volume = Float(node.childNodes[0].opacity)
                }
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
