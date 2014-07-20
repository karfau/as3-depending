package as3.depending {
import as3.depending.examples.tests.Instance;

import org.flexunit.asserts.assertTrue;
import org.hamcrest.collection.array;

public class TestBaseRelaxedResolver {

    private var resolver:BaseRelaxedResolver;

    [Before]
    public function setUpResolver():void {
        resolver = new BaseRelaxedResolver();
    }

    [Test(expects="as3.depending.errors.UnresolvedDependencyError")]
    public function get_throws_UnresolvedDependencyError():void {
        resolver.get(Instance);
    }

    [Test]
    public function optionally_returns_undefined():void {
        assertTrue(resolver.optionally(Instance) === undefined);
    }

    [Test]
    public final function get_invokes_doResolve():void {
        var resolver:TestableRelaxedResolver = new TestableRelaxedResolver();
        resolver.get(Instance);
        resolver.invokes.assertWasInvokedWith(resolver.doResolve$,array(Instance));
    }

    [Test]
    public final function optionally_invokes_doResolve():void {
        var resolver:TestableRelaxedResolver = new TestableRelaxedResolver();
        resolver.optionally(Instance);
        resolver.invokes.assertWasInvokedWith(resolver.doResolve$,array(Instance));
    }
}
}

import as3.depending.BaseRelaxedResolver;
import as3.depending.scope.impl.Invokes;

class TestableRelaxedResolver extends BaseRelaxedResolver{

    private var _invokes:Invokes;
    public function get invokes():Invokes {
        return _invokes;
    }

    public function TestableRelaxedResolver() {
        this._invokes = new Invokes();
    }

    public function get doResolve$():Function {
        return doResolve;
    }
    override protected function doResolve(identifier:Object):* {
        _invokes.invoke(doResolve,identifier);
        return undefined;
    }


}
