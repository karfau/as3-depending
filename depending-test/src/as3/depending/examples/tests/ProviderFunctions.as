package as3.depending.examples.tests {
import as3.depending.Resolver;

public class ProviderFunctions {

    public static function DefinitionProvider():IDefinition {
        return new DefinitionImpl();
    }

    public static function ResolvedDefinitionProvider(resolver:Resolver):IDefinition {
        return new ResolvedDefinition(resolver);
    }
}
}
