//
//  ZoomViewController.swift
//  Zinier 2.0
//
//  Created by Abhishek Kumar on 4/20/20.
//  Copyright © 2020 Zinier. All rights reserved.
//

import Foundation
import MobileRTC

private struct ZoomAPI {
  // SDK Info for using MobileRTC.
 static let domain = "zoom.us"
//  static let appKey = "Aer39Ag8cGRPxxwyi78QqBUkC6NVnr999k7B"
//  static let appSecret = "9uKrluTx9VDEfFPMGd9ki5zb48dql9v13Eia"
    static let appKey = "Ouy0JzCZCK3VjPSX4FdokDQRl692laubZRvN"
    static let appSecret = "CoNfWVM1clOWcv1s6gyeAAh0biq8JQej65vU"
  
    
  // API User info for starting calls as API user.
  static let userID = ""
  static let userToken = ""
  
  // Default display name for meetings.
  static let defaultName = "Venu as User"
}

public struct ZoomMeeting {
  var number: Int
  var password: String = ""
  var topic: String?
  var startTime: Date?
  var timeZone: TimeZone?
  var durationInMinutes: UInt
}

protocol TestZoom {
    func showAlert(message: String)
    func getAuthenticationSucess(isAuthenticated: Bool)
}

// MARK: - ZoomService API Authentication

class ZoomService: NSObject, MobileRTCAuthDelegate {
  
  static let sharedInstance = ZoomService()
  
  var isAPIAuthenticated = false
  var isUserAuthenticated = false
  var userMeetings: [ZoomMeeting] = []
    var delegate: TestZoom?
  var callbackForLogin : ((Int?) -> Void)?

  var loginStatus : Int?

  // Authenticates user to use MobileRTC.
  func authenticateSDK() {
    let context: MobileRTCSDKInitContext = MobileRTCSDKInitContext()
    context.domain = ZoomAPI.domain
    context.enableLog = true
    context.locale = MobileRTC_ZoomLocale.default
    
    let zoomSDK = MobileRTC.shared().initialize(context)
    guard zoomSDK == true,
        let authService = MobileRTC.shared().getAuthService() else { return }
    authService.delegate = self
    authService.clientKey = ZoomAPI.appKey
    authService.clientSecret = ZoomAPI.appSecret
    authService.sdkAuth()
  }
  
  // Handled by MobileRTCAuthDelegate, returns result of authenticateSDK function call.
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        guard returnValue == MobileRTCAuthError_Success else {
            self.delegate?.getAuthenticationSucess(isAuthenticated: true)
            print("Zoom: API authentication task failed, error code: \(returnValue.rawValue)")
            
            return
        }
        isAPIAuthenticated = true
//        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//        if let end = appDelegate?.endID {
//            appDelegate?.endCall(call: (appDelegate?.endID)!)
//        }
//        self.delegate?.getAuthenticationSucess(isAuthenticated: false)
//        print("Zoom: API authentication task completed.")
    }
}

// MARK: - ZoomService Meeting Management

extension ZoomService {
    
    func testZoom1() {
    }
  
  // Join a Zoom meeting.
    //73908324949
    //3683135754
    func joinMeeting(name: String = ZoomAPI.defaultName, number: Int = 79244569196, password: String = "", isCallKit: Bool = false) {
        guard isAPIAuthenticated || isUserAuthenticated,
            let meetingService = MobileRTC.shared().getMeetingService() else {
                self.delegate?.showAlert(message:String(format: "Zoom:  meeting service  task failed %d, %d %d", isAPIAuthenticated,  isUserAuthenticated, 3))
return }
        meetingService.delegate = self
        if meetingService.isSupportedVOIP(){
            print("chinna audop")

        } else {
            //self.delegate?.showAlert(message: "audio Not enabled")
            print("chinna no audop")

        }
        if isCallKit {
            meetingService.resetMeetingAudioForCallKitHeld()
        }
        
        var paramDict: [String : Any] = [
            kMeetingParam_Username : name,
            kMeetingParam_MeetingNumber : "\(number)"
        ]
        
        if password.count > 0 {
            paramDict[kMeetingParam_MeetingPassword] = password
        }
        let settings = MobileRTC.shared().getMeetingSettings()
        settings?.setAutoConnectInternetAudio(true)        
        meetingService.connectMyAudio(true)
        let returnValue = meetingService.joinMeeting(with: paramDict)
        
        guard returnValue == MobileRTCMeetError_Success else {
            self.delegate?.showAlert(message: "Zoom: Join meeting task failed")

            print("Zoom: Join meeting task failed, error code: \(returnValue.rawValue)")
            return
        }
        NotificationCenter.default.post(name: Notification.Name("meetingJoinedSucessFully"), object: nil)

        
        
        print("Zoom: Join meeting task completed.")
    }
    
