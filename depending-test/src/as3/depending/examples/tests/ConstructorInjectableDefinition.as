package as3.depending.examples.tests {
import as3.depending.Resolver;

public class ConstructorInjectableDefinition implements IResolverSpecDefinition {
    private var _resolver:Resolver;

    public function get resolver():Resolver {
        return _resolver;
    }

    public function ConstructorInjectableDefinition(resolver:Resolver) {
        _resolver = resolver;
    }
}
}
