package as3.depending.spec {
import as3.depending.examples.tests.IDefinition;
import as3.depending.examples.tests.NotConstructable;

import org.flexunit.assertThat;
import org.hamcrest.object.nullValue;

public class RelaxedResolverNoInstanceCreation extends ResolverNoInstanceCreation {


    [Before]
    override public function setUpResolver():void {
        super.setUpResolver();
        assertRelaxedResolver();
    }

    protected function resolver_optionally_expecting_undefined(clazz:Class):*{
        try{
            assertThat(relaxedResolver.optionally(clazz), nullValue());
        }catch(error:Error){
            failNotImplemented("returning undefined");
        }
    }

    [Test]
    public function resolving_an_undefined_definition_optionally():void {
        resolver_optionally_expecting_undefined(IDefinition);
    }

    [Test]
    public function resolving_null_optionally():void {
        adapter.defineAnImplementingInstanceForResolver(IDefinition,null);
        try{
            assertThat( relaxedResolver.optionally(IDefinition), nullValue());
        }catch(error:Error){
            failNotImplemented("should resolve null when defined");
        }
    }

    [Test]
    public function resolving_a_defined_type_throwing_optionally():void {
        adapter.defineTypeForResolver(NotConstructable);
        resolver_optionally_expecting_undefined(NotConstructable);
    }

    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing
}
}
