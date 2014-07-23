package as3.depending.provider {
import as3.depending.Resolver;
import as3.depending.examples.tests.Instance;
import as3.depending.scope.impl.*;

public class ProviderMock implements ProviderExpecting {

    protected var invokes:Invokes;
    private var _last:Object;
    public function get lastProvided():Object {
        return _last;
    }

    public function ProviderMock(invokes:Invokes = null) {
        this.invokes = invokes;
    }

    public function provide(resolver:Resolver):Object {
        if(invokes){
            invokes.invoke(provide,resolver);
        }
        _last = new Instance();
        return  _last;
    }

    public static const Null:ValueProvider = new ValueProvider(null);

    public static function Failing(invokes:Invokes):ProviderMock {
        return new FailingProviderMock(invokes);
    }

}
}

import as3.depending.Resolver;
import as3.depending.provider.CustomError;
import as3.depending.provider.ProviderMock;
import as3.depending.scope.impl.Invokes;

class FailingProviderMock extends ProviderMock{
    public function FailingProviderMock(invokes:Invokes) {
        super(invokes);
    }

    override public function provide(resolver:Resolver):Object {
        invokes.invoke(provide,resolver);
        throw new CustomError();
    }
}
