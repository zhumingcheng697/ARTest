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
    
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    public let undergroundVid = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
     public let undergroundVid0 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let undergroundVid1 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let undergroundVid2 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let undergroundVid3 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let undergroundVid4 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let undergroundVid5 = AVPlayer(url: Bundle.main.url(forResource: "Underground", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let plasticVid = AVPlayer(url: Bundle.main.url(forResource: "Plastic", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let laserVid = AVPlayer(url: Bundle.main.url(forResource: "Laser", withExtension: "mov", subdirectory: "art.scnassets")!)
    
    public let restaurantVid1 = AVPlayer(url: Bundle.main.url(forResource: "Contemporary_Restaurant_1", withExtension: "mp4", subdirectory: "art.scnassets")!)
    
    public let restaurantVid2 = AVPlayer(url: Bundle.main.url(forResource: "Contemporary_Closing_1", withExtension: "mp4", subdirectory: "art.scnassets")!)
    
    public let carNode = SCNScene(named: "art.scnassets/car.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode0 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode1 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode2 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode3 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode4 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let keyboardNode5 = SCNScene(named: "art.scnassets/keyboard.scn")!.rootNode.childNodes[0]
    
    public let metrotechNode = SCNScene(named: "art.scnassets/metrotech.scn")!.rootNode.childNodes[0]
    
    public let tuxedoNode = SCNScene(named: "art.scnassets/tuxedo_v10.scn")!.rootNode.childNodes[0]
    
    public let tuxedoNode0 = SCNScene(named: "art.scnassets/tuxedo_v10.scn")!.rootNode.childNodes[0]
    
    public let tuxedoNode1 = SCNScene(named: "art.scnassets/tuxedo_v10.scn")!.rootNode.childNodes[0]
    
    public let tunnelNode = SCNScene(named: "art.scnassets/tunnel.scn")!.rootNode.childNodes[0]
    
    public var modelNodes = [SCNNode]()
    
    public var historicNodes = [SCNNode]()
    
    public var contemporaryNodes = [SCNNode]()
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    func switchMode(withTransition: Bool = true) {
        if withTransition {
            switch self.modeSelector.selectedSegmentIndex {
            case 0:
                for node in self.modelNodes {
                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.5))
                    }
                }
                for node in self.historicNodes {
                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: 0.1, z: 0, duration: 0.5))
                    }
                }
                for node in self.contemporaryNodes {
                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.5))
                    }
                }
            case 2:
                for node in self.modelNodes {
                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.5))
                    }
                }
                for node in self.historicNodes {
                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.5))
                    }
                }
                for node in self.contemporaryNodes {
                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: 0.1, z: 0, duration: 0.5))
                    }
                }
            default:
                for node in self.modelNodes {
                    if node.opacity < 0.01 {
                        node.runAction(.fadeIn(duration: 0.5))
                    }
                }
                for node in self.historicNodes {
                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.5))
                    }
                }
                for node in self.contemporaryNodes {
                    if node.opacity > 0.99 {
                        node.runAction(.fadeOut(duration: 0.5))
                        node.runAction(.moveBy(x: 0, y: -0.1, z: 0, duration: 0.5))
                    }
                }
            }
        } else {
            switch self.modeSelector.selectedSegmentIndex {
            case 0:
                for node in self.modelNodes {
                    node.opacity = 1
                }
                for node in self.historicNodes {
                    node.opacity = 1
                }
                for node in self.contemporaryNodes {
                    node.opacity = 0
                }

            case 2:
                for node in self.modelNodes {
                    node.opacity = 0
                }
                for node in self.historicNodes {
                    node.opacity = 0
                }
                for node in self.contemporaryNodes {
                    node.opacity = 1
                }
            default:
                for node in self.modelNodes {
                    node.opacity = 1
                }
                for node in self.historicNodes {
                    node.opacity = 0
                }
                for node in self.contemporaryNodes {
                    node.opacity = 0
                }
            }
        }
    }
    
    @objc func switchModeListener(sender: UISegmentedControl) {
        self.switchMode()
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
        
        for vid in [self.undergroundVid, self.undergroundVid0, self.undergroundVid1, self.undergroundVid2, self.undergroundVid3, self.undergroundVid4, self.undergroundVid5, self.plasticVid, self.laserVid, self.restaurantVid1, self.restaurantVid2] {
            loopVideo(videoPlayer: vid)
        }
        
        self.modeSelector.alpha = 0
        self.modeSelector.isUserInteractionEnabled = false
        self.modeSelector.addTarget(self, action: #selector(self.switchModeListener(sender:)), for: .valueChanged)
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
        
        for vid in [self.undergroundVid, self.undergroundVid0, self.undergroundVid1, self.undergroundVid2, self.undergroundVid3, self.undergroundVid4, self.undergroundVid5, self.plasticVid, self.laserVid] {
            if vid.rate != 0 {
                vid.pause()
                vid.seek(to: .zero)
            }
        }
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view == self.sceneView {
            let viewTouchLocation: CGPoint = touch.location(in: sceneView)
            if let result = sceneView.hitTest(viewTouchLocation, options: nil).first {
                
//                for child in self.tuxedoNode.childNodes {
//                    if child == result.node {
//                        UIApplication.shared.open(URL(string: "googledrive://https://drive.google.com/file/d/1G8ONYJuZl7PWTZiNS0KfYf3k_OJMuR4T/view")!)
//                    }
//                    for grandchild in child.childNodes {
//                        if grandchild == result.node || grandchild == result.node.parent {
//                            UIApplication.shared.open(URL(string: "googledrive://https://drive.google.com/file/d/1G8ONYJuZl7PWTZiNS0KfYf3k_OJMuR4T/view")!)
//                        }
//                    }
//                }
                
//                if let vid = result.node.geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
//                    if vid == self.undergroundVid5 {
//                        UIApplication.shared.open(URL(string: "googledrive://https://drive.google.com/file/d/1nBdUgmXWZ4q-vsCaGVt_32_NGlYoEEgX/view")!)
//                    }
//                }
                
                if let content = result.node.geometry?.firstMaterial?.diffuse.contents {
                    if content as? AVPlayer == self.restaurantVid2 || content as? UIImage == UIImage(named: "Contemporary_Closing_2") {
                        UIApplication.shared.open(URL(string: "nytimes://www.nytimes.com/2019/12/24/upshot/chinese-restaurants-closing-upward-mobility-second-generation.html")!)
                    }
                    if content as? AVPlayer == self.restaurantVid1 {
                        UIApplication.shared.open(URL(string: "nytimes://www.nytimes.com/2017/02/14/dining/chinese-tuxedo-restaurant-review.html")!)
                    }
                    if content as? UIImage == UIImage(named: "Contemporary_Restaurant_2") {
                        UIApplication.shared.open(URL(string: "https://maps.apple.com/?address=5%20Doyers%20St,%20New%20York,%20NY%20%2010013,%20United%20States&ll=40.714290,-73.998077&q=5%20Doyers%20St&_ext=EiYpu0Plq9paREAx47QmlkGAUsA5ORkLCAFcREBBwXsSaX9/UsBQBA%3D%3D")!)
                    }
                }
                
            }
            
        }
    }
    
    // MARK: - ARSCNViewDelegate
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            var n: Int
            var vid: AVPlayer
            var modelNode: SCNNode
            switch imageAnchor.referenceImage.name {
            case "Underground":
                n = 1
                vid = self.undergroundVid
//                modelNode = self.carNode
                modelNode = self.tuxedoNode1
                modelNode.eulerAngles.x = -.pi / 2
                modelNode.scale = SCNVector3(0.0097,0.0097,0.0097)
            case "Plastic":
                n = 2
                vid = self.plasticVid
                modelNode = self.keyboardNode
                modelNode.scale = SCNVector3(0.01,0.01,0.01)
            case "Laser":
                n = 3
                vid = self.laserVid
                modelNode = self.metrotechNode
            case "Tea":
                n = 4
                vid = self.undergroundVid0
                modelNode = self.keyboardNode0
                modelNode.scale = SCNVector3(0.2,0.2,0.2)
//                modelNode = self.tuxedoNode0
//                modelNode.opacity = 0.6
//                modelNode.position.x = 1
//                modelNode.position.y = 0
//                modelNode.position.z = 0.4
//                modelNode.eulerAngles.x = -.pi / 2 + 0.05
//                modelNode.scale = SCNVector3(0.0097,0.0097,0.0097)
            case "Dragon":
                n = 5
                vid = self.undergroundVid1
                modelNode = self.tunnelNode
                modelNode.position.x = -4
                modelNode.position.y = -3
                modelNode.position.z = 2
                modelNode.eulerAngles.x = -.pi / 2 + 0.15
                modelNode.eulerAngles.z = +.pi / 3
                modelNode.scale = SCNVector3(0.0255, 0.0255, 0.0255)
            case "OldMan":
                n = 6
                vid = self.undergroundVid2
                modelNode = self.keyboardNode2
                modelNode.scale = SCNVector3(0.2,0.2,0.2)
            case "YuYuan":
                n = 7
                vid = self.undergroundVid3
                modelNode = self.keyboardNode3
                modelNode.scale = SCNVector3(0.2,0.2,0.2)
            case "WuChang":
                n = 8
                vid = self.undergroundVid4
                modelNode = self.keyboardNode4
                modelNode.scale = SCNVector3(0.2,0.2,0.2)
            case "Lease":
                n = 9
                vid = self.undergroundVid5
//                modelNode = self.keyboardNode4
                modelNode = self.tuxedoNode
                modelNode.position.x = 4.5
                modelNode.position.y = -0.01
                modelNode.position.z = 4
                modelNode.eulerAngles.x = -.pi / 2 - 0.05
                modelNode.scale = SCNVector3(0.0255, 0.0255, 0.0255)
                
                let historicNode = SCNNode()
                let contemporaryNode = SCNNode()
                
                let imgPlaneA = SCNPlane(width: 2.3, height: 1.38)
                imgPlaneA.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Tuxedo_Intro")
                imgPlaneA.firstMaterial?.lightingModel = .constant
                
                let imgNodeA = SCNNode(geometry: imgPlaneA)
                imgNodeA.position.x = -2.7
                
                let imgPlaneC = SCNPlane(width: 1.6, height: 2)
                imgPlaneC.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Peace_Dinner")
                imgPlaneC.firstMaterial?.lightingModel = .constant
                
                let imgNodeC = SCNNode(geometry: imgPlaneC)
                imgNodeC.position.x = -0.2
                
                let imgPlaneB1 = SCNPlane(width: 0.96, height: 2.3)
                imgPlaneB1.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Tom_Lee")
                imgPlaneB1.firstMaterial?.lightingModel = .constant
                
                let imgNodeB1 = SCNNode(geometry: imgPlaneB1)
                imgNodeB1.position.x = 1.5
                
                let imgPlaneB2 = SCNPlane(width: 0.96, height: 2.3)
                imgPlaneB2.firstMaterial?.diffuse.contents = UIImage(named: "Historical_Mock_Duck")
                imgPlaneB2.firstMaterial?.lightingModel = .constant
                
                let imgNodeB2 = SCNNode(geometry: imgPlaneB2)
                imgNodeB2.position.x = 2.8
                
                let imgPlaneD1 = SCNPlane(width: 1.6, height: 1.55)
                imgPlaneD1.firstMaterial?.diffuse.contents = UIImage(named: "Contemporary_Restaurant_2")
                imgPlaneD1.firstMaterial?.lightingModel = .constant
                
                let imgNodeD1 = SCNNode(geometry: imgPlaneD1)
                imgNodeD1.position.x = -0.9
                
                let imgPlaneD2 = SCNPlane(width: 1.6, height: 1.55)
                imgPlaneD2.firstMaterial?.diffuse.contents = UIImage(named: "Contemporary_Closing_2")
                imgPlaneD2.firstMaterial?.lightingModel = .constant
                
                let imgNodeD2 = SCNNode(geometry: imgPlaneD2)
                imgNodeD2.position.x = 2.6
                
                let vidPlaneE1 = SCNPlane(width: 1.6, height: 1.55)
                vidPlaneE1.firstMaterial?.diffuse.contents = self.restaurantVid1
                vidPlaneE1.firstMaterial?.lightingModel = .constant
                
                let vidNodeE1 = SCNNode(geometry: vidPlaneE1)
                vidNodeE1.position.x = -2.6
                
                let vidPlaneE2 = SCNPlane(width: 1.6, height: 1.55)
                vidPlaneE2.firstMaterial?.diffuse.contents = self.restaurantVid2
                vidPlaneE2.firstMaterial?.lightingModel = .constant
                
                let vidNodeE2 = SCNNode(geometry: vidPlaneE2)
                vidNodeE2.position.x = 0.9
                
                historicNode.addChildNode(imgNodeA)
                historicNode.addChildNode(imgNodeC)
                historicNode.addChildNode(imgNodeB1)
                historicNode.addChildNode(imgNodeB2)
                historicNode.eulerAngles.x = -.pi / 2
                historicNode.position.x = -0.5
                historicNode.position.y = 2
                historicNode.position.z = 2
                
                contemporaryNode.addChildNode(imgNodeD1)
                contemporaryNode.addChildNode(imgNodeD2)
                contemporaryNode.addChildNode(vidNodeE1)
                contemporaryNode.addChildNode(vidNodeE2)
                contemporaryNode.eulerAngles.x = -.pi / 2
                contemporaryNode.position.x = -0.5
                contemporaryNode.position.y = 2
                contemporaryNode.position.z = 2
                
                self.historicNodes.append(historicNode)
                self.contemporaryNodes.append(contemporaryNode)
                
                node.addChildNode(historicNode)
                node.addChildNode(contemporaryNode)
            case "Map":
                n = 10
                vid = self.undergroundVid5
                modelNode = self.tuxedoNode1
                modelNode.opacity = 0.6
//                modelNode.position.x = 1
//                modelNode.position.y = 0
                modelNode.position.z = -2
                modelNode.eulerAngles.x = -.pi / 2
                modelNode.scale = SCNVector3(0.0097,0.0097,0.0097)
            default:
                return SCNNode()
            }
            
            var vidPlane: SCNPlane
            
            if n <= 3 {
                vidPlane = SCNPlane(width: max(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01, height: min(imageAnchor.referenceImage.physicalSize.width, imageAnchor.referenceImage.physicalSize.height) * 1.01)
            } else {
                vidPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 1.01, height: imageAnchor.referenceImage.physicalSize.height * 1.01)
            }
            
            vidPlane.firstMaterial?.diffuse.contents = vid
            vidPlane.firstMaterial?.lightingModel = .constant
            
            let vidNode = SCNNode(geometry: vidPlane)
            vidNode.eulerAngles.x = -.pi / 2
            vidNode.eulerAngles.y = (imageAnchor.referenceImage.physicalSize.width < imageAnchor.referenceImage.physicalSize.height && n <= 3 ? -.pi/2 : 0)
//            vidNode.opacity = 0
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                vid.play()
//                vidNode.opacity = 0.01
//            }
            
            /*
             Munged-JjCgeNndsH Imperial-700
             Munged-Nlq6tvqpZ3 Imperial-400
             Munged-teVV8iw7A5 Cheltenham-700
             Munged-c89WsWJ0R2 Cheltenham-400
             */
            
//            let title = SCNText(string: "\(imageAnchor.referenceImage.name!)", extrusionDepth: 0.5)
//            title.font = UIFont(name: "Munged-teVV8iw7A5", size: 8)
//            title.firstMaterial?.diffuse.contents = UIColor.black
//            title.flatness = 0.01
            
//            let titleNode = SCNNode(geometry: title)
//            titleNode.pivot = SCNMatrix4MakeTranslation(titleNode.boundingBox.max.x * 0.5 + titleNode.boundingBox.min.x * 0.5, titleNode.boundingBox.max.y * 0.5 + titleNode.boundingBox.min.y * 0.5, titleNode.boundingBox.max.z * 0.5 + titleNode.boundingBox.min.z * 0.5)
//            titleNode.position.z = Float(imageAnchor.referenceImage.physicalSize.height / 2 + (n > 3 ? 0.5 : 0.02))
//            titleNode.eulerAngles.x = -.pi / 2
//            titleNode.scale = n <= 3 ? SCNVector3(0.005, 0.005, 0.005) : SCNVector3(0.1, 0.1, 0.1)
            
            let light = SCNLight()
            light.type = .directional
            light.categoryBitMask = 1 << n
            
            modelNode.categoryBitMask = 1 << n
            modelNode.light = light
            
            vidNode.categoryBitMask = 1 << n
            vidNode.light = light
            
            self.modelNodes.append(modelNode)
            vidNode.opacity = 0
//            self.contemporaryNodes.append(vidNode)
//            self.contemporaryNodes.append(titleNode)
            
            node.addChildNode(vidNode)
            node.addChildNode(modelNode)
//            node.addChildNode(titleNode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.switchMode(withTransition: false)
                UIView.animate(withDuration: 1.5, animations: {
                    self.modeSelector.alpha = 1
                })
                self.modeSelector.isUserInteractionEnabled = true
                
                self.restaurantVid1.play()
                self.restaurantVid2.play()
            }
            
            node.opacity = 0
            node.runAction(.fadeIn(duration: 1.5))
            
            
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
                
