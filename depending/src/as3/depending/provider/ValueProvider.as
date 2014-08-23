package as3.depending.provider {
/**
 * Each instance of this provider always returns the given value.
 */
public class ValueProvider implements ProviderZero, ProvidingSameInstance, ProvidingTyped {

    protected var value:Object;

    public function get type():Class {
        return value == null ? null : value.constructor;
    }

    public function ValueProvider(value:Object) {
        this.value = value;
    }

    public function provide():Object {
        return value;
    }

}
}
