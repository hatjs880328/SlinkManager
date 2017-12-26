//
//  SlinkManager.swift
//  Slink
//  线程任务必然是个同步的方法，或许是异步，但是无法获取结果。
//  Created by MrShan on 2016/12/27.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import Foundation

/**
 任务优先级枚举
 
 - HighLevel:     高
 - NormalLevel:   普通
 - LowLevel:      低
 - VeryHighLevel: 很高
 */
enum PriorityLevel {
    case HighLevel,NormalLevel,LowLevel,VeryHighLevel
}

///  队列管理类，整个队列都是在后台执行的
///  队列的功能：属性确认目前队列中任务个数
///  队列中一个任务的执行并且清除之
///  队列中添加一个任务
///  中断队列中所有任务.
///  中断队列中某一个任务
///  清除队列中某一个任务
///  优先级设置

class SlinkManager {
    
    //是否在执行任务当中
    var ifprogressNow = false
    
    //在内部需要锁机制
    let DG_LOCK = NSRecursiveLock()
    
    //收先需要在那一个线程中解锁，设置一个全局变量，让执行方法的线程先一直return或者等待，然后操作这个线程（主线程）中的方法，操作完毕之后在将属性设置回去
    //是否需要等待锁机制完成执行的属性
    var CAN_GO_RUN = false
    
    /// 当前队列中的全局属性，保存任务
    var TASK_ARRAY: Array<TaskModel> = []
    
    /**
    构造完毕之后立马执行当前方法<不应该使用单例>
    
    - parameter linkname: 队列名字
    
    - returns: self
    */
    init(linkname:String) {
        
    }
    
    /**
     创建完毕之后需要调用这个方法,一直在执行这个方法，没有完结的时候幺
     */
    func exeAllfunction() {
        GCDUtils.asyncProgress(dispatchLevel: 1, asyncDispathchFunc: { 
            while true {
                self.DG_LOCK.lock()
                if self.TASK_ARRAY.count != 0 {
                    //这里有执行失败的方法，但并没有做处理，这个失败可以在任务model里面做。
                    print("\(self.TASK_ARRAY[0].taskname!)开始执行了。")
                    self.TASK_ARRAY[0].exeFunc()
                    self.removeOnetask(Index: 0)
                    //解锁
                    self.DG_LOCK.unlock()
                    continue
                }else{
                    //解锁
                    self.DG_LOCK.unlock()
                    //设置属性为false
                    self.ifprogressNow = false
                    //没有任务的时候，那么就停止当前方法
                    return
                }
                
            }
        }) { 
            
        }
    }
    
    /**
     添加一个任务，添加之后按照任务等级进行排序
     
     - parameter task: 某个任务
     - parameter taskname: 某个任务名字
     */
    func addTask(task:TaskModel) {
        self.DG_LOCK.lock()
        self.TASK_ARRAY.append(task)
        self.TASK_ARRAY = MergeSort.sort(array: self.TASK_ARRAY)
        print("\(task.taskname!)添加完毕，并排序结束")
        self.DG_LOCK.unlock()
        //添加任务的时候，如果没有开始队列。那么就开始。
        if !ifprogressNow {
            ifprogressNow = true
            exeAllfunction()
        }
    }
    
    /**
     将一个任务移除出队列
     
     - parameter Index: 任务索引
     */
    func removeOnetask(Index:Int){
        if Index == 0 {
            self.TASK_ARRAY.removeFirst()
        }
    }
    
    /**
     设置任务的优先级，即使前面已经有其他的任务,按照任务名称
     默认是调用这个方法，将任务设置为最高等级
     
     - parameter level   : 优先级等级
     - parameter taskName: 任务名称
     */
    func setPriorityLevel(level:Int,taskName:String = "") {
        //收先需要在那一个线程中解锁，设置一个全局变量，让执行方法的线程先一直return或者等待，然后操作这个线程（主线程）中的方法，操作完毕之后在将属性设置回去
        self.DG_LOCK.lock()
        
        for (item,_) in self.TASK_ARRAY.enumerated() {
            if TASK_ARRAY[item].taskname == taskName {
                let task = TASK_ARRAY[item]
                self.TASK_ARRAY.insert(task, at: 0)
                self.TASK_ARRAY.remove(at: item + 1)
                break
            }
        }
        self.DG_LOCK.unlock()
    }
}
