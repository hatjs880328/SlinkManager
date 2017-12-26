//
//  MergeSort.swift
//  mergeSort
//
//  Created by MrShan on 2017/3/7.
//  Copyright © 2017年 JNDZ. All rights reserved.
//

import Foundation


class MergeSort<T:Comparable> {
    
    /// 归并排序做法 第一步，插入排序
    /// 将两个已经排好序的数组  ，进行比较排序，使用分而治之的思想，递归搞定这个问题
    /// - Parameters:
    ///   - arrayLeft: 左边数组
    ///   - arrayRight: 右边数组
    /// - Returns: 结构集
    private class func sort(arrayLeft:[T],arrayRight:[T])->[T] {
        var leftindex = 0
        var rightindex = 0
        var resultarray = [T]()
        while leftindex <= arrayLeft.count - 1 ||  rightindex <= arrayRight.count - 1{
            if arrayLeft[leftindex] <= arrayRight[rightindex] {
                resultarray.append(arrayLeft[leftindex])
                if leftindex != arrayLeft.count - 1 {
                    leftindex += 1
                }else{
                    //添加右边没有添加完毕的数据
                    for eachItem in rightindex ... arrayRight.count - 1 {
                        resultarray.append(arrayRight[eachItem])
                    }
                    break
                }
            }else{
                resultarray.append(arrayRight[rightindex])
                if rightindex != arrayRight.count - 1 {
                    rightindex += 1
                }else{
                    //加上左边没有添加完毕的数据
                    for eachItem in leftindex ... arrayLeft.count - 1 {
                        resultarray.append(arrayLeft[eachItem])
                    }
                    break
                }
            }
        }
        return resultarray
    }
    
    
    /// 将一个数组分割为单个数字为一个数组的数组集合
    ///
    /// - Parameter array: 原始数组
    /// - Returns: 结果集
    private class func sepAllnumberToarray(array:[T])->[[T]] {
        var resultarray = [[T]]()
        for eachItem in 0 ... array.count - 1 {
            resultarray.append([array[eachItem]])
        }
        return resultarray
    }
    
    
    /// 递归调用插入排序，将所有问题搞定并返回
    ///
    /// - Parameter arrays: 数组S
    /// - Returns: 结果
    private class func combineArray(arrays:[[T]])->[T] {
        if arrays.count == 1 {
            return arrays[0]
        }
        if arrays.count == 2 {
            return self.sort(arrayLeft: arrays[0], arrayRight: arrays[1])
        }
        let groupCount = arrays.count / 2
        let groupSplit = arrays.count % 2
        var resultArray = [[T]]()
        
        for eachItem in 0 ... groupCount - 1 {
            resultArray.append(self.sort(arrayLeft: arrays[eachItem * 2], arrayRight: arrays[eachItem * 2 + 1]))
        }
        if groupSplit != 0 {
            resultArray.append(arrays.last!)
        }
        return combineArray(arrays: resultArray)
    }
    
    
    /// 归并排序的使用
    ///
    /// - Parameter array: 原数组
    /// - Returns: 结果集
    class func sort(array:[T])->[T] {
        let info = sepAllnumberToarray(array: array)
        return combineArray(arrays: info)
    }
}