    func muteZoomCall(isMute: Bool) {
        let meetingServce = MobileRTC.shared().getMeetingService()
        meetingServce?.muteMyAudio(isMute)
    }
    
    func leaveMeeting(){
        let meetingServce = MobileRTC.shared().getMeetingService()
        meetingServce?.leaveMeeting(with: .init(rawValue: 0))

    }
    
        func joinMeeting1(name: String = ZoomAPI.defaultName, number: Int, password: String = "", isCallKit: Bool = false, completion:((_ isSucess:Bool)-> Void?)) {
            guard isAPIAuthenticated || isUserAuthenticated,
                let meetingService = MobileRTC.shared().getMeetingService() else {
                  //  ZoomService.sharedInstance.authenticateSDK()
                    self.delegate?.showAlert(message:String(format: "Zoom:  meeting service  task failed %d, %d %d", isAPIAuthenticated,  isUserAuthenticated, 3))
    return }
            meetingService.delegate = self
            if meetingService.isSupportedVOIP(){
                print("chinna audop")

            } else {
                //self.delegate?.showAlert(message: "audio Not enabled")
                print("chinna no audop")

            }
            if isCallKit {
                meetingService.resetMeetingAudioForCallKitHeld()
            }
            
            var paramDict: [String : Any] = [
                kMeetingParam_Username : name,
                kMeetingParam_MeetingNumber : "\(number)"
            ]
            
            if password.count > 0 {
                paramDict[kMeetingParam_MeetingPassword] = password
            }
            
            let returnValue = meetingService.joinMeeting(with: paramDict)
            
            guard returnValue == MobileRTCMeetError_Success else {
                self.delegate?.showAlert(message: "Zoom: Join meeting task failed")

                print("Zoom: Join meeting task failed, error code: \(returnValue.rawValue)")
                return
            }
            
            completion(true)

            
            
            print("Zoom: Join meeting task completed.")
        }
  
  // Start a Zoom meeting immediately.
  func startMeeting(name: String = ZoomAPI.defaultName, number: Int = -1, password: String = "") {
    guard isAPIAuthenticated || isUserAuthenticated, let meetingService = MobileRTC.shared().getMeetingService() else { return }
    
    var paramDict: [String : Any] = [kMeetingParam_Username : name]
    
    if isAPIAuthenticated && !isUserAuthenticated {
      paramDict[kMeetingParam_UserID] = ZoomAPI.userID
      paramDict[kMeetingParam_UserToken] = ZoomAPI.userToken
    }
    
    if number != -1 {
      paramDict[kMeetingParam_MeetingNumber] = "\(number)"
    }
    
    if password.count > 0 {
      paramDict[kMeetingParam_MeetingPassword] = password
    }
    
    let returnValue = meetingService.startMeeting(with: paramDict)
    
    guard returnValue == MobileRTCMeetError_Success else {
      print("Zoom: Start meeting task failed, error code: \(returnValue.rawValue)")
      return
    }
    
    print("Zoom: Start meeting task completed.")
  }
}

// MARK: - ZoomService User + Meeting Scheduling Management

