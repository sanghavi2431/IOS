//
//  DailyLogsInfo.swift
//  Woloo
//
//  Created on 05/08/21.
//

import UIKit

enum Bleeding: String, CaseIterable {
    case light
    case medium
    case heavy
    case spotting
    
    var title: String {
        switch self {
        case .light:
            return "Light"
        case .medium:
            return "Medium"
        case .heavy:
            return "Heavy"
        case .spotting:
            return "Spotting"
        }
    }
    
    var images: UIImage {
        switch self {
        case .light:
            return UIImage(named: "lightBleeding")!
        case .medium:
            return UIImage(named: "mediumBleeding")!
        case .heavy:
            return UIImage(named: "heavyBleeding")!
        case .spotting:
            return UIImage(named: "spottingBleeding")!
        }
    }
}

enum Mood: String, CaseIterable {
    case normal
    case happy
    case dizzy
    case tired
    
    var title: String {
        switch self {
        case .happy:
            return "Happy"
        case .dizzy:
            return "Dizzy"
        case .tired:
            return "Tired"
        case .normal:
            return "Normal"
        }
    }
    
    var images: UIImage {
        switch self {
        case .happy:
            return UIImage(named: "happyMood")!
        case .dizzy:
            return UIImage(named: "dizzyMood")!
        case .tired:
            return UIImage(named: "tiredMood")!
        case .normal:
            return UIImage(named: "normalMood")!
        }
    }
}

enum DieasesAndMedication: String, CaseIterable {
    case obesity
    case hypertension
    case diabetes
    case pcos
    case thyroid
    case stress
    case sickness
    case onAntibiotics = "On Antibiotics"
    case anyOtherMedicine = "Any other medicine"
    
    var title: String {
        switch self {
        case .obesity:
            return "Obesity"
        case .hypertension:
            return "Hypertension"
        case .diabetes:
            return "Diabetes"
        case .pcos:
            return "PCOS"
        case .thyroid:
            return "Thyroid"
        case .stress:
            return "Stress"
        case .sickness:
            return "Sickness"
        case .onAntibiotics:
            return "On Antibiotics"
        case .anyOtherMedicine:
            return "Any other medicine"
        }
    }
    
    var images: UIImage {
        switch self {
        case .obesity:
            return UIImage(named: "Obesity")!
        case .hypertension:
            return UIImage(named: "Hypertension")!
        case .diabetes:
            return UIImage(named: "Diabetes")!
        case .pcos:
            return UIImage(named: "PCOS")!
        case .thyroid:
            return UIImage(named: "Thyroid")!
        case .stress:
            return UIImage(named: "Stress")!
        case .sickness:
            return UIImage(named: "Sickness")!
        case .onAntibiotics:
            return UIImage(named: "OnAntibiotics")!
        case .anyOtherMedicine:
            return UIImage(named: "Anyothermedicine")!
        }
    }
    
}

enum Habits: String, CaseIterable {
    case smoking
    case drinking
    
    var title: String {
        switch self {
        case .smoking:
            return "Smoking"
        case .drinking:
            return "Drinking"
        }
    }
    var image: UIImage {
        switch self {
        case .smoking:
            return UIImage(named: "smoking")!
        case .drinking:
            return UIImage(named: "drinking")!
        }
    }
}

enum PreMenstruation: String, CaseIterable {
    case fine = "everything is fine"
    case cramps = "cramps"
    case headache = "headache"
    case bloatinginLowerAbdomen = "bloating in lower abdomen"
    case constipation = "Constipation"
    case heavinessInLegs = "heaviness in legs"
    case migrane = "migrane"
    case ChangeInAppetite = "change in appetite"
    
    var title: String {
        switch self {
        case .ChangeInAppetite:
            return "Change in appetite"
        case .migrane:
            return "Migrane"
        case .heavinessInLegs:
            return "Heaviness in legs"
        case .constipation:
            return "Constipation"
        case .bloatinginLowerAbdomen:
            return "Bloating in Lower Abdomen"
        case .fine:
            return "Everything is fine"
        case .cramps:
            return "Cramps"
        case .headache:
            return "Headache"
        }
    }
    
    var images: UIImage {
        switch self {
        case .fine:
            return UIImage(named: "fineSymptoms")!
        case .cramps:
            return UIImage(named: "crampsSymptoms")!
        case .migrane:
            return UIImage(named: "headacheSymtoms")!
        case .headache:
            return UIImage(named: "migrane")!
        case .ChangeInAppetite:
            return UIImage(named: "appetite")!
        case .heavinessInLegs:
            return UIImage(named: "heavyLegs")!
        case .constipation:
            return UIImage(named: "constipation")!
        case .bloatinginLowerAbdomen:
            return UIImage(named: "abdomen")!
        }
    }
}

enum Menstruation: String, CaseIterable {
    case fine = "everything is fine"
    case tenderBreasts = "tender breasts"
    case bowel = "bowel"
    case vomiting = "Vomiting"
    case headache = "Headache"
    case ChangeInAppetite = "change in appetite"
    
    var title: String {
        switch self {
        case .ChangeInAppetite:
            return "Change in appetite"
        case .fine:
            return "Everything is fine"
        case .bowel:
            return "Bowel"
        case .vomiting:
            return "Vomiting"
        case .tenderBreasts:
            return "Tender Breasts"
        case .headache:
            return "Headache"
        }
    }
    
    var images: UIImage {
        switch self {
        case .fine:
            return UIImage(named: "menstruationFine")!
        case .headache:
            return UIImage(named: "menstruationHeadache")!
        case .ChangeInAppetite:
            return UIImage(named: "menstruationAppetite")!
        case .bowel:
            return UIImage(named: "menstruationBowel")!
        case .vomiting:
            return UIImage(named: "menstruationVomiting")!
        case .tenderBreasts:
            return UIImage(named: "menstruationtender")!
        }
    }
}

enum SexDrive: String, CaseIterable {
    case didntHaveSex = "didn't have sex"
    case protectedSex = "protected sex"
    case unProtectedSex = "unprotected sex"
    case highsexDrive = "high sex drive"
    case masturbation = "masturbation"
    
    var title: String {
        switch self {
        case .didntHaveSex:
            return "Didn't have Sex"
        case .protectedSex:
            return "Protected Sex"
        case .unProtectedSex:
            return "Unprotected Sex"
        case .highsexDrive:
            return "High Sex Drive"
        case .masturbation:
            return "Masturbation"
        }
    }
    
    var images: UIImage {
        switch self {
        case .didntHaveSex:
            return UIImage(named: "didnotSex")!
        case .protectedSex:
            return UIImage(named: "protectedSex")!
        case .unProtectedSex:
            return UIImage(named: "unProtectedSex")!
        case .highsexDrive:
            return UIImage(named: "highSexDrive")!
        case .masturbation:
            return UIImage(named: "masturbation")!
        }
    }
}

struct DailyLogInfo {
    var preMenstruation = [PreMenstruation]()
    var menstruation = [Menstruation]()
    var diseasAndMediaction = [DieasesAndMedication]()
    var habits = [Habits]()
    var bleedig = [Bleeding]()
    var mood = [Mood]()
    var sexDrive = [SexDrive]()
}
