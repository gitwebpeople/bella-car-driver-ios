//
//  CabRequestedUV.swift
//  DriverApp
//
//  Created by ADMIN on 25/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import AudioToolbox


class CabRequestedUV: UIViewController, OnLocationUpdateDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var pickUpAddContainerView: UIView!
    @IBOutlet weak var pickUpAddViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pickUpHLbl: MyLabel!
    @IBOutlet weak var pickUpVLbl: MyLabel!
    @IBOutlet weak var progressCntainerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var progressCntainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var gMapContainer: UIView!
//    @IBOutlet weak var dialPView: UIView!
    @IBOutlet weak var mcDialView: CircleProgressView!
    @IBOutlet weak var destHLbl: MyLabel!
    @IBOutlet weak var destVLbl: MyLabel!
    @IBOutlet weak var destAddrContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var destAddContainerView: UIView!
    @IBOutlet weak var userRatingBar: RatingView!
    @IBOutlet weak var userNameLbl: MyLabel!
    @IBOutlet weak var timerLbl: MyLabel!
    @IBOutlet weak var requestTypeLbl: MyLabel!
    @IBOutlet weak var pickUpAddTopMargin: NSLayoutConstraint!
    @IBOutlet weak var deliveryPackageView: UIView!
    @IBOutlet weak var packageInfoLbl: MyLabel!
    @IBOutlet weak var bottomAreaHeight: NSLayoutConstraint!
    
    @IBOutlet weak var jobRefLblHeight: NSLayoutConstraint!
    @IBOutlet weak var jobRefView: UIView!
    @IBOutlet weak var jobTypeLbl: MyLabel!
    @IBOutlet weak var jobRefHLbl: MyLabel!
    @IBOutlet weak var jobRefVLbl: MyLabel!
    @IBOutlet weak var jobRefViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rentalPackageNameLbl: MyLabel!
    
    // Multidelivery Outlets
    @IBOutlet weak var deliveryPackageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var packageInfoLblXPosition: NSLayoutConstraint!
    
    var generalFunc = GeneralFunctions()
    
    let passengerMarker : GMSMarker = GMSMarker()
    
    var passengerJsonDetail_dict:NSDictionary?
    
    var isOnForground = true
//    var startTime:TimeInterval!
    
    var timer:Timer!
    
    var initializedMiliSeconds:Int64!
    
    var progressTapGue = UITapGestureRecognizer()
    
    var currentSecond = UInt8(0)
    
    var REQUEST_TYPE = ""
    
    var isPageLoaded = false
    
