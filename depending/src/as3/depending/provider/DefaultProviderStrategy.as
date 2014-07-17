package as3.depending.provider {
import as3.depending.Provider;

public class DefaultProviderStrategy implements ProviderStrategy {

    public function createProviderFor(value:*):Provider {
        if (value is Class) {
            return new TypeProvider(value);
        } else if (value is Function) {
            return new FactoryProvider(value);
        } else {
            return new ValueProvider(value);
        }
    }
}
}
