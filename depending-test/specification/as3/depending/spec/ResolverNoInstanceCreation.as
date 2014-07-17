package as3.depending.spec {
import as3.depending.errors.UnresolvedDependencyError;
import as3.depending.examples.tests.IProtocol;
import as3.depending.examples.tests.NotConstructableProtocol;
import as3.depending.examples.tests.ProtocolImpl;

import org.flexunit.assertThat;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;

public class ResolverNoInstanceCreation extends BaseResolverSpec {


    [Test]
    public function resolving_an_implementing_instance():void {
        const instance:ProtocolImpl = new ProtocolImpl();
        adapter.specifyAnImplementingInstanceForResolver(IProtocol, instance);
        assertThat(resolver.get(IProtocol), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_null():void {
        adapter.specifyAValueForResolver(null);
        assertThat( resolver.get(null), nullValue());
    }

    [Test]
    public function resolving_null_for_a_definition():void {
        adapter.specifyAnImplementingInstanceForResolver(IProtocol,null);
        try{
            assertThat( resolver.get(IProtocol), nullValue());
        }catch(error:Error){
            failNotImplemented("should resolve null when defined");
        }
    }

    [Test]
    public function resolving_an_undefined_definition():void {
        resolver_get_expecting_UnresolvedDependencyError(IProtocol);
    }

    [Test]
    public function resolving_a_defined_type_throwing():void {
        adapter.specifyTypeForResolver(NotConstructableProtocol);
        resolver_get_expecting_UnresolvedDependencyError(NotConstructableProtocol);
    }

    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing

    protected function resolver_get_expecting_UnresolvedDependencyError(clazz:Class):*{
        var unresolved:UnresolvedDependencyError;
        try{
            resolver.get(clazz);
        }catch(error:UnresolvedDependencyError){
           unresolved = error;
        }catch(error:Error){
            failNotImplemented("expected an UnresolvedDependencyError but was: "+error.getStackTrace());
        }
        if(unresolved == null){
            failNotImplemented("expected an UnresolvedDependencyError but no error was thrown");
        }
    }

}
}
