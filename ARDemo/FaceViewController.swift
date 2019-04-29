//
//  FaceViewController.swift
//  ARDemo
//
//  Created by KKFantasy on 2019/4/29.
//  Copyright © 2019 kk. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class FaceViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)

        // Do any additional setup after loading the view.
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        let material = faceGeometry.firstMaterial!

        material.diffuse.contents = #imageLiteral(resourceName: "wireframeTexture") // Example texture map image.
        material.lightingModel = .physicallyBased

        let contentNode = SCNNode(geometry: faceGeometry)
        return contentNode
    }
}
