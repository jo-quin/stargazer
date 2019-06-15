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
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

