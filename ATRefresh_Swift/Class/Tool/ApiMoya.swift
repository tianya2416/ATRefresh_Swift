//
//  ApiMoya.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

public enum ApiMoya{
    case apiHome
    case apiClassify(page: Int, size : Int,group:String,name:String)
}
extension ApiMoya : TargetType{
    public var method: Moya.Method {
        return .get;
    }
    
    public var sampleData: Data {
        return Data();
    }
    public var task: Task {
            switch self {
            
            case let .apiClassify(page:page, size: size, group: group, name: name):
                return .requestParameters(parameters: ["gender":group,"major":name,"start":String((page - 1)*size + 1  ),"limit":String(size),"type":"hot","minor":""], encoding: URLEncoding.default);
            case .apiHome:
                return .requestParameters(parameters: [:], encoding:URLEncoding.default);
            }

    }
    
    public var headers: [String : String]? {
        return [:]
    }
    public var baseURL: URL {
        return URL(string: "https://api.zhuishushenqi.com")!
    }
    
    public var path: String {
        switch self {
        case .apiClassify:
            return "book/by-categories";
        case .apiHome:
            return "";
        }
    }
    public static func apiMoyaRequest(target: ApiMoya,sucesss:@escaping ((_ object : JSON) ->()),failure:@escaping ((_ error : String) ->())){
        let moya = MoyaProvider<ApiMoya>();
        moya.request(target) { (result) in
            DispatchQueue.main.async {
                switch result{
                case let .success(respond):
                    let json = JSON(respond.data)
                    //print(json);
                    if json["ok"] == true {
                        sucesss(json["books"])
                    }else{
                    
                        failure((json["msg"].rawString() ?? ""))
                    }
                    break;
                case let .failure(error):
                    failure(error.errorDescription!)
                    break;
                }
            }
        }
    }
}
