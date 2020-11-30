//
//  ApiDataQueue.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/11/30.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SQLite
import SwiftyJSON

private let DataTable    = "DataTable"
//表主键
private let id   = Expression<String>("primaryId")
//表模型数据
private let data        = Expression<String?>("data")

class ApiDataQueue : NSObject{
    //MARK:创建表
    private class func createTable(_ name : String) -> Table{
        let tables = Table(DataTable)
        try! dataBase.run(tables.create(ifNotExists: true, block: { (table) in
            //注意.autoincrement
            table.column(id,primaryKey: true)
            table.column(data)
        }))
        return tables
    }
    //MARK:指定id数据统计
    private class func selectCount(_ name : String,primaryId :String) ->Int{
        let table = createTable(name)
        let alice = table.filter(id == primaryId)
        do {
            let count = try dataBase.scalar(alice.count)
            debugPrint(count)
            return count
        } catch  {
            return 0
        }
    }
    //MARK:数据插入
    public class func insertData(tableName :String = DataTable,primaryId :String,content : String,completion:@escaping ((_ success : Bool) -> Void)){
        let count = selectCount(tableName,primaryId: primaryId)
        if count == 0 {
            let table = createTable(tableName)
            let insertdata = table.insert(id <- primaryId,data <- content)
            do {
                try dataBase.run(insertdata)
                completion(true)
            } catch  {
                debugPrint(error)
                completion(false)
            }
        }else{
            updateData(tableName: tableName, primaryId: primaryId, content: content, completion: completion)
        }
    }
    //MARK:数据更新
    public class func updateData(tableName :String = DataTable,primaryId :String,content : String,completion:@escaping ((_ success : Bool) -> Void)){
        let count = selectCount(tableName,primaryId: primaryId)
        if count == 0 {
            insertData(tableName: tableName, primaryId: primaryId, content: content, completion: completion)
        }else{
            let table = createTable(tableName).filter(primaryId == id)
            let update = table.update(id <- primaryId,data <- content)
            do {
                try dataBase.run(update)
                completion(true)
            } catch  {
                debugPrint(error)
                completion(false)
            }
        }
    }
    //MARK:数据删除
    public class func deleteData(tableName :String = "DataTable",primaryId :String,completion:@escaping ((_ success : Bool) -> Void)){
        let table = createTable(tableName)
        do {
            let alice = table.filter(id == primaryId)
            try dataBase.run(alice.delete())
            completion(true)
        } catch {
            debugPrint(error)
            completion(false)
        }
    }
    //MARK:数据查询Id
    public class func searchData(tableName :String = DataTable,primaryId :String,completion:@escaping ((_ datas : JSON) -> Void)){
        let table = createTable(tableName)
        let alice = table.filter(id == primaryId)
        guard let datas : AnySequence<Row> = try? dataBase.prepare(alice) else {
            completion("")
            return
        }
        decodeData(listData: datas, completion: completion)
    }
    //MARK:数据查询page
    public class func searchData(tableName :String = DataTable,page : Int,size : Int = 20,completion:@escaping ((_ datas : JSON) ->Void)){
        let table = createTable(tableName)
        let order = table.order(id.asc).limit(size, offset: (page - 1) * size)
        
        guard let datas : AnySequence<Row> = try? dataBase.prepare(order) else {
            completion(JSON(""))
            return
        }
        decodeData(listData: datas,completion: completion)
    }
    //MARK:数据查询all
    public class func searchData(tableName :String = DataTable,completion:@escaping ((_ datas : JSON) ->Void)){
        let table = createTable(tableName)
        guard let datas : AnySequence<Row> = try? dataBase.prepare(table) else {
            completion(JSON(""))
            return
        }
        decodeData(listData: datas,completion: completion)
    }
    //MARK:数据解析
    private class func decodeData(listData : AnySequence<Row>,completion:@escaping ((_ datas : JSON) ->Void)){
        DispatchQueue.global().async {
            var contentData : [JSON] = []
            listData.forEach { (objc) in
                let content :String = objc[data] ?? ""
                let dataS : Data = content.data(using: .utf8)!
                let json = JSON(dataS)
                contentData.append(json)
            }
            let json = JSON(contentData)
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
}
