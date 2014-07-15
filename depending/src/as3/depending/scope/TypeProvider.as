package as3.depending.scope {
import as3.depending.Depending;
import as3.depending.Provider;
import as3.depending.Resolver;

/**
 * Each instance of this provider creates a new instance of the given Class,
 * by calling its constructor with zero arguments.
 */
public class TypeProvider implements Provider {

    private var Impl:Class;

    public function TypeProvider(implementation:Class) {
        this.Impl = implementation;
    }

    public function provide(resolver:Resolver = null):Object {
        const value:* = new Impl();
        if(value is Depending){
            Depending(value).fetchDependencies(resolver);
        }
        return value;
    }

}
}
