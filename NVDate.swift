//
//  NVDate.swift
//  NVDate
//
//  Created by Noval Agung Prayogo on 11/10/15.
//  Copyright © 2015 Noval Agung Prayogo. All rights reserved.
//

import UIKit

class NVDate: NSObject {
    
    public enum DayUnit: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    
    public enum MonthUnit: Int {
        case january = 1
        case february = 2
        case march = 3
        case april = 4
        case may = 5
        case june = 6
        case july = 7
        case august = 8
        case september = 9
        case october = 10
        case november = 11
        case december = 12
    }
    
    // ============= private props

    fileprivate var _date: Date?
    fileprivate var _dateFormatter: DateFormatter = DateFormatter()
    fileprivate var _calendar = Calendar.current
    fileprivate var _calendarUnitDateTime: Set<Calendar.Component> = [.year, .month, .weekOfYear, .weekday, .day, .hour, .minute, .second]
    fileprivate var _calendarUnitDateOnly: Set<Calendar.Component> = [.year, .month, .day]
    fileprivate var _timeZone = NSTimeZone.local
    
    // ============= private funcs
    
    fileprivate func _dateComponentsFromCurrentDate() -> DateComponents {
        return _calendar.dateComponents(_calendarUnitDateTime, from: _date!)
    }
    
    fileprivate func _dateComponentsFromCurrentDate(calendarUnit: Set<Calendar.Component>) -> DateComponents {
        return _calendar.dateComponents(calendarUnit, from: _date!)
    }
    
    fileprivate func _dateByAddingComponentsToCurrentDate(_ components: DateComponents) -> Date? {
        if _date != nil {
            return _calendar.date(byAdding: components, to: _date!, wrappingComponents: true)
        }
        
        return _date
    }
    
    fileprivate func _dateByAddingDay(days: Int, isForward: Bool) -> NVDate {
        if _date != nil {
            var components = DateComponents()
            components.day = days * (isForward ? 1 : -1)
            _date = _dateByAddingComponentsToCurrentDate(components)
        }
        
        return self
    }
    
    fileprivate func _dateByAddingWeek(weeks: Int, isForward: Bool) -> NVDate {
        if _date != nil {
            var components = DateComponents()
            components.day = (7 * weeks) * (isForward ? 1 : -1)
            _date = _dateByAddingComponentsToCurrentDate(components)
        }
        
        return self
    }
    
    fileprivate func _dateByAddingMonth(months: Int, isForward: Bool) -> NVDate {
        if _date != nil {
            var components = DateComponents()
            components.month = months * (isForward ? 1 : -1)
            _date = _dateByAddingComponentsToCurrentDate(components)
        }
        
        return self
    }
    
    fileprivate func _dateByAddingYear(years: Int, isForward: Bool) -> NVDate {
        if _date != nil {
            var components = DateComponents()
            components.year = years * (isForward ? 1 : -1)
            _date = _dateByAddingComponentsToCurrentDate(components)
        }
        
        return self
    }
    
    // ============= init
    
    override init() {
        super.init()
        
        _dateFormatter.dateStyle = .full
        _dateFormatter.timeStyle = .full
        _dateFormatter.timeZone = _timeZone
        
        _calendar.timeZone = _timeZone
        
        _date = Date()
    }
    
    convenience init(fromString: String, withFormat: String) {
        self.init()
        
        let df = DateFormatter()
        df.dateFormat = withFormat
        
        _dateFormatter.dateFormat = withFormat
        _date = _dateFormatter.date(from: fromString)
    }
    
    convenience init(year: Int, month: Int, day: Int) {
        self.init()
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        _date = _calendar.date(from: components)
    }