//    var mcDialView:CircleProgressView!
    
    var gMapView:GMSMapView!
    
    var cntView:UIView!
    
    var isScreenKilled = false
    
    var PAGE_HEIGHT:CGFloat = 690
    var PAGE_HEIGHT_OFFSET:CGFloat = 50
    var initializedSeconds:Int64 = 30
    
    var isAddressLoaded = false
    
    var RIDER_REQUEST_ACCEPT_TIME = 30
    
    var isCancelReqFired = false
    
    var isSafeAreaSet = false
    
    var currentLocation:CLLocation?
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        isOnForground = true
        
        if(isScreenKilled == true){
            self.closePassengerRequest()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        isOnForground = false
    }
    
    deinit {
        
        releaseAllTask()
        
    }
    
    @objc func releaseAllTask(){
        
        progressTapGue.removeTarget(self, action: nil)
        
        if(self.timer != nil){
            self.timer.invalidate()
        }
        
        if(gMapView != nil){
            gMapView.clear()
            gMapView.removeFromSuperview()
            gMapView = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "true" as AnyObject)
         self.updateStatus(status: "Open")
        
        cntView = self.generalFunc.loadView(nibName: "CabRequestedScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        
        scrollView.backgroundColor = UIColor.clear
        
        let navHeight = self.navigationController!.navigationBar.frame.height
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        
        self.navigationItem.titleView = imageView
        
        let acceptBtn = UIBarButtonItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT"), style: .plain, target: self, action: #selector(self.acceptTapped))
        self.navigationItem.rightBarButtonItem = acceptBtn
        
        let declineBtn = UIBarButtonItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINE_TXT"), style: .plain, target: self, action: #selector(self.declineTapped))
        self.navigationItem.leftBarButtonItem = declineBtn
        
        self.viewDetailsBtn.isUserInteractionEnabled = true
        self.viewDetailsBtn.setTitle(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_DETAILS").uppercased(), for: UIControl.State.normal)
        
        self.bgImgView.image = UIImage(named: "ic_bg_request")
	
        
        switch UIDevice().type {
        case .iPhone4:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone4S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone5:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone5S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        case .iPhone6:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone6plus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhone6S:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone6Splus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhone7:
            self.bgImgView.image = UIImage(named: "ic_bg_request@750")
        case .iPhone7plus:
            self.bgImgView.image = UIImage(named: "ic_bg_request@1242")
        case .iPhoneSE:
            self.bgImgView.image = UIImage(named: "ic_bg_request@640")
        default:
            print("default")
        }
        
        RIDER_REQUEST_ACCEPT_TIME = GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) == nil ? 30 : GeneralFunctions.parseInt(origValue: 30, data: (GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) as! String))
        
        initializedSeconds = Int64(RIDER_REQUEST_ACCEPT_TIME)
        
        self.mcDialView.trackBackgroundColor = UIColor.UCAColor.AppThemeTxtColor
        self.mcDialView.trackFillColor = UIColor.UCAColor.AppThemeColor
        mcDialView.roundedCap = true
        
        Utils.createRoundedView(view: gMapContainer, borderColor: Color.clear, borderWidth: 0)
        
        setData()
        
        self.jobRefViewHeight.constant = 0
        
//        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//        let APP_TYPE = userProfileJson.get("APP_TYPE")
        
        
        self.jobRefView.isHidden = true
        
        if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
            self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            
            self.requestTypeLbl.isHidden = false
            self.deliveryPackageView.isHidden = false
            self.packageInfoLbl.text = self.passengerJsonDetail_dict!.get("PACKAGE_TYPE").trim()
    //            self.packageInfoLbl.fitText()
            PAGE_HEIGHT = PAGE_HEIGHT - PAGE_HEIGHT_OFFSET
            
            if(Configurations.isRTLMode()){
                 self.packageInfoLblXPosition.constant = -40
            }else{
                 self.packageInfoLblXPosition.constant = 40
            }
            
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Ride){
            self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            
            if (self.passengerJsonDetail_dict!.get("ePoolRequest").uppercased() == "YES"){
                
                self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_POOL_REQUEST") + " (" + Configurations.convertNumToAppLocal(numStr: self.passengerJsonDetail_dict!.get("iPersonSize")) + " " +  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON") + ")"
            }
            
            self.requestTypeLbl.isHidden = false
            self.deliveryPackageView.isHidden = true
            
            PAGE_HEIGHT = PAGE_HEIGHT - 80 - PAGE_HEIGHT_OFFSET
            
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
            
            self.jobRefView.isHidden = false
           
            var textHeight:CGFloat = 0
            
            self.requestTypeLbl.isHidden = false
            self.deliveryPackageView.isHidden = true
            self.jobRefViewHeight.constant = 86
            
//            if(self.passengerJsonDetail_dict!.get("eFareType") != "Regular"){
                self.pickUpAddContainerView.isHidden = true
                
                self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST")
            
//            self.jobTypeLbl.text = self.passengerJsonDetail_dict!.get("SelectedTypeName")
            self.jobTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "Loading service type", key: "LBL_LOAD_SERVICE_TYPE")
            
            
                self.jobTypeLbl.fitText()
                
                textHeight = textHeight + self.passengerJsonDetail_dict!.get("SelectedTypeName").height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 18)!) + 25
                
                self.pickUpAddViewHeight.constant = 0
                self.progressCntainerViewWidth.constant = 160
                self.progressCntainerViewHeight.constant = 90
                
                self.PAGE_HEIGHT = self.PAGE_HEIGHT - 225
                self.mcDialView.isHidden = true
                self.gMapContainer.isHidden = true
                
                self.progressContainerView.backgroundColor = UIColor.clear
                Utils.createRoundedView(view: self.progressContainerView, borderColor: UIColor(hex: 0xFFFFFF), borderWidth: 1.0, cornerRadius: 10)
                self.progressContainerView.layer.masksToBounds = true

                PAGE_HEIGHT = PAGE_HEIGHT - 80 + 10 - 210 // + self.jobRefViewHeight.constant
