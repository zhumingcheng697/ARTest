//
//  ViewControllerWorld.swift
//  ARTest
//
//  Created by McCoy Zhu on 1/10/20.
//  Copyright © 2020 McCoy Zhu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewControllerWorld: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    public let undergroundVid = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let plasticVid = AVPlayer(url: Bundle.main.url(forResource: "Plastic", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let laserVid = AVPlayer(url: Bundle.main.url(forResource: "Laser", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let carNode = SCNScene(named: "art.scnassets/car.scn")!.rootNode.childNodes[0]
    
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
        let configuration = ARWorldTrackingConfiguration()
        let detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main)!
        
        configuration.detectionImages = detectionImages
        configuration.maximumNumberOfTrackedImages = 3
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for vid in [self.undergroundVid, self.plasticVid, self.laserVid] {
            if vid.rate != 0 {
                vid.pause()
                vid.seek(to: .zero)
            }
        }
        
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
            case "Wall":
                vid = self.undergroundVid
            case "Subway Map":
                vid = self.undergroundVid
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
            
            let imgPlane1 = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            imgPlane1.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)_")
            let imgPlane2 = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            imgPlane2.firstMaterial?.diffuse.contents = UIImage(named: "\(imageAnchor.referenceImage.name!)")
            
            let imgNode1 = SCNNode(geometry: imgPlane1)
            let imgNode2 = SCNNode(geometry: imgPlane2)
            
            node.addChildNode(vidNode)
            node.addChildNode(imgNode1)
            node.addChildNode(imgNode2)
            node.addChildNode(self.carNode)
            
            node.opacity = 0
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        if let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
            if (anchor as? ARImageAnchor == nil) {
                vid.pause()
                vid.seek(to: .zero)
            } else {
                if let parentNode = node.parent {
                    for siblingNode in parentNode.childNodes {
                        let size = (anchor as! ARImageAnchor).referenceImage.physicalSize
                        if let siblingAnchor = sceneView.anchor(for: siblingNode) as? ARImageAnchor, let siblingSize = (sceneView.anchor(for: siblingNode) as? ARImageAnchor)?.referenceImage.physicalSize, !siblingAnchor.isTracked && (anchor as! ARImageAnchor).isTracked && siblingNode.opacity != 0 && (pow(siblingNode.position.x - node.position.x, 2.0) + pow(siblingNode.position.z - node.position.z, 2.0)) <= Float(pow(size.width / 2 + siblingSize.width / 2, 2.0) + pow(size.height / 2 + siblingSize.height / 2, 2.0)) {
                            siblingNode.opacity -= 0.035
                            if let siblingVid = siblingNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer, siblingVid.rate != 0 {
                                siblingVid.pause()
                                siblingVid.seek(to: .zero)
                            }
                        }
                    }
                }
                
                if let cam = sceneView.session.currentFrame?.camera {                
                    let d = simd_distance(node.simdTransform.columns.3, cam.transform.columns.3)
                    let w = Float((anchor as! ARImageAnchor).referenceImage.physicalSize.width) * 1.01
                    
                    node.childNodes[1].position.y = (w + 0.1) / 2 * sin(atan(w / d))
                    node.childNodes[2].position.y = (w + 0.1) / 2 * sin(atan(w / d))
                    node.childNodes[1].position.x = (w + 0.1) / 2 * (-cos(atan(w / d)) - 1)
                    node.childNodes[2].position.x = (w + 0.1) / 2 * (cos(atan(w / d)) + 1)
                    node.childNodes[1].eulerAngles.x = -.pi / 2
                    node.childNodes[2].eulerAngles.x = -.pi / 2
                    node.childNodes[1].eulerAngles.z = -atan(w / d)
                    node.childNodes[2].eulerAngles.z = atan(w / d)
                }
                
                if vid.rate == 0 && renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) {
                    if vid.currentTime() == CMTime.zero {
                        node.childNodes[0].opacity = 0
                        node.opacity = 0
                        vid.volume = 0
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            vid.play()
                            node.childNodes[0].opacity = 0.01
                        }
                    } else {
                        vid.play()
                    }
                } else if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 1 {
                    node.childNodes[0].opacity += 0.035
                    node.opacity = node.childNodes[0].opacity
                    vid.volume = Float(node.childNodes[0].opacity)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let anchors = sceneView.session.currentFrame?.anchors {
            for anchor in anchors where (anchor as? ARImageAnchor) != nil {
                if !(anchor as! ARImageAnchor).isTracked, let node = sceneView.node(for: anchor), let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer, node.opacity == 1 {
                    if renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) && vid.rate == 0 {
                        vid.play()
                    } else if !renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) && vid.rate != 0 {
                        vid.pause()
                        vid.seek(to: .zero)
                    }
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
