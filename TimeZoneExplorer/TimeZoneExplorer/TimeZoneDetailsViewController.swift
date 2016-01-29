//
//  TimeZoneDetailsViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit

class TimeZoneDetailsViewController: UIViewController {

    var zoneID: String!
    
    private var timer: NSTimer! // the ticking clock
    
    @IBOutlet weak var areaName: UILabel!
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var stdTimeAbbrev: UILabel!
    @IBOutlet weak var stdTimeOffset: UILabel!
    @IBOutlet weak var dstTimeAbbrev: UILabel!
    @IBOutlet weak var dstTimeOffset: UILabel!
    @IBOutlet weak var currentDateField: UILabel!
    @IBOutlet weak var currentTimeClock: UILabel!
    @IBOutlet weak var currentClockAMPM: UILabel!
    @IBOutlet weak var currentClockZone: UILabel!
    
    @IBOutlet weak var regionStack: UIStackView!
    @IBOutlet weak var dstStack: UIStackView!
    
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var regionNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stdTimeAbbrevLabel: UILabel!
    @IBOutlet weak var stdTimeOffsetLabel: UILabel!
    @IBOutlet weak var dstTimeAbbrevLabel: UILabel!
    @IBOutlet weak var dstTimeOffsetLabel: UILabel!
    @IBOutlet weak var currentDateFieldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fillOutFields()
        
        // set up the 1-second timer initially
        // NOTE: moved to viewWillAppear()
        
        // text color adjustments
        self.view.backgroundColor = SystemLook.darkColor
        
        let labelColor = SystemLook.mediumColor
        areaNameLabel.textColor = labelColor
        regionNameLabel.textColor = labelColor
        cityNameLabel.textColor = labelColor
        stdTimeAbbrevLabel.textColor = labelColor
        stdTimeOffsetLabel.textColor = labelColor
        dstTimeAbbrevLabel.textColor = labelColor
        dstTimeOffsetLabel.textColor = labelColor
        currentDateFieldLabel.textColor = labelColor
        
        let fieldColor = SystemLook.lightColor
        areaName.textColor = fieldColor
        regionName.textColor = fieldColor
        cityName.textColor = fieldColor
        stdTimeAbbrev.textColor = fieldColor
        stdTimeOffset.textColor = fieldColor
        dstTimeAbbrev.textColor = fieldColor
        dstTimeOffset.textColor = fieldColor
        currentDateField.textColor = fieldColor
        currentTimeClock.textColor = fieldColor
        currentClockAMPM.textColor = fieldColor
        currentClockZone.textColor = fieldColor
    }
    
    private func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateClock"), userInfo: nil, repeats: true)
        print("Started 1 second timer for clock update")
    }
    
    private func stopTimer() {
        timer.invalidate()
        print("Stopped timer")
    }

    func updateClock() {
        // redisplay just the clock field, including date, time, ampm, and zone abbrev (might change)
        fillOutClockFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillOutFields() {
        // format and show the names parsed from the time zone ID
        let (area, region, city) = TZTimeZone.getDetailedName(zoneID)
        areaName.text = area
        regionName.text = region
        cityName.text = city
        // hide the middle line if not present (stack views will recalculate)
        regionStack.hidden = (region == "")
        
        // format and show the standard time offset and abbreviation
        let (abbrevS, offsetS) = TZTimeZone.getTimeInfo(zoneID, type: .Standard)!
        let offsetStdStr = TZTimeZone.getStandardFormatOffset(offsetS)
        stdTimeAbbrev.text = abbrevS
        stdTimeOffset.text = offsetStdStr
        
        // format and show the daylight savings time offset and abbreviation
        let (abbrevD, offsetD) = TZTimeZone.getTimeInfo(zoneID, type: .Daylight)!
        let offsetDstStr = TZTimeZone.getStandardFormatOffset(offsetD)
        dstTimeAbbrev.text = abbrevD
        dstTimeOffset.text = offsetDstStr
        
        // optionally hide the DST stack if it isn't different from STD time
        dstStack.hidden = (offsetS == offsetD)
        
        // update the clock initially here too
        fillOutClockFields()
    }
    
    private func fillOutClockFields() {
       
        // format and show the current time
        let now = NSDate()
        let (currentDate, clock, ampm, abbrev) = TZTimeZone.getClock(now, formattedForZone: zoneID)
        currentDateField.text = currentDate
        currentTimeClock.text = clock
        currentClockAMPM.text = ampm
        currentClockZone.text  = abbrev
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
