//
//  SettingStore.swift
//  BookOfMoons
//
//  Created by Handy Hasan on 05/09/2022.
//

import Foundation
import Combine

enum DisplayOrderType: Int, CaseIterable {
    case horror = 0
    case personalDevelopment = 1
    case romance = 2
    case mystery = 3
    case comedy = 4
    case shortStories = 5
    case fiction = 6
    case nonFiction = 7
    case biography = 8
    case general = 9
    case animeJapan = 10
    case history = 11
    case fantasy = 12
    case classic = 13
    
    init(type: Int) {
        switch type {
        case 0: self = .horror
        case 1: self = .personalDevelopment
        case 2: self = .romance
        case 3: self = .mystery
        case 4: self = .comedy
        case 5: self = .shortStories
        case 6: self = .fiction
        case 7: self = .nonFiction
        case 8: self = .biography
        case 9: self = .general
        case 10: self = .animeJapan
        case 11: self = .history
        case 12: self = .fantasy
        case 13: self = .classic
        default: self = .horror
        }
    }
    
    var text: String {
        switch self {
        case .horror: return "Horror"
        case .personalDevelopment: return "Personal Development"
        case .romance: return "Romance"
        case .mystery: return "Mystery"
        case .comedy: return "Comedy"
        case .shortStories: return "Short Stories"
        case .fiction: return "Fiction"
        case .nonFiction: return "Non-Fiction"
        case .biography: return "Biography"
        case .general: return "General"
        case .animeJapan: return "Anime/Japan"
        case .history: return "History"
        case .fantasy: return "Fantasy"
        case .classic: return "Classic"
            
        }
    }
    
    func predicate() -> ((NewResult,NewResult) -> Bool) {
        
        switch self {
        case .horror: return { $0.newCategories == "Horror" && $1.newCategories != "Horror" }
        case .personalDevelopment:
            return {  $0.newCategories == "Personal Development" && $1.newCategories != "Personal Development" }
        case .romance:
            return {  $0.newCategories == "Romance" && $1.newCategories != "Romance" }
        case .mystery:
            return {  $0.newCategories == "Mystery" && $1.newCategories != "Mystery" }
        case .comedy:
            return {   $0.newCategories == "Comedy" && $1.newCategories != "Comedy" }
        case .shortStories:
            return {   $0.newCategories == "Short Stories" && $1.newCategories != "Short Stories" }
        case .fiction:
            return {   $0.newCategories == "Fiction" && $1.newCategories != "Fiction" }
        case .nonFiction:
            return {   $0.newCategories == "Non-Fiction" && $1.newCategories != "Non-Fiction" }
        case .biography:
            return {   $0.newCategories == "Biography" && $1.newCategories != "Biography" }
        case .general:
            return {   $0.newCategories == "General" && $1.newCategories != "General" }
        case .animeJapan:
            return {   $0.newCategories == "Anime/Japan" && $1.newCategories != "Anime/Japan" }
        case .history:
            return { $0.newCategories == "History" && $1.newCategories != "History" }
        case .fantasy:
            return {  $0.newCategories == "Fantasy" && $1.newCategories != "Fantasy" }
        case .classic:
            return {  $0.newCategories == "Classic" && $1.newCategories != "Classic" }
        }
    }
}

final class SettingStore: ObservableObject {
    
    init() {
        UserDefaults.standard.register(defaults: [
            "view.preferences.displayOrder" : 0,
        ])
    }
    
    
    
    @Published var displayOrder: DisplayOrderType = DisplayOrderType(type: UserDefaults.standard.integer(forKey: "view.preferences.displayOrder")) {
        didSet {
            UserDefaults.standard.set(displayOrder.rawValue, forKey: "view.preferences.displayOrder")
        }
    }
    
    @Published var newList = [NewResult]()
    
    
    
}
