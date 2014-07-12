package as3.depending.examples.readme {
import as3.depending.Resolver;

public class TweetService{

    public static function create(resolver:Resolver):TweetService{
        return new TweetService( resolver.get(UrlShorter), resolver.get(ITweetClient));
    }

    private var urlShorter:UrlShorter;
    private var tweetClient:ITweetClient;

    public function TweetService(shorter:UrlShorter,tweetClient:ITweetClient){
        urlShorter = shorter;
        this.tweetClient = tweetClient;
    }

    public function tweet(message:String):void{
        if(message.length >140){
            message = urlShorter.shorten(message);
        }
        if(message.length <= 140){
            tweetClient.post(message);
        }
    }
}
}
