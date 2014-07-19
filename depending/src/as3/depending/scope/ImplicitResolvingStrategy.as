package as3.depending.scope {
import as3.depending.Provider;
import as3.depending.provider.ProviderStrategy;
import as3.depending.provider.TypeProvider;

public class ImplicitResolvingStrategy implements ProviderStrategy {

    public function providerFor(value:*):Provider {
        return new TypeProvider(value);
    }
}
}
