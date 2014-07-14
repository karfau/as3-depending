package as3.depending.examples.tests {
import as3.depending.Resolver;

public class ConstructorInjectableProtocol implements IResolverSpecProtocol {
    private var _resolver:Resolver;

    public function get resolver():Resolver {
        return _resolver;
    }

    public function ConstructorInjectableProtocol(resolver:Resolver) {
        _resolver = resolver;
    }
}
}
