package as3.depending.examples.tests {
import as3.depending.Resolver;

public class InlineConstructorInjectableProtocol implements IResolverSpecProtocol {

    public static function create(resolver:Resolver):InlineConstructorInjectableProtocol {
        return new InlineConstructorInjectableProtocol(resolver);
    }

    private var _resolver:Resolver;

    public function get resolver():Resolver {
        return _resolver;
    }

    public function InlineConstructorInjectableProtocol(resolver:Resolver) {
        _resolver = resolver;
    }
}
}
