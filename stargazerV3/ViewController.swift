//
//  ViewController.swift
//  stargazerV3
//
//  Created by Student on 13/06/2019.
//  Copyright © 2019 Dominic. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(config)

        config.planeDetection = .horizontal

        func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
            let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))) //1
            floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)
            floorNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "night")
            floorNode.geometry?.firstMaterial?.isDoubleSided = true
            floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)
            return floorNode
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return} //1
            let planeNode = createFloorNode(anchor: planeAnchor) //2
            node.addChildNode(planeNode) //3
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }

            let planeNode = createFloorNode(anchor: planeAnchor)
            node.addChildNode(planeNode)
        }

        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard let _ = anchor as? ARPlaneAnchor else {return}
            node.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }

            sceneView.delegate = self as? ARSCNViewDelegate


        }
        
        
        
            
            
        
        
        // Do any additional setup after loading the view.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.worldAlignment = .gravityAndHeading

        sceneView.session.run(config)

        addStar(material: "texture.jpg")
        addStar(material: "sun.jpg")
        addStar(material: "moon_material.jpeg")
        addStar(material: "moon_material.jpeg")

        addPlanet(material: "sun.jpg", x: 0 , y: 0, z: -90, rotation: 0 )
        addPlanet(material: "moon_material", x: 90 , y: 0, z: 50, rotation: 5 )
        addPlanet(material: "sun.jpeg", x: 90 , y: 0, z: 0, rotation: 5 )
        addPlanet(material: "sun.jpg", x: -90 , y: 0, z: 0, rotation: -5 )

        addCoordinates(text: "NORTH", x: 0 , y: 0, z: -100, rotation: 0 )
        addCoordinates(text: "SOUTH", x: 0, y: 0, z: 100, rotation: 10 )
        addCoordinates(text: "EAST", x: 100, y: 0, z: 0, rotation: 5 )
        addCoordinates(text: "WEST", x: -100, y: 0, z: 0, rotation: -5 )


    }

    func addStar(material: String){
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.25))
        sphere.position = SCNVector3(Float.random(in: 0 ..< 5),1 ,Float.random(in: 0 ..< 5))
        sphere.geometry?.firstMaterial?.diffuse.contents = material
        sceneView.scene.rootNode.addChildNode(sphere)
        
        // 1
        let ceilingNode = makeCeilingNode()
        ceilingNode.position = SCNVector3(0 , 10 , 0)
        
        sphere.addChildNode(ceilingNode)
    }

    func addPlanet(material: String, x: Int, y: Int, z: Int, rotation: CGFloat){
        let sphere = SCNNode(geometry: SCNSphere(radius: 10))
        let rotate = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1.0)
        let continuedRotate = SCNAction.repeatForever(rotate)
        sphere.position = SCNVector3(x, y, z)
        sphere.geometry?.firstMaterial?.diffuse.contents = material
        sphere.runAction(continuedRotate)
        sceneView.scene.rootNode.addChildNode(sphere)
    }

    func addCoordinates(text: String, x: Int, y: Int, z: Int, rotation: CGFloat) {
        let text = SCNNode(geometry: SCNText(string: text, extrusionDepth: 5))
        text.position = SCNVector3(x, y, z )
        text.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        text.runAction(SCNAction.rotateBy(x: 0, y: rotation, z: 0, duration: 0))
        sceneView.scene.rootNode.addChildNode(text)
    }
    

}

