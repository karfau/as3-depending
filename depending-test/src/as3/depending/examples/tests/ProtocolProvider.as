package as3.depending.examples.tests {
import as3.depending.Provider;
import as3.depending.examples.tests.ProtocolImpl;

public class ProtocolProvider implements Provider {

    public function provide():Object {
        return new ProtocolImpl();
    }

    public function get providesResolved():Boolean {
        return false;
    }
}
}
