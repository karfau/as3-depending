package as3.depending.examples.tests {
import as3.depending.Resolver;

public class ResolvedDefinition implements IDefinition {
    private var _resolver:Resolver;

    public function get resolver():Resolver {
        return _resolver;
    }

    public function ResolvedDefinition(resolver:Resolver) {
        _resolver = resolver;
    }
}
}
