package as3.depending.examples.tests {
public class ProviderFunctions {

    public static function DefinitionProvider():IDefinition {
        return new DefinitionImpl();
    }
}
}
