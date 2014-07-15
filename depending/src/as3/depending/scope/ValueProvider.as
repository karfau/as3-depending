package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.Resolver;

/**
 * Each instance of this provider always returns the given value.
 */
public class ValueProvider implements Provider {
    protected var value:Object;

    public function ValueProvider(value:Object) {
        this.value = value;
    }

    public function provide(resolver:Resolver = null):Object {
        return value;
    }

}
}
