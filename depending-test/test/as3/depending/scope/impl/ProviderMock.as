package as3.depending.scope.impl {
import as3.depending.Provider;

public class ProviderMock implements Provider {

    public var callsTo_provide:uint = 0;

    public function provide():Object {
        callsTo_provide++;
        return null;
    }
}
}
