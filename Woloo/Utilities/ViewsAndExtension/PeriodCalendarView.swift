//
//  PeriodCalendarView.swift
//  PeriodCalendar
//
//  Created by Amit Srivastava on 7/17/21.
//

import UIKit

public struct PeriodItem {
    var title: String
    var color: String
    var innerColor: String
    var icon: UIImage!
}

public struct PeriodType {
    static let Period = PeriodItem(title: "Edit Period", color: "#F1779B", innerColor: "#FFFFFF", icon:nil)
    static let Menstruation = PeriodItem(title: "Menstruation", color: "#f8646b", innerColor: "#FFFFFF", icon: UIImage(named: "menstrual_cup.png"))
    static let Ovulation = PeriodItem(title: "Ovulation", color: "#B0C8E8",innerColor: "#FFFFFF", icon: UIImage(named: "fertilization.png"))
    static let Pregnancy = PeriodItem(title: "Pregnancy", color: "#DFA7CC",innerColor: "#FFFFFF", icon: UIImage(named: "fetus.png"))
}

protocol PeriodCalendarViewDelegate {
    func onEdit()
}

@IBDesignable class PeriodCalendarView: UIView {
    
    var delegate:PeriodCalendarViewDelegate?
    
    var currentPeriod:PeriodItem = PeriodType.Ovulation
    var currentMonth:Int = 0
    var currentYear:Int = 0
    var currentDay:Int = 0
    var periodDay:Int = 10
    
    var todayIndicatorColor = ["#414042","#414042"]
    
    var menstruationDays: [Int] = [] //[ClosedRange<Int>] = [0...0]
    var ovulationDays: [Int] = [] // [ClosedRange<Int>] = [0...0]
    var pregnancyDays: [Int] = [] // [ClosedRange<Int>] = [0...0]
    
    
    let FONT_BOLD = "OpenSans-Bold"
    let FONT_LIGHT = "OpenSans-Light"
    let FONT_REGULAR = "OpenSans-Regular"
    let FONT_SEMI_BOLD = "OpenSans-SemiBold"
    
    let TITLE_COLOR = "#171A21"
    
