package as3.depending.spec {
import as3.depending.errors.UnresolvedDependencyError;
import as3.depending.examples.tests.IProtocol;
import as3.depending.examples.tests.NotConstructableProtocol;
import as3.depending.examples.tests.ProtocolImpl;

import org.flexunit.assertThat;
import org.hamcrest.object.equalTo;
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
    public function resolving_an_instance_using_its_type():void {
        const instance:ProtocolImpl = new ProtocolImpl();
        adapter.specifyAValueForResolver(instance);
        assertThat(resolver.get(ProtocolImpl), strictlyEqualTo(instance));
    }

    [Test]
    public function resolving_null():void {
        adapter.specifyAValueForResolver(null);
        assertThat( resolver.get(null), nullValue());
    }

    [Test]
    public function resolving_a_value_by_String_identifier():void {
        const identifier:String = "id";
        const value:int = 5;
        adapter.specifyAValueByIdentifier(identifier, value);
        assertThat(resolver.get(identifier), equalTo(value));
    }

    [Test]
    public function resolving_null_for_a_definition():void {
        adapter.specifyAnImplementingInstanceForResolver(IProtocol,null);
        try{
            assertThat( resolver.get(IProtocol), nullValue());
        }catch(error:Error){
            failNotImplemented("should resolve null when specified");
        }
    }

    [Test]
    public function resolving_an_unspecified_definition():void {
        resolver_get_expecting_UnresolvedDependencyError(IProtocol);
    }

    [Test]
    public function resolving_an_unspecified_identifier():void {
        resolver_get_expecting_UnresolvedDependencyError("missing");
    }

    [Test]
    public function resolving_a_specified_type_throwing():void {
        adapter.specifyTypeForResolver(NotConstructableProtocol);
        resolver_get_expecting_UnresolvedDependencyError(NotConstructableProtocol);
    }

    [Test]
    public function resolving_a_specified_interface_throwing():void {
        adapter.specifyTypeForResolver(IProtocol);
        resolver_get_expecting_UnresolvedDependencyError(IProtocol);
    }

    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing

    protected function resolver_get_expecting_UnresolvedDependencyError(identifier:Object):*{
        var unresolved:UnresolvedDependencyError;
        try{
            resolver.get(identifier);
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
