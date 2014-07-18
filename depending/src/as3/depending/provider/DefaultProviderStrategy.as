package as3.depending.provider {
import as3.depending.Provider;

public class DefaultProviderStrategy implements ProviderStrategy {

    public function providerFor(value:*):Provider {
        if (value is Provider) {
            return value;
        } else if (value is Class) {
            return forClass(value);
        } else if (value is Function) {
            return forFactory(value);
        } else {
            return forValue(value);
        }
    }

    protected function forValue(value:*):ValueProvider {
        return new ValueProvider(value);
    }

    protected function forFactory(value:Function):FactoryProvider {
        return new FactoryProvider(value);
    }

    protected function forClass(value:Class):TypeProvider {
        return new TypeProvider(value);
    }
}
}
