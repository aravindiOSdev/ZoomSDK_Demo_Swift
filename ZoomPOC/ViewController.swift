//
//  ViewController.swift
//  ZoomPOC
//
//  Created by k.chinnababu on 02/08/20.
//  Copyright © 2020 Zinier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var reStartButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!

    
    @IBAction func loginAndStartMeeting(_ sender: Any) {
        ZoomService.sharedInstance.login(email: "kolluvenu4u@gmail.com", password: "KOLLUvenu@435")
    }
    
    @IBAction func joinZoomMeeting(_ sender: Any) {
        ZoomService.sharedInstance.joinMeeting(number: 79244569196)
    }
    
    @IBAction func startMeeting(_ sender: Any) {
        if let status = ZoomService.sharedInstance.loginStatus{
            if status == 1{
                ZoomService.sharedInstance.logout()
            }
        }
        ZoomService.sharedInstance.startMeeting()
    }
    @IBAction func logoutAction(_ sender: Any) {
        ZoomService.sharedInstance.logout()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        ZoomService.sharedInstance.callbackForLogin = {
//            (loginStatus) in
//            print(loginStatus)
//        }
//    }
    
    func handleUIChanges(){
        ZoomService.sharedInstance.callbackForLogin = {
            (loginStatus) in
            if loginStatus == 1 {
                self.loginButton.alpha = 0.3
                self.loginButton.isUserInteractionEnabled = false
            }
        }
    }

}

