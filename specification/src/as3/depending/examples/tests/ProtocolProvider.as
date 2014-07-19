package as3.depending.examples.tests {
import as3.depending.Provider;
import as3.depending.Resolver;

public class ProtocolProvider implements Provider {

    public function provide(resolver:Resolver = null):Object {
        return new ProtocolImpl();
    }

}
}
