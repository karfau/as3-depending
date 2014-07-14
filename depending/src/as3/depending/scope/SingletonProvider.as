package as3.depending.scope {
import as3.depending.Provider;

/**
 * This implements the (lazy) singleton pattern.
 *
 * It wraps any other Provider that provides values, and just delegates to it when required.
 * Each <b>instance</b> of this class, will always provide the same value.
 * It will only invoke its provider the first time it gets invoked.
 *
 */
public class SingletonProvider implements Provider {

    private var provider:Provider;
    private var value:Object;

    public function SingletonProvider(provider:Provider) {
        this.provider = provider;
    }

    public function provide():Object {
        if(value == null){
            value = provider.provide();
        }
        return value;
    }

    public function get providesResolved():Boolean {
        return provider.providesResolved;
    }
}
}
