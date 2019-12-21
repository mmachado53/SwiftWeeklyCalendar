//
//  Delegates.swift
//  SwiftWeeklyCalendar
//
//  Created by Miguel Machado on 12/20/19.
//

import UIKit

@objc public protocol WeeklyCalendarColectionViewDelegate {
    func weeklyCalendarColectionView(_ collectionView: WeeklyCalendarColectionView, cellFor date:Date, indexPath:IndexPath) -> UICollectionViewCell
    func weeklyCalendarColectionView(collectionView: WeeklyCalendarColectionView,changeWeek dates:[Date])
    func weeklyCalendarColectionView(collectionView: WeeklyCalendarColectionView, didSelectItemAt cellState: Date)
}

@objc public protocol WeeklyCalendarHeaderColectionViewDelegate {
    func weeklyHeaderCalendarColectionView(_ collectionView: WeeklyHeaderCalendarColectionView, cellFor date:Date, indexPath:IndexPath) -> UICollectionViewCell
}
@objc public protocol WeeklyCalendarHoursColectionViewDelegate {
    func weeklyCalendarHoursColectionViewDelegate(_ collectionView: WeeklyHoursCalendarColectionView, cellFor hour:Int, indexPath:IndexPath) -> UICollectionViewCell
}
