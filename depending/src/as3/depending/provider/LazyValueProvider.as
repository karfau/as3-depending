package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.Resolver;

/**
 * This implements the (lazy) singleton pattern.
 *
 * It wraps any other Provider that provides values, and just delegates to it when required.
 * Each <b>instance</b> of this class, will always provide the same value.
 * It will only invoke its provider the first time it gets invoked.
 *
 * It will throw an ArgumentError when created without a provider.
 */
public class LazyValueProvider implements ProviderExpecting, SameInstanceProviding {

    private var provider:Providing;
    private var value:Object;

    public function LazyValueProvider(provider:Providing) {
        if(provider == null){
            throw new ArgumentError('expected Provider but was null');
        }
        this.provider = provider;
    }

    public function provide(resolver:Resolver):Object {
        if(value == null){
            value = invokeProvider(provider, resolver);
        }
        return value;
    }

}
}
