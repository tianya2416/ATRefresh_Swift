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
    case apiClassify(page: Int, size : Int)
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
            
            case .apiClassify:
                return .requestParameters(parameters: [:], encoding: URLEncoding.default);
            case .apiHome:
                return .requestParameters(parameters: [:], encoding:URLEncoding.default);
            }

    }
    
    public var headers: [String : String]? {
        return [:]
    }
    public var baseURL: URL {
        return URL(string: "http://c.m.163.com")!
    }
    
    public var path: String {
        switch self {
        case let .apiClassify(page: page, size: size):
            return "nc/article/headline/T1348647853363/\((page - 1)*size)-\(size).html";
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
                    sucesss(json)
                    break;
                case let .failure(error):
                    failure(error.errorDescription!)
                    break;
                }
            }
        }
    }
}
