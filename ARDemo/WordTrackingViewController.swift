//
//  ViewController.swift
//  ARDemo
//
//  Created by KKFantasy on 2019/4/19.
//  Copyright © 2019 kk. All rights reserved.
//

import ARKit
import SceneKit
import UIKit

// 基本的AR效果，快照
class WordTrackingViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: ARSCNView!
    
    var snapshots = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // 添加点击事件
        let clearItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear(_:)))
        let captureItem = UIBarButtonItem(title: "Capture", style: .plain, target: self, action: #selector(capture))
        navigationItem.rightBarButtonItems = [clearItem, captureItem]
    }
    
    // 点击屏幕
    @objc func capture() {
        // 截图并创建平面
        let imagePlane = SCNPlane(width: sceneView.bounds.width / 6000, height: sceneView.bounds.height / 6000)
        imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
        imagePlane.firstMaterial?.lightingModel = .constant
        
        // 创建plane node并添加到场景
        let planeNode = SCNNode(geometry: imagePlane)
        sceneView.scene.rootNode.addChildNode(planeNode)
        
        snapshots.append(planeNode)
        
        // 改变其在空间的位置为摄像头的位置
        let currentFrame = sceneView.session.currentFrame
        if let transform = currentFrame?.camera.transform {
            var translation = matrix_identity_float4x4
            updateTranslationMatrix(&translation)
            planeNode.simdTransform = matrix_multiply(transform, translation)
            
        }
    }
    
    func updateTranslationMatrix(_ translation: inout simd_float4x4) {
        switch UIDevice.current.orientation{
        case .portrait, .portraitUpsideDown, .unknown, .faceDown, .faceUp:
            print("portrait ")
            translation.columns.0.x = -cos(.pi/2)
            translation.columns.0.y = sin(.pi/2)
            translation.columns.1.x = -sin(.pi/2)
            translation.columns.1.y = -cos(.pi/2)
        case .landscapeLeft :
            print("landscape left")
            translation.columns.0.x = 1
            translation.columns.0.y = 0
            translation.columns.1.x = 0
            translation.columns.1.y = 1
        case .landscapeRight :
            print("landscape right")
            translation.columns.0.x = cos(.pi)
            translation.columns.0.y = -sin(.pi)
            translation.columns.1.x = sin(.pi)
            translation.columns.1.y = cos(.pi)
        default:
            break
        }
        translation.columns.3.z = -0.15 //60cm in front of the camera
    }
    
    @objc func clear(_ sender: UIBarButtonItem) {
//        sceneView.scene.rootNode.enumerateChildNodes({ node, _ in
//            node.removeFromParentNode()
//        })
        snapshots.forEach({$0.removeFromParentNode()})
        snapshots.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
         let node = SCNNode()
     
         return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
