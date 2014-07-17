package as3.depending.scope {
import as3.depending.Provider;

public class MappingStrategy implements ProviderStrategy {
    public function MappingStrategy() {
    }

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
