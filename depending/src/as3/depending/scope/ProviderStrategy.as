package as3.depending.scope {
import as3.depending.Provider;

public interface ProviderStrategy {
    function createProviderFor(value:*):Provider;
}
}
