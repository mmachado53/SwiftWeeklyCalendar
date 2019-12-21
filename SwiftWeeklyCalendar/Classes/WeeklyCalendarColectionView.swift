//
//  WeeklyCalendarColectionView.swift
//  TestWeeklyCalendar
//
//  Created by Miguel Machado on 10/22/19.
//  Copyright © 2019 Miguel Machado. All rights reserved.
//

import UIKit
public class WeeklyCalendarColectionView: UICollectionView {
    
    fileprivate var dateFormaterForKey:DateFormatter = {
        var df:DateFormatter = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("dd-MMM-YYYY")
        return df
    }()
    
    // MARK: - Inspectables -
    
    /// day column Height its customHeightPerHour * 24
    @IBInspectable var customHeightPerHour:CGFloat = -1 {
        didSet{
            self.rebuildSizes()
        }
    }
    
    fileprivate var hoursCollectionViewLayout:VerticalCollectionViewLayout?
    /// top padding for columns
    @IBInspectable var paddingTop:CGFloat = 0 {
        didSet{
            // when padding top change update inset in hours collection view
            self.rebuildSizes()
        }
    }
    
    // MARK: - Outlets -
    
    /// Use instead of UICollectionViewDelegate and UICollectionViewDataSource
    @IBOutlet var calendarDelegate:WeeklyCalendarColectionViewDelegate?
    
    /// Header collectionView
    @IBOutlet var headerCollectionView:WeeklyHeaderCalendarColectionView?{
        // MARK: configure headerCollectionView
        didSet{
            if let headerCollectionView:WeeklyHeaderCalendarColectionView = self.headerCollectionView {
                headerCollectionView.delegate = self
                headerCollectionView.dataSource = self
                headerCollectionView.isPagingEnabled = false
                headerCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
                headerCollectionView.collectionViewLayout = BaseWeeklyCalendarCollectionViewLayout()
                headerCollectionView.showsHorizontalScrollIndicator = false
                headerCollectionView.showsVerticalScrollIndicator = false
            }
        }
    }
    
    // MARK: - configure hoursCollectionView
    @IBOutlet var hoursCollectionView:WeeklyHoursCalendarColectionView?{
        didSet{
            if let hoursCollectionView:WeeklyHoursCalendarColectionView = self.hoursCollectionView {
                hoursCollectionView.delegate = self
                hoursCollectionView.dataSource = self
                hoursCollectionView.isPagingEnabled = false
                hoursCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
                self.hoursCollectionViewLayout = VerticalCollectionViewLayout()
                self.hoursCollectionViewLayout!.sectionInset.top = self.paddingTop
                hoursCollectionView.collectionViewLayout = self.hoursCollectionViewLayout!
                hoursCollectionView.showsHorizontalScrollIndicator = false
                hoursCollectionView.showsVerticalScrollIndicator = false
            }
        }
    }
    
    
    
    
    
    
    // MARK: - Check when weeklyCollectionView bounds change-
    fileprivate var lastFrame:CGRect = .zero
    override public var bounds: CGRect{
        didSet{
            if(lastFrame.width != self.frame.width || lastFrame.height != frame.height){
                rebuildSizes()
                DispatchQueue.main.async {
                    self.scrollToItem(at: self.currentIndexPath, at: .left, animated: false)
                }
            }
            
        }
    }
    
