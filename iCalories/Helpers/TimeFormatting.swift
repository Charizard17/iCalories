//
//  TimeFormatting.swift
//  iCalories
//
//  Created by Esad Dursun on 23.06.23.
//

import Foundation

func calcTimeSince(date: Date) -> String{
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    let weeks = days/7
    let months = weeks/4
    
    if minutes < 2 {
        return "\(minutes) min ago"
    } else if minutes < 120 {
        return "\(minutes) mins ago"
    } else if minutes >= 120 &&  hours < 48 {
        return "\(hours) hrs ago"
    } else if days < 14 {
        return "\(days) days ago"
    } else if weeks < 8 {
        return "\(weeks) weeks ago"
    } else {
        return "\(months) mos ago"
    }
}
