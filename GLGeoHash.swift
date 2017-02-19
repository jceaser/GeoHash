//
//  GLGeoHash.swift
//  MapPadProto
//
//  Created by Thomas Cherry on 2017-16-02.
//  Copyright © 2017 Thomas Cherry. All rights reserved.
//

import Foundation

public class GeoHash
{
    public init(raw:String)
    {
    }
    
    /**********************************************************************/
    /* Object */
    
    //ezs42 ≈ 42.6° -5.6°
    
    public func parseHash(raw:String) -> String
    {
        return ""
    }
    
    /* 39.2780150, -76.7618450 should be dqcrmnrep2ev */
    public func parse(lat:Double, long:Double) -> String
    {//even are longitude(o), odd are latatude(a) so: oaoa oaoa oaoa...
        let lon = parseLong(lon:long)
        let lat = parseLat(lat: lat)
        
        var together = ""
        var hash = ""
        for (o, a) in zip(Array(lon.characters), Array(lat.characters))
        {
            //together = together + o + Array(lat.characters)
             together = together + String(o) + String(a)
        }
        
        var c = 0;
        var block = ""
        for i in together.characters
        {
            c += 1
            block += String(i)
            if 5<=c
            {
                let num = block.withCString { strtoul($0, nil, 2) }
                let dec = String(num, radix: 10, uppercase: true) // (or false)
                let hex = encode(code: dec)
                
                //print ("five chunk \(block) is \(hex) and \(dec) in dec")
                
                hash += hex
                
                block = ""
                c = 0
            }
        }
        
        //let num = together.withCString { strtoul($0, nil, 2) }
        //let hex = String(num, radix: 32, uppercase: true) // (or false)
        
        return hash
    }
    
    func encode(code:String) -> String
    {
        var ret = ""
        switch code
        {
            case "10": ret = "b"
            case "11": ret = "c"
            case "12": ret = "d"
            case "13": ret = "e"
            case "14": ret = "f"
            case "15": ret = "g"
            case "16": ret = "h"
            case "17": ret = "j"
            case "18": ret = "k"
            case "19": ret = "m"
            case "20": ret = "n"
            case "21": ret = "p"
            case "22": ret = "q"
            case "23": ret = "r"
            case "24": ret = "s"
            case "25": ret = "t"
            case "26": ret = "u"
            case "27": ret = "v"
            case "28": ret = "w"
            case "29": ret = "x"
            case "30": ret = "y"
            case "31": ret = "z"
            default: ret = code
        }
        return ret
    }
    
    func parseLat(lat:Double) -> String
    {
        return parseRange(raw: lat, min_val: -90.0, max_val: 90.0);
    }
    func parseLong(lon:Double) -> String
    {
        return parseRange(raw: lon, min_val: -180.0, max_val: 180.0);
    }
    
    /**
        //length of 05 is 1 dec place, 14 loops
        //length of 06 is 1 dec place, 15,16,17 loops
        //length of 07 is 2 dec place, 18 loops
        //length of 08 is 3 dec places, 20, 22 loops
        //length of 09 is 4 dec place, 24 loops
        //length of 10 is 4 dec place, 26 loops
        //length of 11 is 5 dec place, 28 loops
        //length of 12 is 6 dec places, 30, 32 loops
    */
    public func guessPrecision(raw:Double) -> Int
    {
        let str = String(raw)
        let range: Range<String.Index> = str.range(of: ".")!
        let size: Int = str.distance(from: range.upperBound, to: str.endIndex)
        
        var per = 32
        switch size
        {
            case 1: per=14
            case 2: per=18
            case 3: per=20
            case 4: per=24
            case 5: per=28
            case 6: per=32
            default: per=32
        }
        
        return per
    }
    
    func parseRange(raw:Double, min_val:Double, max_val:Double) -> String
    {
        var min = min_val
        var mid = 0.0
        var max = max_val
        //var high = true
        var result = ""
        var i = 0
        
        while i<guessPrecision(raw: raw)
        {
            if raw==mid {break;}
            
            // is min < value < mid or min < value < max
            if mid<raw
            {//high range, move range up and mark as a one
                // min:-90 mid:0 val:75 max:90
                // min:0 mid:45 val:75 max:90
                //min:mid value:same mid:max/2 max:same
                
                result = result + "1"
                
                //print ("H \(min) < \(mid) < \(max) == \(raw)")
                
                let middle = (max+mid)/2.0
                min = mid
                mid = middle
                //max = max
                //print ("    H \(min) < \(mid) < \(max) == \(raw)")
            }
            else if raw<mid
            {//low range, move range down and mark as a zero
                // min:-90 val:-75 mid:0 max:90
                // min:-90 val:-75 mid:-45 max:-0
                //min:same value:same mid:min/2 max:oldmin
                
                result = result + "0"
                
                //print ("L \(min) < \(mid) < \(max) == \(raw)")
                
                let middle = (min+mid)/2.0
                max = mid
                mid = middle
                //min = min
                //print ("    L \(min) < \(mid) < \(max) == \(raw)")
            }
            i = i + 1
        }
        
        return result
    }

}
