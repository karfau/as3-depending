package as3.depending.examples.tests {
import as3.depending.Resolver;

public class ProtocolProviderFunctions {

    public static function DefinitionProvider():IProtocol {
        return new ProtocolImpl();
    }

    public static function ConstructorInjectableDefinitionProvider(resolver:Resolver):IProtocol {
        return new ConstructorInjectableProtocol(resolver);
    }
}
}
