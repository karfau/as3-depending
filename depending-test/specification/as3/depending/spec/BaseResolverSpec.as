package as3.depending.spec {
import as3.depending.Resolver;

import org.flexunit.asserts.assertNotNull;

public class BaseResolverSpec {
    protected var adapter:ResolverAdapter;

    public function BaseResolverSpec() {
    }

    protected function get resolver():Resolver {
        return adapter.resolver;
    }

    protected function createAdapter():ResolverAdapter {
        return new ResolverAdapter();
    }

    [Before]
    public function setUpResolver():void {
        adapter = createAdapter();
        assertNotNull(resolver);
    }

    protected final function failNotImplemented(feature:String):void {
        adapter.failNotImplemented(feature);
    }
}
}
