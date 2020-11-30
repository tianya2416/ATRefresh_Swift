//
//  ApiSearchQueue.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/11/30.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SQLite
import SwiftyJSON

private let SearchTable    = "SearchTable"
private let id             = Expression<Int>("primaryId")//主键自动增加
private let hotName        = Expression<String?>("hotName")//关键词
private let updateTime     = Expression<TimeInterval>("time")//更新时间
//用于后期升级表结构
private let createTime     = Expression<TimeInterval>("createTime")//创建时间
class ApiSearchQueue : NSObject{
    //MARK:创建表
    private class func createTable() -> Table{
        let tables = Table(SearchTable)
        try! dataBase.run(tables.create(ifNotExists: true, block: { (table) in
            //注意.autoincrement
            table.column(id,primaryKey: .autoincrement)
            table.column(hotName)
            table.column(updateTime)
            
        }))
        return tables
    }
    //MARK:等于0表示表结构需要升级
    private class func columns(_ column :String) -> Bool{
        let table = SearchTable
        var columnDatas :[String] = []
        do {
            let s = try dataBase.prepare("PRAGMA table_info(" + table + ")" )
            for row in s {
                columnDatas.append(row[1]! as! String)
            }
        }
        catch {
            print("some woe in findColumns for \(table) \(error)")
        }
        let list = columnDatas.filter { (item) -> Bool in
            return item == column
        }
        return list.count > 0
    }
    //MARK:判断表中是否有本条数据
    private class func selectCount(keyword :String) ->Int{
        let table = createTable()
        let haveColumn = columns("createTime")
        //表结构升级放在这里 添加一列createTime
        if !haveColumn {
            do {
                try dataBase.run(table.addColumn(createTime,defaultValue:0))
            } catch  {
                debugPrint(error)
            }
        }
        let alice = table.filter(hotName == keyword)
        do {
            let count = try dataBase.scalar(alice.count)
            debugPrint(count)
            return count
        } catch  {
            return 0
        }
    }
    public class func insertData(keyword :String,completion:@escaping ((_ success : Bool) -> Void)){
        let count = selectCount(keyword: keyword)
        if count == 0 {
            let table = createTable()
            let time : TimeInterval = NSDate ().timeIntervalSince1970
            let insertdata = table.insert(hotName <- keyword,updateTime <- time,createTime <- time)
            do {
                try dataBase.transaction {
                    try dataBase.run(insertdata)
                }
                completion(true)
            } catch  {
                debugPrint(error)
                completion(false)
            }
        }else{
            updateData(keyword: keyword, completion: completion)
        }
    }
    public class func updateData(keyword :String,completion:@escaping ((_ success : Bool) -> Void)){
        let count = selectCount(keyword: keyword)
        if count == 0 {
            insertData( keyword: keyword, completion: completion)
        }else{
            let table = createTable().filter(hotName == keyword)
            let time : TimeInterval = NSDate ().timeIntervalSince1970
            let update = table.update(hotName <- keyword,updateTime <- time)
            do {
                try dataBase.transaction {
                    try dataBase.run(update)
                }
                completion(true)
            } catch  {
                debugPrint(error)
                completion(false)
            }
        }
    }
    public class func deleteData(keyword :String,completion:@escaping ((_ success : Bool) -> Void)){
        let table = createTable()
        do {
            try dataBase.transaction {
                let alice = table.filter(hotName == keyword)
                try dataBase.run(alice.delete())
            }
            completion(true)
        } catch {
            debugPrint(error)
            completion(false)
        }
    }
    public class func deleteData(keywords :[String],completion:@escaping ((_ success : Bool) -> Void)){
        do {
            try dataBase.transaction {
                keywords.forEach { (title) in
                    let table = createTable()
                    do {
                        let alice = table.filter(hotName == title)
                        try dataBase.run(alice.delete())
                    } catch {
                        debugPrint(error)
                    }
                }
            }
            completion(true)
        } catch  {
            completion(false)
        }
    }
    public class func searchData(page : Int,size : Int = 20,completion:@escaping ((_ datas : [String]) ->Void)){
        let table = createTable()
        let order = table.order(updateTime.desc).limit(size, offset: (page - 1) * size)
        guard let datas : AnySequence<Row> = try? dataBase.prepare(order) else {
            completion([])
            return
        }
        decodeData(listData: datas,completion: completion)
    }
    public class func searchData(completion:@escaping ((_ datas : [String]) ->Void)){
        let table = createTable()
        guard let datas : AnySequence<Row> = try? dataBase.prepare(table) else {
            completion([])
            return
        }
        decodeData(listData: datas,completion: completion)
    }
    private class func decodeData(listData : AnySequence<Row>,completion:@escaping ((_ datas : [String]) ->Void)){
        var contentData : [String] = []
        listData.forEach { (objc) in
            let content :String = objc[hotName] ?? ""
            contentData.append(content)
        }
        completion(contentData)
    }
}