    // MARK: - Rebuild all row-columns Sizes
    fileprivate var defaultDayCellSize:CGSize = .zero
    fileprivate var dayCellSizeWithPadding:CGSize = .zero
    public var dayCellSize:CGSize = .zero
    fileprivate var hourCellHeight:CGFloat = 0
    fileprivate var headerCellWidth:CGFloat = 0
    private func rebuildSizes(){
        lastFrame = self.frame
        self.hoursCollectionViewLayout?.sectionInset.top = self.paddingTop
        defaultDayCellSize.width = self.frame.width / 7
        defaultDayCellSize.height = self.frame.height
        self.hourCellHeight = self.customHeightPerHour != -1 && self.customHeightPerHour * 24 > self.frame.height ? self.customHeightPerHour : (self.frame.height / 24)
        self.headerCellWidth = defaultDayCellSize.width
        self.dayCellSize.width = defaultDayCellSize.width
        self.dayCellSize.height = self.hourCellHeight * 24
        self.dayCellSizeWithPadding.width = self.dayCellSize.width
        self.dayCellSizeWithPadding.height = self.dayCellSize.height + self.paddingTop
        self.collectionViewLayout.invalidateLayout()
        self.headerCollectionView?.collectionViewLayout.invalidateLayout()
        self.hoursCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    // default initial date is now
    private var initialDate:Date = Date()
    fileprivate var totalSections:Int = 1000
    fileprivate var initialSection:Int = 500
    fileprivate var currentSection:Int = 500
    
    
    fileprivate var cellDatesCache:[String:[Date]] = [:]
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setDate(date: Date())
        self.initialConfiguration()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setDate(date: Date())
        self.initialConfiguration()
    }
    private func initialConfiguration(){
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = false
        self.collectionViewLayout = WeeklyCalendarCollectionViewLayout()
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.headerCollectionView?.contentOffset.x = self.contentOffset.x
        self.headerCollectionView?.contentOffset.y = 0
        self.hoursCollectionView?.contentOffset.x = 0
        self.hoursCollectionView?.contentOffset.y = self.contentOffset.y
        //self.headerCollectionView?.contentOffset = self.contentOffset
    }
    
    /// Navigate to specific Date
    ///
    /// - Parameter date: date to navigate
    ///   standard output.
    func setDate(date:Date){
        self.totalSections = 1000
        self.currentSection = 500
        self.lastXcontentOffset = 0
        let dayOfWeek:Int = Calendar.current.component(.weekday, from: date)
        self.initialDate = Calendar.current.date(byAdding: .day, value: (dayOfWeek - 1) * -1, to: date)!
        self.reloadData()
        self.headerCollectionView?.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var visibleDates:[Date] = []
            visibleDates.append(date)
            for i in 1...6 {
                visibleDates.append(Calendar.current.date(byAdding: .day, value: i, to: date)!)
            }
            self.calendarDelegate?.weeklyCalendarColectionView(collectionView: self, changeWeek: visibleDates)
            self.currentIndexPath = IndexPath(row: dayOfWeek-1, section: self.currentSection )
            self.scrollToItem(at: self.currentIndexPath, at: .left, animated: false)
        }
    }
    
    private var lastXcontentOffset:CGFloat = 0
    private var currentIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.lastXcontentOffset != self.contentOffset.x {
            //PAGE CHANGED
            self.lastXcontentOffset = self.contentOffset.x
            let rowWidth:CGFloat = self.frame.width / 7
            var row:Int = Int(self.contentOffset.x / rowWidth)
            let page:Int = row / 7
            row = row - (page * 7)
            
            let firstVisibleIndexPath:IndexPath = IndexPath(row: row, section: page)
            let firstVisibleDate:Date = self.getDateFromIndexPath(firstVisibleIndexPath)
            var visibleDates:[Date] = []
            visibleDates.append(firstVisibleDate)
            for i in 1...6 {
                visibleDates.append(Calendar.current.date(byAdding: .day, value: i, to: firstVisibleDate)!)
            }
            self.calendarDelegate?.weeklyCalendarColectionView(collectionView: self, changeWeek: visibleDates)
            self.currentIndexPath = firstVisibleIndexPath
        }
    }
    
    public override func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        if self.dataSource?.numberOfSections?(in: self) == nil {return}        
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func getDateFromIndexPath(_ indexPath:IndexPath) -> Date {
        
        let sectionDiference:Int = indexPath.section - self.initialSection
        let calendar = Calendar.current
        let sectionInitialWeekDay:Date = calendar.date(byAdding: .day, value: sectionDiference * 7, to: self.initialDate)!
        
        let cacheKey:String = dateFormaterForKey.string(from: sectionInitialWeekDay)
        
        if let currentWeekStates:[Date] = self.cellDatesCache[cacheKey] {
            return currentWeekStates[indexPath.row]
        }
        
        var currentWeekDates:[Date] = WeeklyCalendarColectionView.getWeek(of: sectionInitialWeekDay)
        self.cellDatesCache[cacheKey] = currentWeekDates
        return currentWeekDates[indexPath.row]
    }
    
    static func getWeek(of date:Date)->[Date]{
        let calendar = Calendar.current
        let weekDay:Int = calendar.component(.weekday, from: date)
        let firstDayOfWeek:Date
        if weekDay == 1 {
            firstDayOfWeek = date
        }else{
            firstDayOfWeek = calendar.date(byAdding: .day, value: (weekDay - 1) * -1, to: date)!
        }
        var result:[Date] = []
        result.append(firstDayOfWeek)
        for i in 1...6 {
            let newDate:Date = calendar.date(byAdding: .day, value: i, to: firstDayOfWeek)!
            result.append(newDate)
        }
        return result
    }
    
    public class Utils{
        public static let minutesInADay:Int = 24 * 60
        
        public static func minutesBetween(startDate:Date, endDate:Date)->Int{
            return Int(endDate.timeIntervalSince(startDate) / 60)
        }
        public static func eventViewFrame(inParentWith size:CGSize,startDate:Date, duration:Int)->CGRect{
            let minuteInDay:Int = (Calendar.current.component(.hour, from: startDate) * 60) + Calendar.current.component(.minute, from: startDate)
            let yPositionPercent:CGFloat = CGFloat(minuteInDay) / CGFloat(minutesInADay)
            let yPosition:CGFloat = size.height * yPositionPercent
            let heightPercent:CGFloat = CGFloat(duration) / CGFloat(minutesInADay)
            let height:CGFloat = size.height * heightPercent
            return CGRect(x: 0, y: yPosition, width: size.width, height: height)
        }
        
        public static func eventViewFrame(inParentWith size:CGSize,startDate:Date, endDate:Date)->CGRect{
            return eventViewFrame(inParentWith: size, startDate: startDate, duration: minutesBetween(startDate: startDate, endDate: endDate))
        }
    }
    
}

