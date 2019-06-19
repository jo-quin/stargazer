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
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.require(toFail: tapGesture)
        
        sceneView.session.run(config)

        addCoordinates(text: "NORTH", x: 0 , y: 0, z: -100, rotation: 0 )
        addCoordinates(text: "SOUTH", x: 0, y: 0, z: 100, rotation: 10 )
        addCoordinates(text: "EAST", x: 100, y: 0, z: 0, rotation: 5 )
        addCoordinates(text: "WEST", x: -100, y: 0, z: 0, rotation: -5 )
        
        readFileToCreateNodes(starsOrTags: "Stars")
        
    }
    
    func readFileToCreateNodes(starsOrTags: String){
        let path = Bundle.main.path(forResource: "stars.txt", ofType: nil)! // add planet to the same file?
        let content = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        let lines = content.components(separatedBy: "\n")
        lines.forEach {
            createCelestialNodes(line: $0, starsOrTags: starsOrTags)
        }
    }
    
    func createCelestialNodes(line: String, starsOrTags: String){
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
                    if starsOrTags == "Stars" {
                        addCelestialBody(x: Float((raNow - 6) * 25), z: Float(dec! * -1) * 4, name: name, type: type)
                    } else if starsOrTags == "Tags" {
                        addTag(name: name, position: SCNVector3(Float((raNow - 6) * 25), Float(70), Float((dec! * -1) * 4 )), type: type)
                    }
                  
                // Select the circumpolar stars (always on our sky)
                } else if (90 - dec!) <= 50  {
                    if starsOrTags == "Stars" {
                        addCelestialBody(x: Float((raNow - 6) * 25), z: Float(dec! * -1) * 4, name: name, type: type)
                    } else if starsOrTags == "Tags" {
                        addTag(name: name, position: SCNVector3(Float((raNow - 6) * 25), Float(70), Float((dec! * -1) * 4 )), type: type)
                    }
                }
            }
        }
    }
    
    func addCelestialBody(x: Float, z: Float, name: String, type: String ){
        var radius = 20
        if type == "planet" {
            if name == "Moon" {
                radius = 10
            }
            let sphere = SCNNode(geometry: SCNSphere(radius: CGFloat(radius)))
            sphere.position = SCNVector3(x: x, y: 70, z: z) // y is the height which help us to adjust spread of celestial bodies
            let rotate = SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1.0)
            let continuedRotate = SCNAction.repeatForever(rotate)
            sphere.runAction(continuedRotate)
            sphere.geometry?.firstMaterial?.diffuse.contents = "\(name).jpg"
            sceneView.scene.rootNode.addChildNode(sphere)
        } else {
            let particleSystem = SCNParticleSystem(named: "reactor", inDirectory: nil)
            let particleNode = SCNNode()
            particleNode.addParticleSystem(particleSystem!)
            particleNode.position = SCNVector3(x: x, y: 70, z: z)
            sceneView.scene.rootNode.addChildNode(particleNode)
        }
    }
    
    func addTag(name: String, position: SCNVector3,type: String){
        
        // check if the tag is for a planet or for a star to adjust dy
        var dyLocation = 1.2
        if type == "planet" {
            dyLocation = 3.2
        }
        if name == "Moon" {
            dyLocation = 2.5
        }
        
        let tag = SCNNode(geometry: SCNText(string: name, extrusionDepth: 5))
        tag.name = "tag"
        tag.position = position
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        let constraint = SCNLookAtConstraint(target: cameraNode)
        constraint.isGimbalLockEnabled = true
        tag.constraints = [constraint]
        
        tag.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        // changes the center of the text to be the center of the node
        let (min, max) = tag.boundingBox
        let dx = min.x - 0.5 * (max.x - min.x)
        let dy = min.y + Float(dyLocation) * (max.y - min.y) // to position below
        let dz = min.z + 0.5 * (max.z - min.z)
        tag.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        // rotates the text to face the camera
        tag.pivot = SCNMatrix4Rotate(tag.pivot, Float.pi, 0, 1, 0)
        
        sceneView.scene.rootNode.addChildNode(tag)
    }
    
    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        readFileToCreateNodes(starsOrTags: "Tags")
    }
    
    @objc func doubleTapped(gestureRecognizer: UITapGestureRecognizer) {
        resetScene()
        
    }
    
    func resetScene() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "tag" {
                node.removeFromParentNode()
            }
        }
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.worldAlignment = .gravityAndHeading
        
        sceneView.session.run(config)
    }
    
    func addCoordinates(text: String, x: Int, y: Int, z: Int, rotation: CGFloat) {
        let text = SCNNode(geometry: SCNText(string: text, extrusionDepth: 5))
        text.position = SCNVector3(x, y, z )
        text.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        text.runAction(SCNAction.rotateBy(x: 0, y: rotation, z: 0, duration: 0))
        sceneView.scene.rootNode.addChildNode(text)
    }
}

