//
//  FacebookProvider.swift
//  Unplugged
//
//  Created by Noah Smith and Matt Vu on 11/2/24.
//

import SwiftUI
import Foundation
import WebKit
import Alamofire

class FacebookProvider: ObservableObject {
    let cookieStore: HTTPCookieStorage
    
    @Published var authState: AuthenticationState = .loggedOut
    @Published var posts: [Post] = []
    
    var afterCursor: String?
    var dtsg: String = ""
    let headers: HTTPHeaders = [
//            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"
        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-encoding": "gzip",
        "accept-language": "en-US,en;q=0.9,ja;q=0.8",
        "cache-control": "no-cache",
        "dpr": "2",
        "pragma": "no-cache",
        "priority": "u=0, i",
        "referer": "https://www.facebook.com/login/device-based/regular/login/?login_attempt=1&lwv=120&lwc=1348092",
        "sec-ch-prefers-color-scheme": "dark",
        "sec-ch-ua": "\"Chromium\";v=\"130\", \"Google Chrome\";v=\"130\", \"Not?A_Brand\";v=\"99\"",
        "sec-ch-ua-full-version-list": "\"Chromium\";v=\"130.0.6723.92\", \"Google Chrome\";v=\"130.0.6723.92\", \"Not?A_Brand\";v=\"99.0.0.0\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-model": "\"\"",
        "sec-ch-ua-platform": "\"macOS\"",
        "sec-ch-ua-platform-version": "\"14.4.1\"",
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "same-origin",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36",
        "viewport-width": "393"
    ]
    
    init() {
        self.cookieStore = HTTPCookieStorage.shared
        self.afterCursor = ""
        
        refreshLoginState()
    }
    
    func refreshLoginState() {
        if let cookies = self.cookieStore.cookies(for: URL(string: "https://facebook.com")!) {
            for cookie in cookies {
                if cookie.name == "c_user" { // Could also be ds_user_id
                    authState = .loggedIn
                    return
                }
            }
        }

        authState = .loggedOut
        return
    }
    
    func getDGST(completionBlock: @escaping () -> Void) {
        AF.request("https://www.facebook.com/?filter=friends&sk=h_chr", method: .get, headers: headers).response { res in
            if let error = res.error {
                print(error)
                return
            }
            
            let response = String(decoding: res.data!, as: UTF8.self)
            self.dtsg = String(response.split(separator: "\"f\":\"")[1].split(separator: "\"")[0])
//            print(self.dtsg)
            completionBlock()
        }
    }

