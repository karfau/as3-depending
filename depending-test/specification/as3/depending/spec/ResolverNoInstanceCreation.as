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

    protected function resolver_optionally_expecting_undefined(clazz:Class):*{
        try{
            assertThat(resolver.optionally(clazz), nullValue());
        }catch(error:Error){
            failNotImplemented("returning undefined");
        }
    }

    [Test]
    public function resolving_an_undefined_definition():void {
        resolver_get_expecting_UnresolvedDependencyError(IDefinition);
    }

    [Test]
    public function resolving_an_undefined_definition_optionally():void {
        resolver_optionally_expecting_undefined(IDefinition);
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
    public function resolving_null_optionally():void {
        adapter.defineAnImplementingInstanceForResolver(IDefinition,null);
        try{
            assertThat( resolver.optionally(IDefinition), nullValue());
        }catch(error:Error){
            failNotImplemented("should resolve null when defined");
        }
    }

    [Test]
    public function resolving_a_defined_type_throwing():void {
        adapter.defineTypeOnResolver(NotConstructable);
        resolver_get_expecting_UnresolvedDependencyError(NotConstructable);
    }

    [Test]
    public function resolving_a_defined_type_throwing_optionally():void {
        adapter.defineTypeOnResolver(NotConstructable);
        resolver_optionally_expecting_undefined(NotConstructable);
    }

    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing
}
}
