//
//  ViewController.swift
//  arDrawing
//
//  Created by A4-iMAC01 on 11/02/2021.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
        // Do any additional setup after loading the view.
        //self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("Renderizando")
        //Almacenar la ubicacion y orientacion de la camara
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let frontOfCamera = orientation + location
        //print(orientation.x,orientation.y,orientation.z)
        DispatchQueue.main.async {
            if self.draw.isHighlighted{
                print("Esta dibujando")
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = frontOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            }else{
                print("No esta dibujando")
                let pointer = SCNNode(geometry: SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 1))
                pointer.position = frontOfCamera
                self.sceneView.scene.rootNode.enumerateChildNodes({(node,_) in
                    if node.geometry is SCNBox{
                        node.removeFromParentNode()
                    }
                })
                //Eliminar todos los cursores antes de añadir el siguiente
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                self.sceneView.scene.rootNode.addChildNode(pointer)
                
            }
            
        }
    }
}

func +(left:SCNVector3, right:SCNVector3) -> SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
