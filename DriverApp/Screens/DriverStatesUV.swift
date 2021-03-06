//
//  DriverStatesUV.swift
//  DriverApp
//
//  Created by ADMIN on 19/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class DriverStatesUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate {

    @IBOutlet weak var checkAccStatusBtn: MyButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    var window:UIWindow!
    
    let generalFunc = GeneralFunctions()
    
    var numOfItems = 0
    
    var selectedRow = -1
    
    var statusOfStates = [Bool]()
    
    var loaderView:UIView!
    
    var userProfileJson:NSDictionary!
    
    var isPageLoaded = false
    var cntView:UIView!
    
    var isSafeAreaSet = false
    
    var inCompleteDialog:MTDialog!
    var completeDialog:MTDialog!
    
    var currExeWebServerUrl:ExeServerUrl!

    var totalAddedVehicles : Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(statusOfStates.count > 0 && self.completeDialog == nil){
            reloadData(isFromCheckBtn: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "DriverStatesScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        window = Application.window!

        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)

        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "DriverStateTVCell", bundle: nil), forCellReuseIdentifier: "DriverStateTVCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.showsVerticalScrollIndicator = false

        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.userProfileJson = userProfileJson
        
        showLoader()
        
        checkAccStatusBtn.setButtonTitle(buttonTitle: generalFunc.getLanguageLabel(origValue: "Check Account Status", key: "LBL_CHECK_ACC_STATUS"))
        checkAccStatusBtn.clickDelegate = self
        
        self.checkAccStatusBtn.isHidden = true
        self.bottomView.isHidden = true
        
        GeneralFunctions.removeValue(key: "GO_ONLINE")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            loadData(isFromCheckBtn: false)
            isPageLoaded = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(cntView != nil){
                self.cntView.frame = self.view.frame
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
                
                self.bottomView.backgroundColor = Color.UCAColor.AppThemeColor_1
                
                self.bottomViewHeight.constant = GeneralFunctions.getSafeAreaInsets().bottom / 2
            }
            
            isSafeAreaSet = true
        }
    }
    
    deinit {
        releaseAllTask()
    }
    
    func reloadData(isFromCheckBtn:Bool){
        loadData(isFromCheckBtn: isFromCheckBtn)
    }
    
    func showLoader(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
            loaderView.isHidden = false
        }else{
            loaderView.isHidden = false
        }
    }
    
    
    
    func loadData(isFromCheckBtn:Bool){
    
        if(currExeWebServerUrl != nil){
            currExeWebServerUrl.cancel()
        }
        if(self.statusOfStates.count == 0){
            showLoader()
        }
        
        let parameters = ["type":"getDriverStates","UserType": Utils.appUserType, "iDriverId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: isFromCheckBtn)
        currExeWebServerUrl = exeWebServerUrl
        
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.loaderView.isHidden = true
            self.checkAccStatusBtn.isHidden = false
            self.bottomView.isHidden = false
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.statusOfStates.removeAll()
                    self.numOfItems = 0
                    self.tableView.reloadData()
                    
                    self.statusOfStates += [true]
                    
                    self.totalAddedVehicles = GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("TotalVehicles"))
                    
                    if(dataDict.get("IS_DOCUMENT_PROCESS_COMPLETED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    if(dataDict.get("IS_VEHICLE_PROCESS_COMPLETED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                        if(dataDict.get("IS_DRIVER_MANAGE_TIME_AVAILABLE") != "Yes"){
                            self.statusOfStates += [false]
                        }else{
                            self.statusOfStates += [true]
                        }
                        self.numOfItems = 5
                    }else{
                        self.numOfItems = 4
                    }
                    
                    if(dataDict.get("IS_DRIVER_STATE_ACTIVATED") != "Yes"){
                        self.statusOfStates += [false]
                    }else{
                        self.statusOfStates += [true]
                    }
                    
                    var isAllCompleted = true

                    for i in 0..<self.statusOfStates.count{
                        if(self.statusOfStates[i] == false){
                            isAllCompleted = false
                            break
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                    if(isFromCheckBtn == true && isAllCompleted == false){
                        if(self.inCompleteDialog != nil){
                            self.inCompleteDialog.disappear()
                            self.inCompleteDialog = nil
                        }
                        self.inCompleteDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please wait for admin's approval if you have completed all required steps.", key: "LBL_DRIVER_STATUS_INCOMPLETE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                        })
                    }
                    
                    
                    if(isFromCheckBtn == true && isAllCompleted == true){
                        if(self.completeDialog != nil){
                            return
                        }
                        self.completeDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your account has been activated.", key: "LBL_DRIVER_STATUS_COMPLETE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = Application.window!
                            
                            let getUserData = GetUserData(uv: self, window: window)
                            getUserData.getdata()
                            
                        })
                        
                        return
                    }
                    
                    if(isAllCompleted == true){
                        let window = Application.window!
                        
                        let getUserData = GetUserData(uv: self, window: window)
                        getUserData.getdata()
                        return
                    }

                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            self.loadData(isFromCheckBtn: isFromCheckBtn)
                        }
                        
                    })
                }
                
            }else{
                if(isFromCheckBtn){
                    self.generalFunc.setError(uv: self)
                }
//                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
//
//                    self.loadData()
//                })
            }
            
        })
    }

    func releaseAllTask(){
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverStateTVCell", for: indexPath) as! DriverStateTVCell
        
        if(indexPath.item == 0){
            cell.stateNumLbl.isHidden = true
            cell.stateFinishedImgView.isHidden = false
            cell.topSeperatorView.isHidden = true
        }else{
            cell.stateNumLbl.isHidden = false
            cell.stateFinishedImgView.isHidden = true
            cell.topSeperatorView.isHidden = false
        }
        
        switch indexPath.item {
        case 0:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Registration Successful", key: "LBL_REGISTRATION_SUCCESS")
            cell.actionBtn.isHidden = true
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
            
        case 1:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Upload your documents", key: "LBL_UPLOAD_YOUR_DOCS")
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPLOAD_DOCS_NOTE")
            }else{
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We need to verify your driving documents to activate your account.", key: "LBL_UPLOAD_YOUR_DOCS_NOTE")
            }
            
            cell.actionBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Upload Document", key: "LBL_UPLOAD_DOC"))

            cell.actionBtn.isHidden = false
            
            cell.actionBtn.btnType = "UPLOAD_DOC"
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Documents uploaded successfully.", key: "LBL_UPLOADDOC_SUCCESS")
                cell.actionBtn.isHidden = true
            }
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        case 2:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "Add your services" : "Add vehicles with document", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "LBL_ADD_SERVICE_TITLE" : "LBL_ADD_VEHICLE_AND_DOC")
            cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "Please select your services as per your expertise and industry." : "Please add your vehicles and its document. After that we will verify its registration.", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_ADD_SERVICE_NOTE" : "LBL_ADD_VEHICLE_AND_DOC_NOTE")
            cell.actionBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue:  self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "Select Services" : "Add Vehicle", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_SELECT_SERVICE" : "LBL_ADD_VEHICLE"))
            cell.actionBtn.isHidden = false
            cell.actionBtn.btnType = "ADD_VEHICLE"
            
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC_NOTE")
                cell.actionBtn.setButtonTitle(buttonTitle:self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_MANANGE_SERVICES"))
            }
            
            if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_UberX && self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_Ride_Delivery_UberX){
                if totalAddedVehicles > 0 {
                    cell.actionBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue:"Manage Vehicles", key: "LBL_MANAGE_VEHICLES"))
                    cell.actionBtn.btnType = "MANAGE_VEHICLE"
                }
            }
            
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "Service added successfully" : "", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_SERVICE_ADD_SUCCESS" : "LBL_VEHICLE_ADD_SUCCESS")
                
                cell.actionBtn.isHidden = true
            }
            if (Configurations.isRTLMode()){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        case 3:
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add your availability", key: "LBL_ADD_YOUR_AVAILABILITY")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add your availability for scheduled booking requests", key: "LBL_ADD_AVAILABILITY_DOC_NOTE")
                cell.actionBtn.isHidden = statusOfStates[indexPath.item]
                cell.actionBtn.btnType = "ADD_SERVICE_AVAIL"
                cell.actionBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue:  "Set Availability", key: "LBL_SET_AVAILABILITY_TXT"))
                if(statusOfStates[indexPath.item] == true){
                    cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABILITY_ADD_SUCESS_MSG")
                }
                if (Configurations.isRTLMode()){
                    cell.stateNoteLbl.textAlignment = .right
                    cell.stateTitleLbl.textAlignment = .right
                }else{
                    cell.stateNoteLbl.textAlignment = .left
                    cell.stateTitleLbl.textAlignment = .left
                }
            }else{
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Waiting for admin's approval", key: "LBL_WAIT_ADMIN_APPROVE")
                cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE")
                cell.actionBtn.isHidden = true
                cell.actionBtn.btnType = "CONTACT_US"
                
                
                if(statusOfStates[indexPath.item] == true){
                    cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_APPROVE")
                    cell.stateNoteLbl.text = ""
//                    cell.stateNoteLbl.fitText()
                    
                    cell.actionBtn.isHidden = true
                }
                if Configurations.isRTLMode(){
                    cell.stateNoteLbl.textAlignment = .right
                    cell.stateTitleLbl.textAlignment = .right
                }else{
                    cell.stateNoteLbl.textAlignment = .left
                    cell.stateTitleLbl.textAlignment = .left
                }
            }
            break
        case 4:
            cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Waiting for admin's approval", key: "LBL_WAIT_ADMIN_APPROVE")
            cell.stateNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE")
            cell.actionBtn.isHidden = true
            cell.actionBtn.btnType = "CONTACT_US"
            
            if(statusOfStates[indexPath.item] == true){
                cell.stateTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_APPROVE")
                cell.stateNoteLbl.text = ""
//                cell.stateNoteLbl.fitText()
                
                cell.actionBtn.isHidden = true
            }
            
            if Configurations.isRTLMode(){
                cell.stateNoteLbl.textAlignment = .right
                cell.stateTitleLbl.textAlignment = .right
            }else{
                cell.stateNoteLbl.textAlignment = .left
                cell.stateTitleLbl.textAlignment = .left
            }
            break
        default:
            break
            
        }
        
        cell.actionBtn.clickDelegate = self
        