extension ZoomService: MobileRTCPremeetingDelegate {
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        print("sinkSchedultMeeting: result: \(result) meetingUniquedID: \(uniquedID)")
    }
    
    func sinkEditMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        print("sinkEditMeeting: result: \(result) meetingUniquedID: \(uniquedID)")
    }
    
    func sinkDeleteMeeting(_ result: PreMeetingError) {
        print("sinkDeleteMeeting: result: \(result)")
    }
    
    func sinkListMeeting(_ result: PreMeetingError, withMeetingItems array: [Any]) {
        print("sinkListMeeting: result: \(result) withMeetingItems: \(array)")
    }
    
    
    // Authenticate user as a Zoom member.
    func login(email: String, password: String) {
        guard isAPIAuthenticated,
            let authService = MobileRTC.shared().getAuthService() else { return }
        authService.login(withEmail: email, password: password, rememberMe: true)
        //authService.login(withSSOToken: email, rememberMe: true)
    }
    
    // Handled by MobileRTCPremeetingDelegate, returns result of login function call.
    func onMobileRTCLoginReturn(_ returnValue: Int) {
        guard returnValue == 0 else {
            print("Zoom (User): Login task failed, error code: \(returnValue)")
            return
        }
        
        isUserAuthenticated = true
        
        guard let preMeetingService = MobileRTC.shared().getPreMeetingService() else { return }
        preMeetingService.delegate = self
        
        print("Zoom (User): Login task completed.")
        if let cb = callbackForLogin {
            self.loginStatus = 1
            cb(loginStatus)
        }
        self.startMeeting()
    }
    
    // Logout as Zoom member if user is authenticated as Zoom member.
    func logout() {
        guard isUserAuthenticated, let authService = MobileRTC.shared().getAuthService() else { return }
        authService.logoutRTC()
    }
    
    // Handled by MobileRTCPremeetingDelegate, returns result of logout function call.
    func onMobileRTCLogoutReturn(_ returnValue: Int) {
        guard returnValue == 0 else {
            print("Zoom (User): Logout task failed, error code: \(returnValue)")
            return
        }
        
        isUserAuthenticated = false
        
        print("Zoom (User): Logout task completed.")
    }
    
    // Handled by MobileRTCPremeetingDelegate, prints a list of meetings the Zoom member has after scheduling, editing, or deleting a meeting.
    func sinkListMeeting(_ result: Int, withMeetingItems array: [Any]!) {
        guard result == 0 else {
            print("Zoom (User): List meeting task failed, error code: \(result)")
            return
        }
        
        userMeetings = []
        
        for meeting in array {
            if let meeting = meeting as? MobileRTCMeetingItem {
                let number = Int(meeting.getMeetingNumber())
                let password = meeting.getMeetingPassword() ?? ""
                let topic = meeting.getMeetingTopic()
                let startTime = meeting.getStartTime()
                
                let timeZone: TimeZone?
                if let timeZoneID = meeting.getTimeZoneID() {
                    timeZone = TimeZone(abbreviation: timeZoneID)
                } else {
                    timeZone = nil
                }
                
                let durationInMinutes = meeting.getDurationInMinutes()
                let zoomMeeting = ZoomMeeting(number: number, password: password, topic: topic, startTime: startTime, timeZone: timeZone, durationInMinutes: durationInMinutes)
                userMeetings.append(zoomMeeting)
            }
        }
        
        print("\nZoom (User): Found \(userMeetings.count) meetings.")
        
        for (index, meeting) in userMeetings.enumerated() {
            print("\n\(index + 1). Meeting number: \(meeting.number)")
            
            if meeting.password.count > 0 {
                print("   Meeting password: \(meeting.password)")
            }
            
            if meeting.topic != nil {
                print("   Meeting Topic: \(meeting.topic!)")
            } else {
                print("   Meeting Topic: <NO TOPIC>")
            }
            
            if meeting.startTime != nil {
                print("   Meeting Start Time: \(meeting.startTime!)")
            } else {
                print("   Meeting Start Time: <NO START TIME>")
            }
            
            if meeting.timeZone != nil {
                print("   Meeting Time Zone: \(meeting.timeZone!)")
            } else {
                print("   Meeting Time Zone: <NO TIME ZONE>")
            }
            
            print("   Meeting Duration: \(meeting.durationInMinutes) minute(s)")
        }
        
        print()
    }
    
    // Schedule a Zoom meeting as a Zoom member.
    func scheduleMeeting(topic: String, startTime: Date, timeZone: TimeZone = NSTimeZone.local, durationInMinutes: TimeInterval) {
        guard isUserAuthenticated, let preMeetingService = MobileRTC.shared().getPreMeetingService(), let meeting = preMeetingService.createMeetingItem() else { return }
        meeting.setMeetingTopic(topic)
        meeting.setStartTime(startTime)
        meeting.setTimeZoneID(timeZone.abbreviation()!)
        meeting.setDurationInMinutes(UInt(durationInMinutes))
        
        preMeetingService.scheduleMeeting(meeting, withScheduleFor: "Abhishek")
        preMeetingService.destroy(meeting)
    }
    
    // Handled by MobileRTCPremeetingDelegate, returns result of scheduleMeeting function call.
    func sinkSchedultMeeting(_ result: Int) {
        guard result == 0 else {
            print("Zoom (User): Schedule meeting task failed, error code: \(result)")
            return
        }
        
        print("Zoom (User): Schedule meeting task completed.")
    }
    
    // Edit an existing Zoom meeting as a Zoom member by providing a ZoomMeeting object.
    func editMeeting(_ zoomMeeting: ZoomMeeting, topic: String? = nil, startTime: Date? = nil, timeZone: TimeZone? = nil, durationInMinutes: TimeInterval? = nil) {
        editMeeting(number: zoomMeeting.number, topic: topic, startTime: startTime, timeZone: timeZone, durationInMinutes: durationInMinutes)
    }
    
    // Edit an existing Zoom meeting as a Zoom member by providing a Zoom meeting number.
    func editMeeting(number: Int, topic: String? = nil, startTime: Date? = nil, timeZone: TimeZone? = nil, durationInMinutes: TimeInterval? = nil) {
        guard isUserAuthenticated, let preMeetingService = MobileRTC.shared().getPreMeetingService(), let meeting = preMeetingService.getMeetingItem(byUniquedID: UInt64(UInt(number))) else { return }
        
        if let topic = topic {
            meeting.setMeetingTopic(topic)
        }
        
        if let startTime = startTime {
            meeting.setStartTime(startTime)
        }
        
        if let timeZone = timeZone {
            meeting.setTimeZoneID(timeZone.abbreviation()!)
        }
        
        if let durationInMinutes = durationInMinutes {
            meeting.setDurationInMinutes(UInt(durationInMinutes))
        }
        
        preMeetingService.editMeeting(meeting)
    }
    
    // Handled by MobileRTCPremeetingDelegate, returns result of editMeeting function call.
    func sinkEditMeeting(_ result: Int) {
        guard result == 0 else {
            print("Zoom (User): Edit meeting task failed, error code: \(result)")
            return
        }
        
        print("Zoom (User): Edit meeting task completed.")
    }
    
    // Delete an existing event as a Zoom member by providing a ZoomMeeting object.
    func deleteMeeting(_ zoomMeeting: ZoomMeeting) {
        deleteMeeting(number: zoomMeeting.number)
    }
    
    // Delete an existing event as a Zoom member by providing a Zoom meeting number.
    func deleteMeeting(number: Int) {
        guard isUserAuthenticated,
            let preMeetingService = MobileRTC.shared().getPreMeetingService(),
            let meeting = preMeetingService.getMeetingItem(byUniquedID: UInt64(UInt(number))) else { return }
        preMeetingService.deleteMeeting(meeting)
    }
    
    // Handled by MobileRTCPremeetingDelegate, returns result of deleteMeeting function call.
    func sinkDeleteMeeting(_ result: Int) {
        guard result == 0 else {
            print("Zoom (User): Delete meeting task failed, error code: \(result)")
            return
        }
        
        print("Zoom (User): Delete meeting task completed.")
    }
    
    func onJoinMeetingConfirmed() {
        print("meeting joined.")
    }
    
    
}
 extension ZoomService: MobileRTCMeetingServiceDelegate{
    
    func onSinkAttendeeChatPriviledgeChanged(_ currentPrivilege: MobileRTCMeetingChatPriviledgeType) {
        
        print("chinna123")
    }
    
    func on(inMeetingChat messageID: String) {
        let meetingServices = MobileRTC.shared().getMeetingService()
        let chat = meetingServices?.meetingChat(byID: messageID)
        let sender = chat?.senderName
        let receiver = chat?.receiverName
        print("chinna1234", chat, messageID, sender, receiver)
        
    }
    
}


  
