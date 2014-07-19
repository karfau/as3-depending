package as3.depending.spec {
import as3.depending.RelaxedResolver;
import as3.depending.Resolver;

import org.flexunit.assertThat;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.hamcrest.core.both;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.strictlyEqualTo;

public class BaseResolverSpec {

    protected var adapter:ResolverAdapter;

    protected function get resolver():Resolver {
        return adapter.resolver;
    }

    protected function get relaxedResolver():RelaxedResolver {
        return adapter.relaxedResolver;
    }

    protected function createAdapter():ResolverAdapter {
        return null;
    }

    [Before]
    public final function setUpResolver():void {
        adapter = createAdapter();
        assertNotNull("has to implement createAdapter()", resolver);
        if (resolver is RelaxedResolver) {
            assertRelaxedResolver();
        }
        additionalSetUpReachedSuper = false;
        additionalSetUp();
        assertTrue(this + ".additionalSetUp() is not calling super.additionalSetUp()", additionalSetUpReachedSuper);
    }

    private function assertRelaxedResolver():void {
        assertThat(relaxedResolver, both(notNullValue()).and(strictlyEqualTo(resolver)));
    }

    //noinspection JSFieldCanBeLocal
    private var additionalSetUpReachedSuper:Boolean;
    protected function additionalSetUp():void {
        additionalSetUpReachedSuper = true;
    }

    protected final function failNotImplemented(feature:String):void {
        adapter.failNotImplemented(feature);
    }
}
}
