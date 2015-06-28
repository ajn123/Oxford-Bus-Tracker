//
//  StringManipulation.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 6/28/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation

class  StringManipulation
{
    /**
    Sort the routes by number (U1 should come before U5)
    Then sort them by suffix (busses that end in X should come before the night busses (N)
    */
     class func sortBusses(strings: [String]) -> [String]
        {
            
            return strings.sorted()
            {
                    (a, b) -> Bool in
                    
                    var str =  a.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                    var abc = "".join(str)
                    var comp1 = abc.toInt()!
                    
                    var str2 =  b.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                    var abc2 = "".join(str2)
                    var comp2 = abc2.toInt()!
                    
                    if(comp1 < comp2)
                    {
                        return true
                    }
                    else if(comp1 > comp2)
                    {
                        return false
                    }
                    
                    if(!a.hasSuffix("X") && !a.hasPrefix("N"))
                    {
                        return true
                    }
                    
                    if(a.hasSuffix("X") && b.hasPrefix("N"))
                    {
                        return true
                    }
                    else
                    {
                        return false
                    }
            }

        }
}