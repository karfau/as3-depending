package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.scope.impl.Invokes;

public class ProviderStrategyMock implements ProviderStrategy {

    private var invokes:Invokes;
    public var result:ProviderMock;
    public function ProviderStrategyMock(invokes:Invokes = null) {
        this.invokes = invokes;
    }

    public function providerFor(value:*):Providing {
        if(invokes){
            invokes.invoke(providerFor, value);
        }
        return result;
    }

}
}
