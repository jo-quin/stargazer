//
//  SCNNodeHelpers.swift
//  stargazerV3
//
//  Created by Stuart Pethurst on 17/06/2019.
//  Copyright © 2019 Dominic. All rights reserved.
//

import Foundation
import SceneKit

let SURFACE_LENGTH: CGFloat = 3.0
let SURFACE_HEIGHT: CGFloat = 0.2
let SURFACE_WIDTH: CGFloat = 3.0

let SCALEX: Float = 2.0
let SCALEY: Float = 2.0

func createPlaneNode(center: vector_float3,
                     extent: vector_float3) -> SCNNode {
    
    let plane = SCNPlane(width: CGFloat(extent.x),
                         height: CGFloat(extent.z))
    
    let planeMaterial = SCNMaterial()
    planeMaterial.diffuse.contents = UIColor.yellow.withAlphaComponent(0.4)
    
    plane.materials = [planeMaterial]
    
    let planeNode = SCNNode(geometry: plane)
    
    planeNode.position = SCNVector3Make(center.x, 0, center.z)
    
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
    
    return planeNode
}

func updatePlaneNode(_ node: SCNNode,
                     center: vector_float3,
                     extent: vector_float3) {
    
    let geometry = node.geometry as? SCNPlane
    
    geometry?.width = CGFloat(extent.x)
    geometry?.height = CGFloat(extent.z)
    
    node.position = SCNVector3Make(center.x, 0, center.z)
}

func repeatTextures(geometry: SCNGeometry, scaleX: Float, scaleY: Float) {
    // 1
    geometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
    geometry.firstMaterial?.selfIllumination.wrapS = SCNWrapMode.repeat
    geometry.firstMaterial?.normal.wrapS = SCNWrapMode.repeat
    geometry.firstMaterial?.specular.wrapS = SCNWrapMode.repeat
    geometry.firstMaterial?.emission.wrapS = SCNWrapMode.repeat
    geometry.firstMaterial?.roughness.wrapS = SCNWrapMode.repeat
    
    // 2
    geometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
    geometry.firstMaterial?.selfIllumination.wrapT = SCNWrapMode.repeat
    geometry.firstMaterial?.normal.wrapT = SCNWrapMode.repeat
    geometry.firstMaterial?.specular.wrapT = SCNWrapMode.repeat
    geometry.firstMaterial?.emission.wrapT = SCNWrapMode.repeat
    geometry.firstMaterial?.roughness.wrapT = SCNWrapMode.repeat
    
    // 3
    geometry.firstMaterial?.diffuse.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
    geometry.firstMaterial?.selfIllumination.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
    geometry.firstMaterial?.normal.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
    geometry.firstMaterial?.specular.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
    geometry.firstMaterial?.emission.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
    geometry.firstMaterial?.roughness.contentsTransform =
        SCNMatrix4MakeScale(scaleX, scaleY, 0)
}

func makeCeilingNode() -> SCNNode {
    
    let ceilingNode = SCNNode()
    
    // 3
    let innerCeiling = SCNBox(width: SURFACE_WIDTH,
                              height: SURFACE_HEIGHT,
                              length: SURFACE_LENGTH,
                              chamferRadius: 0)
    
    // 4
    innerCeiling.firstMaterial?.lightingModel = .physicallyBased
    innerCeiling.firstMaterial?.diffuse.contents =
        UIImage(named:
            "night")
    innerCeiling.firstMaterial?.emission.contents =
        UIImage(named:
            "night")
    innerCeiling.firstMaterial?.normal.contents =
        UIImage(named:
            "night")
    innerCeiling.firstMaterial?.specular.contents =
        UIImage(named:
            "night")
    innerCeiling.firstMaterial?.selfIllumination.contents =
        UIImage(named:
            "night")
    
    // 5
    repeatTextures(geometry: innerCeiling, scaleX:
        SCALEX, scaleY: SCALEY)
    
    // 6
    let innerCeilingNode = SCNNode(geometry: innerCeiling)
    innerCeilingNode.renderingOrder = 100
    
    // 7
    innerCeilingNode.position = SCNVector3(SURFACE_HEIGHT * 0.5,
                                           0, 0)
    ceilingNode.addChildNode(innerCeilingNode)
    return ceilingNode
}
