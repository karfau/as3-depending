package as3.depending.examples.tests {
import as3.depending.Provider;
import as3.depending.examples.tests.DefinitionImpl;

public class DefinitionProvider implements Provider {

    public function provide():Object {
        return new DefinitionImpl();
    }

    public function get providesResolved():Boolean {
        return false;
    }
}
}