// MARK: - Delegates - manage standard collectionview delegates for weekly, hours and header collectionviews
extension WeeklyCalendarColectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if it shoursCollectionView return 24 (24 hours in a day)
        if collectionView == self.hoursCollectionView {
            return 24
        }
        //if it header or weekly return 7 (7 days in a week)
        return 7
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.hoursCollectionView {
            return 1
        }
        return self.totalSections
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self {
            let date = self.getDateFromIndexPath(indexPath)
            if let cell =
                self.calendarDelegate?.weeklyCalendarColectionView(self, cellFor: date, indexPath: indexPath) {
                return cell
            }
        }else if let headerCollectionView:WeeklyHeaderCalendarColectionView = collectionView as? WeeklyHeaderCalendarColectionView{
            let date = self.getDateFromIndexPath(indexPath)
            if let cell = headerCollectionView.calendarHeaderDelegate?.weeklyHeaderCalendarColectionView(headerCollectionView, cellFor: date, indexPath: indexPath) {
                return cell
            }
        }else if let hoursCollectionView:WeeklyHoursCalendarColectionView = collectionView as? WeeklyHoursCalendarColectionView{
            if let cell = hoursCollectionView.calendarHoursDelegate?.weeklyCalendarHoursColectionViewDelegate(hoursCollectionView, cellFor: indexPath.row, indexPath: indexPath) {
                cell.clipsToBounds = false
                return cell
            }
        }
        // return defualt cell
        let def = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        def.backgroundColor = UIColor.red
        return def
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.headerCollectionView {
            return CGSize(width: self.headerCellWidth, height: collectionView.frame.height)
        }else if collectionView == self.hoursCollectionView {
            return CGSize(width: collectionView.frame.width, height: self.hourCellHeight)
        }
        
        return self.defaultDayCellSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self { return }
        self.calendarDelegate?.weeklyCalendarColectionView(collectionView: self, didSelectItemAt: self.getDateFromIndexPath(indexPath))
    }
    
    
}











