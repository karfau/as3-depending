package as3.depending.examples.readme {
import as3.depending.Depending;
import as3.depending.Resolver;

public class TweetServiceResolver implements Resolver {

    public function get(clazz:Class, required:Boolean = true):* {
        var instance:*;
        switch(clazz){
            case TweetService:
                instance = TweetService.create(this);
                break;
            case ITweetClient:
                instance = new TraceTweetClient();
                break;
            default:
                instance = new clazz();
        }
        if(instance is Depending){
            Depending(instance).fetchDependencies(this);
        }

        return instance;
    }
}
}
