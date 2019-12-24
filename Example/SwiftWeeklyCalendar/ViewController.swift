//
//  ViewController.swift
//  SwiftWeeklyCalendar
//
//  Created by mmachado53 on 12/20/2019.
//  Copyright (c) 2019 mmachado53. All rights reserved.
//

import UIKit
import SwiftWeeklyCalendar
class ViewController: UIViewController {

    var dateFormatter:DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return df
    }
    
    var monthDF:DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy "
        return df
    }
    
    var dayDF:DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "EE dd"
        return df
    }
    
    var events:[SampleEvent] = []
    var eventsPerDay:[String:[SampleEvent]] = [:]
    
    
    @IBOutlet var calendar:WeeklyCalendarCollectionView?
    
    var defaultCalendarWidth:CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.events.append(SampleEvent(name: "Event 1", startDate: dateFormatter.date(from: "2019-10-21T00:48:00+0000")!, endDate: dateFormatter.date(from: "2019-10-21T01:48:00+0000")!))
        
        self.events.append(SampleEvent(name: "Event 2", startDate: dateFormatter.date(from: "2019-10-21T16:30:00+0000")!, endDate: dateFormatter.date(from: "2019-10-21T17:15:00+0000")!))
        
        buildEventsPerDay()
    }
    
    func buildEventsPerDay(){
        for event in events {
            let keySt:String = key(from: event.startDate)
            if (eventsPerDay.index(forKey: keySt) == nil){
                eventsPerDay[keySt] = []
            }
            eventsPerDay[keySt]?.append(event)
        }
        calendar?.reloadData()
    }
    
    func key(from date:Date)->String{
        let calendarComponents : Set<Calendar.Component> = [.year, .month, .day]
        let components = Calendar.current.dateComponents(calendarComponents, from: date)
        return "\(components.year!)/\(components.month!)/\(components.day!)"
    }
    
    @IBAction func test(_ sender:Any){
        if defaultCalendarWidth == nil {self.defaultCalendarWidth = calendar?.frame.width}
        let f:CGRect = self.calendar!.frame
        if self.calendar?.frame.width != self.defaultCalendarWidth {
            self.calendar?.frame = CGRect(x: f.minX, y: f.minY, width: self.defaultCalendarWidth!, height: f.height)
        }else{
            self.calendar?.frame = CGRect(x: f.minX, y: f.minY, width: self.defaultCalendarWidth! / 2, height: f.height)
        }
    }
    
}

extension ViewController : WeeklyCalendarCollectionViewDelegate{
    func weeklyCalendarCollectionView(_ collectionView: WeeklyCalendarCollectionView, cellFor date: Date, indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let bgView:UIView = cell.viewWithTag(54) {
            let weekDay:Int = Calendar.current.component(.weekday, from: date)
            let bgAlpha:CGFloat = weekDay == 7 || weekDay == 1 ? 0.7 : 0.22
            bgView.backgroundColor = bgView.backgroundColor?.withAlphaComponent(bgAlpha)
        }
        if let label:UILabel = cell.viewWithTag(53) as? UILabel {
            //label.text = date.toDateTimeString()
        }
        if let eventsContainer:UIView = cell.viewWithTag(54){
            eventsContainer.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            let keySt:String = key(from: date)
            eventsPerDay[keySt]?.forEach({ (event) in
                let frame:CGRect = WeeklyCalendarCollectionView.Utils.eventViewFrame(inParentWith: collectionView.dayCellSize, startDate: event.startDate, endDate: event.endDate)
                let eventView:UIView = UIView(frame: frame)
                eventsContainer.addSubview(eventView)
                eventView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            })
            
        }
        
        return cell
    }
    
    func weeklyCalendarCollectionView(collectionView: WeeklyCalendarCollectionView, changeWeek dates: [Date]) {
        title = monthDF.string(from: dates.first!)
    }
    
    func weeklyCalendarCollectionView(collectionView: WeeklyCalendarCollectionView, didSelectItemAt cellState: Date) {
        
    }
    
    
}

extension ViewController : CalendarHeaderCollectionViewDelegate {
    func calendarHeaderCollectionView(_ collectionView: CalendarHeaderCollectionView, cellFor date: Date, indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let label:UILabel = cell.viewWithTag(53) as? UILabel {
            label.text = dayDF.string(from: date)
        }
        
        
        return cell
    }
    
    
}

extension ViewController : CalendarHoursCollectionViewDelegate {
    func calendarHoursCollectionView(_ collectionView: CalendarHoursCollectionView, cellFor hour: Int, indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let label:UILabel = cell.viewWithTag(53) as? UILabel {
            label.text = "\(hour)h"
        }
        
        return cell
    }
    
    
}

class SampleEvent{
    public var startDate:Date
    public var endDate:Date
    public var name:String
    init(name:String,startDate:Date,endDate:Date) {
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
    }
}
