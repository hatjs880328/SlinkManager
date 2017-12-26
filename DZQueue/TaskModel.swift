//
//  TaskModel.swift
//  Slink
//
//  Created by MrShan on 2016/12/27.
//  Copyright © 2016年 Mrshan. All rights reserved.
//
import UIKit
import Foundation

/// 任务类，包含当前任务的内容，当前任务的中断方法，当前任务的执行方法
class TaskModel:Comparable {
    
    /// 任务详情
    var info:(()->Bool)?
    
    /// 任务名称,切记是唯一的，不可重复 nsuuid().stringuuid
    var taskname:String?
    
    /// 任务等级 默认为5，1-6，数值越小，执行级别越高
    var taskLevel:Int = 5
    
    /**
     初始化方法
     
     - parameter taskinfo:  任务详情
     - parameter taskname:  任务名称
     - parameter taskLevel: 任务等级，默认为5，1-6，数值越小，执行级别越高
     
     - returns: self
     */
    init(taskinfo: @escaping ()->Bool,taskname:String,taskLevel:Int = 5) {
        self.info = taskinfo
        self.taskname = taskname
        self.taskLevel = taskLevel
    }
    
    /**
     当前任务的执行
     */
    func exeFunc() {
        let successorFail = self.info!()
        //这里的失败是在真正的业务处理逻辑返回的，当判定是false的时候需要进行一定的处理，比如说重新执行
        if !successorFail {
            //这里失败应该当前线程休息1S 然后重试此方法<如数据库打开失败>
            print("失败了，在这里做处理奥。")
        }
        //return successorFail
    }
    
    static func == (fis:TaskModel,ses:TaskModel)->Bool {
        return fis.taskname == ses.taskname
    }
    
    public static func <(lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.taskLevel < rhs.taskLevel
    }
    
    public static func <=(lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.taskLevel <= rhs.taskLevel
    }
    
    public static func >=(lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.taskLevel >= rhs.taskLevel
    }
    
    public static func >(lhs: TaskModel, rhs: TaskModel) -> Bool{
        return lhs.taskLevel > rhs.taskLevel
    }
}
