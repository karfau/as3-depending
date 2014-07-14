package as3.depending.scope.impl {
import as3.depending.Provider;
import as3.depending.examples.tests.Instance;

public class ProviderMock implements Provider {

    public var callsTo_provide:uint = 0;

    public function provide():Object {
        callsTo_provide++;
        return new Instance();
    }

    public var isProvidingResolved:Boolean;
    public function get providesResolved():Boolean {
        return isProvidingResolved;
    }
}
}
