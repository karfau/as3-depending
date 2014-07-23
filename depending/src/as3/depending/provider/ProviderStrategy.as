package as3.depending.provider {
import as3.depending.Providing;

/**
 * A ProviderStrategy decides if it can return a Provider value.
 *
 * If it can't, it should return null, to allow the calling instance to ask other ProviderStrategies.
 *
 * The DefaultProviderStrategy is an implementation that always returns a Provider.
 */
public interface ProviderStrategy {
    function providerFor(value:*):Providing;
}
}
