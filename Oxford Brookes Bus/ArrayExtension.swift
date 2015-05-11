//
//  ArrayExtension.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/11/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation


extension Array{
 
    
    func removeDuplicates<T: Comparable>() -> [T]
    {
        var array = [T]()
        for elem in self
        {
            if !contains(array, elem as! T)
            {
                array.append(elem as! T)
            }
        }
        return array
        
    }
}