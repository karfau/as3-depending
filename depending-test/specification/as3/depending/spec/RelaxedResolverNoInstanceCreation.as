package as3.depending.spec {
import as3.depending.examples.tests.IProtocol;
import as3.depending.examples.tests.NotConstructableProtocol;

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
            failNotImplemented("expected undefined, but error was thrown: " + error.getStackTrace());
        }
    }

    [Test]
    public function resolving_an_undefined_definition_optionally():void {
        resolver_optionally_expecting_undefined(IProtocol);
    }

    [Test]
    public function resolving_a_defined_type_throwing_optionally():void {
        adapter.specifyTypeForResolver(NotConstructableProtocol);
        resolver_optionally_expecting_undefined(NotConstructableProtocol);
    }
    //TODO: everything that works in ResolverInstanceCreation can be tested how it behaves when failing while providing

    [Test]
    public function resolving_null_optionally():void {
        adapter.specifyAValueForResolver(null);
        assertThat( relaxedResolver.optionally(null), nullValue());
    }


    [Test]
    public function resolving_null_for_a_definition_optionally():void {
        adapter.specifyAnImplementingInstanceForResolver(IProtocol,null);
        assertThat( relaxedResolver.optionally(IProtocol), nullValue());
    }

}
}