    func fetchPosts(cursor: String, completionBlock: @escaping ([Post]) -> Void) {
        if self.dtsg.isEmpty {
            getDGST {
                self.fetchPosts(cursor: cursor, completionBlock: completionBlock)
            }
            return
        }
        struct Variables: Encodable {
            init(cursor: String?) {
                self.cursor = cursor
            }
            
            let cursor: String?
            let connectionClass: String = "EXCELLENT"
            let feedbackSource: Int = 1
            let feedInitialFetchSize: Int = 5
            let feedLocation: String = "NEWSFEED"
            let feedStyle: String = "MOST_RECENT_FRIENDS_FEED"
            let orderby: [String] = [
                "MOST_RECENT"
              ]
            let privacySelectorRenderLocation: String = "COMET_STREAM"
            let recentVPVs: [String] = []
            let refreshMode: String = "MANUAL"
            let renderLocation: String = "homepage_stream"
            let scale: Int = 2
            let shouldChangeBRSLabelFieldName: Bool = false
            let shouldObfuscateCategoryField: Bool = false
            let useDefaultActor: Bool = false
            let __relay_internal__pv__GHLShouldChangeSponsoredAuctionDistanceFieldNamerelayprovider: Bool = false
            let __relay_internal__pv__GHLShouldChangeSponsoredDataFieldNamerelayprovider: Bool = false
            let __relay_internal__pv__GHLShouldChangeAdIdFieldNamerelayprovider: Bool = false
            let __relay_internal__pv__CometImmersivePhotoCanUserDisable3DMotionrelayprovider: Bool = false
            let __relay_internal__pv__IsWorkUserrelayprovider: Bool = false
            let __relay_internal__pv__IsMergQAPollsrelayprovider: Bool = false
            let __relay_internal__pv__FBReelsMediaFooter_comet_enable_reels_ads_gkrelayprovider: Bool = false
            let __relay_internal__pv__CometUFIReactionsEnableShortNamerelayprovider: Bool = false
            let __relay_internal__pv__CometUFIShareActionMigrationrelayprovider: Bool = true
            let __relay_internal__pv__IncludeCommentWithAttachmentrelayprovider: Bool = true
            let __relay_internal__pv__StoriesArmadilloReplyEnabledrelayprovider: Bool = true
            let __relay_internal__pv__EventCometCardImage_prefetchEventImagerelayprovider: Bool = false
        }
        
        struct Parameters: Encodable {
            
            init(variables: Variables, dtsg: String) {
                self.variables = String(data: try! JSONEncoder().encode(variables), encoding: .utf8)!
                self.fb_dtsg = dtsg
            }
            
//            let av: UInt64 = 17841403880909452
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
            let fb_dtsg: String
//            let jazoest: Int = 25552
//            lsd: uqc1r73rfGXNjIoLhi5x8y
//            __spin_r: 1017900101
//            __spin_b: trunk
//            __spin_t: 1730574497
            let fb_api_caller_class: String = "RelayModern"
            let fb_api_req_friendly_name: String = "CometModernHomeFeedQuery"
            let variables: String
            let server_timestamps: Bool = true
            let doc_id: UInt64 = 8588151837930652
        }
        
        func preprocess(_ data: Data) -> Data {
            let str = String(decoding: data, as: UTF8.self)
            var parsedStr = "[" + str.replacingOccurrences(of: "\r\n", with: ",") + "]"
//            parsedStr = "[" + String(parsedStr) + "]"
//            print(parsedStr)
            
            return parsedStr.data(using: .utf8)!
        }
        
        AF.request("https://www.facebook.com/api/graphql/", method: .post, parameters: Parameters(variables: Variables(cursor: cursor), dtsg: self.dtsg), encoder: URLEncodedFormParameterEncoder.default, headers: self.headers).response { res in
//            print(res.response)
//            print(res.data)
            if let err = res.error {
                print(err)
                return
            }
            
            typealias StrDict = [String: Any]
            
            do {
                let response = try JSONSerialization.jsonObject(with: preprocess(res.data!), options: .fragmentsAllowed) as! [Any]
                let top = response[0] as! StrDict
                let data = top["data"] as! StrDict
                let viewer = data["viewer"] as! StrDict
                let newsFeed = viewer["news_feed"] as! StrDict
                let edges = newsFeed["edges"] as! [Any]
                var posts: [Post] = []
                
                for edge in edges {
                    var allMedia: [MediaItem] = []
                    
                    let node = (edge as! StrDict)["node"] as! StrDict
                    let cometSections = node["comet_sections"] as! StrDict
                    let content = cometSections["content"] as! StrDict
                    let story = content["story"] as! StrDict
                    let subCometSections = story["comet_sections"] as! StrDict
                    let message = subCometSections["message"] as! StrDict
                    let messageStory = message["story"] as! StrDict
                    let subMessage = messageStory["message"] as! StrDict
                    let caption = subMessage["text"] as! String
                    let isTextOnlyStory = messageStory["is_text_only_story"] as! Bool
                    
                    if !isTextOnlyStory {
                        let attachments = story["attachments"] as! [Any]
                        
                        for attachment in attachments {
                            let styles = (attachment as! StrDict)["styles"] as! StrDict
                            let styleAttachment = styles["attachment"] as! StrDict
                            let subAttachment = styleAttachment["all_subattachments"] as! StrDict
                            let subNodes = subAttachment["nodes"] as! [Any]
                            
                            for node in subNodes {
                                let media = (node as! StrDict)["media"] as! StrDict
                                let isPlayable = media["is_playable"] as! Bool
                                
                                if isPlayable { // Video
                                    let videoGridRenderer = media["video_grid_renderer"] as! StrDict
                                    let video = videoGridRenderer["video"] as! StrDict
                                    let videoDeliveryLegacyFields = video["videoDeliveryLegacyFields"] as! StrDict
                                    let videoURL = videoDeliveryLegacyFields["browser_native_hd_url"] as! String
                                    let videoHeight = video["height"] as! Int
                                    let videoWidth = video["width"] as! Int
                                    
                                    allMedia.append(MediaItem(url: videoURL, postType: .video, width: videoWidth, height: videoHeight))
                                } else { // Photo
                                    let image = media["image"] as! StrDict
                                    let imageURL = image["uri"] as! String
                                    let imageHeight = image["height"] as! Int
                                    let imageWidth = image["width"] as! Int
                                    
                                    allMedia.append(MediaItem(url: imageURL, postType: .photo, width: imageWidth, height: imageHeight))
                                }
                            }
                        }
                    }
                    
                    let contextLayout = cometSections["context_layout"] as! StrDict
                    let contextLayoutStory = contextLayout["story"] as! StrDict
                    let contextLayoutStoryCometSections = contextLayoutStory["comet_sections"] as! StrDict
                    
                    let metadata = contextLayoutStoryCometSections["metadata"] as! [Any]
                    var timestamp: Int = Int(Date().timeIntervalSince1970)
                    
                    for entry in metadata {
                        if (entry as! StrDict)["__typename"] as! String == "CometFeedStoryMinimizedTimestampStrategy" {
                            let entryStory = (entry as! StrDict)["story"] as! StrDict
                            timestamp = entryStory["creation_time"] as! Int
                        }
                    }
                    
                    let actorPhoto = contextLayoutStoryCometSections["actor_photo"] as! StrDict
                    let actorPhotoStory = actorPhoto["story"] as! StrDict
                    let actors = actorPhotoStory["actors"] as! [Any]
                    let firstActor = actors[0] as! StrDict
                    let name = firstActor["name"] as! String
                    let profilePicture = firstActor["profile_picture"] as! StrDict
                    let profilePictureURL = profilePicture["uri"] as! String
                    
                    let feedback = cometSections["feedback"] as! StrDict
                    let feedbackStory = feedback["story"] as! StrDict
                    let storyUFIContainer = feedbackStory["story_ufi_container"] as! StrDict
                    let storyUFIContainerStory = storyUFIContainer["story"] as! StrDict
                    let feedbackContext = storyUFIContainerStory["feedback_context"] as! StrDict
                    let feedbackTargetWithContext = feedbackContext["feedback_target_with_context"] as! StrDict
                    let summaryAndActions = feedbackTargetWithContext["comet_ufi_summary_and_actions_renderer"] as! StrDict
                    let summaryAndActionsFeedback = summaryAndActions["feedback"] as! StrDict
                    let reactionCount = summaryAndActionsFeedback["reaction_count"] as! StrDict
                    let likeCount = reactionCount["count"] as! Int
                    
                    posts.append(Post(liked: false, likeCount: likeCount, userImage: profilePictureURL, username: name, media: allMedia, body: caption, source: .facebook, timestamp: timestamp))
                }
                
                let paginationBody = response.last as! StrDict
                let paginationData = paginationBody["data"] as! StrDict
                let pageInfo = paginationData["page_info"] as! StrDict
                self.afterCursor = pageInfo["end_cursor"] as? String
                
                completionBlock(posts)
            } catch {
                print(error)
            }
//            let response = String(decoding: res.data!, as: UTF8.self)
//            print(response)
//            print(response)
        }
    }
    
    func fetchNextPageOfPosts(completionBlock: @escaping ([Post]) -> Void) {
//        print(self.afterCursor)
        if let cursor = self.afterCursor {
            self.fetchPosts(cursor: cursor, completionBlock: completionBlock)
        }
    }
}
