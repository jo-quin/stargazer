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
        var starsArray = [Any]()
        let path = Bundle.main.path(forResource: "stars.txt", ofType: nil)! // add planet to the same file?
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = content.components(separatedBy: "\n")
        lines.forEach {
            starsArray.append(createCelestialBodies(line: $0))
        }
    }
    
    func createCelestialBodies(line: String){
        let line = line.components(separatedBy: " ")
        if line.count > 1 {
            let dec = Float(line[5].components(separatedBy: "°")[0]) // make sure stars and planets txts have the same structure
            let wtl = dec! - 51.49 // London latitude
            let raNow = Int(line[3].components(separatedBy: "h")[0])! - 6 // 6 is hardcoded for month of June
            let name = line[1]
            
            if wtl >= -90 {
                if 13 > raNow && raNow > 0 {
                    addCelestialBody(x: Float((raNow - 6) * 5), z: Float(dec! * -1), radius: 0.2, name: name, type: "star") // work on hardcoded radius and type
                } else if (90 - dec!) <= 50  {
                    addCelestialBody(x: Float((raNow - 6) * 5), z: Float(dec! * -1), radius: 0.2, name: name, type: "star") // [ "x": RA - 6, "z": Dec * -1, "radius": VisualMagnitud + 1, "name": name, "type": type ]
                }
            }
        }
    }
    
    func addCelestialBody(x: Float, z: Float, radius: CGFloat, name: String, type: String ){
        let sphere = SCNNode(geometry: SCNSphere(radius: radius))
        sphere.position = SCNVector3(x: x, y: 10, z: z)
        
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

