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
        for element in self
        {
            if let elem = element as? T
            {
                if !array.contains(elem)
                {
                    array.append(elem)
                }
            }
        }
        return array
    }
    
    func withoutDuplicates<U : Hashable>(attribute : Element -> U) -> [Element] {
        var result : [Element] = []
        
        var seen : Set<U> = Set()
        for elem in self {
            let value = attribute(elem)
            if !seen.contains(value) {
                result.append(elem)
                seen.insert(value)
            }
        }
        return result
    }
}