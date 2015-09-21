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
            return strings.sort()
            {
                (a, b) -> Bool in
                let str =  a.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let abc = str.joinWithSeparator("")
                let comp1 = Int(abc)!
                
                let str2 =  b.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let abc2 = str2.joinWithSeparator("")
                let comp2 = Int(abc2)!
                
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