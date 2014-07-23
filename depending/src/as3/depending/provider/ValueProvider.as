package as3.depending.provider {
/**
 * Each instance of this provider always returns the given value.
 */
public class ValueProvider implements ProviderZero, SameInstanceProviding {
    protected var value:Object;

    public function ValueProvider(value:Object) {
        this.value = value;
    }

    public function provide():Object {
        return value;
    }

}
}
