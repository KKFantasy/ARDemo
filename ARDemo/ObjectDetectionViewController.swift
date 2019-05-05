//
//  ObjectDetectionViewController.swift
//  ARDemo
//
//  Created by KKFantasy on 2019/4/24.
//  Copyright © 2019 kk. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ObjectDetectionViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        sceneView.showsStatistics = true
        
        sceneView.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "Object Detection", bundle: nil) else {
            fatalError("Object Detection 资源文件不存在")
        }
        
        configuration.detectionObjects = referenceObjects
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let objectAnchor = anchor as? ARObjectAnchor else { return }
        
        let referenceObject = objectAnchor.referenceObject
        let box = SCNBox(width: CGFloat(referenceObject.extent.z), height: CGFloat(referenceObject.extent.y), length: CGFloat(referenceObject.extent.x), chamferRadius: 0)
        
        let boxNode = SCNNode(geometry: box)
        boxNode.simdPosition = referenceObject.center
        boxNode.opacity = 0.25
        boxNode.runAction(.fadeIn(duration: 0.25))
        
        node.addChildNode(boxNode)
        
    }

}
