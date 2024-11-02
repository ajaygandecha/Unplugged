//
//  InstagramProvider.swift
//  Unplugged
//
//  Created by Noah Smith on 11/2/24.
//

import SwiftUI
import Foundation
import WebKit
import Alamofire

enum AuthenticationState {
    case loggedIn
    case loggedOut
}

class InstagramProvider: ObservableObject {
    let cookieStore: HTTPCookieStorage
    
    @Published var authState: AuthenticationState = .loggedOut
    @Published var posts: [Post] = []
    
    init() {
        self.cookieStore = HTTPCookieStorage.shared
        refreshLoginState()
    }
    
    func refreshLoginState() {
        if let cookies = self.cookieStore.cookies(for: URL(string: "https://instagram.com")!) {
            for cookie in cookies {
                if cookie.name == "sessionid" { // Could also be ds_user_id
                    authState = .loggedIn
                    return
                }
            }
        }

        authState = .loggedOut
        return
    }

    func fetchPosts(after: String, before: String) {
        struct VariableData: Encodable {
            let device_id: String = "528471E5-D166-4197-ABC9-ACA510B10649"
            let is_async_ads_double_request: String = "0"
            let is_async_ads_in_headload_enabled: String = "0"
            let is_async_ads_rti: String = "0"
            let rti_delivery_backend: String = "0"
            let pagination_source: String = "following"
            let feed_view_info: String = "" // This may not work
        }
        
        struct Variables: Encodable {
            let after: String? = ""
            let before: String? = nil
            let data: VariableData = VariableData()
            let first: Int? = 12
            let last: Int? = nil
            let __relay_internal__pv__PolarisIsLoggedInrelayprovider: Bool = true
            let __relay_internal__pv__PolarisFeedShareMenurelayprovider: Bool = false
        }
        
//        let variables: [String: Any?] = [
//            "after": "",
//            "before": nil,
//            "data": [
//                "device_id": "528471E5-D166-4197-ABC9-ACA510B10649",
//                "is_async_ads_double_request": "0",
//                "is_async_ads_in_headload_enabled": "0",
//                "is_async_ads_rti": "0",
//                "rti_delivery_backend": "0",
//                "pagination_source": "following",
//                "feed_view_info": ""
//            ],
//            "first": 12,
//            "last": nil,
//            "variant": "following",
//            "__relay_internal__pv__PolarisIsLoggedInrelayprovider": true,
//            "__relay_internal__pv__PolarisFeedShareMenurelayprovider": false
//        ]
        
        struct Parameters: Encodable {
            let av: UInt64 = 17841403880909452
//            __d: www
//            __user: 0
//            __a: 1
//            __req: 1q
//            __hs: 20029.HYP:instagram_web_pkg.2.1..0.1
//            dpr: 2
//            __ccg: UNKNOWN
//            __rev: 1017900101
//            __s: i072ey:oa40j6:gcpfrq
//            __hsi: 7432760869495521507
//            __dyn: 7xeUjG1mxu1syUbFp41twpUnwgU7SbzEdF8aUco2qwJxS0k24o1DU2_CwjE1EE2Cw8G11wBz81s8hwGxu786a3a1YwBgao6C0Mo2iyo7u3ifK0EUjwGzEaE2iwNwmE2eUlwhEe87q7U881eFEbUGdG1QwTU9UaQ0Lo6-3u2WE5B08-269wr86C1mwPwUQp1yUb8jxKi2qi7E5yqcxK2K0Pay9rx66E
//            __csr: gqgkiN74ON4Jv9FOih4nb9kp4lRmykOZV5Vp5ARl9eqmqqXiJ5DBHarFmF-5ohV9jAKZvG8DKiWJ5USiqm8B8qiFt3aF0wKcBDgK4bzWUnyu9KFWUyUCay22VVum9iKFCq7Ey9GhogyEiK8XCx6bzE01eWQ2eq0yU5i0iC0jK1eCKHw4bw4jcEOh1fo6Fx9w1o63C09Kxgw3mw7iw7BcEhgMGP384N0jF8YE2tge5Gi542e3_8fDBlpVi1ca0DwuS3-2Cqqt2CC0IEGq9C86o4C15wb617zVUG2yhwXU3Dxpe1-oco4-58pwg89E07_a0iu0c7w
//            __comet_req: 7
//            fb_dtsg: NAcPSqq24zcmlGmMNupfJJXLyEPAWaHuPb8FLHAI3V8IR6RL_XLf7yA:17843709688147332:1729619979
            let jazoest: Int = 26162
//            lsd: uqc1r73rfGXNjIoLhi5x8y
//            __spin_r: 1017900101
//            __spin_b: trunk
//            __spin_t: 1730574497
            let fb_api_caller_class: String = "RelayModern"
            let fb_api_req_friendly_name: String = "PolarisFeedRootPaginationCachedQuery_subscribe"
            let variables: String = String(data: try! JSONEncoder().encode(Variables()), encoding: .utf8)!
            let server_timestamps: Bool = true
            let doc_id: UInt64 = 8761125853933541
        }
        
        AF.request("https://www.instagram.com/graphql/query", method: .post, parameters: Parameters(), encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let data = JSON["data"] as! [String: Any]
                        let feed = data["xdt_api__v1__feed__timeline__connection"] as! [String: Any]
                        let edges = data["edges"] as [Any]
                        let firstPost = edges[0]
                        print(firstPost)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
