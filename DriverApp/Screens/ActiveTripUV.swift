//
//  ActiveTripUV.swift
//  DriverApp
//
//  Created by ADMIN on 29/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftExtensionData

class ActiveTripUV: UIViewController, GMSMapViewDelegate, OnLocationUpdateDelegate, AddressFoundDelegate, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate, DispatchDemoLocationsProtocol {

    
    var MENU_USER_OR_DELIVERY_DETAIL = "0"
    var MENU_USER_CALL = "1"
    var MENU_USER_MSG = "2"
    var MENU_EMERGENCY = "3"
    var MENU_CANCEL_TRIP = "4"
    var MENU_WAY_BILL = "5"
    var MENU_SPECIAL_INS = "6"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var topDataContainerStkView: UIStackView!
//    @IBOutlet weak var navigateView: UIView!
    @IBOutlet weak var topDataContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tripBtn: MyButton!
    @IBOutlet weak var addDestinationView: UIView!
    @IBOutlet weak var addDestinationLbl: MyLabel!
    
    @IBOutlet weak var addDestView: UIView!
    @IBOutlet weak var addDestLbl: MyLabel!
    
    @IBOutlet weak var btnIconBgView: UIView!
    @IBOutlet weak var btnIconImgView: UIImageView!
    @IBOutlet weak var rightArrowImgView: UIImageView!
//    @IBOutlet weak var tollNoteLbl: MyLabel!
    @IBOutlet weak var emeImgView: UIImageView!
    @IBOutlet weak var googleLogoImgView: UIImageView!
    
    //UFX related OutLets
    @IBOutlet weak var detailBottomVIew: UIView!
    @IBOutlet weak var senderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var senderImgView: UIImageView!
    @IBOutlet weak var sourceAddLbl: MyLabel!
    @IBOutlet weak var senderNameLbl: MyLabel!
    @IBOutlet weak var bottomPointViewHeight: NSLayoutConstraint!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var jobStatusTitleLbl: MyLabel!
    @IBOutlet weak var progressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressStatusTitleLbl: MyLabel!
    @IBOutlet weak var progressBtn: MyButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourVLbl: MyLabel!
    @IBOutlet weak var hourHLbl: MyLabel!
    @IBOutlet weak var minuteVLbl: MyLabel!
    @IBOutlet weak var minuteHLbl: MyLabel!
    @IBOutlet weak var secHLbl: MyLabel!
    @IBOutlet weak var secVLbl: MyLabel!
    @IBOutlet weak var ufxHeaderView: UIView!
    @IBOutlet weak var ufxHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var progressView: UIView!
    
    // Surge Price OutLets
    @IBOutlet weak var surgePriceHLbl: MyLabel!
    @IBOutlet weak var surgePriceVLbl: MyLabel!
    @IBOutlet weak var surgePayAmtLbl: MyLabel!
    @IBOutlet weak var surgeAcceptBtn: MyButton!
    @IBOutlet weak var surgeLaterLbl: MyLabel!
    
    // MultiDelivery
    @IBOutlet weak var deliveryDetailsImgView: UIImageView!
    @IBOutlet weak var deliveryCallImgView: UIImageView!
    @IBOutlet weak var googleLogoBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var recHLbl: UILabel!
    @IBOutlet weak var recNameValLbl: UILabel!
    @IBOutlet weak var noOfPersonLbl: UILabel!
    @IBOutlet weak var deliveryView: UIView!
    
    /* In-Transit Shopping System*/
    @IBOutlet weak var waitingProgressBtn: MyButton!
    @IBOutlet weak var waitingTimeLbl: MyLabel!
    
    /* MSP Changes*/
    @IBOutlet weak var mspCancelLbl: UILabel!
    @IBOutlet weak var mspCancelImgView: UIImageView!
    @IBOutlet weak var mspCancelCloseImgView: UIImageView!
    
    
    var surgePriceView:UIView!
    var surgePriceBGView:UIView!
    
    var dataArrList = [NSDictionary]()
    var loaderView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var isPageLoaded = false
    
    var currentLocation:CLLocation!
    var currentRotatedLocation:CLLocation!
    var currentHeading:Double = 0
    var isFirstHeadingCompleted = false
    
    var lastPublishedLoc:CLLocation!
    
    var gMapView:GMSMapView!
    
//    var navView:UIView!
    var topNavView:navigationVIew!
    
    var window:UIWindow!
    
    var getLocation:GetLocation!
    
    var isFirstLocationUpdate = true
    
    var tripData:NSDictionary!
    
    var menu:BTNavigationDropdownMenu!
    
    var updateDriverLoc:UpdateDriverLocations!
    
    var updateDirections:UpdateDirections!
    var updateTripLocationService:UpdateTripLocationService!
    
    let driverMarker: GMSMarker = GMSMarker()
    let destinationMarker: GMSMarker = GMSMarker()
    
    let btnPanGue = UIPanGestureRecognizer()
    
    var isTripStarted = false
    
    var isTripEndPressed = false
    
    var cancelReason = ""
   
   
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var tripTaskExecuted = false
    
    var iCancelReasonId = ""
    
    var locationDialog:OpenLocationEnableView!
    
    var isDeliveryCodeEntered = false
    
    var ufxCntView:UIView!
    
    var iTripTimeId = ""
    
    var totalSecond:Double = 0
    
    var isResume = true
    
    var jobTimer:Timer!
    var latitudeList = [String]()
    var longitudeList = [String]()
    
//    var PHOTO_UPLOAD_SERVICE_ENABLE = "No"
    
//    var UFX_PHOTO_SELECT_TASK_COMPLETED = false
    var serviceImageData:Data!
    
    var headerViewHeight:CGFloat = 347
    
    var userProfileJson:NSDictionary!
    
    var destinationOnTripLatitude = ""
    var destinationOnTripLongitude = ""
    var destinationOnTripAddress = ""
    
    var isTollChecked = false
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    var ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = ""
    
    var currentDestination:CLLocation!
    
    var PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT:Double = 5
    
    var dispatchDemoLocations:DispatchDemoLocations!
    
    /* MSP Changes*/
    var mspEndTimer:Timer!
    var isDropAll = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(updateDirections != nil){
           updateDirections.pauseDirectionUpdate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
        
        if(isPageLoaded == false){
            
            isPageLoaded = true
            
            if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular")){
                
                topNavView = navigationVIew(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 95))
                topNavView.backgroundColor = UIColor.clear
                
                if (tripData.get("DestLocLatitude") != "" && tripData.get("DestLocLatitude") != "0"
                    && tripData.get("DestLocLongitude") != "" && tripData.get("DestLocLongitude") != "0" &&
                    tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() ) {
//                    || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular"))
                    topDataContainerStkView.addArrangedSubview(topNavView)
                    topDataContainerViewHeight.constant = 95
                }else if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() ){
                    let addDestView = generalFunc.loadView(nibName: "AddDestinationView", uv: self, isWithOutSize: true)
                    addDestView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 50)
                    
