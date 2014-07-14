package as3.depending.scope {
import as3.depending.Provider;

/**
 * Each instance of this provider creates a new instance of the given Class,
 * by calling its constructor with zero arguments.
 */
public class TypeProvider implements Provider {

    private var Impl:Class;

    public function TypeProvider(implementation:Class) {
        this.Impl = implementation;
    }

    public function provide():Object {
        return new Impl();
    }

    public function get providesResolved():Boolean {
        return false;
    }
}
}
