package as3.depending.examples.readme {
public class UrlShorter {
    public function UrlShorter() {
    }

    public function shorten(message:String):String {
        return message.replace(/https?:\/\//gi,'');
    }
}
}