                    topDataContainerStkView.addArrangedSubview(addDestView)
                    topDataContainerViewHeight.constant = 50
                }
                
                let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 0.0)
                gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
                
                gMapView.settings.rotateGestures = false
                gMapView.settings.tiltGestures = false
                gMapView.delegate = self
                self.googleMapContainerView.addSubview(gMapView)
                
                self.gMapView.bindFrameToSuperviewBounds()
            }else{
                let ufxCntView = self.generalFunc.loadView(nibName: "ActiveTripUFXScreenDesign", uv: self)
                ufxCntView.frame = self.googleMapContainerView.frame
                self.ufxCntView = ufxCntView
                self.googleMapContainerView.addSubview(ufxCntView)
            }
            
            setData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        window = Application.window!
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ActiveTripScreenDesign", uv: self, contentView: contentView))
        
        /** Used for configDriverTripStatus Type */
        GeneralFunctions.saveValue(key: "iTripId", value: self.tripData!.get("TripId") as AnyObject)
        /** Used for configDriverTripStatus Type */
        
        ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP = GeneralFunctions.getValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP_KEY) as! String
        PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT = GeneralFunctions.parseDouble(origValue: 5, data: GeneralFunctions.getValue(key: Utils.PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT_KEY) as! String)
        
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        self.btnIconBgView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
        GeneralFunctions.setImgTintColor(imgView: self.btnIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        Utils.createRoundedView(view: self.btnIconBgView, borderColor: Color.clear, borderWidth: 0)
        
        if(Configurations.isRTLMode()){
            var scalingTransform : CGAffineTransform!
            scalingTransform = CGAffineTransform(scaleX: -1, y: 1);
            self.rightArrowImgView.transform = scalingTransform
        }
        
        self.emeImgView.isHidden = true
        
        self.contentView.isHidden = true
        
//        self.PHOTO_UPLOAD_SERVICE_ENABLE = GeneralFunctions.getValue(key: "PHOTO_UPLOAD_SERVICE_ENABLE") == nil ? "No" : (GeneralFunctions.getValue(key: "PHOTO_UPLOAD_SERVICE_ENABLE") as! String)
        
        if(GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") != nil && (GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") as! String) == "true"){
            let chatUV = GeneralFunctions.instantiateViewController(pageName: "ChatUV") as! ChatUV
            
            GeneralFunctions.removeValue(key: "OPEN_MSG_SCREEN")
            
            chatUV.receiverId = tripData!.get("PassengerId")
            chatUV.receiverDisplayName = self.tripData!.get("PName")
            chatUV.assignedtripId = self.tripData!.get("TripId")
            self.pushToNavController(uv:chatUV, isDirect: true)
            
        }
        
        if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
        }
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"){
            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_active_waybill")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(wayBilltapped))
            self.navigationItem.rightBarButtonItem = rightButton
            
            self.deliveryDetailsImgView.isHidden = false
            
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
            self.deliveryDetailsImgView.isUserInteractionEnabled = true
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsImgView.addGestureRecognizer(detailsBtnTapGue)
            
            self.googleLogoBottomSpace.constant = 60
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
            self.deliveryView.isHidden = false
            self.deliveryCallImgView.isHidden = false
            
            GeneralFunctions.setImgTintColor(imgView: self.deliveryCallImgView, color: UIColor.white)
            self.deliveryCallImgView.isUserInteractionEnabled = true
            let delCallTapGue = UITapGestureRecognizer()
            delCallTapGue.addTarget(self, action: #selector(self.deliveryCallTapped))
            self.deliveryCallImgView.addGestureRecognizer(delCallTapGue)
            
            
            self.recHLbl.text = tripData!.get("Running_Delivery_Txt")
            self.recNameValLbl.text = tripData!.get("vReceiverName")
            
        }else if(self.tripData.get("ePoolRide").uppercased() == "YES") {  /* Pool Ride Bootom View*/
        
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
            self.deliveryDetailsImgView.isUserInteractionEnabled = true
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsImgView.addGestureRecognizer(detailsBtnTapGue)
            
            self.googleLogoBottomSpace.constant = 60
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
             self.deliveryCallImgView.isHidden = true
            self.deliveryView.isHidden = false
            self.noOfPersonLbl.isHidden = false
            self.recHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_DROPOFF").uppercased()
            self.recNameValLbl.text = self.tripData.get("PName") + " " + self.tripData.get("vLastName")
            self.noOfPersonLbl.text = Configurations.convertNumToAppLocal(numStr:self.tripData.get("iPersonSize")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSON")
            
                
        }else if(self.tripData.get("iStopId").uppercased() != ""){
            
            self.deliveryDetailsImgView.isHidden = false
            GeneralFunctions.setImgTintColor(imgView: self.deliveryDetailsImgView, color: UIColor.white)
            self.deliveryDetailsImgView.isUserInteractionEnabled = true
            let detailsBtnTapGue = UITapGestureRecognizer()
            detailsBtnTapGue.addTarget(self, action: #selector(self.deliveryDetailsTapped))
            self.deliveryDetailsImgView.addGestureRecognizer(detailsBtnTapGue)
            
            self.googleLogoBottomSpace.constant = 60
            self.btnIconImgView.isHidden = true
            self.btnIconBgView.isHidden = true
            self.deliveryCallImgView.isHidden = true
            self.deliveryView.isHidden = false
                        
            self.recNameValLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOP_OVER_TITLE_TXT") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOP_OVER_OUT_OF") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("totalStopOverPoint"))
            
            if(isTripStarted){
                //self.recNameValLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_1") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_2")
            }
            
            
            
        }/* ........*/
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        if(Configurations.isRTLMode() && btnIconImgView != nil){
                btnIconImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        self.observeTripDestionationAdd()
    }
    
    override func viewDidLayoutSubviews() {
        
        if(isSafeAreaSet == false){
            
            if(Configurations.isIponeXDevice()){
                
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
                iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
            }
            
            isSafeAreaSet = true
        }
        
    }

    @objc func wayBilltapped(){
    }
    
    @objc func deliveryDetailsTapped(){
        /* MSP Changes*/
        if(self.tripData.get("iStopId").uppercased() != ""){
            return
        }/* ..........*/
    }
    
    @objc func deliveryCallTapped(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            //if SinchCalling.getInstance().client.isStarted(){
                
                let selfDic = ["Id":"", "Name": "", "PImage": "", "type": ""]
                let assignedDic = ["Id":"", "Name": tripData!.get("vReceiverName"), "PImage": "", "type": ""]
                SinchCalling.getInstance().makeACall(IDString:"", assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"+\(tripData!.get("vReceiverMobile"))")
                return
                
           // }
        }else{
            UIApplication.shared.openURL(NSURL(string:"telprompt:+" + tripData!.get("vReceiverMobile"))! as URL)
        }
       
    }
    
    deinit {
        releaseAllTask()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EN_ROUTE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EN_ROUTE_TXT")
        
        if(self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPopUpMenu))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        
        self.contentView.isHidden = false
        
