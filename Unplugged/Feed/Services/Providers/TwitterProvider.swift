//
//  TwitterProvider.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI
import Foundation
import WebKit
import Alamofire

class TwitterProvider: ObservableObject {
    let cookieStore: HTTPCookieStorage
    
    @Published var authState: AuthenticationState = .loggedOut
    @Published var activeTwitterCookies: [HTTPCookie]?
        
    init() {
        self.cookieStore = HTTPCookieStorage.shared
        refreshLoginState()
    }
    
    func refreshLoginState() {
        if let cookies = self.cookieStore.cookies(for: URL(string: "https://x.com")!) {
            self.activeTwitterCookies = cookies
            for cookie in cookies {
                
                if cookie.name == "auth_token" {
                    authState = .loggedIn
                    return
                }
            }
        }

        authState = .loggedOut
        return
    }

    func fetchPosts(completionBlock: @escaping ([Post]) -> Void) {
        
        guard let cookies = activeTwitterCookies else { completionBlock([]); return }
        
        let csrfCookie = cookies.first { $0.name == "ct0" }
        
        
        let headers: HTTPHeaders = [
            "x-csrf-token": csrfCookie?.value ?? "",
            "x-twitter-active-user": "yes",
            "x-twitter-auth-type": "OAuthSession",
            "x-twitter-client-language": "en",
            "Authorization": "Bearer AAAAAAAAAAAAAAAAAAAAANRILgAAAAAAnNwIzUejRCOuH5E6I8xnZz4puTs%3D1Zv7ttfk8LF81IUq16cHjhLTvJu4FA33AGWWjCpTnA"
        ]

        
        struct Features: Encodable {
            let rweb_tipjar_consumption_enabled: Bool = true
            let responsive_web_graphql_exclude_directive_enabled: Bool = true
            let verified_phone_label_enabled: Bool = false
            let creator_subscriptions_tweet_preview_api_enabled: Bool = true
            let responsive_web_graphql_timeline_navigation_enabled: Bool = true
            let responsive_web_graphql_skip_user_profile_image_extensions_enabled: Bool = false
            let communities_web_enable_tweet_community_results_fetch: Bool = true
            let c9s_tweet_anatomy_moderator_badge_enabled: Bool = true
            let articles_preview_enabled: Bool = true
            let responsive_web_edit_tweet_api_enabled: Bool = true
            let graphql_is_translatable_rweb_tweet_is_translatable_enabled: Bool = true
            let view_counts_everywhere_api_enabled: Bool = true
            let longform_notetweets_consumption_enabled: Bool = true
            let responsive_web_twitter_article_tweet_consumption_enabled: Bool = true
            let tweet_awards_web_tipping_enabled: Bool = false
            let creator_subscriptions_quote_tweet_preview_enabled: Bool = false
            let freedom_of_speech_not_reach_fetch_enabled: Bool = true
            let standardized_nudges_misinfo: Bool = true
            let tweet_with_visibility_results_prefer_gql_limited_actions_policy_enabled: Bool = true
            let rweb_video_timestamps_enabled: Bool = true
            let longform_notetweets_rich_text_read_enabled: Bool = true
            let longform_notetweets_inline_media_enabled: Bool = true
            let responsive_web_enhance_cards_enabled: Bool = false

        }
        
        struct Variables: Encodable {
            
            let count: Int? = 20
            let cursor: String? = "DAABCgABGbbIJVb__9sKAAIZtYOybVZwQggAAwAAAAIAAA"
            let includePromotedContent: Bool? = false
            let latestControlAvailable: Bool? = true
            let withCommunity: Bool? = true
            let seenTweetIds: [String]? = []

        }
        
        struct Parameters: Encodable {
            
            init(variables: Variables) {
                self.variables = String(data: try! JSONEncoder().encode(variables), encoding: .utf8)!
                self.features = String(data: try! JSONEncoder().encode(Features()), encoding: .utf8)!
            }
            
            let queryId: String = "E6AtJXVPtK7nIHAntKc5fA"
            let variables: String
            let features: String
        }
        
        AF.request("https://x.com/i/api/graphql/E6AtJXVPtK7nIHAntKc5fA/HomeLatestTimeline", method: .get, parameters: Parameters(variables: Variables()), encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseJSON { response in
            typealias StrDict = [String: Any];
            
            switch response.result {
                
                case .success(let value):
                    if let JSON = value as? StrDict {
                        var posts: [Post] = [];
                        
                        let data = JSON["data"] as! StrDict
                        let entries = data["entries"] as! [Any]
                        
                        for e in entries {
                            let entry = e as! StrDict
                            let content = entry["content"] as! StrDict
                            let itemContent = content["itemContent"] as! StrDict
                            
                            let tweetData = (((itemContent["tweet_results"] as! StrDict)["result"] as! StrDict)["legacy"] as! StrDict)
                            let core = (((itemContent["tweet_results"] as! StrDict)["result"] as! StrDict)["core"] as! StrDict)
                            
                            let userResults = core["user_results"] as! StrDict
                            let userData = (userResults["result"] as! StrDict)["legacy"] as! StrDict
                            
                            let mediaItemList = (tweetData["entities"] as! StrDict)["media"] as! [Any]
                            
                            let mediaItems: [MediaItem] = mediaItemList.map { item in
                                let itemData = item as! StrDict
                                let sizeData = ((itemData["features"] as! StrDict)["orig"] as! StrDict)["faces"] as! StrDict
                                let width = sizeData["w"] as! Int
                                let height = sizeData["h"] as! Int
                                return MediaItem(url: itemData["media_url_https"] as? String ?? "", postType: .photo, width: width, height: height)
                            }
                            
                            let dateFormatter = DateFormatter()

                            // Set the format according to the string pattern
                            dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing

                            var date = Date()
                            if let translatedDate = dateFormatter.date(from: tweetData["created_at"] as? String ?? "") {
                                date = translatedDate
                            } else {
                                print("Failed to convert date")
                            }
                                                        
                            posts.append(
                                Post(liked: tweetData["favorited"] as? Bool ?? false,
                                     likeCount: tweetData["favorite_count"] as? Int ?? 0,
                                     userImage: userData["profile_image_url_https"] as? String ?? "",
                                     username: userData["screen_name"] as? String ?? "",
                                     media: mediaItems,
                                     body: tweetData["full_text"] as? String ?? "",
                                     source: .twitter, timestamp: Int(date.timeIntervalSince1970))
                            )
                        }
                                                
                        completionBlock(posts)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func fetchNextPageOfPosts(completionBlock: @escaping ([Post]) -> Void) {
        self.fetchPosts(completionBlock: completionBlock)
    }
}
