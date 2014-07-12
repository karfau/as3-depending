package as3.depending.scope {
import as3.depending.Provider;

/**
 * Each instance of this provider always returns the given instance.
 */
public class InstanceProvider implements Provider {
    private var instance:Object;

    public function InstanceProvider(instance:Object) {
        this.instance = instance;
    }

    public function provide():Object {
        return instance;
    }

    public function get providesResolved():Boolean {
        return true;
    }
}
}
