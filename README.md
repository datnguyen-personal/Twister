## Twister

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: 15 hours

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unfavorite and should decrement the favorite count.
- [ ] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough
![Video Walkthrough](RottenTomatoes.gif)

### Credits
---------
* [Twitter API](https://dev.twitter.com/rest/public)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [KVNProfress] (https://github.com/kevin-hirsch/KVNProgress)
* [BDBOAuth1Manager] (https://github.com/bdbergeron/BDBOAuth1Manager)

### Open-sources
* Close by Leyla Jacqueline from the Noun Project
* Icons made by [Elegant Themes](http://www.flaticon.com/authors/elegant-themes) from [Flaticon] (http://www.flaticon.com) is licensed by [Creative Commons BY 3.0] (http://creativecommons.org/licenses/by/3.0/)
* Icons made by [Stephen Hutchings](http://www.flaticon.com/authors/stephen-hutchings) from [Flaticon] (http://www.flaticon.com) is licensed by [Creative Commons BY 3.0] (http://creativecommons.org/licenses/by/3.0/)
