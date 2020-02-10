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
    
    public var lightAdded = false
    
    public let undergroundVid = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let plasticVid = AVPlayer(url: Bundle.main.url(forResource: "Plastic", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let laserVid = AVPlayer(url: Bundle.main.url(forResource: "Laser", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let carNode = SCNScene(named: "art.scnassets/car.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let metrotechNode = SCNScene(named: "art.scnassets/metrotech.scn")!.rootNode.childNodes[0]
    
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
            var modelNode: SCNNode
            switch imageAnchor.referenceImage.name {
            case "Underground":
                vid = self.undergroundVid
                modelNode = self.carNode
            case "Plastic":
                vid = self.plasticVid
                modelNode = self.keyboardNode
                modelNode.scale = SCNVector3(0.01,0.01,0.01)
            case "Laser":
                vid = self.laserVid
                modelNode = self.metrotechNode
            case "Tea":
                vid = self.undergroundVid
                modelNode = self.keyboardNode
                modelNode.scale = SCNVector3(0.2,0.2,0.2)
            case "Dragon":
                vid = self.plasticVid
                modelNode = self.carNode
                modelNode.scale = SCNVector3(10,10,10)
            default:
                return SCNNode()
            }
            
            let vidPlane = SCNPlane(width: max(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01, height: min(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01)
            vidPlane.firstMaterial?.diffuse.contents = vid
            vidPlane.firstMaterial?.lightingModel = .constant
            
            let vidNode = SCNNode(geometry: vidPlane)
            vidNode.eulerAngles.x = -.pi / 2
            vidNode.eulerAngles.y = (imageAnchor.referenceImage.physicalSize.width > imageAnchor.referenceImage.physicalSize.height ? 0 : -.pi/2)
//            vidNode.opacity = 0
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                vid.play()
                vidNode.opacity = 0.01
//            }
            
            /*
             Munged-JjCgeNndsH Imperial-700
             Munged-Nlq6tvqpZ3 Imperial-400
             Munged-teVV8iw7A5 Cheltenham-700
             Munged-c89WsWJ0R2 Cheltenham-400
             */
            
            let title = SCNText(string: "\(imageAnchor.referenceImage.name!)", extrusionDepth: 0.5)
            title.font = UIFont(name: "Munged-teVV8iw7A5", size: 8)
            title.firstMaterial?.diffuse.contents = UIColor.black
            title.flatness = 0.01
            
            let titleNode = SCNNode(geometry: title)
            titleNode.pivot = SCNMatrix4MakeTranslation(titleNode.boundingBox.max.x * 0.5 + titleNode.boundingBox.min.x * 0.5, titleNode.boundingBox.max.y * 0.5 + titleNode.boundingBox.min.y * 0.5, titleNode.boundingBox.max.z * 0.5 + titleNode.boundingBox.min.z * 0.5)
            titleNode.position.z = Float(imageAnchor.referenceImage.physicalSize.height / 2 + 0.02)
            titleNode.eulerAngles.x = -.pi / 2
            titleNode.scale = SCNVector3(0.005, 0.005, 0.005)
            
            let light = SCNLight()
            light.type = .directional
            
            if !self.lightAdded {
                vidNode.light = light
                self.lightAdded = true
            }
            
            node.addChildNode(vidNode)
            node.addChildNode(modelNode)
            node.addChildNode(titleNode)
            
            node.opacity = 0
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if let lightEst = sceneView.session.currentFrame?.lightEstimate {
            node.childNodes[0].light?.intensity = lightEst.ambientIntensity * 0.8
            node.childNodes[0].light?.temperature = lightEst.ambientColorTemperature
        }
            
//        node.childNodes[1].eulerAngles.x = -node.eulerAngles.x
//        node.childNodes[1].eulerAngles.y = -node.eulerAngles.y
//        node.childNodes[1].eulerAngles.z = -node.eulerAngles.z
        
        if let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
            if (anchor as? ARImageAnchor == nil) {
                vid.pause()
                vid.seek(to: .zero)
            } else {
//                if let parentNode = node.parent {
//                    for siblingNode in parentNode.childNodes {
//                        let size = (anchor as! ARImageAnchor).referenceImage.physicalSize
//                        if let siblingAnchor = sceneView.anchor(for: siblingNode) as? ARImageAnchor, let siblingSize = (sceneView.anchor(for: siblingNode) as? ARImageAnchor)?.referenceImage.physicalSize, !siblingAnchor.isTracked && (anchor as! ARImageAnchor).isTracked && siblingNode.opacity != 0 && (pow(siblingNode.position.x - node.position.x, 2.0) + pow(siblingNode.position.z - node.position.z, 2.0)) <= Float(pow(size.width / 2 + siblingSize.width / 2, 2.0) + pow(size.height / 2 + siblingSize.height / 2, 2.0)) + 0.01 {
//                            siblingNode.opacity -= 0.035
//                            if let siblingVid = siblingNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer, siblingVid.rate != 0 {
//                                siblingVid.pause()
//                                siblingVid.seek(to: .zero)
//                            }
//                        }
//                    }
//                }
                
//                let d = simd_distance(node.simdTransform.columns.3, cam.transform.columns.3)
//                let w = Float((anchor as! ARImageAnchor).referenceImage.physicalSize.width) * 1.01
//
//                node.childNodes[1].position.y = (w + 0.1) / 2 * sin(atan(w / d))
//                node.childNodes[2].position.y = (w + 0.1) / 2 * sin(atan(w / d))
//                node.childNodes[1].position.x = (w + 0.1) / 2 * (-cos(atan(w / d)) - 1)
//                node.childNodes[2].position.x = (w + 0.1) / 2 * (cos(atan(w / d)) + 1)
//                node.childNodes[1].eulerAngles.x = -.pi / 2
//                node.childNodes[2].eulerAngles.x = -.pi / 2
//                node.childNodes[1].eulerAngles.z = -atan(w / d)
//                node.childNodes[2].eulerAngles.z = atan(w / d)
                
                if renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) {
                    if vid.rate == 0 && vid.currentTime() == CMTime.zero && node.opacity == 0 {
                        node.childNodes[0].opacity = 0.01
                        node.opacity = 0
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            vid.play()
//                            node.childNodes[0].opacity = 0.01
//                        }
//                    } else {
//                        vid.play()
                    }
                    
                    if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 1 {
                        node.childNodes[0].opacity += 0.035
                        node.opacity = node.childNodes[0].opacity
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let anchors = sceneView.session.currentFrame?.anchors {
            for anchor in anchors where (anchor as? ARImageAnchor) != nil {
                if let node = sceneView.node(for: anchor), let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer, node.opacity == 1 {
                    if let cam = sceneView.session.currentFrame?.camera {
                        if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) > 0.8 {
                            if vid.rate != 0 {
                                vid.pause()
                            }
                            for i in 0..<node.childNodes.count {
                                if node.childNodes[i].opacity < 1 {
                                    node.childNodes[i].opacity += 0.035
                                }
                            }
                        } else if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) < 0.2 {
//                        } else if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) < Float(max((anchor as! ARImageAnchor).referenceImage.physicalSize.height, (anchor as! ARImageAnchor).referenceImage.physicalSize.width) / 2 + 0.02) {
                            if vid.rate != 0 {
                                vid.pause()
                            }
                            for i in 0..<node.childNodes.count {
                                if node.childNodes[i].opacity > 0 {
                                    node.childNodes[i].opacity -= 0.05
                                }
                            }
                        } else {
                            if vid.rate == 0 && renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!){
                                vid.play()
                            } else if vid.rate != 0 && !renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) {
                                vid.pause()
                                vid.seek(to: .zero)
                            }
                            for i in 0..<node.childNodes.count {
                                if node.childNodes[i].opacity < 1 {
                                    node.childNodes[i].opacity += 0.035
                                }
                            }
                        }
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
