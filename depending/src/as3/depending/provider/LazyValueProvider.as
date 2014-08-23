package as3.depending.provider {
import as3.depending.Providing;
import as3.depending.Resolver;

/**
 * This implements the (lazy) singleton pattern.
 *
 * It wraps any other Provider that provides values, and just delegates to it when required.
 * Each <b>instance</b> of this class, will always provide the same value.
 * It will only invoke delegate to its provider the first time it gets invoked.
 *
 * It will throw an ArgumentError when created without a providing.
 */
public class LazyValueProvider implements ProviderExpecting, ProvidingSameInstance, ProvidingTyped {

    private var providing:Providing;
    private var value:Object;

    public function LazyValueProvider(providing:Providing) {
        if (providing == null) {
            throw new ArgumentError('expected Providing but was null');
        }
        this.providing = providing;
    }

    public function provide(resolver:Resolver):Object {
        if(value == null){
            value = invokeProvider(providing, resolver);
        }
        return value;
    }

    /**
     * @returns the type of the returned value if possible:
     * - when the providing implements ProvidingTyped
     * - or it has already been invoked
     * otherwise it throws a ReferenceError
     *
     * @throws ReferenceError when the type is not known yet
     */
    public function get type():Class {
        if(value != null){
            return value.constructor;
        }
        if (providing is ProvidingTyped) {
            return ProvidingTyped(providing).type;
        }
        throw  new ReferenceError("type is not known before first call to provide because " + providing + " doesn't implement ProvidingTyped");
    }
}
}
