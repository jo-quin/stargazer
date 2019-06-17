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
        
        addCelestialBody(x: 0, z: -10, radius: 1, name: "Polaris", type: "star")
        addCelestialBody(x: 0, z: 10, radius: 1, name: "sun", type: "planet")

        addCoordinates(text: "NORTH", x: 0 , y: 0, z: -100, rotation: 0 )
        addCoordinates(text: "SOUTH", x: 0, y: 0, z: 100, rotation: 10 )
        addCoordinates(text: "EAST", x: 100, y: 0, z: 0, rotation: 5 )
        addCoordinates(text: "WEST", x: -100, y: 0, z: 0, rotation: -5 )
      
    }
    
    func addCelestialBody(x: Float, z: Float, radius: CGFloat, name: String, type: String ){
        let sphere = SCNNode(geometry: SCNSphere(radius: radius))
        sphere.position = SCNVector3(x: x, y: 1, z: z)
        
        let type = type
        if type == "planet" {
            let rotate = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1.0)
            let continuedRotate = SCNAction.repeatForever(rotate)
            sphere.runAction(continuedRotate)
            sphere.geometry?.firstMaterial?.diffuse.contents = "\(name).jpg"
        } else {
            sphere.geometry?.firstMaterial?.diffuse.contents = "moon_material.jpeg" // hardcode star material here
        }
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

