//
//  Delegates.swift
//  SwiftWeeklyCalendar
//
//  Created by Miguel Machado on 12/20/19.
//

import UIKit

@objc public protocol WeeklyCalendarCollectionViewDelegate {
    func weeklyCalendarCollectionView(_ collectionView: WeeklyCalendarCollectionView, cellFor date:Date, indexPath:IndexPath) -> UICollectionViewCell
    func weeklyCalendarCollectionView(collectionView: WeeklyCalendarCollectionView,changeWeek dates:[Date])
    func weeklyCalendarCollectionView(collectionView: WeeklyCalendarCollectionView, didSelectItemAt cellState: Date)
}

@objc public protocol CalendarHeaderCollectionViewDelegate {
    func calendarHeaderCollectionView(_ collectionView: CalendarHeaderCollectionView, cellFor date:Date, indexPath:IndexPath) -> UICollectionViewCell
}
@objc public protocol CalendarHoursCollectionViewDelegate {
    func calendarHoursCollectionView(_ collectionView: CalendarHoursCollectionView, cellFor hour:Int, indexPath:IndexPath) -> UICollectionViewCell
}
