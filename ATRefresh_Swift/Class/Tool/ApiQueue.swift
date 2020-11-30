//
//  ApiQueue.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/11/25.
//  Copyright © 2020 wangws1990. All rights reserved.
//
import UIKit
import SQLite

public let dataBase : Connection = BaseQueue.manager.dataBase

public class BaseQueue : NSObject{
    static let manager = BaseQueue()
    lazy var dataBase: Connection = {
        let path = BaseQueue.path()
        var dataBase = try? Connection(path)
            dataBase?.busyTimeout = 5.0
        return dataBase!
    }()
    private class func path() -> String{
        let path = NSHomeDirectory() + "/Documents/Caches/Sqlite"
        let file = FileManager.default
        if file.fileExists(atPath: path) == false{
            do {
                try file.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("create path success")
            } catch  {
                print(error.localizedDescription)
            }
            
        }
        return path + "DataBase.sqlite"
    }
    //MARK:删除表
    public class func dropTable(_ name :String) -> Bool{
        let exeStr = "drop table if exists \(name) "
        do {
            try manager.dataBase.execute(exeStr)
            return true
        }catch(let error){
            debugPrint(error.localizedDescription)
            return  false
        }
    }
}


