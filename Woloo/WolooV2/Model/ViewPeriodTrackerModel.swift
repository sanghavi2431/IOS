//
//  PeriodTrackerModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 26/05/23.
//

import Foundation

struct ViewPeriodTrackerModel: Codable {
    
    var id: Int?
    var userId: Int?
    var periodDate: String? = ""
    var cycleLength: Int?
    var periodLength: Int?
    var lutealLength: Int?
    var log: [String: [String]]?
    var createdAt: String? = ""
    var updatedAt: String? = "" 
   
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case userId = "user_id"
        case periodDate = "period_date"
        case cycleLength = "cycle_length"
        case periodLength = "period_length"
        case lutealLength = "luteal_length"
        case log = "log"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
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

    
}
