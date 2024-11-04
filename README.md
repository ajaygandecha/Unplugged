# Unplugged

![Swift](https://img.shields.io/badge/-Swift-05122A?style=flat&logo=swift)
![SwiftUI](https://img.shields.io/badge/-SwiftUI-05122A?style=flat&logo=swift&logoColor=03c3ff)

> **✨ HackNC 2024 1st Place Winner! ✨**
>
> Developed by [Ajay Gandecha](https://github.com/ajaygandecha), [Noah Smith](https://github.com/noahsmiths), [Jade Keegan](https://github.com/jadekeegan), and [Matt Vu](https://github.com/tmattvu) for HackNC 2024 at UNC-Chapel Hill. View Unplugged's DevPost submission for HackNC [here](https://devpost.com/software/unplugged-githlb).
>
> ***Note:** This application was developed entirely in a 24-hour period as part of HackNC. No further commits will be added on the main branch to preserve the state of the project at the end of the hackathon!*

With the typical social media user spending an average of 2.4 hours a day—and teenagers nearly doubling that at 4.8 hours—new generations dedicate a significant portion of their time to consuming random content, much of which has little impact on their lives. Many try to delete social media apps entirely, but doing so often means disconnecting from friends and family. In addition, since many student organizations on college campuses use social media to share important news and upcoming events, disconnecting entirely from social media leaves students entirely out of the loop.

That's were **Unplugged** comes in! Unplugged offers an alternative way to interact with social media, enabling users to see posts from only those they care about across their various social media accounts. Unplugged offers many ways for users to customize their feed, enabling them to stay connected with friends, family, and their communities without being subjected to advertisements, social media algorithms, and unsolicited content.

## Features

Users of Unplugged can:
- View a **chronological feed** of their friends posts from across **many social media providers at once** (including Instagram and Facebook).
    - *Supports all forms of content, including text, single image, image carousels, and short-form videos.*
- **Filter** their feed based on social media provider.
- **Hide like counts** on posts.
- **Hide all video shorts** on the feed, commonly considered the most addictive form of social media content.
- Choose **only specific accounts to show** for each social media provider. This is extremely useful because for example, a user may follow 100s of accounts on Instagram but only want to see posts from 10-20 accounts.

## Implementation and Technical Notes

Unplugged is a native iOS app built using **Swift** and designed using **SwiftUI**. There were many interesting and challenging technical considerations for implementing this project, the key ones are discussed below.

### Access to Internal Instagram and Facebook Data

One of the largest technical challenges for Unplugged was accessing Instagram and Facebook feeds for the user. By default, Meta does **not have any direct APIs** for this data. To reliably load Instagram and Facebook data, we needed to (1) reverse-engineer the endpoints used by the traditional Instagram and Facebook, and (2) call these endpoints using the user's authorization credentials every time.

Meta uses GraphQL API endpoints for loading posts on a users feed for both Instagram and Facebook. We were able to locate these endpoints in the browser developer network tools for both Instagram and Facebook and view their output. A very large amount of time was spent parsing this data to locate where post information is stored. We also had to do research into other properties of the API request, including headers and parameters. To load the feed for both social media platforms in Unplugged, these headers and parameters must be configured correctly when making the API requests in the app. Most of the functionality for loading both Instagram and Facebook via the reversed-engineered APIs can be found in `InstagramProvider.swift` ([here](https://github.com/ajaygandecha/Unplugged/blob/main/Unplugged/Feed/Services/Providers/InstagramProvider.swift)) and `FacebookProvider.swift` ([here](https://github.com/ajaygandecha/Unplugged/blob/main/Unplugged/Feed/Services/Providers/FacebookProvider.swift)) respectively.

To run these endpoints successfully, we need to trick the endpoints into assuming we are logged into the social media account itself. When users connect Unplugged to their Instagram and Facebook accounts respectively, users log into their accounts in a `WKWebView` in the app. Once they log in, *cookies* are stored in the web view that store authentication information and details. If we were to call the endpoints we created above using the cookies from the web view when the users connected to their accounts originally, the endpoints will succesfully return with post data. The good news is that Swift's `WKWebView`s maintain a shared HTTP cookie storage (accessible at `HTTPCookieStorage.shared`) which would contain these cookies. These cookies, combined with the endpoints above and some parsing, return a list of posts for each social media account the user is signed in to. Whether these cookies occur or not also is used across the app to determine whether or not a user is authenticated for the service. If Instagram or Facebook cookies exist, then Unplugged is connected to those accounts. Also, we do not need to worry about cookies expiring here, since these cookies typically are long-lasting (since Meta would want people to have to reduce the number of times that users need to sign in online).
