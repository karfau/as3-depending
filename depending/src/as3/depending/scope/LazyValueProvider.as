package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.Resolver;

/**
 * This implements the (lazy) singleton pattern.
 *
 * It wraps any other Provider that provides values, and just delegates to it when required.
 * Each <b>instance</b> of this class, will always provide the same value.
 * It will only invoke its provider the first time it gets invoked.
 *
 */
public class LazyValueProvider extends ValueProvider {

    private var provider:Provider;

    public function LazyValueProvider(provider:Provider) {
        this.provider = provider;
        super(null);
    }

    override public function provide(resolver:Resolver = null):Object {
        if(value == null){
            value = provider.provide(resolver);
        }
        return value;
    }

}
}