    var buttonTouchRect:CGRect = CGRect.zero
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        setupView()
     }

    //initWithCode to init view from xib or storyboard
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setupView()
     }

    func setupView(){
        let today = Date()
        currentDay = today.get(.day)
        currentMonth = today.get(.month)
        currentYear = today.get(.year)
    }
    
    func flippedPoint(point: CGPoint, bounds: CGRect) -> CGPoint {
        return CGPoint(x: point.x, y: bounds.maxY - point.y);
    }

    func flippedRect(rect: CGRect, bounds:CGRect) -> CGRect {
        return CGRect(x: rect.minX,
                      y: bounds.maxY - rect.maxY,
                      width: rect.size.width,
                      height: rect.size.height);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touchesBegan, Tapped",event as Any);
        let touch = touches.first!
        let location = touch.location(in: self)
//        print("location",buttonTouchRect as Any, location as Any);
        if buttonTouchRect.contains(flippedPoint(point: location,bounds: self.bounds)) {
            if let delegate = self.delegate {
                delegate.onEdit()
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {

        //Background
        UIColor.white.setFill()
        UIRectFill(rect)
        
        //Calendar base
        drawCalendar(rect: rect)
        
        //Period cycle
        drawPeriodCycle(rect: rect, periodItem: currentPeriod)
    }
    
    func drawCalendar(rect:CGRect){
        let padding:CGFloat = rect.size.width * 0.03 //15
        
        let innerRect = CGRect(x: padding, y: padding, width: rect.width - (padding * 2), height: rect.height - (padding * 2))
        
//        UIColor.black.setStroke()
//        let outerPath = UIBezierPath(ovalIn: rect)
//        outerPath.stroke()
        
        UIColor.red.setStroke()
        
        let innerPath = UIBezierPath(ovalIn: innerRect)
        innerPath.stroke()
        
        //self.frame isn’t defined yet, so we can’t use self.center
        let viewCenter = CGPoint(x: rect.width / 2, y: rect.height / 2);
        
        let days = daysInMonth(currentMonth, currentYear)
        
        //Semi Circles
        let radius:CGFloat = innerRect.width / 2 //rect.width * 0.40
        var startAngle:CGFloat = -90
        let endAngle:CGFloat = (360 / CGFloat(days)) * 1
        
        for day in (1...days) {
            var periodColor = PeriodType.Period
            menstruationDays.forEach { (dayRange) in
                if dayRange == day {
                    periodColor = PeriodType.Menstruation
                }
            }
            
            pregnancyDays.forEach { (dayRange) in
                if  dayRange == day {
                    periodColor = PeriodType.Pregnancy
                }
            }
            
            ovulationDays.forEach { (dayRange) in
                if  dayRange == day {
                    periodColor = PeriodType.Ovulation
                }
            }
            
            
            UIColor(hexString: periodColor.color)?.setFill()
            
            
            let midPath = UIBezierPath()
            midPath.move(to: viewCenter)
            midPath.addArc(withCenter: viewCenter, radius: radius, startAngle: startAngle.degreesToRadians, endAngle: (endAngle + startAngle).degreesToRadians, clockwise: true)
            midPath.close()
            midPath.fill()
            midPath.lineWidth = 2
            UIColor.white.setStroke()
            midPath.stroke()
            
            startAngle = (endAngle + startAngle)
        }
        
        UIColor.white.setStroke()
        let outerPath = UIBezierPath(ovalIn: innerRect)
        outerPath.lineWidth = 2
        outerPath.stroke()
        
        drawDays(center: viewCenter, days: days, radius: radius)
    }
    
    func drawDays(center:CGPoint,days:Int,radius:CGFloat){
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let angle = degreeToRadian(degree: 360 / CGFloat(days))
        let cx = center.x // x origin
        let cy = center.y // y origin
        let r  = (radius - (bounds.size.width * 0.05 )) // radius of circle //18
        let adjustment = CGFloat(275) //-96
        var i = days
        var j = 0
        var points = [CGPoint]()
        
        while points.count <= days {
           let xpo = cx - r * cos(angle * CGFloat(j) + degreeToRadian(degree: adjustment))
           let ypo = cy - r * sin(angle * CGFloat(j) + degreeToRadian(degree: adjustment))
            
            let offset = (bounds.size.width * 0.02 ); //8
            
            let xpo1 = cx - (radius + offset) * cos(angle * CGFloat(j) + degreeToRadian(degree: adjustment))
            let ypo1 = cy - (radius + offset) * sin(angle * CGFloat(j) + degreeToRadian(degree: adjustment))
            
            points.append(CGPoint(x: xpo, y: ypo))
        
            if(i > 0){
                let font = UIFont(name: FONT_SEMI_BOLD, size: ceil(radius * 0.08))
                let attributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.black]
                let attributedString = NSAttributedString(string: i.description, attributes: attributes)
                let line = CTLineCreateWithAttributedString(attributedString)
                let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
                
//                context.setLineWidth(1.5)
//                context.setTextDrawingMode(.stroke)
                
                let xn = xpo - bounds.width / 2
                let yn = ypo - bounds.midY
                
                context.textPosition = CGPoint(x: xn, y: yn)
                CTLineDraw(line, context)
                
                if(currentDay == i){
                    drawToday(context: context, cx: xpo1, cy: ypo1)
                }
            }
           
        
           i -= 1
           j += 1
       }
    }
    
    func drawToday(context:CGContext, cx:CGFloat, cy:CGFloat){
        
        context.saveGState()
        
        let startColor = UIColor(hexString: todayIndicatorColor[0])
        guard let startColorComponents = startColor!.cgColor.components else { return }
                
        let endColor = UIColor(hexString: todayIndicatorColor[1])
        guard let endColorComponents = endColor!.cgColor.components else { return }
        
        let colorComponents: [CGFloat]
                    = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        
        let locations:[CGFloat] = [0.0, 1.0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations,count: 2) else { return }
        
        let circleSize = bounds.size.width * 0.01
        let todayRect = CGRect(x: cx - circleSize, y: cy - circleSize, width: circleSize * 2, height: circleSize * 2)
        let todayCircle = UIBezierPath(ovalIn: todayRect)
        todayCircle.fill()
        todayCircle.addClip()
        
        context.drawLinearGradient(gradient, start: CGPoint(x: todayRect.midX, y: todayRect.minY), end: CGPoint(x: todayRect.midX,y: todayRect.maxY), options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        context.restoreGState()
    }
    
    func drawPeriodCycle(rect:CGRect, periodItem: PeriodItem){
        //Center circle
        UIColor.white.setStroke()
        UIColor(hexString: periodItem.color)?.setFill()
        let outterCirclePath = UIBezierPath(ovalIn:rect.insetBy(dx: rect.width * 0.25 / 2, dy: rect.height * 0.25 / 2))
        outterCirclePath.lineWidth = 2
        outterCirclePath.fill()
        outterCirclePath.stroke()
        
        UIColor(hexString: periodItem.innerColor)?.setFill()
        let innerCircleRect = rect.insetBy(dx: rect.width * 0.40 / 2, dy: rect.height * 0.40 / 2);
        let innerCirclePath = UIBezierPath(ovalIn:innerCircleRect)
        innerCirclePath.fill()
        
        let context = UIGraphicsGetCurrentContext()!
        
//        context.saveGState()
        
        var bgRect:CGRect = rect.insetBy(dx: rect.width * 0.42 / 2, dy: rect.height * 0.50 / 2)
        bgRect.origin.y-=bgRect.height * 0.10
        context.draw((UIImage(named: "pt_background.png")?.cgImage)!, in: bgRect)

        if let icon = periodItem.icon {
            var offset:CGFloat = 1
            if UIDevice.current.userInterfaceIdiom == .pad {
                offset = 2;
            }
            
            let iconWidth = icon.size.width * offset
            let iconHeight = icon.size.height * offset
            
            var iconRect:CGRect = rect.insetBy(dx: (rect.width - iconWidth) * 0.5, dy: (rect.height - iconHeight) * 0.5)
            iconRect.size.width = iconWidth
            iconRect.size.height = iconHeight
            iconRect.origin.y+=innerCircleRect.size.height * 0.39
            context.draw((icon.cgImage)!, in: iconRect)
        }
        
        let titleFontSize = bounds.size.width * 0.035 //14
        // Period Title
        drawText(context: context, color: TITLE_COLOR, text: "\(periodItem.title) Cycle", rect: bgRect, font: FONT_LIGHT, size: titleFontSize, offset: CGPoint(x: 0.5, y: 0.9))
       
        let daysFontSize = bounds.size.width * 0.086 //34
        // Period Days
        drawText(context: context, color: periodItem.color, text: "Day \(periodDay)", rect: bgRect, font: FONT_BOLD, size: daysFontSize, offset: CGPoint(x: 0.5, y: 0.8))
        
        drawButton(context: context, cx: bounds.size.width * 0.5, cy: bounds.size.height * 0.43)
//        context.restoreGState()
    }
    
    func drawText(context:CGContext,color: String, text: String,rect:CGRect,font:String,size:CGFloat,offset:CGPoint) {
        let fsize = ceil(size)
        let font = UIFont(name: font, size: fsize)
        let attributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor(hexString: color)]
        let attributedString = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        let line = CTLineCreateWithAttributedString(attributedString)
        let textBounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)

        let xn = rect.origin.x + (rect.width - textBounds.width) * offset.x
        let yn = rect.origin.y + (rect.height - textBounds.height) * offset.y
        
        context.textPosition = CGPoint(x: xn, y: yn)
        
        CTLineDraw(line, context)
    }
    
    func drawButton(context:CGContext, cx:CGFloat, cy:CGFloat){
        context.saveGState()
        
        let startColor = UIColor(hexString: todayIndicatorColor[0])
        guard let startColorComponents = startColor!.cgColor.components else { return }
                
        let endColor = UIColor(hexString: todayIndicatorColor[1])
        guard let endColorComponents = endColor!.cgColor.components else { return }
        
        let colorComponents: [CGFloat]
                    = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        
        let locations:[CGFloat] = [0.0, 1.0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations,count: 2) else { return }
        
        let buttonSize = bounds.size.width * 0.05
        let buttonRect = CGRect(x: cx - buttonSize, y: cy - buttonSize, width: buttonSize * 2, height: buttonSize * 2)
       
        //TODO: update local rect for touch detection
        buttonTouchRect = CGRect(x: buttonRect.origin.x, y: buttonRect.origin.y,
                                 width: buttonRect.size.width-5,
                                 height: buttonRect.size.height-5)
        
        let buttonRadius = bounds.size.width * 0.018
        let buttonRectPath = UIBezierPath(roundedRect: buttonRect, cornerRadius: buttonRadius)
        buttonRectPath.fill()
        buttonRectPath.addClip()
        
        context.drawLinearGradient(gradient, start: CGPoint(x: buttonRect.midX, y: buttonRect.minY), end: CGPoint(x: buttonRect.midX,y: buttonRect.maxY), options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let bgRect:CGRect = buttonRect.insetBy(dx: buttonRect.width * 0.50 / 2, dy: buttonRect.height * 0.50 / 2)
        context.draw((UIImage(named: "pensil.png")?.cgImage)!, in: bgRect)
        
        context.restoreGState()
        
        //TODO: uncomment only for debug rect location
//        UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5).setFill()
//        let rectPath = UIBezierPath(rect: buttonTouchRect)
//        rectPath.fill()
    }
    
    // MARK: - Methods
    
    func setPeroidType(periodItem:PeriodItem){
        currentPeriod = periodItem
        self.setNeedsDisplay()
    }
    
    func setCalendar(day:Int,month:Int,year:Int){
        currentDay = day
        currentMonth = month
        currentYear = year
        self.setNeedsDisplay()
    }
    
    func setPeriodCycle(menstruation: [Int], ovulation: [Int], pregnancy: [Int]){
        menstruationDays = menstruation
        ovulationDays = ovulation
        pregnancyDays = pregnancy
        self.setNeedsDisplay()
    }
    
    func setPeriodDays(days:Int){
        periodDay = days
        self.setNeedsDisplay()
    }
}

extension PeriodCalendarView {
    func degreesToRadians(_ number: Double) -> Float {
        return Float((number * .pi / 180))
    }
    
    fileprivate func degreeToRadian(degree: CGFloat) -> CGFloat {
           let result = CGFloat(Double.pi) * degree / 180
           return result
       }
    
    func daysInMonth(_ monthNumber: Int? = nil, _ year: Int? = nil) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year ?? Calendar.current.component(.year, from: Date())
        dateComponents.month = monthNumber ?? Calendar.current.component(.month,  from: Date())
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