    convenience init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        self.init()
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        _date = _calendar.date(from: components)
    }
    
    convenience init(fromDate: Date) {
        self.init()
        
        _date = fromDate
    }
    
    convenience init(fromTimeIntervalSinceReferenceDate: TimeInterval) {
        self.init()
        
        _date = Date(timeIntervalSinceReferenceDate: fromTimeIntervalSinceReferenceDate)
    }
    
    // ============= public functions
    
    func date() -> Date? {
        return _date
    }
    
    func asString() -> String {
        if _date != nil {
            return _dateFormatter.string(from: _date!)
        }
        
        return ""
    }
    
    func asString(withFormat: String) -> String {
        let localDateFormatter = _dateFormatter.copy() as! DateFormatter
        localDateFormatter.dateFormat = withFormat
        
        if _date != nil {
            return localDateFormatter.string(from: _date!)
        }
        
        return ""
    }
    
    func setTimeAsZero() -> NVDate {
        if _date != nil {
            var components = _dateComponentsFromCurrentDate(calendarUnit: _calendarUnitDateOnly)
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            _date = _calendar.date(from: components)
        }
        
        return self
    }
    
    func dateFormat() -> String {
        return _dateFormatter.dateFormat
    }
    
    func dateFormat(setFormat: String) {
        _dateFormatter.dateFormat = setFormat
    }
    
    func dateStyle() -> DateFormatter.Style {
        return _dateFormatter.dateStyle
    }
    
    func dateStyle(setStyle: DateFormatter.Style) {
        _dateFormatter.dateStyle = setStyle
    }
    
    func timeStyle() -> DateFormatter.Style {
        return _dateFormatter.timeStyle
    }
    
    func timeStyle(setStyle: DateFormatter.Style) {
        _dateFormatter.timeStyle = setStyle
    }
    
    func timeZone() -> TimeZone {
        return _timeZone
    }
    
    func timeZone(setTimeZone: TimeZone) {
        _timeZone = setTimeZone
        _calendar.timeZone = setTimeZone
        _dateFormatter.timeZone = setTimeZone
    }
    
    // ================ date and time related functions
    
    func nextDays(days: Int) -> NVDate {
        return _dateByAddingDay(days: days, isForward: true)
    }
    
    func nextDay() -> NVDate {
        return nextDays(days: 1)
    }
    
    func tomorrow() -> NVDate {
        return nextDay()
    }
    
    func previousDays(days: Int) -> NVDate {
        return _dateByAddingDay(days: days, isForward: false)
    }
    
    func previousDay() -> NVDate {
        return previousDays(days: 1)
    }
    
    func yesterday() -> NVDate {
        return previousDay()
    }
    
    func nextWeeks(weeks: Int) -> NVDate {
        return _dateByAddingWeek(weeks: weeks, isForward: true)
    }
    
    func nextWeek() -> NVDate {
        return nextWeeks(weeks: 1)
    }
    
    func previousWeeks(weeks: Int) -> NVDate {
        return _dateByAddingWeek(weeks: weeks, isForward: false)
    }
    
    func previousWeek() -> NVDate {
        return previousWeeks(weeks: 1)
    }
    
    func nextMonths(months: Int) -> NVDate {
        return _dateByAddingMonth(months: months, isForward: true)
    }
    
    func nextMonth() -> NVDate {
        return nextMonths(months: 1)
    }
    
    func previousMonths(months: Int) -> NVDate {
        return _dateByAddingMonth(months: months, isForward: false)
    }
    
    func previousMonth() -> NVDate {
        return previousMonths(months: 1)
    }
    
    func nextYears(years: Int) -> NVDate {
        return _dateByAddingYear(years: years, isForward: true)
    }
    
    func nextYear() -> NVDate {
        return nextYears(years: 1)
    }
    
    func previousYears(years: Int) -> NVDate {
        return _dateByAddingYear(years: years, isForward: false)
    }
    
    func previousYear() -> NVDate {
        return previousYears(years: 1)
    }
    
    func firstDayOfMonth() -> NVDate {
        if _date != nil {
            var components = _dateComponentsFromCurrentDate()
            components.day = 1
            _date = _calendar.date(from: components)
        }
        
        return self
    }
    
    func lastDayOfMonth() -> NVDate {
        if _date != nil {
            var components = _dateComponentsFromCurrentDate()
            components.day = 1
            _date = _calendar.date(from: components)
            
            components = DateComponents()
            components.month = 1
            _date = _calendar.date(byAdding: components, to: _date!, wrappingComponents: true)
            
            components = DateComponents()
            components.day = -1
            _date = _calendar.date(byAdding: components, to: _date!, wrappingComponents: true)
        }
        
        return self
    }
    
    func firstMonthOfYear() -> NVDate {
        if _date != nil {
            var components = _dateComponentsFromCurrentDate()
            components.month = MonthUnit.january.rawValue
            _date = _calendar.date(from: components)
        }
        
        return self
    }
    
    func lastMonthOfYear() -> NVDate {
        if _date != nil {
            var components = _dateComponentsFromCurrentDate()
            components.month = MonthUnit.december.rawValue
            _date = _calendar.date(from: components)
        }
        
        return self
    }
    
    func nearestPreviousDay(_ dayUnit: DayUnit) -> NVDate {
        if _date != nil {
            
            var components = _dateComponentsFromCurrentDate()
            if let currentWeekDay = components.weekday {
                
                if currentWeekDay == dayUnit.rawValue {
                    return self.previousWeek()
                }
                
                components = DateComponents()
                
                if currentWeekDay > dayUnit.rawValue {
                    components.day = -(currentWeekDay - dayUnit.rawValue)
                } else {
                    components.day = -currentWeekDay - (7 - dayUnit.rawValue)
                }
                
                _date = _calendar.date(byAdding: components, to: _date!, wrappingComponents: true)
            }
        }
        
        return self
    }
    
    func nearestNextDay(_ dayUnit: DayUnit) -> NVDate {
        if _date != nil {
            
            var components = _dateComponentsFromCurrentDate()
            if let currentWeekDay = components.weekday {
                
                if currentWeekDay == dayUnit.rawValue {
                    return self.previousWeek()
                }
                
                components = DateComponents()
                
                if currentWeekDay < dayUnit.rawValue {
                    components.day = dayUnit.rawValue - currentWeekDay
                } else {
                    components.day = -currentWeekDay + dayUnit.rawValue
                }
                
                _date = _calendar.date(byAdding: components, to: _date!, wrappingComponents: true)
            }
        }
        
        return self
    }
    
    func isThisDay(_ dayUnit: DayUnit) -> Bool {
        if _date != nil {
            let components = _dateComponentsFromCurrentDate()
            return components.weekday == dayUnit.rawValue
        }
        
        return false
    }
    
    func isToday(_ dayUnit: DayUnit) -> Bool {
        return isThisDay(dayUnit)
    }
    
    func isThisMonth(_ monthUnit: MonthUnit) -> Bool {
        let components = _dateComponentsFromCurrentDate()
        return components.month == monthUnit.rawValue
    }
    
    func year() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.year!
    }
    
    func year(setYear: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.year = setYear
        
        _date = _calendar.date(from: components)
    }
    
    func month() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.month!
    }
    
    func month(setMonth: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.month = setMonth
        
        _date = _calendar.date(from: components)
    }
    
    func week() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.weekOfYear!
    }
    
    func day() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.day!
    }
    
    func day(setDay: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.day = setDay
        
        _date = _calendar.date(from: components)
    }
    
    func hour() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.hour!
    }
    
    func hour(setHour: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.hour = setHour
        
        _date = _calendar.date(from: components)
    }
    
    func minute() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.minute!
    }
    
    func minute(setMinute: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.minute = setMinute
        
        _date = _calendar.date(from: components)
    }
    
    func second() -> Int {
        let components = _dateComponentsFromCurrentDate()
        return components.second!
    }
    
    func second(setSecond: Int) {
        var components = _dateComponentsFromCurrentDate()
        components.second = setSecond
        
        _date = _calendar.date(from: components)
    }
}
