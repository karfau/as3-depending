package as3.depending.provider {
import as3.depending.scope.impl.*;
import as3.depending.Provider;
import as3.depending.Resolver;
import as3.depending.examples.tests.Instance;

public class ProviderMock implements Provider {

    private var invokes:Invokes;

    public function ProviderMock(invokes:Invokes = null) {
        this.invokes = invokes;
    }

    public function provide(resolver:Resolver = null):Object {
        if(invokes){
            invokes.invoke(provide,resolver);
        }
        return new Instance();
    }

}
}