//            }else{
//                 self.requestTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST") + "\n" + self.passengerJsonDetail_dict!.get("SelectedTypeName")
//                
//                PAGE_HEIGHT = PAGE_HEIGHT - 80 + self.jobRefViewHeight.constant
//            }
            
            self.requestTypeLbl.fitText()
            textHeight = textHeight + self.requestTypeLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 20
            
            PAGE_HEIGHT = PAGE_HEIGHT + textHeight
            
            
        }else{
            self.pickUpAddTopMargin.constant = self.pickUpAddTopMargin.constant - 15
            
            self.requestTypeLbl.text = ""
            self.requestTypeLbl.isHidden = true
            self.deliveryPackageView.isHidden = true
            
            PAGE_HEIGHT = PAGE_HEIGHT - 80 - 25 - PAGE_HEIGHT_OFFSET
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            self.bottomAreaHeight.constant = self.bottomAreaHeight.constant + GeneralFunctions.getSafeAreaInsets().bottom
            if(Configurations.isIponeXDevice()){
                self.bottomAreaHeight.constant = self.bottomAreaHeight.constant - 15
            }
            isSafeAreaSet = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            self.scrollView.bounces = false
            //            self.scrollView.setContentViewSize(offset: 15, currentMaxHeight: self.scrollViewCOntentViewHeight.constant)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            
            
            let latitude = GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLatitude"))
            let longitude = GeneralFunctions.parseDouble(origValue: 0.0, data: self.passengerJsonDetail_dict!.get("sourceLongitude"))
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: Utils.defaultZoomLevel)
            gMapView = GMSMapView.map(withFrame: self.gMapContainer.frame, camera: camera)
            
            gMapView.center = CGPoint(x: gMapContainer.bounds.midX, y: gMapContainer.bounds.midY)
            //        googleMapContainerView = gMapView
            //        gMapView = GMSMapView()
            gMapView.isMyLocationEnabled = false
            
            passengerMarker.position = CLLocationCoordinate2DMake(latitude, longitude)
            if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
                passengerMarker.icon = UIImage(named: "ic_sender")
            }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
                passengerMarker.icon = UIImage(named: "ic_user")
            }else{
                passengerMarker.icon = UIImage(named: "ic_passenger")
            }
            passengerMarker.map = self.gMapView
            passengerMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)

            
            let bgView = UIView()
            
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.4
            bgView.frame = self.gMapContainer.frame
            bgView.center = CGPoint(x: gMapContainer.bounds.midX, y: gMapContainer.bounds.midY)
            
            self.gMapContainer.addSubview(gMapView)
            self.gMapContainer.addSubview(bgView)
            
            Utils.createRoundedView(view: bgView, borderColor: Color.clear, borderWidth: 0)
            Utils.createRoundedView(view: gMapView, borderColor: Color.clear, borderWidth: 0)
            
            let getLocation = GetLocation(uv: self, isContinuous: true)
            getLocation.buildLocManager(locationUpdateDelegate: self)
            
            isPageLoaded = true
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
    }
    
    @IBAction func viewMultiDetailsBtnAction(_ sender: UIButton) {
    }
   
    func setData(){
        
        timerLbl.text = "00:00"
        timerLbl.text = Configurations.convertNumToAppLocal(numStr: timerLbl.text!)
        
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
//        startTime = Date.timeIntervalSinceReferenceDate
        if(initializedMiliSeconds != nil && (Utils.currentTimeMillis() - initializedMiliSeconds!) < (RIDER_REQUEST_ACCEPT_TIME * 1000)){
            
//            currentSecond = UInt8((Utils.currentTimeMillis() - initializedMiliSeconds!)/1000)
//            startTime = TimeInterval((Utils.currentTimeMillis() - initializedMiliSeconds!) / 1000)

            initializedSeconds = initializedSeconds - ((Utils.currentTimeMillis() - initializedMiliSeconds!)/1000)
        }else if(initializedMiliSeconds != nil && (Utils.currentTimeMillis() - initializedMiliSeconds!) > ((RIDER_REQUEST_ACCEPT_TIME - 1) * 1000)){
//            startTime = Date.timeIntervalSinceReferenceDate 
            
            self.mcDialView.progress  = 0
            
            self.updateStatus(status: "Timeout")
            self.isScreenKilled = true
            self.closePassengerRequest()
        }
        
        timer.fire()
        
        Utils.createRoundedView(view: progressContainerView, borderColor: Color.clear, borderWidth: 0)
        
        userNameLbl.text = self.passengerJsonDetail_dict!.get("PName")
        
        if(Configurations.isRTLMode()){
            userNameLbl.textAlignment = .left
        }
        
        self.userRatingBar.fullStarColor = UIColor.UCAColor.requestPageRatingFillColor
        self.userRatingBar.rating = self.passengerJsonDetail_dict!.get("PRating") == "" ? 0 : Float(self.passengerJsonDetail_dict!.get("PRating"))!
        
        let destLatitude = self.passengerJsonDetail_dict!.get("destLatitude")
        let destLongitude = self.passengerJsonDetail_dict!.get("destLongitude")
        let sourceLatitude = self.passengerJsonDetail_dict!.get("sourceLatitude")
        let sourceLongitude = self.passengerJsonDetail_dict!.get("sourceLongitude")
        
        self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pick Up Address", key: "LBL_PICK_UP_ADDRESS").uppercased()
        self.pickUpVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
        
        
        self.jobRefHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT")
        self.jobRefHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.jobRefVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOADING_TXT")
        
        if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Sender location", key: "LBL_SENDER_LOCATION").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Receiver's Location", key: "LBL_RECEIVER_LOCATION").uppercased()
            
            progressContainerView.isUserInteractionEnabled = true
            self.progressTapGue.addTarget(self, action: #selector(self.acceptTapped))
            progressContainerView.addGestureRecognizer(progressTapGue)
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_Ride){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pickup Location", key: "LBL_PICKUP_LOCATION_TXT").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Destination Address", key: "LBL_DEST_ADD_TXT").uppercased()
            
            progressContainerView.isUserInteractionEnabled = true
            self.progressTapGue.addTarget(self, action: #selector(self.acceptTapped))
            progressContainerView.addGestureRecognizer(progressTapGue)
        }else if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pick Up Address", key: "LBL_PICK_UP_ADDRESS").uppercased()
            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Job Location", key: "LBL_JOB_LOCATION_TXT").uppercased()
        }
