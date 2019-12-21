//
//  BaseWeeklyCalendarCollectionViewLayout.swift
//  SwiftWeeklyCalendar
//
//  Created by Miguel Machado on 12/21/19.
//

import UIKit

class BaseWeeklyCalendarCollectionViewLayout : UICollectionViewFlowLayout{
    override init() {
        super.init()
        self.initialConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialConfig()
    }
    
    func initialConfig(){
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
