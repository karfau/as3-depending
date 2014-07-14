package as3.depending.scope {
import as3.depending.Provider;

/**
 * This provider invokes the given method with the given parameters on each invoke.
 */
public class FactoryProvider implements Provider {

    private var factory:Function;
    private var params:Array;

    public function FactoryProvider(factory:Function, params:Array) {
        this.factory = factory;
        this.params = params;
    }

    public function provide():Object {
        return factory.apply(null, params);
    }

    public function get providesResolved():Boolean {
        return true;
    }
}
}
