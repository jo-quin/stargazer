//
//  SCNNodeHelpers.swift
//  stargazerV3
//
//  Created by Stuart Pethurst on 17/06/2019.
//  Copyright © 2019 Dominic. All rights reserved.
//

import Foundation
import SceneKit

let SURFACE_LENGTH: CGFloat = 2
let SURFACE_HEIGHT: CGFloat = 0
let SURFACE_WIDTH: CGFloat = 2

let SCALEX: Float = 2.0
let SCALEY: Float = 2.0

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
    
    let ceiling = SCNBox(width: SURFACE_WIDTH,
                              height: SURFACE_HEIGHT,
                              length: SURFACE_LENGTH,
                              chamferRadius: 0)
    
    ceiling.firstMaterial?.lightingModel = .physicallyBased
    ceiling.firstMaterial?.diffuse.contents =
        UIImage(named:
            "night")
    ceiling.firstMaterial?.emission.contents =
        UIImage(named:
            "night")
    ceiling.firstMaterial?.normal.contents =
        UIImage(named:
            "night")
    ceiling.firstMaterial?.specular.contents =
        UIImage(named:
            "night")
    ceiling.firstMaterial?.selfIllumination.contents =
        UIImage(named:
            "night")
    
    repeatTextures(geometry: ceiling, scaleX:
        SCALEX, scaleY: SCALEY)
    
    let ceilingNode = SCNNode(geometry: ceiling)
    ceilingNode.renderingOrder = 100
    
    ceilingNode.position = SCNVector3(SURFACE_HEIGHT, 0, 0)
    return ceilingNode
}