//        self.tripBtn.clickDelegate = self
        
        getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
        
        btnPanGue.addTarget(self, action: #selector(self.btnPanning(sender:)))
        self.tripBtn.isUserInteractionEnabled = true
        self.tripBtn.addGestureRecognizer(btnPanGue)
        
//        if(self.getPubNubConfig().uppercased() == "YES"){
        
        ConfigPubNub.getInstance().buildPubNub()
        
//        }else{
//            self.updateDriverLoc = UpdateDriverLocations(uv: self)
//            self.updateDriverLoc.scheduleDriverLocUpdate()
//        }
        
        if(self.tripData.get("ePoolRide").uppercased() == "YES"){
            ConfigPubNub.getInstance().subscribeToCabReqChannel()
        }
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        
        if(userProfileJson.get("eEnableDemoLocDispatch").uppercased() == "YES"){
            dispatchDemoLocations = DispatchDemoLocations()
            dispatchDemoLocations.startDispatchingLocations(delegate: self)
        }
        
        if(self.topNavView != nil){
            self.topNavView.navigateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NAVIGATE")
            self.topNavView.navOptionView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
            //        self.navView.subviews[0].subviews[1].subviews[0].backgroundColor = UIColor(hex: 0xFFFFFF)
            GeneralFunctions.setImgTintColor(imgView: self.topNavView.navImgView, color: UIColor.UCAColor.AppThemeTxtColor_1)
            self.topNavView.navigateLbl.textColor = UIColor.UCAColor.AppThemeTxtColor_1
            
            let navViewTapGue = UITapGestureRecognizer()
            navViewTapGue.addTarget(self, action: #selector(self.navViewTapped))
            self.topNavView.navOptionView.isUserInteractionEnabled = true
            self.topNavView.navOptionView.addGestureRecognizer(navViewTapGue)
        }
        
        
        initializeMenu()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
//        updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: passengerLocation, navigateView: navView)
//        updateDirections.scheduleDirectionUpdate()
        
        if(isTripStarted){
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                
                self.tripBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_END_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_END_JOB_TXT" : "LBL_BTN_SLIDE_END_TRIP_TXT")))
            }else{
                
                
                self.tripBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_END_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_END_JOB_TXT" : "LBL_BTN_SLIDE_END_TRIP_TXT")))
                
                
                if(self.tripBtn.button != nil){
                    self.tripBtn.button!.titleEdgeInsets.left = Configurations.isRTLMode() ? 40 : 80
                    self.tripBtn.button!.titleEdgeInsets.right = Configurations.isRTLMode() ? 80 : 40
                    
                    if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
                        self.btnIconImgView.isHidden = true
                        self.btnIconBgView.isHidden = true
                        
                        self.tripBtn.button!.titleEdgeInsets.left = 40
                        self.tripBtn.button!.titleEdgeInsets.right = 40
                        
                    }
                    
                    self.tripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.tripBtn.button!.titleLabel?.numberOfLines = 2
                    self.tripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.tripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                }
                
                if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"
                {
                    self.tripBtn.button!.titleEdgeInsets.left = Configurations.isRTLMode() ? 40 : 20
                    self.tripBtn.button!.titleEdgeInsets.right = Configurations.isRTLMode() ? 20 : 40
                }
            }
            
            /* In Transist Shopping System. */
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES" && self.tripData.get("eRental").uppercased() != "YES" && self.tripData!.get("eHailTrip").uppercased() != "YES"){
                self.waitingProgressBtn.isHidden = false
                self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
                self.waitingProgressBtn.clickDelegate = self
                self.waitingTimeLbl.isHidden = false
                self.waitingTimeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.waitingTimeLbl.text = "00:00:00"
                self.manageWaitTime()
            }
            
            updateTripLocationService = UpdateTripLocationService(uv: self)
            updateTripLocationService.tripId = tripData.get("TripId")
            updateTripLocationService.scheduleDriverLocUpdate()
            self.btnIconImgView.image = UIImage(named: "ic_btn_trip_end")
        }else{
            if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
//                self.tripBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver ? "LBL_SLIDE_BEGIN_DELIVERY" : "LBL_BTN_SLIDE_BEGIN_TRIP_TXT"))
                self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_BEGIN_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_BEGIN_JOB_TXT" : "LBL_BTN_SLIDE_BEGIN_TRIP_TXT")))
            }else{
                self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_SLIDE_BEGIN_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_BTN_SLIDE_BEGIN_JOB_TXT" : "LBL_BTN_SLIDE_BEGIN_TRIP_TXT")))
                
                if(self.tripBtn.button != nil){
                    self.tripBtn.button!.titleEdgeInsets.left = Configurations.isRTLMode() ? 40 : 80
                    self.tripBtn.button!.titleEdgeInsets.right = Configurations.isRTLMode() ? 80 : 40
                    
                    if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
                        self.btnIconImgView.isHidden = true
                        self.btnIconBgView.isHidden = true
                        
                        self.tripBtn.button!.titleEdgeInsets.left = 40
                        self.tripBtn.button!.titleEdgeInsets.right = 40
                    }
                    
                    self.tripBtn.button!.titleLabel?.lineBreakMode = .byWordWrapping
                    self.tripBtn.button!.titleLabel?.numberOfLines = 2
                    self.tripBtn.button!.titleLabel?.adjustsFontSizeToFitWidth = true
                    self.tripBtn.button!.titleLabel?.minimumScaleFactor = 0.6
                }
                if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"
                {
                    self.tripBtn.button!.titleEdgeInsets.left = Configurations.isRTLMode() ? 40 : 20
                    self.tripBtn.button!.titleEdgeInsets.right = Configurations.isRTLMode() ? 20 : 40
                }
            }
            
            self.btnIconImgView.image = UIImage(named: "ic_btn_trip_start")
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.btnIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        self.addDestinationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
        
        if(tripData.get("eTollSkipped").uppercased() == "YES"){
            let tollNoteLbl = MyLabel(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 45))
            tollNoteLbl.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
            tollNoteLbl.font = UIFont(name: Fonts().light, size: 16)
            tollNoteLbl.backgroundColor = UIColor.clear
            self.topDataContainerStkView.addArrangedSubview(tollNoteLbl)
            
            self.topDataContainerViewHeight.constant = self.topDataContainerViewHeight.constant + 45
            
            let text = self.generalFunc.getLanguageLabel(origValue: "Passenger selected to skip the toll route. Please ignore toll route.", key: "LBL_TOLL_SKIP_HELP")
            
            let height = text.height(withConstrainedWidth: tollNoteLbl.frame.width - tollNoteLbl.paddingLeft - tollNoteLbl.paddingRight, font: tollNoteLbl.font!) + tollNoteLbl.paddingTop + tollNoteLbl.paddingBottom
            
            //            self.tollNoteLbl.isHidden = false
            tollNoteLbl.frame.size.height = height
            tollNoteLbl.text = text
            tollNoteLbl.fitText()
        }
        let destLocLatitude = tripData.get("DestLocLatitude")
        let destLocLongitude = tripData.get("DestLocLongitude")
        let reqType = tripData.get("REQUEST_TYPE").uppercased()
        
        if (destLocLatitude != "" && destLocLatitude != "0"
            && tripData.get("DestLocLongitude") != "" && destLocLongitude != "0" && (reqType != Utils.cabGeneralType_UberX.uppercased() || (reqType == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular"))) {
            
            let destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: destLocLongitude))
            
            updateDirections = UpdateDirections(uv: self, gMap: gMapView, destinationLocation: destLocation, navigateView: topNavView)
            updateDirections.scheduleDirectionUpdate(eTollSkipped: tripData.get("eTollSkipped"))

            self.topNavView.isHidden = false
            self.addDestinationView.isHidden = true
            if(self.addDestView != nil){
                self.addDestLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
                self.addDestView.isHidden = true
            }
            addDestMarker(location: destLocation)
            
        }else{
            
//            self.navigateView.isHidden = true
            self.addDestinationView.isHidden = false
            
            let addDestTapGue = UITapGestureRecognizer()
            addDestTapGue.addTarget(self, action: #selector(self.addDestinationTapped))
            
            self.addDestinationView.isUserInteractionEnabled = true
            self.addDestinationView.addGestureRecognizer(addDestTapGue)
            
            if(self.addDestView != nil){
                self.addDestLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
                self.addDestView.isUserInteractionEnabled = true
                self.addDestView.addGestureRecognizer(addDestTapGue)
            }
        }
        
        if(reqType == Utils.cabGeneralType_UberX.uppercased() && (destLocLatitude == "" || destLocLongitude == "" || tripData.get("eFareType") != "Regular")){
            
            if(self.topNavView != nil){
                self.topNavView.isHidden = true
            }
            
            if(self.addDestinationView != nil){
                self.addDestinationView.isHidden = true
            }
        }
        
        self.emeImgView.isHidden = false
        self.emeImgView.isUserInteractionEnabled = true
        let emeTapGue = UITapGestureRecognizer()
        emeTapGue.addTarget(self, action: #selector(self.emeImgViewTapped))
        self.emeImgView.addGestureRecognizer(emeTapGue)
            
        if(reqType == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") != "Regular"){
            self.emeImgView.isHidden = true
            self.googleLogoImgView.isHidden = true
            
            if(tripData.get("eFareType") == "Fixed"){
                self.progressViewHeight.constant = 0
                self.progressView.isHidden = true
                
                headerViewHeight = headerViewHeight - 190
            }else if(tripData.get("eFareType") != "Fixed"){
                if(isTripStarted == false){
                    self.progressViewHeight.constant = 150
////                    self.progressView.isHidden = true
                    self.progressBtn.isHidden = true
                    headerViewHeight = headerViewHeight - 40
                }
            }
            
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.btnIconImgView.bounds.height + 10, right: 0)

            setUFXHeaderViewHeight()
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.tableFooterView = UIView()
            self.tableView.register(UINib(nibName: "MyOnGoingTripDetailsTVCell", bundle: nil), forCellReuseIdentifier: "MyOnGoingTripDetailsTVCell")
//            self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            
            self.jobStatusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROGRESS_HINT")
            self.progressStatusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_JOB_TIMER_HINT")
            
            self.hourHLbl.text = self.generalFunc.getLanguageLabel(origValue: "HOURS", key: "LBL_HOUR_TXT").uppercased()
            self.minuteHLbl.text = self.generalFunc.getLanguageLabel(origValue: "MINUTES", key: "LBL_MINUTES_TXT").uppercased()
            self.secHLbl.text = self.generalFunc.getLanguageLabel(origValue: "SECONDS", key: "LBL_SECONDS_TXT").uppercased()
            
            self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
            self.progressBtn.clickDelegate = self
            
            self.hourVLbl.text = "00"
            self.minuteVLbl.text = "00"
            self.secVLbl.text = "00"
            
            Utils.createRoundedView(view: self.hourVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            Utils.createRoundedView(view: self.minuteVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            Utils.createRoundedView(view: self.secVLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            
            let bottomPointImg = UIImage(named: "ic_bottom_anchor_point", in: Bundle(for: ActiveTripUV.self), compatibleWith: self.traitCollection)
            
            let iv = UIImageView(image: bottomPointImg)
            
            detailBottomVIew.backgroundColor = UIColor(patternImage: UIImage(named: "ic_bottom_anchor_point")!)
            bottomPointViewHeight.constant = iv.frame.height
            
            self.contentView.isHidden = true
            self.getData()
        }
        
        /* MSP Changes*/
        if(self.tripData.get("iStopId").uppercased() != ""){
        
            if(isTripStarted){
                
                if(self.tripData.get("totalStopOverPoint") != self.tripData.get("currentStopOverPoint")){
                    
                    self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_1") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_2") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")))
                    
                    self.mspCancelLbl.isHidden = false
                    self.mspCancelImgView.isHidden = false
                    self.mspCancelImgView.image = UIImage(named:"ic_msp_cancelAll")
                    self.mspCancelImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
                    self.mspCancelLbl.text = ""
                    self.mspCancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                    self.mspCancelCloseImgView.image = UIImage(named:"cm_close_white")
                    
                    self.mspCancelLbl.setOnClickListener { (Instance) in
                        
                        if(self.mspCancelCloseImgView.isHidden == true){
                            self.mspCancelLbl.text = ""
                            self.mspCancelCloseImgView.isHidden = false
                            
                            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_DROP_ALL_CONFIRM_TXT"), uv: self)
                            self.isDropAll = true
                            self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SLIDE_END_TRIP_TXT"))
                            self.mspEndTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.startBlinking), userInfo: nil, repeats: true)
                            self.mspEndTimer.fire()
                            
                        }else{
                            self.isDropAll = false
                            self.mspEndTimer.invalidate()
                            self.mspEndTimer = nil
                            self.mspCancelLbl.text = ""
                            self.mspCancelCloseImgView.isHidden = true
                            self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_1") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_STOPOVER_2") + " " + Configurations.convertNumToAppLocal(numStr: self.tripData.get("currentStopOverPoint")))
                        }
                        
                    }
                }
         
            }
          
        }/* ........*/
        
        checkLocationEnabled()
        addBackgroundObserver()
        
    }
    
    /* MSP Changes*/
    @objc func startBlinking(){
        
        if(self.tripBtn.buttonTitle != ""){
            self.tripBtn.setButtonTitle(buttonTitle:  "")
        }else{
            self.tripBtn.setButtonTitle(buttonTitle:  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SLIDE_END_TRIP_TXT"))
        }
    }/* .........*/
    
    /* In-Transist Shopping System*/
    func manageWaitTime(){
        //        self.iTripTimeId = self.tripData.get("iTripTimeId")
        let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("TotalSeconds"))
        self.totalSecond = totalSecond
        
        let hours = Int(totalSecond / 3600)
        let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        
        self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        Utils.printLog(msgData: "WT:MT: \(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60)))")
        
        if(self.tripData.get("TimeState") == "Resume"){
            self.isResume = true
            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Stop", key: "LBL_STOP"))
            self.runJobTimer()
        }else{
            self.isResume = false
            self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
            
        }
        
        if self.isResume{
            self.isResume = false
        }else{
            self.isResume = true
        }
    }/* In-Transist Shopping System*/
    
    func onDemoLocationDispatch(latitude: Double, longitude: Double) {
        onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = nil
        return true
    }
    func setUFXHeaderViewHeight(){
        
        self.tableView.parallaxHeader.view = self.ufxHeaderView
        self.tableView.parallaxHeader.height = headerViewHeight
        self.tableView.parallaxHeader.mode = .bottom
    }
    
    func addBackgroundObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)

    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.removeView()
            locationDialog = nil
        }
        
        if(GeneralFunctions.hasLocationEnabled() == false || InternetConnection.isConnectedToNetwork() == false){
            locationDialog = OpenLocationEnableView(uv: self, containerView: self.contentView, gMapView: self.gMapView, isMapLocEnabled: false)
            locationDialog.show()
            return
        }
        
    }
    
    @objc func appInBackground(){
        if(updateDirections != nil){
            updateDirections.pauseDirectionUpdate()
        }
    }
    
    @objc func appInForground(){
        checkLocationEnabled()
        
        ConfigPubNub.getInstance().unSubscribeToPrivateChannel()
        ConfigPubNub.getInstance().subscribeToPrivateChannel()
        
        if(updateDirections != nil){
            updateDirections.startDirectionUpdate()
        }
    }
    
    
    @objc func emeImgViewTapped(){
        let confirmEmergencyTapUV = GeneralFunctions.instantiateViewController(pageName: "ConfirmEmergencyTapUV") as! ConfirmEmergencyTapUV
        confirmEmergencyTapUV.iTripId = tripData.get("TripId")
        self.pushToNavController(uv: confirmEmergencyTapUV)
    }
    
    @objc func addDestinationTapped(){
       
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && tripData.get("vTripPaymentMode").uppercased() == "CARD" && tripData.get("ePayWallet").uppercased() == "YES"){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_ADD_DEST_FROM_DRIVER"))
            return
        }/* ............ */
        
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
//        addDestinationUv.centerLocation = self.currentLocation
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func navViewTapped(){
        if(isTripStarted == false){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_NAVIGATION_ALERT" : (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery"  ? "LBL_NAVIGATION_DELIVERY_ALERT" : "LBL_NAVIGATION_BOOKING_ALERT")))
           return
        }
        
        
        let openNavOption = OpenNavOption(uv: self, containerView: self.view, placeLatitude: tripData!.get("DestLocLatitude"), placeLongitude: tripData!.get("DestLocLongitude"))
        openNavOption.chooseOption()
    }
    
    @objc func releaseAllTask(isDismiss:Bool = true){
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(self.dispatchDemoLocations != nil){
            self.dispatchDemoLocations.stopDispatchingDemoLocations()
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        
        if(updateDriverLoc != nil){
            self.updateDriverLoc.releaseTask()
            self.updateDriverLoc = nil
        }
        
        if(updateDirections != nil){
            self.updateDirections.releaseTask()
            if(self.updateDirections.gMap != nil){
                self.updateDirections.gMap!.removeFromSuperview()
                self.updateDirections.gMap!.clear()
                self.updateDirections.gMap!.delegate = nil
                self.updateDirections.gMap = nil
            }
            self.updateDirections = nil
        }
        
        if(updateTripLocationService != nil){
            self.updateTripLocationService.releaseTask()
            self.updateTripLocationService = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
//    func onHeadingUpdate(heading: Double) {
//        driverMarker.rotation = heading
//    }
    func onHeadingUpdate(heading: Double) {
        //        driverMarker.isFlat = true
        //        driverMarker.rotation = heading
        //
        //        self.gMapView.animate(toBearing: heading - 20)
        currentHeading = heading
        
        if(isFirstHeadingCompleted == false){
            updateDriverMarker()
            isFirstHeadingCompleted = true
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        
        self.currentLocation = location
        
        if(tripData.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() || (tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && tripData.get("eFareType") == "Regular")){
            if(gMapView == nil){
                releaseAllTask()
                return
            }
            
            if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() == "YES" || tripData.get("DestLocLatitude") == "" || tripData.get("DestLocLatitude") == "0"
                && tripData.get("DestLocLongitude") == "" || tripData.get("DestLocLongitude") == "0"){
                var currentZoomLevel:Float = self.gMapView.camera.zoom
                
                if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
                    currentZoomLevel = Utils.defaultZoomLevel
                }
                
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude, zoom: currentZoomLevel)
                self.gMapView.animate(to: camera)
            }else{
                
                if(isFirstLocationUpdate && tripData != nil){
                    if(currentDestination == nil){
                        currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
                    }
                    
                    var bounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(location.coordinate)
                    bounds = bounds.includingCoordinate(currentDestination!.coordinate)
                    
                    /* Pool Ride. */
                    var addExtraPddingForPoolAndMultiDelivery:CGFloat = 0.0
                    if(self.tripData.get("ePoolRide").uppercased() == "YES" || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery") {
                        addExtraPddingForPoolAndMultiDelivery = 40.0
                    }
                    
                    let edgeInsets = UIEdgeInsets.init(top: 125 + self.topNavView.tripIntervalLbl.frame.height, left: 20, bottom: 120 + addExtraPddingForPoolAndMultiDelivery + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 20)
                    let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
                    self.gMapView.animate(with: update)
                }
            }
            
            isFirstLocationUpdate = false
            
            updateDriverMarker()
            updateLocationToPubNub()
        }
        
    }
    
    
    func updateDriverMarker(){
        if(currentLocation == nil || gMapView == nil){
            return
        }
        
        driverMarker.title = GeneralFunctions.getMemberd()
        
        var rotationAngle:Double = 0
        if(currentRotatedLocation == nil){
            rotationAngle = currentHeading
            
            if(currentHeading > 1 || UIDevice().type == .simulator){
                currentRotatedLocation = currentLocation
            }
        }else{
            rotationAngle = currentRotatedLocation.bearingToLocationDegrees(destinationLocation: currentLocation, currentRotation: driverMarker.rotation)
            if(rotationAngle == -1){
                rotationAngle = currentHeading
            }else{
                currentRotatedLocation = currentLocation
            }
        }
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            rotationAngle = 0
        }
        
//        Utils.updateMarker(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 1.0)
        
        let previousItemOfMarker = Utils.getLastLocationDataOfMarker(marker: driverMarker)
        
        var tempData = [String:String]()
        tempData["vLatitude"] = "\(currentLocation.coordinate.latitude)"
        tempData["vLongitude"] = "\(currentLocation.coordinate.longitude)"
        tempData["iDriverId"] = "\(GeneralFunctions.getMemberd())"
        tempData["RotationAngle"] = "\(rotationAngle)"
        tempData["LocTime"] = "\(Utils.currentTimeMillis())"
        
        let tempDataDict = tempData as NSDictionary
        let locTimeData = tempDataDict.get("LocTime")
        if(previousItemOfMarker.get("LocTime") != "" && locTimeData != ""){
            
            let locTime = Int64(previousItemOfMarker.get("LocTime"))
            let newLocTime = Int64(locTimeData)
            
            if(locTime != nil && newLocTime != nil){
                
                if((newLocTime! - locTime!) > Int64(0) && Utils.driverMarkerAnimFinished == false){
                    Utils.driverMarkersPositionList.append(tempData as NSDictionary)
                }else if((newLocTime! - locTime!) > Int64(0)){
                    Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
                }
                
            }else if((locTime == nil || newLocTime == nil) && Utils.driverMarkerAnimFinished == false){
                Utils.driverMarkersPositionList.append(tempDataDict)
            }else{
                Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
            }
            
        }else if(Utils.driverMarkerAnimFinished == false){
            Utils.driverMarkersPositionList.append(tempDataDict)
        }else{
            Utils.updateMarkerOnTrip(marker: driverMarker, googleMap: self.gMapView, coordinates: currentLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: GeneralFunctions.getMemberd(), LocTime: locTimeData)
        }

        
//        driverMarker.position = self.currentLocation.coordinate
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            let providerView = self.getProviderMarkerView(providerImage: UIImage(named: "ic_no_pic_user")!)
            driverMarker.icon = UIImage(view: providerView)
            (providerView.subviews[1] as! UIImageView).sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                self.driverMarker.icon = UIImage(view: providerView)
            })
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        }else{
           // driverMarker.icon = UIImage(named: "ic_driver_car_pin")

            let eIconType = tripData.get("eIconType")
            var iconId = "ic_driver_car_pin"
            
            if(eIconType == "Bike"){
                iconId = "ic_bike"
            }else if(eIconType == "Cycle"){
                iconId = "ic_cycle"
            }else if(eIconType == "Truck"){
                iconId = "ic_truck"
            }
            
            driverMarker.icon = UIImage(named: iconId)
            driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
//        driverMarker.icon = UIImage(named: "ic_driver_car_pin")
        driverMarker.map = self.gMapView
        driverMarker.title = GeneralFunctions.getMemberd()
        driverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        driverMarker.isFlat = true
        
        if(ENABLE_DIRECTION_SOURCE_DESTINATION_DRIVER_APP.uppercased() != "YES" && tripData.get("DestLocLatitude") != "" && tripData.get("DestLocLatitude") != "0"
            && tripData.get("DestLocLongitude") != "" && tripData.get("DestLocLongitude") != "0"){
            
            if(currentDestination == nil){
                currentDestination = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripData!.get("DestLocLongitude")))
            }
            
            var bounds = GMSCoordinateBounds()
            bounds = bounds.includingCoordinate(self.currentLocation.coordinate)
            bounds = bounds.includingCoordinate(self.currentDestination.coordinate)
            let edgeInsets = UIEdgeInsets.init(top: 125 + self.topNavView.tripIntervalLbl.frame.height, left: 10, bottom: 120 + (GeneralFunctions.getSafeAreaInsets().bottom / 2), right: 10)
            let update = GMSCameraUpdate.fit(bounds, with: edgeInsets)
            self.gMapView.animate(with: update)
        }else{
            var currentZoomLevel:Float = gMapView.camera.zoom
            
            if(currentZoomLevel < Utils.defaultZoomLevel){
                currentZoomLevel = Utils.defaultZoomLevel
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude,
                                                  longitude: self.currentLocation.coordinate.longitude, zoom: currentZoomLevel)
            
            self.gMapView.animate(to: camera)
        }
    }
    
    func updateLocationToPubNub(){
        
        if(currentLocation != nil){
            if(lastPublishedLoc != nil){
                
                if(currentLocation!.distance(from: lastPublishedLoc) < PUBSUB_PUBLISH_DRIVER_LOC_DISTANCE_LIMIT){
                    return
                }else{
                    lastPublishedLoc = currentLocation
                }
                
            }else{
                lastPublishedLoc = currentLocation
            }
            
            ConfigPubNub.getInstance().publishMsg(channelName: GeneralFunctions.getLocationUpdateChannel(), content: GeneralFunctions.buildLocationJson(location: currentLocation!, msgType: "LocationUpdateOnTrip"))
        }
    }
    
    
    func initializeMenu(){
        
        var items = [NSDictionary]()
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() &&  tripData.get("eFareType") != "Regular"){
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT"),"ID" : MENU_USER_CALL] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT"),"ID" : MENU_USER_MSG] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "SOS", key: "LBL_EMERGENCY_SOS_TXT"),"ID" : MENU_EMERGENCY] as NSDictionary)
            
        }else if(self.tripData!.get("eHailTrip").uppercased() != "YES"){
//            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver ? "LBL_VIEW_DELIVERY_DETAILS" : "LBL_VIEW_PASSENGER_DETAIL"),"ID" : MENU_USER_OR_DELIVERY_DETAIL] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_VIEW_DELIVERY_DETAILS" : (self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_VIEW_USER_DETAIL" : "LBL_VIEW_PASSENGER_DETAIL")),"ID" : MENU_USER_OR_DELIVERY_DETAIL] as NSDictionary)
        }
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() != Utils.cabGeneralType_UberX.uppercased() && userProfileJson.get("WAYBILL_ENABLE").uppercased() == "YES"){
//             ||  (tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() && self.tripData.get("eFareType") == "Regular")
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Way Bill", key: "LBL_MENU_WAY_BILL"),"ID" : MENU_WAY_BILL] as NSDictionary)
        }
        
        
        if(tripData!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
            if(tripData!.get("moreServices").uppercased() == "YES"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_REQUESTED_SERVICES"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }else{
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"),"ID" : MENU_SPECIAL_INS] as NSDictionary)
            }
          
        }
        
        
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver ? "LBL_CANCEL_DELIVERY" : "LBL_CANCEL_TRIP"),"ID" : MENU_CANCEL_TRIP] as NSDictionary)
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver || self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" ? "LBL_CANCEL_DELIVERY" : (tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_UberX ? "LBL_CANCEL_JOB" : "LBL_CANCEL_TRIP")),"ID" : MENU_CANCEL_TRIP] as NSDictionary)
        
        if(self.menu == nil){
            menu = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "", items: items)
            
            menu.cellHeight = 65
            menu.cellBackgroundColor = UIColor.UCAColor.AppThemeColor.lighter(by: 10)
            menu.cellSelectionColor = UIColor.UCAColor.AppThemeColor
            menu.cellTextLabelColor = UIColor.UCAColor.AppThemeTxtColor
            menu.cellTextLabelFont = UIFont(name: Fonts().light, size: 20)
            menu.cellSeparatorColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode()){
                menu.cellTextLabelAlignment = NSTextAlignment.right
            }else{
                menu.cellTextLabelAlignment = NSTextAlignment.left
            }
            menu.arrowPadding = 15
            menu.animationDuration = 0.5
            menu.maskBackgroundColor = UIColor.black
            menu.maskBackgroundOpacity = 0.5
            menu.menuStateHandler = { (isMenuOpen: Bool) -> () in
                
                //                if(isMenuOpen){
                //                    self.rightButton.setBackgroundImage(nil, for: .normal, barMetrics: .default)
                //
                //                }else{
                //                    self.rightButton.setBackgroundImage(UIImage(color : UIColor.UCAColor.AppThemeColor.lighter(by: 10)!), for: .normal, barMetrics: .default)
                //                }
                
            }
            menu.didSelectItemAtIndexHandler = {(indexID: String) -> () in
                //            self.selectedCellLabel.text = items[indexPath]
                
                switch indexID {
                case self.MENU_USER_CALL:
                    self.getMaskedNumber()
                    break
                case self.MENU_USER_MSG:
                    let chatUV = GeneralFunctions.instantiateViewController(pageName: "ChatUV") as! ChatUV
                    
                    chatUV.receiverId = self.tripData!.get("PassengerId")
                    chatUV.receiverDisplayName = self.tripData!.get("PName")
                    chatUV.assignedtripId = self.tripData!.get("TripId")
                    chatUV.pPicName = self.tripData!.get("PPicName")
                    self.pushToNavController(uv:chatUV, isDirect: true)
                    break
                case self.MENU_EMERGENCY:
                    self.emeImgViewTapped()
                    break
                case self.MENU_USER_OR_DELIVERY_DETAIL:
                    if(self.tripData!.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver){
                    }else{
                        let openPassengerDetail = OpenPassengerDetail(uv:self, containerView: self.contentView)
                        openPassengerDetail.tripData = self.tripData
                        openPassengerDetail.currInst = openPassengerDetail
                        openPassengerDetail.showDetail()
                    }
                    break
                case self.MENU_WAY_BILL:
                    let wayBillUV = GeneralFunctions.instantiateViewController(pageName: "WayBillUV") as! WayBillUV
                    self.pushToNavController(uv: wayBillUV)
                    break
                case self.MENU_SPECIAL_INS:
                    if(self.tripData!.get("moreServices").uppercased() == "YES"){

                    }else{
                        self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Special Instruction", key: "LBL_SPECIAL_INSTRUCTION_TXT"), content: self.tripData!.get("tUserComment") == "" ? (self.generalFunc.getLanguageLabel(origValue: "There is a No Special Instruction", key: "LBL_NO_SPECIAL_INSTRUCTION")) : self.tripData!.get("tUserComment") )
                    }
                    
                    break
                case self.MENU_CANCEL_TRIP:
                    let openCancelBooking = OpenCancelBooking(uv: self)
                    openCancelBooking.cancelTrip(eTripType: self.tripData!.get("REQUEST_TYPE"), PAGE_TYPE: "", iTripId: self.tripData!.get("TripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
                        self.onTripCanceled(iCancelReasonId: iCancelReasonId, reason: reason)
                    }
                    break
                    
                default:
                    break
                }
            }
        }else{
            menu.updateItems(items)
        }
    }
    
    func getMaskedNumber(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
           // if SinchCalling.getInstance().client.isStarted(){
                
                
                let selfDic = ["Id":userProfileJson.get("iDriverId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImage"), "type": Utils.appUserType]
                let assignedDic = ["Id":self.tripData.get("PassengerId"), "Name": self.tripData.get("PName"), "PImage": self.tripData.get("PPicName"), "type": "Passenger"]
                SinchCalling.getInstance().makeACall(IDString:"Passenger" + "_" + self.tripData.get("PassengerId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                return
                
           // }
        }
        
        let parameters = ["type":"getCallMaskNumber","iTripid": self.tripData!.get("TripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.contentView, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let number = "\(dataDict.get(Utils.message_str))"
                    UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)

                }else{
                    let number = "\(self.tripData!.get("PPhone"))"
                    
                    UIApplication.shared.openURL(NSURL(string: ("telprompt:\(number)").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func openPopUpMenu(){
        
        initializeMenu()
        
        if(menu.isShown){
            menu.hideMenu()
            return
        }else{
            menu.showMenu()
        }
    }
    
    func onTripCanceled(iCancelReasonId:String, reason: String) {
        
        
        
        self.cancelReason = reason
        self.iCancelReasonId = iCancelReasonId
        
        isTripEndPressed = false
        
        if(isTripStarted == true){
            getAddressFrmLocation.setLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow:true)
            return
        }
        
        
        let parameters = ["type":"cancelTrip","iDriverId": GeneralFunctions.getMemberd(), "iUserId": tripData!.get("PassengerId"), "iTripId": tripData!.get("TripId"), "UserType": Utils.appUserType, "Reason": reason, "iCancelReasonId": iCancelReasonId,"vLatitude" : "\(currentLocation!.coordinate.latitude)","vLongitude" : "\(currentLocation!.coordinate.longitude)"]
        
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
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func addDestination(latitude: String, longitude: String, address:String, eConfirmByUser:String, tollPrice:String, tollPriceCurrencyCode:String, isTollSkipped:String, eTollConfirmByUser:String) {
        if(self.userProfileJson.get("ENABLE_TOLL_COST").uppercased() == "YES" && isTollChecked == false){
            self.destinationOnTripLatitude = latitude
            self.destinationOnTripLongitude = longitude
            self.destinationOnTripAddress = address
            
            if(self.currentLocation != nil && GeneralFunctions.parseDouble(origValue: 0.0, data: latitude) != 0.0 && GeneralFunctions.parseDouble(origValue: 0.0, data: longitude) != 0.0){
                
                checkTollPrice(fromLocation: self.currentLocation, toLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude)), eConfirmByUser: eConfirmByUser)
            }
            return
        }
        
        let parameters = ["type":"addDestination","iMemberId": GeneralFunctions.getMemberd(), "Latitude": latitude, "Longitude": longitude, "Address": address, "UserType": Utils.appUserType, "TripId": tripData!.get("TripId"), "eConfirmByUser": eConfirmByUser, "fTollPrice": tollPrice, "vTollPriceCurrencyCode": tollPriceCurrencyCode, "eTollSkipped": isTollSkipped, "eTollConfirmByUser": eTollConfirmByUser == "" ? "No" : "\(eTollConfirmByUser)"]
        
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
                    if(dataDict.get("eTollExist").uppercased() == "YES"){
                        let openTollBox = OpenTollBox(uv: self, containerView: self.contentView)
                        openTollBox.setViewHandler(handler: { (isContinueBtnTapped, isTollSkipped) in
                            if(isContinueBtnTapped){
                                
                                self.addDestination(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped == true ? "Yes" : "No", eTollConfirmByUser: "Yes")
                                
                            }else{
                                self.isTollChecked = false
                            }
                        })
                        
                        
                        openTollBox.show(tollPrice: "\(tollPriceCurrencyCode) \(tollPrice)", currentFare: "")
                        return
                    }
                    
                    if(dataDict.get("message").uppercased() == "YES"){
                        self.isTollChecked = false
                        self.destinationOnTripLatitude = latitude
                        self.destinationOnTripLongitude = longitude
                        self.destinationOnTripAddress = address
                        
                        self.openSurgeConfirmDialog(dataDict: dataDict)
                        return
                    }
                    self.isTollChecked = false
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.isTollChecked = false
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func checkTollPrice(fromLocation:CLLocation, toLocation:CLLocation, eConfirmByUser:String){
        
        let tollURL = "https://tce.cit.api.here.com/2/calculateroute.json?app_id=\(self.userProfileJson.get("TOLL_COST_APP_ID"))&app_code=\(self.userProfileJson.get("TOLL_COST_APP_CODE"))&waypoint0=\(fromLocation.coordinate.latitude),\(fromLocation.coordinate.longitude)&waypoint1=\(toLocation.coordinate.latitude),\(toLocation.coordinate.longitude)&mode=fastest;car"
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: true)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("onError").uppercased() == "FALSE" || dataDict.get("onError") == "0"){
                    
                    self.isTollChecked = true
                    
                    let totalCost = dataDict.getObj("costs").get("totalCost")
                    let currency = dataDict.getObj("costs").get("currency")
                    
                    if(totalCost != "0.0"){
                        
                        self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: "No", eTollConfirmByUser: "")
                    }else{
                        
                        self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
                        
                    }
                    
                }else{
                    
                    self.isTollChecked = true
                    
                    self.addDestination(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: eConfirmByUser, tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
                    
                }
                
            }else{
                
                self.generalFunc.setError(uv: self)
            }
        }, url: tollURL)
        
    }
    
    func openSurgeConfirmDialog(dataDict:NSDictionary){
        
        surgePriceView = self.generalFunc.loadView(nibName: "SurgePriceView", uv: self, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
        
        var defaultHeight:CGFloat = 154
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        
        surgePriceView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        surgePriceBGView = UIView()
        surgePriceBGView.backgroundColor = UIColor.black
        self.surgePriceBGView.alpha = 0
        surgePriceBGView.isUserInteractionEnabled = true
        
        let bgViewTapGue = UITapGestureRecognizer()
        surgePriceBGView.frame = self.contentView.frame
        
        surgePriceBGView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        bgViewTapGue.addTarget(self, action: #selector(self.cancelSurgeView))
        
        surgePriceBGView.addGestureRecognizer(bgViewTapGue)
        
        surgePriceView.layer.shadowOpacity = 0.5
        surgePriceView.layer.shadowOffset = CGSize(width: 0, height: 3)
        surgePriceView.layer.shadowColor = UIColor.black.cgColor
        
        surgePriceView.alpha = 0
        self.view.addSubview(surgePriceBGView)
        self.view.addSubview(surgePriceView)
        
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.surgePriceBGView.alpha = 0.4
                        self.surgePriceView.alpha = 1
        },  completion: { finished in
            self.surgePriceBGView.alpha = 0.4
            self.surgePriceView.alpha = 1
        })
        
        let cancelSurgeTapGue = UITapGestureRecognizer()
        cancelSurgeTapGue.addTarget(self, action: #selector(self.cancelSurgeView))
        
        surgeLaterLbl.isUserInteractionEnabled = true
        surgeLaterLbl.addGestureRecognizer(cancelSurgeTapGue)
        
        self.surgeLaterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_LATER")
        
        if(dataDict.get("eFlatTrip").uppercased() == "YES"){
            self.surgePayAmtLbl.isHidden = true
            self.surgePayAmtLbl.text = ""
            defaultHeight = defaultHeight - 20
            self.surgePriceVLbl.text = (dataDict.get("Action") == "1" || dataDict.get("SurgePrice") == "") ? dataDict.get("fFlatTripPricewithsymbol") : "\(Configurations.convertNumToAppLocal(numStr: dataDict.get("fFlatTripPricewithsymbol"))) (\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AT_TXT")) \(Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))))"
            self.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIX_FARE_HEADER")
            self.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT"))
        }else{
            self.surgePriceVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))
            self.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str))
            self.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_SURGE"))
        }
        
        let headerTxtHeight = self.surgePriceHLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 17)!)
        let priceTxtHeight = self.surgePriceVLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 26)!)
        let payAmtTxtHeight = self.surgePayAmtLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 16)!)
        
        self.surgePriceHLbl.fitText()
        self.surgePayAmtLbl.fitText()
        self.surgePriceVLbl.fitText()
        
        defaultHeight = defaultHeight + headerTxtHeight + priceTxtHeight + payAmtTxtHeight
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        surgePriceView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
        
        self.surgeAcceptBtn.clickDelegate = self
        
    }
    
    @objc func cancelSurgeView(){
        if(surgePriceView != nil){
            surgePriceView.removeFromSuperview()
        }
        
        if(surgePriceBGView != nil){
            surgePriceBGView.removeFromSuperview()
        }
    }

    func addDestMarker(location:CLLocation){
    
        destinationMarker.position = location.coordinate
        
        destinationMarker.icon = UIImage(named: "ic_destination_place_image")
        destinationMarker.map = self.gMapView
        destinationMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    
    func startTrip(isFromServicePhoto:Bool){
        if(self.currentLocation == nil){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            return
        }
        if(tripData.get("eBeforeUpload").uppercased() == "YES" && isFromServicePhoto == false){
            return
        }
        
        let parameters = ["type":"StartTrip","iDriverId": GeneralFunctions.getMemberd(), "TripID": tripData!.get("TripId"), "iUserId": tripData!.get("PassengerId"), "UserType": Utils.appUserType,"vLatitude" : "\(currentLocation.coordinate.latitude)","vLongitude" : "\(currentLocation.coordinate.longitude)","iTripDeliveryLocationId":tripData!.get("iTripDeliveryLocationId")]

        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        if(self.serviceImageData != nil){
            exeWebServerUrl.uploadImage(fileData: self.serviceImageData,fileName: "UserService.png", completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
                
                self.tripTaskExecuted = false
            })
        }else{
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                
                
                self.tripTaskExecuted = false
            })
        }
        
    }
    
    func endTrip(dAddress:String, dest_lat:String, dest_lon:String, isTripCancelled:Bool, iCancelReasonId:String, reason:String, isFromServicePhoto:Bool, isFromAdditionalCharges:Bool, materialFee:String, miscFee:String, providerDiscount:String){
        if(self.currentLocation == nil){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_LOCATION_FOUND_TXT"))
            return
        }
        if(tripData.get("eAfterUpload").uppercased() == "YES" && isFromServicePhoto == false){
            return
        }
        
        var latitudeList = ""
        var longitudeList = ""
        
        if(updateTripLocationService != nil){
            if(self.latitudeList.count == 0 || self.longitudeList.count == 0){
                self.latitudeList.removeAll()
                self.longitudeList.removeAll()
                
            }
            
             latitudeList = updateTripLocationService.latitudeList.joined(separator:",")
             longitudeList = updateTripLocationService.longitudeList.joined(separator:",")
        
        }else{
             latitudeList = ""
             longitudeList = ""
        }
        
        var parameters = ["type":"ProcessEndTrip", "TripId": tripData!.get("TripId"), "latList": "\(latitudeList)", "lonList": "\(longitudeList)", "PassengerId": tripData!.get("PassengerId"),"DriverId": GeneralFunctions.getMemberd(), "dAddress": dAddress, "dest_lat": dest_lat, "dest_lon": dest_lon, "UserType": Utils.appUserType, "isTripCanceled": isTripCancelled == true ? "true" : "", "iCancelReasonId": isTripCancelled == true ? iCancelReasonId : "", "Reason": isTripCancelled == true ? reason : "", "fMaterialFee": materialFee, "fMiscFee": miscFee, "fDriverDiscount": providerDiscount, "iTripDeliveryLocationId":tripData!.get("iTripDeliveryLocationId")]
        
        /* MSP Changes */
        if(self.tripData.get("iStopId") != ""){
            parameters["iStopId"] = self.tripData.get("iStopId")
            parameters["isDropAll"] = "\(self.isDropAll)"
        }/* ........ */
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        
        if(self.serviceImageData != nil){
            exeWebServerUrl.uploadImage(fileData: self.serviceImageData, fileName: "UserService.png", completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                self.tripTaskExecuted = false
            })
        }else{
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    }else if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        self.releaseAllTask()
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
                self.tripTaskExecuted = false
            })
        }
        
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//        
//        let touch: UITouch = touches.first as! UITouch
//        
//        if (touch.view == self.tripBtn){
//            print("touchesMoved | This is an ImageView")
//            
//            let point = touch.location(in: self.view)
//            
//            let pointX = point.x
//            let pointY = point.y
//            
//            print("PointX:\(pointX)")
//        }else{
//            print("touchesMoved | This is not an ImageView")
//        }
//    }
    
