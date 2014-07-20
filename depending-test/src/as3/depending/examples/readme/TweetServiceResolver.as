package as3.depending.examples.readme {
import as3.depending.Depending;
import as3.depending.Resolver;

public class TweetServiceResolver implements Resolver{

    public function get(identifier:Object):* {
        var instance:*;
        switch(identifier){
            case TweetService:
                instance = TweetService.create(this);
                break;
            case ITweetClient:
                instance = new TraceTweetClient();
                break;
            default:
                if(identifier is Class){
                    instance = new identifier();
                }
        }
        if(instance is Depending){
            Depending(instance).fetchDependencies(this);
        }

        return instance;
    }
}
}