//        else{
//            self.pickUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pick Up Address", key: "LBL_PICK_UP_ADDRESS").uppercased()
//            self.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_TXT").uppercased()
//        }
        
        if(destLatitude == "" || destLongitude == ""){
            self.destVLbl.text = "----"
            
            checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: "", destLongitude: "")
        }else{
            self.destVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOAD_ADDRESS")
            checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude, destLongitude: destLongitude)
        }
//        checkAddressForLocation(sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude_str, destLongitude: destLongitude_str)
    }
    
    
    @objc func acceptTapped(){
        
//        if(isAddressLoaded == false){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please wait for address to be loaded.", key: "LBL_WAIT_FOR_ADDRESS"))
//            return
//        }
        
        if(timer != nil){
            timer.invalidate()
        }
        
        if(self.currentLocation == nil){
            self.currentLocation = CLLocation.init(latitude: 0.0, longitude: 0.0)
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        let parameters = ["type":"GenerateTrip","DriverID": GeneralFunctions.getMemberd(), "PassengerID": self.passengerJsonDetail_dict!.get("PassengerId"), "start_lat": self.passengerJsonDetail_dict!.get("sourceLatitude"), "start_lon": self.passengerJsonDetail_dict!.get("sourceLongitude"), "iCabBookingId": self.passengerJsonDetail_dict!.get("iBookingId"), "sAddress": self.pickUpVLbl.text!, "vDeviceType": Utils.deviceType, "GoogleServerKey": Configurations.getGoogleServerKey(), "UserType": Utils.appUserType, "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode"), "iCabRequestId": self.passengerJsonDetail_dict!.get("iCabRequestId"),"ride_type":self.passengerJsonDetail_dict!.get("REQUEST_TYPE"),"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.releaseAllTask()
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                    
                }else{
                    
                    if(dataDict.get(Utils.message_str) != "" && dataDict.get(Utils.message_str) == "LBL_DRIVER_BLOCK"){
                        if(dataDict.get("isShowContactUs") == "Yes"){
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUv)
                                }else{
                                    self.declineTapped()
                                }
                                
                            })
                            return
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                            self.declineTapped()
                            return
                        }
                    }else{
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if(dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                                let window = Application.window
                                
                                let getUserData = GetUserData(uv: self, window: window!)
                                getUserData.getdata()
                            }else{
                                self.declineTapped()
                            }
                            
                        })
                    }
                  
                }
                
            }else{
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                    
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                })
//                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func declineTapped(){
        declineRequest()
    }
    
    @objc func updateTime(){
        initializedSeconds = initializedSeconds - 1
        
        if((initializedSeconds % 5) == 0 && isOnForground){
            AudioServicesPlayAlertSound(1315)
//            currentSecond = initializedSeconds
        }
        
        
        if(initializedSeconds < 1){
            timer.invalidate()
            progressContainerView.removeGestureRecognizer(progressTapGue)
            self.navigationItem.rightBarButtonItem!.isEnabled = false
            self.updateStatus(status: "Timeout")
            closePassengerRequest()
            
            return
            
        }
        
        let minutes = Double(initializedSeconds / 60).roundTo(places: 0)
        
        let cusSeconds = Double(initializedSeconds) - (minutes * 60)
        
        let strSeconds = String(format: "%02d", Int(cusSeconds))
        let strMinutes = String(format: "%02d", Int(minutes))
        timerLbl.text = "\(strMinutes):\(strSeconds)"
        timerLbl.text = Configurations.convertNumToAppLocal(numStr: timerLbl.text!)
        
        let value = initializedSeconds
        
        let final = Double(value) / Double(RIDER_REQUEST_ACCEPT_TIME)
        
        self.mcDialView.progress  = final
        
        timerLbl.fitText()
    }
    
    func closePassengerRequest(){
        //        self.navigationController?.popViewControllerAnimated(true)
        timer.invalidate()
        progressContainerView.removeGestureRecognizer(progressTapGue)
        
        GeneralFunctions.saveValue(key: Utils.DRIVER_CURRENT_REQ_OPEN_KEY, value: "false" as AnyObject)
        
        
        if(isCancelReqFired == false){
            ConfigPubNub.getInstance().publishMsg(channelName: "PASSENGER_\(self.passengerJsonDetail_dict!.get("PassengerId"))", content: GeneralFunctions.buildRequestCancelJson(iUserId: self.passengerJsonDetail_dict!.get("PassengerId"), vMsgCode: self.passengerJsonDetail_dict!.get("MsgCode")))
            isCancelReqFired = true
        }
        
        isScreenKilled = true
        
        if(isOnForground){
//            self.navigationController?.popViewController(animated: true)
//            self.dismiss(animated: true, completion: nil)
            self.releaseAllTask()
            self.closeCurrentScreenAnimConfig(isAnimated: false)
        }
    }
    
    func checkAddressForLocation(sourceLatitude:String, sourceLongitude:String, destLatitude:String, destLongitude:String){
        
        if(self.passengerJsonDetail_dict!.get("iCabRequestId") != ""){
            self.checkCabReqAddress()
            return
        }

        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLatitude),\(sourceLongitude)&destination=\(destLatitude == "" ? sourceLatitude : destLatitude),\(destLongitude == "" ? sourceLongitude : destLongitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true"
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)

        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("routes").count == 0){
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        self.checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude, destLongitude: destLongitude)
                    })
                    return
                }
                
                self.isAddressLoaded = true
                
                let routesArr = dataDict.getArrObj("routes")
                let legs_arr = (routesArr.object(at: 0) as! NSDictionary).getArrObj("legs")
                let start_address = (legs_arr.object(at: 0) as! NSDictionary).get("start_address")
                let end_address = (legs_arr.object(at: 0) as! NSDictionary).get("end_address")
                
                self.pickUpVLbl.text = start_address
                self.destVLbl.text = (destLatitude == "" || destLongitude == "" ) ? "----" : end_address
                
                
