package as3.depending.examples.readme {
import as3.depending.BaseResolver;
import as3.depending.Depending;

public class TweetServiceResolver extends BaseResolver{

    override protected function doResolve(clazz:Class):* {
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
