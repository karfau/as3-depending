package as3.depending.examples.readme {
import as3.depending.Resolver;

import flash.display.Sprite;

public class Main extends Sprite{


    public function Main() {

        var resolver:Resolver = new TweetServiceResolver();

        var tweetService:TweetService = resolver.get(TweetService);

        tweetService.tweet('First Message today');
        //First Message today

        tweetService.tweet(
            'When I post a tweet that is to long, it will shorten the url found in the message.\n' +
            'https://github.com/karfau/as3-depending/blob/master/README.md'
        );
        //When I post a tweet that is to long, it will shorten the url found in the message.
        //github.com/karfau/as3-depending/blob/master/README.md



    }
}
}
