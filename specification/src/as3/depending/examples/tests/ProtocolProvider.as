package as3.depending.examples.tests {
import as3.depending.provider.ProviderZero;

public class ProtocolProvider implements ProviderZero {

    public function provide():Object {
        return new ProtocolImpl();
    }

}
}