//                self.navigationItem.rightBarButtonItem!.isEnabled = true
                
            }else{
//                self.generalFunc.setError(uv: self)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.checkAddressForLocation(sourceLatitude: sourceLatitude, sourceLongitude: sourceLongitude, destLatitude: destLatitude, destLongitude: destLongitude)
                })
            }
        }, url: directionURL)
    }
    
    func checkCabReqAddress(){
        let parameters = ["type":"getCabRequestAddress","iCabRequestId": self.passengerJsonDetail_dict!.get("iCabRequestId"), "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode"), "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                self.isAddressLoaded = true
                if(dataDict.get("Action") == "1"){
                    let msg = dataDict.getObj(Utils.message_str)
                    
                    self.isAddressLoaded = true
                    
                    let destLatitude = self.passengerJsonDetail_dict!.get("destLatitude")
                    let destLongitude = self.passengerJsonDetail_dict!.get("destLongitude")
                    
                    self.pickUpVLbl.text = msg.get("tSourceAddress")
                    self.destVLbl.text = (destLatitude == "" || destLongitude == "" ) ? "----" : msg.get("tDestAddress")
                    self.jobRefVLbl.text = msg.get("tUserComment") == "" ? "----" : msg.get("tUserComment")
                    self.jobRefVLbl.fitText()
                    
                    self.jobTypeLbl.text = msg.get("SelectedTypeName")
                    self.jobTypeLbl.fitText()
                    
                    
                    if msg.get("iRentalPackageId") != ""{
                        self.rentalPackageNameLbl.text = msg.get("PackageName")
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + 20
                        self.pickUpAddTopMargin.constant = 20
                    }else{
                        self.rentalPackageNameLbl.isHidden = true
                    }
                    
                    if(self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX){
                        
                        let vTypeHeight = msg.get("SelectedTypeName").height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 18)!)
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + vTypeHeight
                        
                        let refTextHeight = self.jobRefVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                        let extraHeight = 86 + refTextHeight
                        
                        self.jobRefViewHeight.constant =  extraHeight
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + extraHeight
                        
//                        if(self.passengerJsonDetail_dict!.get("eFareType") != "Regular"){
                            self.destVLbl.text = msg.get("tSourceAddress")
                            self.destVLbl.fitText()
                            
                            let addressHeight = self.destVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                            
                            self.destAddrContainerHeight.constant =  86 + addressHeight
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + addressHeight
                            
//                        }
                        
                    }else{
                        
                        if self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"
                        {
                            var recHTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT").uppercased()
                            let count:Int = Int(msg.get("Total_Delivery"))!
                            if count > 1
                            {
                                recHTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_RECIPIENTS").uppercased()
                            }
                            self.destVLbl.isHidden = true
                            self.destHLbl.textColor = UIColor.white
                            self.destHLbl.font = UIFont.systemFont(ofSize: 19)
                            self.destHLbl.text = "\(recHTxt): \(msg.get("Total_Delivery").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_MODE_TXT").uppercased()): \(msg.get("ePayType").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOTAL_DISTANCE").uppercased()): \(msg.get("fDistance").uppercased())\n\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Total_Fare").uppercased()): \(msg.get("fTripGenerateFare").uppercased())\n"
                            
                            self.deliveryPackageView.isHidden = true
                            self.deliveryPackageViewHeight.constant = 0
                            self.viewDetailsBtn.isHidden = false
                        }
                        
                        if(msg.get("VehicleTypeName") != "" && self.passengerJsonDetail_dict!.get("ePoolRequest").uppercased() != "YES"){
                            var requestTxt = "\(self.requestTypeLbl.text!) (\(msg.get("VehicleTypeName")))"
                            if msg.get("iRentalPackageId") != ""{
                                requestTxt = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENTAL_RIDE_REQUEST")) (\(msg.get("VehicleTypeName")))"
                            }
                            let vTypeHeight = requestTxt.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                            self.requestTypeLbl.text = requestTxt
                            self.requestTypeLbl.fitText()
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + vTypeHeight
                        }
                        
                        let pickUpAddressHeight = self.pickUpVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                        self.pickUpVLbl.fitText()
                            
                        self.pickUpAddViewHeight.constant = 86 + pickUpAddressHeight
                        
                        
                        let destAddHeight = self.destVLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().light, size: 20)!) - 24
                        self.destVLbl.fitText()
                        
                        if self.passengerJsonDetail_dict!.get("REQUEST_TYPE") == "Multi-Delivery"
                        {
                            self.destAddrContainerHeight.constant = 165 + destAddHeight
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.destAddrContainerHeight.constant 
                            
                        }else
                        {
                            self.destAddrContainerHeight.constant = 86 + destAddHeight
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + pickUpAddressHeight + destAddHeight
                        }
                      
                    }
                    
                    if(msg.get("moreServices").uppercased() == "YES"){
                        
                        self.jobRefVLbl.text = ""
                        self.jobRefHLbl.text = ""
                        self.jobRefHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                        self.jobRefHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                        self.jobRefHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_REQUESTED_SERVICES")
                        self.jobRefHLbl.font = UIFont.init(name: Fonts().regular, size: 16)
                        self.jobRefLblHeight.constant = 35
                        
                        self.jobRefHLbl.setClickHandler { (instance) in
                        }
                    }
                    self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)

                }else{
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.checkCabReqAddress()
                })
            }
        })
    }
    
    func declineRequest(){
        self.updateStatus(status: "Decline")
        let parameters = ["type":"DeclineTripRequest","DriverID": GeneralFunctions.getMemberd(), "PassengerID": self.passengerJsonDetail_dict!.get("PassengerId"), "vMsgCode": self.passengerJsonDetail_dict!.get("MsgCode")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.closePassengerRequest()
        })
    }
    
    func updateStatus(status:String){
        if(self.passengerJsonDetail_dict == nil){
            return
        }
        
        CabRequestStatus.updateDriverRequestStatus(PassengerId: (self.passengerJsonDetail_dict!.get("PassengerId")), UpdatedStatus: status, ReceiverByscriptName: "AppReqState", repeatCount: 1, vMsgCode: (self.passengerJsonDetail_dict!.get("MsgCode")))
    }
    
}
