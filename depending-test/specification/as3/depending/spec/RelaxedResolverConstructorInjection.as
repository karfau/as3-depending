package as3.depending.spec {
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.IResolverSpecProtocol;

import org.flexunit.assertThat;
import org.hamcrest.object.strictlyEqualTo;

public class RelaxedResolverConstructorInjection extends ResolverConstructorInjection {

    [Test]
    public function resolving_a_defined_type_optionally():void {
        adapter.specifyConstructorInjectableProtocolForResolver();
        assertThat(IResolverSpecProtocol(relaxedResolver.optionally(ConstructorInjectableProtocol)).resolver, strictlyEqualTo(resolver));
    }

    [Test]
    public function resolving_an_implementation_optionally():void {
        adapter.specifyConstructorInjectableProtocolAsImplementationForResolver(IResolverSpecProtocol);
        assertThat(IResolverSpecProtocol(relaxedResolver.optionally(IResolverSpecProtocol)).resolver, strictlyEqualTo(resolver));
    }

    //TODO: 'inline configuration' for constructor injection

}
}