//    var btnPanTaskComplete = false
    
    @objc func btnPanning(sender:UIPanGestureRecognizer){
        
        if (Configurations.isRTLMode() ? sender.isLeft() : sender.isRight()) {
            let center = sender.view?.center
            let translation = sender.translation(in: sender.view)
//            center = CGPoint(center!.x + translation.x, center!.y + translation.y)
//            sender.view?.center = center!
//            sender .setTranslation(CGPoint.zero, in: sender.view)
            

            if((Configurations.isRTLMode() ? (translation.x + center!.x < 0) : (translation.x > center!.x)) && tripTaskExecuted == false){
//                btnPanTaskComplete = true
//                self.tripBtn.removeGestureRecognizer(btnPanGue)
                
                tripTaskExecuted = true
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//                    self.tripBtn.addGestureRecognizer(self.btnPanGue)
//                    self.btnPanTaskComplete = false
//                })
                
                if(self.isTripStarted){
                    
                    if(self.tripData.get("REQUEST_TYPE") == Utils.cabGeneralType_Deliver && self.isTripStarted && self.userProfileJson.getObj("TripDetails").get("eType") != "Multi-Delivery"){
                        
//                        tripTaskExecuted = false
                        return
                    }
                    
                    continueEndTrip()
                    
//                    self.endTrip()
                }else{
                    self.startTrip(isFromServicePhoto: false)
                }
            }
        }
    }
    
    func continueEndTrip(){
        if(currentLocation != nil){
            
            self.isTripEndPressed = true
            
            getAddressFrmLocation.setLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow: true)
        }else{
            
            tripTaskExecuted = false
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode:Bool, dataResult:String) {
        if(address == ""){
            tripTaskExecuted = false
            return
        }
        print(self.tripData.get("PaymentPerson"))
        if(isTripEndPressed == true){
            
            if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" && (self.tripData.get("ePaymentByReceiverForDelivery") == "Yes" || self.tripData.get("PaymentPerson") == "Each Recipient"){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYMENT_COLLECTED_MSG_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if btnClickedIndex == 0
                    {
                        self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: false, iCancelReasonId: "", reason: "", isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
                    }else
                    {
                        self.isTripEndPressed = true
                        self.tripTaskExecuted = false
                    }
                    
                })
            }else{
                self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: false, iCancelReasonId: "", reason: "", isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
            }
            
        }else{
            
            if self.userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" &&  (self.tripData.get("ePaymentByReceiverForDelivery") == "Yes" || self.tripData.get("PaymentPerson") == "Each Recipient"){
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PAYMENT_COLLECTED_MSG_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if btnClickedIndex == 0
                    {
                        self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: true, iCancelReasonId: self.iCancelReasonId, reason: self.cancelReason, isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
                    }else
                    {
                        self.isTripEndPressed = true
                        self.tripTaskExecuted = false
                    }
                    
                })
                
            }else{
                self.endTrip(dAddress: address, dest_lat: "\(location.coordinate.latitude)", dest_lon: "\(location.coordinate.longitude)", isTripCancelled: true, iCancelReasonId: self.iCancelReasonId, reason: self.cancelReason, isFromServicePhoto: false, isFromAdditionalCharges: false, materialFee: "", miscFee: "", providerDiscount: "")
            }
            
        }
    }
    
    func getData(){
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        self.ufxCntView.isHidden = true
        let parameters = ["type":"getTripDeliveryLocations", "iTripId": tripData.get("TripId"), "userType": Utils.appUserType,"iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let driverDetails = dataDict.getObj(Utils.message_str).getObj("driverDetails")
                    Utils.createRoundedView(view: self.senderImgView, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1)
                    
                    self.senderImgView.sd_setImage(with: URL(string: "\(CommonUtils.passenger_image_url)\(driverDetails.get("iUserId"))/\(driverDetails.get("riderImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    
                    self.senderNameLbl.textColor = UIColor.UCAColor.AppThemeColor
                    self.senderNameLbl.text = driverDetails.get("riderName")
                    self.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: driverDetails.get("riderRating"))
                    self.sourceAddLbl.text = driverDetails.get("tSaddress").trim()
                    self.sourceAddLbl.fitText()
                    
                    let extraHeight = self.sourceAddLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 106, font: UIFont(name: Fonts().light, size: 14)!) - 17

                    self.senderViewHeight.constant = 110 + extraHeight
                    self.headerViewHeight = self.headerViewHeight + extraHeight
                    self.setUFXHeaderViewHeight()
                    
                    let dataArr = dataDict.getObj(Utils.message_str).getArrObj("States")
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    self.iTripTimeId = self.tripData.get("iTripTimeId")
                    
                    let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: self.tripData.get("TotalSeconds"))
                    self.totalSecond = totalSecond
                    
                    let hours = Int(totalSecond / 3600)
                    let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
                    let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
                    
                    self.hourVLbl.text = String(format: "%02d", hours)
                    self.minuteVLbl.text = String(format: "%02d", minutes)
                    self.secVLbl.text = String(format: "%02d", seconds)
                    
                    if(self.tripData.get("TimeState") == "Resume"){
                        self.isResume = true
                        self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Pause", key: "LBL_PAUSE"))
                        self.runJobTimer()
                    }else{
                        self.isResume = false
                        self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
                    }
                    
                    if self.isResume{
                        self.isResume = false
                    }else{
                        self.isResume = true
                    }
                    
                }else{
//                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
                self.contentView.isHidden = false
                
                self.ufxCntView.isHidden = false
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    func runJobTimer(){
        if(jobTimer != nil){
            jobTimer!.invalidate()
        }
        
        jobTimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateJobTimerValue), userInfo: nil, repeats: true)
        
        jobTimer.fire()
    }
    
    func stopJobTimer(){
        if(jobTimer != nil){
            jobTimer!.invalidate()
        }
    }
    
    @objc func updateJobTimerValue(){
        
        self.totalSecond = self.totalSecond + 1
        
        let hours = Int(totalSecond / 3600)
        let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        
        /* In-Transist Shopping Sytem*/
        if(tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()  && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES"){
            
            self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            
        }else{
            self.hourVLbl.text = String(format: "%02d", hours)
            self.minuteVLbl.text = String(format: "%02d", minutes)
            self.secVLbl.text = String(format: "%02d", seconds)
        }
        
    }
    
    func setJobTimeStatus(){
        var parameters = ["type":"SetTimeForTrips", "iTripId": tripData!.get("TripId"), "UserType": Utils.appUserType]
        
        if(!self.isResume){
            parameters["iTripTimeId"] = self.iTripTimeId
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    let totalSecond = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("totalTime"))
                    self.totalSecond = totalSecond
                    
                    let hours = Int(totalSecond / 3600)
                    let minutes = Int(totalSecond.truncatingRemainder(dividingBy: 3600) / 60)
                    let seconds = Int(totalSecond.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
                    
                    /* In-Transist Shopping Sytem*/
                    if(self.tripData.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.userProfileJson.get("ENABLE_INTRANSIT_SHOPPING_SYSTEM").uppercased() == "YES" && self.tripData.get("ePoolRide").uppercased() != "YES" && self.tripData.get("eTransit").uppercased() == "YES"){
                        self.waitingTimeLbl.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
                    }else{
                        self.hourVLbl.text = String(format: "%02d", hours)
                        self.minuteVLbl.text = String(format: "%02d", minutes)
                        self.secVLbl.text = String(format: "%02d", seconds)
                    }
                   
                    
                    if(!self.isResume){
                        self.stopJobTimer()
                        if(self.progressBtn != nil){
                            self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Resume", key: "LBL_RESUME"))
                        }
                        
                        self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Wait", key: "LBL_WAIT"))
                    }else{
                        
                        self.iTripTimeId = dataDict.get(Utils.message_str)
                        
                        if(self.progressBtn != nil){
                            self.progressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Pause", key: "LBL_PAUSE"))
                        }
                        
                        self.waitingProgressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Stop", key: "LBL_STOP"))
                        
                        
                        self.runJobTimer()
                    }
                    
                    
                    if self.isResume{
                        self.isResume = false
                    }else{
                        self.isResume = true
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.tripTaskExecuted = false
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOnGoingTripDetailsTVCell", for: indexPath) as! MyOnGoingTripDetailsTVCell
        
        let item = self.dataArrList[indexPath.item]
        
        cell.progressMsgLbl.text = item.get("text")
        cell.progressTimeLbl.text = item.get("time")
        cell.progressPastTimeLbl.text = item.get("time") //item.get("timediff")
        cell.noLbl.text = "\(indexPath.item + 1)"
        Utils.createRoundedView(view: cell.noView, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.noView.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.noLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.progressTimeLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func getProviderMarkerView(providerImage:UIImage) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProviderMapMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame.size = CGSize(width: 64, height: 100)
        
        GeneralFunctions.setImgTintColor(imgView: view.subviews[0] as! UIImageView, color: UIColor.UCAColor.AppThemeColor)
        
        view.subviews[1].layer.cornerRadius = view.subviews[1].frame.width / 2
        view.subviews[1].layer.masksToBounds = true
        let providerImgView = view.subviews[1] as! UIImageView
        providerImgView.image = providerImage
        
        return view
    }
    func myBtnTapped(sender: MyButton) {
        if(self.progressBtn != nil && sender == self.progressBtn || self.waitingProgressBtn != nil && sender == self.waitingProgressBtn){
            self.setJobTimeStatus()
        }else if(surgeAcceptBtn != nil && sender == surgeAcceptBtn){
            self.cancelSurgeView()
           
            self.addDestination(latitude: self.destinationOnTripLatitude, longitude: self.destinationOnTripLongitude, address: self.destinationOnTripAddress, eConfirmByUser: "Yes", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
        }
    }
    
    @IBAction func unwindToActiveTrip(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddDestinationUV.self)){
            
            let addDestUv = segue.source as! AddDestinationUV
            
            addDestination(latitude: "\(addDestUv.selectedLocation.coordinate.latitude)", longitude: "\(addDestUv.selectedLocation.coordinate.longitude)", address: "\(addDestUv.selectedAddress)", eConfirmByUser: "No", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "")
        }
    }
}
