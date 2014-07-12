package as3.depending.examples.readme {
public class TraceTweetClient implements ITweetClient {

    public function post(message:String):void {
        trace(message);
    }
}
}
