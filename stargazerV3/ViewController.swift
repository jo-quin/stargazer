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

        addCoordinates(text: "NORTH", x: 0 , y: 0, z: -100, rotation: 0 )
        addCoordinates(text: "SOUTH", x: 0, y: 0, z: 100, rotation: 10 )
        addCoordinates(text: "EAST", x: 100, y: 0, z: 0, rotation: 5 )
        addCoordinates(text: "WEST", x: -100, y: 0, z: 0, rotation: -5 )
        readFile()
      
    }
    
    func readFile(){
        let path = Bundle.main.path(forResource: "stars.txt", ofType: nil)!
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = content.components(separatedBy: "\n")
        lines.forEach {
            createCelestialBodies(line: $0)
        }
    }
    
    func createCelestialBodies(line: String){
        let line = line.components(separatedBy: " ")
        
        // Checks for empty line
        if line.count > 1 {
            
            // Declination
            let dec = Float(line[5].components(separatedBy: "°")[0])
            
            // Where to look based on our postion London Latitude (51.49)
            let wtl = dec! - 51.49
            
            // Right Ascension for the current month
            let raNow = Int(line[3].components(separatedBy: "h")[0])! - 6 // 6 is hardcoded for month of June
            
            let name = line[1]
            
            // Type Planet or Star
            let type = line [0]
            
            // Find the celestial bodies that we can see from out location
            // Discard any celestial body that stays behind the horizon
            if wtl >= -90 {
                
                // Select the stars that are in the sky during night time
                if 13 > raNow && raNow > 0 {
                    addCelestialBody(x: Float((raNow - 6) * 25), z: Float(dec! * -1) * 4, radius: 5, name: name, type: type)
                
                // Select the circumpolar stars (always on our sky)
                } else if (90 - dec!) <= 50  {
                    addCelestialBody(x: Float((raNow - 6) * 25), z: Float(dec! * -1) * 4, radius: 5, name: name, type: type)
                }
            }
        }
    }
    
    func addCelestialBody(x: Float, z: Float, radius: CGFloat, name: String, type: String ){        
        if type == "planet" {
            let sphere = SCNNode(geometry: SCNSphere(radius: radius))
            let position = SCNVector3(x: x, y: 70, z: z) // y is the height which help us to adjust spread of celestial bodies
            sphere.position = position
            let rotate = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1.0)
            let continuedRotate = SCNAction.repeatForever(rotate)
            sphere.runAction(continuedRotate)
            sphere.geometry?.firstMaterial?.diffuse.contents = "\(name).jpg"
            sceneView.scene.rootNode.addChildNode(sphere)
        } else {
            let particleSystem = SCNParticleSystem(named: "reactor", inDirectory: nil)
            let particleNode = SCNNode()
            particleNode.addParticleSystem(particleSystem!)
            particleNode.position = position
            sceneView.scene.rootNode.addChildNode(particleNode)   
        }
    }
    
    
    func addCoordinates(text: String, x: Int, y: Int, z: Int, rotation: CGFloat) {
        let text = SCNNode(geometry: SCNText(string: text, extrusionDepth: 5))
        text.position = SCNVector3(x, y, z )
        text.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        text.runAction(SCNAction.rotateBy(x: 0, y: rotation, z: 0, duration: 0))
        sceneView.scene.rootNode.addChildNode(text)
    }
}

