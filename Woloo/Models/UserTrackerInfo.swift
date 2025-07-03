//
//  UserTrackerInfo.swift
//  Woloo
//
//  Created on 13/08/21.
//

import ObjectMapper

struct UserTrackerInfo: Mappable {
    
    
    var id: Int?
    var userId: Int?
    var periodDate: String?
    var cycleLength: Int?
    var periodLength: Int?
    var lutealLength: Int?
    var log: [String: [String]]?
    var createdAt: String?
    var updatedAt: String?
    
    
    var dailyLogData: DailyLogInfo? {
        var loginfo = DailyLogInfo()
        if let bleedingList = log?["bleeding"] {
            loginfo.bleedig = bleedingList.compactMap({Bleeding.init(rawValue: $0.lowercased())})
        }
        
        if let moodList = log?["mood"] {
            loginfo.mood = moodList.compactMap({Mood.init(rawValue: $0.lowercased())})
        }
        
        if let preMenstruation = log?["premenstruation"] {
            loginfo.preMenstruation = preMenstruation.compactMap({PreMenstruation.init(rawValue: $0.lowercased())})
        }
        
        if let habits = log?["habits"] {
            loginfo.habits = habits.compactMap({Habits.init(rawValue: $0.lowercased())})
        }
        
        if let menstruation = log?["menstruation"] {
            loginfo.menstruation = menstruation.compactMap({Menstruation.init(rawValue: $0.lowercased())})
        }
        
        if let dieasesandmedication = log?["diseasesandmedication"] {
            loginfo.diseasAndMediaction = dieasesandmedication.compactMap({DieasesAndMedication.init(rawValue: $0.lowercased())})
        }
    
        if let sexDriveList = log?["sexDrive"] {
            loginfo.sexDrive = sexDriveList.compactMap({SexDrive.init(rawValue: $0.lowercased())})
        }
        
        return loginfo
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        periodDate <- map["period_date"]
        cycleLength <- map["cycle_lenght"]
        periodLength <- map["period_length"]
        lutealLength <- map["luteal_length"]
        log <- map["log"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}
