//
//  JKArrayExtension.swift
//  JKPinTu-Swift
//
//  Created by bingjie-macbookpro on 15/12/15.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import Foundation

extension Array
{
    public mutating func exchangeObjectAtIndex(idx1: Int, withObjectAtIndex idx2: Int){
        let o1 = self[idx1]
        let o2 = self[idx2]
        self[idx1] = o2
        self[idx2] = o1
    }

}