//                if renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) {
//                    if vid.rate == 0 && vid.currentTime() == CMTime.zero && node.opacity == 0 {
//                        node.childNodes[0].opacity = 0.01
//                        node.opacity = 0
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            vid.play()
//                            node.childNodes[0].opacity = 0.01
//                        }
//                    } else {
//                        vid.play()
//                    }
                    
//                    if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 1 {
//                        node.childNodes[0].opacity += 0.035
//                        node.opacity = node.childNodes[0].opacity
//                    }
                    
//                    if node.childNodes[0].opacity > 0 && node.childNodes[0].opacity < 0.02 {
//                        node.childNodes[0].runAction(.fadeIn(duration: 1.5))
//                        node.runAction(.fadeIn(duration: 1.5))
//                    }
//                }
            }
        }
    }
    
    /*
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let anchors = sceneView.session.currentFrame?.anchors {
            for anchor in anchors where (anchor as? ARImageAnchor) != nil {
//                if let node = sceneView.node(for: anchor), let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer, node.opacity == 1 {
                if let node = sceneView.node(for: anchor), let vid = node.childNodes[0].geometry?.firstMaterial?.diffuse.contents as? AVPlayer {
                    if let cam = sceneView.session.currentFrame?.camera {
                        if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) > 0.8 {
                            if vid.rate != 0 {
                                vid.pause()
                            }
//                            for i in 0..<node.childNodes.count {
//                                if node.childNodes[i].opacity < 1 && node.childNodes[i] != self.tuxedoNode && node.childNodes[i] != self.tuxedoNode0 && node.childNodes[i] != self.tuxedoNode1 {
//                                    node.childNodes[i].opacity += 0.035
//                                }
//                            }
                            if node.opacity < 0.01 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    if node.opacity < 0.01 {
                                        node.runAction(.fadeIn(duration: 0.5))
                                    }
                                }
                            }
                        } else if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) < 0.2 {
//                        } else if simd_distance(node.simdTransform.columns.3, cam.transform.columns.3) < Float(max((anchor as! ARImageAnchor).referenceImage.physicalSize.height, (anchor as! ARImageAnchor).referenceImage.physicalSize.width) / 2 + 0.02) {
                            if vid.rate != 0 {
                                vid.pause()
                            }
//                            for i in 0..<node.childNodes.count {
//                                if node.childNodes[i].opacity > 0 {
//                                    node.childNodes[i].opacity -= 0.05
//                                }
//                            }
                            if node.opacity > 0.99 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    if node.opacity > 0.99 {
                                        node.runAction(.fadeOut(duration: 0.5))
                                    }
                                }
                            }
                        } else {
                            if vid.rate == 0 && renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!){
                                vid.play()
                            } else if vid.rate != 0 && !renderer.isNode(node.childNodes[0], insideFrustumOf: sceneView.pointOfView!) {
                                vid.pause()
                                vid.seek(to: .zero)
                            }
//                            for i in 0..<node.childNodes.count {
//                                if node.childNodes[i].opacity < 1 {
//                                    node.childNodes[i].opacity += 0.035
//                                }
//                            }
                            if node.opacity < 0.01 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    if node.opacity < 0.01 {
                                        node.runAction(.fadeIn(duration: 0.5))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
 */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        for vid in [self.undergroundVid, self.undergroundVid0, self.undergroundVid1, self.undergroundVid2, self.undergroundVid3, self.undergroundVid4, self.undergroundVid5, self.plasticVid, self.laserVid] {
            if vid.rate != 0 {
                vid.pause()
            }
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
