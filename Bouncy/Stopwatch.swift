//
//  Stopwatch.swift
//  Bouncy
//
//  Created by Badr AlKhamissi on 3/17/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import Foundation

class Stopwatch {
    
    // Timer
    var timer = NSTimer()
    var timeInterval:NSTimeInterval = 0.5
    var timerStart:NSTimeInterval = 0
    var timeCount:NSTimeInterval = 0.0
    var isTimer:Bool = false
    
    init(){}
    
    init(interval:NSTimeInterval, start:NSTimeInterval){
        timeInterval = interval
        timerStart = start
    }
    
    init(interval:NSTimeInterval, end:NSTimeInterval, flag:Bool){
        timeInterval = interval
        timerStart = end
        isTimer = flag
    }
    
    
    func timeString(time:NSTimeInterval)->String{
        //let min = Int(time) / 60
        let sec = Int(time) % 60
        //let secondFraction = Int((time-Double(sec))*10.0)
        return String(format: "%1i",sec)
    }
    
    func getTimerString()->String{
        if !timer.valid{
            if !isTimer{
                timeCount+=timeInterval // increment timeCount by timeInterval to count up like stopwatch
            }else{
                timeCount-=timeInterval // increment timeCount by timeInterval to count up like stopwatch
            }
        }
        return timeString(timeCount)
    }
    
    func timerDidEnd(timer:NSTimer){
        timeCount-=timeInterval // increment timeCount by timeInterval to count up like stopwatch
        if timeCount <= 0{
            timer.invalidate()
        }
    }
    
    func startTimer(){
        resetTimer()
    }
    
    func pauseTimer(){
        timer.invalidate()
    }
    
    func resumeTimer(){
        startTimer()
    }
    
    func resetTimer(){
        timer.invalidate()
        timeCount = timerStart
    }
}