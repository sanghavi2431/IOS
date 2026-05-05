//
//  ThirstReminderModel.swift
//  Woloo
//
//  Created by DigitalFlake Kapil Dongre on 18/05/23.
//

import Foundation

struct ThirstReminderModel: Codable {
    
    let is_thirst_reminder: Int?
    let thirst_reminder_hours: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case is_thirst_reminder = "is_thirst_reminder"
        case thirst_reminder_hours = "thirst_reminder_hours"
        
    }
    
}
