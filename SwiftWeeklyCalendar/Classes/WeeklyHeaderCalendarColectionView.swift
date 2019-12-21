//
//  WeeklyHeaderCalendarColectionView.swift
//  SwiftWeeklyCalendar
//
//  Created by Miguel Machado on 12/20/19.
//

import UIKit
public class WeeklyHeaderCalendarColectionView: UICollectionView  {
    @IBOutlet var calendarHeaderDelegate:WeeklyCalendarHeaderColectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialConfiguration()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialConfiguration()
    }
    
    private func initialConfiguration(){
        self.isPagingEnabled = false
    }
}
