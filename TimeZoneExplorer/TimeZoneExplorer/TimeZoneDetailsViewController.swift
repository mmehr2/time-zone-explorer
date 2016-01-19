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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fillOutFields(zoneID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillOutFields(zoneID: String) {
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
        dstStack.hidden = (abbrevD == nil)
        
        // format and show the current time
        let now = NSDate()
        let (currentDate, clock, ampm, abbrev) = TZTimeZone.getClock(now, formattedForZone: zoneID)
        currentDateField.text = currentDate
        currentTimeClock.text = clock
        currentClockAMPM.text = ampm
        currentClockZone.text  = abbrev
        
        //self.view.needsUpdateConstraints()
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
