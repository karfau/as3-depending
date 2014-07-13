package as3.depending.spec {
import as3.depending.errors.UnresolvedDependencyError;
import as3.depending.examples.tests.IDefinition;
import as3.depending.examples.tests.NotConstructable;

import org.flexunit.assertThat;
import org.hamcrest.core.throws;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.nullValue;

public class ResolverNoInstanceCreation extends BaseResolverSpec {

    protected function resolver_get_expecting_UnresolvedDependencyError(clazz:Class):*{
        try{
            assertThat(
                    function ():void {
                        resolver.get(clazz);
                    },
                    throws(instanceOf(UnresolvedDependencyError))
            );
        }catch(error:Error){
            failNotImplemented("throwing an UnresolvedDependencyError");
        }
    }

    [Test]
    public function resolving_an_undefined_definition():void {
        resolver_get_expecting_UnresolvedDependencyError(IDefinition);
    }

    [Test]
    public function resolving_null():void {
        adapter.defineAnImplementingInstanceForResolver(IDefinition,null);
        try{
            assertThat( resolver.get(IDefinition), nullValue());
        }catch(error:Error){
            failNotImplemented("should resolve null when defined");
        }
    }

    [Test]
    public function resolving_a_defined_type_throwing():void {
        adapter.defineTypeForResolver(NotConstructable);
        resolver_get_expecting_UnresolvedDependencyError(NotConstructable);
    }

    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing
}
}
