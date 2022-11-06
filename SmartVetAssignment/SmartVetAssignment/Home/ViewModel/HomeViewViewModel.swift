//
//  HomeViewViewModel.swift
//  SmartVetAssignment
//
//  Created by NWagh on 05/11/22.
//

import Foundation

class HomeViewViewModel: HomeViewViewModelProtocol {
    
    //MARK: - Properties
    let service: HomeServicesProtocol
    var configSetting: Settings?
    var petsArray: [Pet]? = [Pet]()
    var operationCompletion: ((Bool, String?) -> Void)?
    var showCallChatOptions: Bool {
        if let setting = configSetting {
            return setting.isCallEnabled && setting.isChatEnabled
        }
        return false
    }
    var rowsCount: Int {
        if let pets = petsArray {
            return pets.count + 1
        }
        return 0
    }
    let dispatchGroup = DispatchGroup()
    
    //MARK: - init
    init(service: HomeServicesProtocol) {
        self.service = service
    }
    
    //MARK: - Custom Methods
    func loadRemoteData() {
        getConfigDetails()
        getPetsDetails()
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.operationCompletion?(true, nil)
        }
    }
    
    private func checkWorkingHoursFormatIsValid(for text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.regularExpression, options: [.caseInsensitive])
        let range = NSRange(location: 0, length: text.count)
        let matches = regex.matches(in: text, options: [], range: range)
        return matches.first != nil
    }
    
    func checkIfWithinWorkHours(now: Date) -> Bool {
        if let setting = configSetting, checkWorkingHoursFormatIsValid(for: setting.workHours) {
            let splitArray = setting.workHours.split(separator: " ")
            let startingWorkHrs = splitArray[1].split(separator: ":")
            let endingWorkHrs = splitArray[3].split(separator: ":")
            
            let calender = Calendar.current
            let startTimeCmp = DateComponents(calendar: calender, hour: Int(startingWorkHrs[0]), minute: Int(startingWorkHrs[1]))
            let endTimeCmp = DateComponents(calendar: calender, hour: Int(endingWorkHrs[0]), minute: Int(endingWorkHrs[1]))
            
            let startOfToday = Calendar.current.startOfDay(for: now)
            let startTime = calender.date(byAdding: startTimeCmp, to: startOfToday)!
            let endTime = calender.date(byAdding: endTimeCmp, to: startOfToday)!
            
            let isWeekend = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.isDateInWeekend(now)
            
            if startTime <= now && now <= endTime && !isWeekend {
                return true
            }
        }
        return false
    }
    
    //MARK: - Service Calls
    func getConfigDetails() {
        dispatchGroup.enter()
        service.getConfigurationDetails { (result, error) in
            DispatchQueue.main.async {
                self.dispatchGroup.leave()
                if let result = result {
                    self.configSetting = result.settings
                } else {
                    self.operationCompletion?(false, error?.reason)
                }
            }
        }
    }
    
    func getPetsDetails() {
        dispatchGroup.enter()
        service.getPetsInfoList { (result, error) in
            DispatchQueue.main.async {
                self.dispatchGroup.leave()
                if let result = result {
                    self.petsArray = result.pets
                } else {
                    self.operationCompletion?(false, error?.reason)
                }
            }
        }
    }
}