// MARK: - Customs UICollectionViewFlowLayou

fileprivate class VerticalCollectionViewLayout : BaseWeeklyCalendarCollectionViewLayout{
    override func initialConfig() {
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
}


fileprivate class  WeeklyCalendarCollectionViewLayout : BaseWeeklyCalendarCollectionViewLayout {
    
    var weeklyCalendar:WeeklyCalendarColectionView? {
        get{
            if let w:WeeklyCalendarColectionView = self.collectionView as? WeeklyCalendarColectionView {
                return w
            }
            return nil
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var result = CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y)
        if let currentContentOffset:CGPoint = self.collectionView?.contentOffset {
            if velocity.x > -1 && velocity.x < 1 {
                let cellWidth:CGFloat = (self.collectionView?.frame.width ?? 0) / 7
                let cell:Int = Int(proposedContentOffset.x / cellWidth)
                let backOffsetX:CGFloat = CGFloat(cell) * cellWidth
                let nextOffsetX:CGFloat = CGFloat(cell + 1) * cellWidth
                let middelPoint:CGFloat = backOffsetX + (cellWidth/2)
                if velocity.x == 0{
                    result.x = currentContentOffset.x < middelPoint ? backOffsetX : nextOffsetX
                }else{
                    result.x = velocity.x < 0 ? backOffsetX : nextOffsetX
                }
                
            }else {
                let pageWidth:CGFloat = self.collectionView?.frame.width ?? 0
                let currentPage:Int = Int(currentContentOffset.x / pageWidth)
                let previousPageScroll:CGFloat = CGFloat(currentPage) * pageWidth
                let nextPageScroll:CGFloat = CGFloat(currentPage + 1) * pageWidth
                result.x = velocity.x < 0 ? previousPageScroll : nextPageScroll
            }
        }
        return result
    }
    
    //fileprivate var dayCellSize:CGSize = .zero
    //fileprivate var dayCellSizeWithPadding:CGSize = .zero
    fileprivate var contentSize:CGSize = .zero
    //fileprivate var paddingTop:CGFloat = 0
    
    override func prepare() {
        self.rebuildContenSize()
    }
    
    func rebuildContenSize(){
        guard let cv:WeeklyCalendarColectionView = self.weeklyCalendar else { return }
        let w:CGFloat = CGFloat(cv.totalSections) * cv.frame.width
        if w != self.contentSize.width {
            // self.paddingTop = cv.paddingTop
            contentSize.width = w
            //let height:CGFloat = cv.customHeightPerHour != -1 ? (cv.customHeightPerHour * 24) : cv.frame.height
            //contentSize.height = cv.frame.height > height ? cv.frame.height : height
            //contentSize.height += cv.paddingTop
            contentSize.height = cv.dayCellSizeWithPadding.height
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let fixedRect:CGRect = CGRect(x: rect.minX, y: 0, width: rect.width, height: rect.height)
        let paddingTop:CGFloat = self.weeklyCalendar?.paddingTop ?? 0
        if let array = super.layoutAttributesForElements(in: fixedRect) {
            for i in array{
                i.frame = CGRect(x: i.frame.minX, y: i.frame.minY + paddingTop, width: i.frame.width, height: self.contentSize.height - paddingTop)
            }
            return array
        }
        return super.layoutAttributesForElements(in: rect)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let result:UICollectionViewLayoutAttributes = super.layoutAttributesForItem(at: indexPath){
            let paddingTop:CGFloat = self.weeklyCalendar?.paddingTop ?? 0
            result.frame = CGRect(x: result.frame.minX, y: result.frame.minY + paddingTop, width: result.frame.width, height: self.contentSize.height - paddingTop)
            return result
        }
        return nil
    }
    
    override var collectionViewContentSize: CGSize  {
        return self.contentSize
    }
    
    
}


