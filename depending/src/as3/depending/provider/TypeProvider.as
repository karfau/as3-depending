package as3.depending.provider {
import as3.depending.Depending;
import as3.depending.Resolver;

/**
 * Each instance of this provider creates a new instance of the given Class,
 * by calling its constructor with zero arguments.
 *
 * Invoking a TypeProvider for an Interface results in a VerifyError with errorCode 1001.
 */
public class TypeProvider implements ProviderExpecting, ProvidingTyped {

    private var Impl:Class;

    public function get type():Class {
        return Impl;
    }

    public function TypeProvider(implementation:Class) {
        if(implementation == null){
            throw new ArgumentError('expected Class but was null');
        }
        this.Impl = implementation;
    }

    public function provide(resolver:Resolver):Object {
        const value:* = new Impl();
        if(value is Depending){
            Depending(value).fetchDependencies(resolver);
        }
        return value;
    }

}
}
