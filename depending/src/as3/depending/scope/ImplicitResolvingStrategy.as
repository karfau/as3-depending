package as3.depending.scope {
import as3.depending.Providing;
import as3.depending.provider.DefaultProviderStrategy;

public class ImplicitResolvingStrategy extends DefaultProviderStrategy {

    override public function providerFor(value:*):Providing {
        if(value is Class){
            return super.providerFor(value);
        }
        return null;
    }
}
}