//        cell.stateTitleLbl.fitText()
//        cell.stateNoteLbl.fitText()
       
        cell.stateNumLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        
        GeneralFunctions.setImgTintColor(imgView: cell.stateFinishedImgView, color: UIColor.UCAColor.AppThemeColor)
        
        cell.topSeperatorView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        cell.stateSeperatorView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
//        if(self.selectedRow == indexPath.item){
//            cell.stateNoteLbl.isHidden = false
//        }else{
//            cell.stateNoteLbl.isHidden = true
//        }
        
        if((indexPath.item + 1) == self.numOfItems){
            cell.stateSeperatorView.isHidden = true
        }else{
            cell.stateSeperatorView.isHidden = false
        }
        
        if(statusOfStates[indexPath.item] == false){
            cell.stateNoteLbl.isHidden = false
            cell.stateFinishedImgView.isHidden = true
            cell.stateNumLbl.isHidden = false
            cell.stateNumLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        }else{
            cell.stateNoteLbl.isHidden = true
//            cell.stateNumLbl.isHidden = true
            cell.stateFinishedImgView.isHidden = false
            cell.stateNumLbl.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        
        cell.stateNumLbl.text = "\(indexPath.item + 1)"
        
        Utils.createRoundedView(view: cell.stateFinishedImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: cell.stateNumLbl, borderColor: UIColor.clear, borderWidth: 0)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(statusOfStates[indexPath.item] == false){
            self.selectedRow = indexPath.item
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        indexPath.item == 0 ||
//        if((statusOfStates.count > 0 && statusOfStates[indexPath.item] == true)){
//            return 55
//        }
        
        var titleHeight:CGFloat = 0
        var noteTextHeight:CGFloat = 0
        var defaultHeight:CGFloat = 140
        
        switch indexPath.item {
        case 0:
            titleHeight = self.generalFunc.getLanguageLabel(origValue: "Registration Successful", key: "LBL_REGISTRATION_SUCCESS").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
            defaultHeight = 50
            break
        case 1:
            titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "Documents uploaded successfully." : "Upload your documents", key: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "LBL_UPLOADDOC_SUCCESS" : "LBL_UPLOAD_YOUR_DOCS").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
           
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "" : "We need to verify your driving documents to activate your account.", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "LBL_UPLOAD_DOCS_NOTE" : "LBL_UPLOAD_YOUR_DOCS_NOTE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
            
            if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                defaultHeight = 50
            }
            break
        case 2:
            var titleTxt = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "Add your services" : "Add vehicles with document", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "LBL_ADD_SERVICE_TITLE" : "LBL_ADD_VEHICLE_AND_DOC")
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                titleTxt = self.generalFunc.getLanguageLabel(origValue:"", key: "LBL_ADD_SERVICES_AND_DOC")
            }
            
            if(statusOfStates[indexPath.item] == true){
                titleTxt = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX ? "Service added successfully" : "", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_SERVICE_ADD_SUCCESS" : "LBL_VEHICLE_ADD_SUCCESS")
            }
            
             titleHeight = titleTxt.height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
            
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "Please select your services as per your expertise and industry." : "Please add your vehicles and its document. After that we will verify its registration.", key: self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX ? "LBL_ADD_SERVICE_NOTE" : "LBL_ADD_VEHICLE_AND_DOC_NOTE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
            
            if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                defaultHeight = 50
            }
            break
        case 3:
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "Availability added successfully." : "Add your availability", key: statusOfStates.count > 0 && statusOfStates[indexPath.item] == true ? "LBL_AVAILABILITY_ADD_SUCESS_MSG" : "LBL_ADD_YOUR_AVAILABILITY").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
                
                noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "Add your availability for scheduled booking requests", key: "LBL_ADD_AVAILABILITY_DOC_NOTE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
                
                if(statusOfStates.count > 0 && statusOfStates[indexPath.item] == true){
                    defaultHeight = 50
                }
                
            }else{
                noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
                
                defaultHeight = defaultHeight - 65 // minus button Height + margin
//                noteTextHeight = noteTextHeight - 60 - 10
            }
            break
        case 4:
            
            titleHeight = self.generalFunc.getLanguageLabel(origValue: statusOfStates[indexPath.item] == true ? "" : "Waiting for admin's approval", key: statusOfStates[indexPath.item] == true ? "LBL_ADMIN_APPROVE" : "LBL_WAIT_ADMIN_APPROVE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
            
            noteTextHeight = self.generalFunc.getLanguageLabel(origValue: "We will check your provided information and get back to you soon.", key: "LBL_WAIT_ADMIN_APPROVE_NOTE").height(withConstrainedWidth: Application.screenSize.width - 85, font: UIFont (name: Fonts().light, size: 15)!)
                
            defaultHeight = defaultHeight - 65 // minus button Height + margin
//                noteTextHeight = noteTextHeight - 60 - 10
            
            break
        default:
            break
            
        }
        titleHeight = titleHeight - 18
        if(titleHeight < 0){
            titleHeight = 0
        }
        noteTextHeight = noteTextHeight - 18
        if(noteTextHeight < 0){
            noteTextHeight = 0
        }
        if((statusOfStates.count > 0 && statusOfStates[indexPath.item] == true)){
            return defaultHeight + titleHeight
        }

        
        return defaultHeight + noteTextHeight + titleHeight
    }
    
    func myBtnTapped(sender: MyButton) {
        if(checkAccStatusBtn != nil && sender == checkAccStatusBtn){
            reloadData(isFromCheckBtn: true)
            return
        }
        if(sender.btnType == "UPLOAD_DOC"){
            let listOfDocumentUV = GeneralFunctions.instantiateViewController(pageName: "ListOfDocumentUV") as! ListOfDocumentUV
            self.pushToNavController(uv: listOfDocumentUV)
        }else if(sender.btnType == "ADD_VEHICLE"){
            
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX || (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "NO")){
            }else if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX && self.userProfileJson.get("eShowVehicles").uppercased() == "YES"){
                let appTypeSelectionUv = GeneralFunctions.instantiateViewController(pageName: "AppTypeSelectionUV") as! AppTypeSelectionUV
                appTypeSelectionUv.isFromDriverStatesUV = true
                appTypeSelectionUv.totalAddedVehicles = totalAddedVehicles
                appTypeSelectionUv.screenToNavigate = "MANAGE_VEHICLE"
                self.pushToNavController(uv: appTypeSelectionUv)
            }else{
                let addVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "AddVehiclesUV") as! AddVehiclesUV
                addVehiclesUv.isFromDriverStatesUV = true
                self.pushToNavController(uv: addVehiclesUv)
            }
            
        }else if(sender.btnType == "MANAGE_VEHICLE"){
            if (self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                if(self.userProfileJson.get("eShowVehicles").uppercased() == "YES"){
                    let appTypeSelectionUv = GeneralFunctions.instantiateViewController(pageName: "AppTypeSelectionUV") as! AppTypeSelectionUV
                    appTypeSelectionUv.screenToNavigate = "MANAGE_VEHICLE"
                    appTypeSelectionUv.totalAddedVehicles = totalAddedVehicles
                    self.pushToNavController(uv: appTypeSelectionUv)
                }else{
                }
            }else{
                let manageVehiclesUv = GeneralFunctions.instantiateViewController(pageName: "ManageVehiclesUV") as! ManageVehiclesUV
                self.pushToNavController(uv: manageVehiclesUv)
            }
            
        }else if(sender.btnType == "ADD_SERVICE_AVAIL"){
        }
    }
}
