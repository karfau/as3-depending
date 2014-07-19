package as3.depending.spec {
import as3.depending.examples.tests.ConstructorInjectableProtocol;
import as3.depending.examples.tests.IResolverSpecProtocol;

import org.flexunit.assertThat;
import org.hamcrest.object.strictlyEqualTo;

public class ResolverConstructorInjection extends BaseResolverSpec {

    [Test]
    public function resolving_a_specified_type():void {
        adapter.specifyConstructorInjectableProtocolForResolver();
        assertResolverWasInjected(ConstructorInjectableProtocol);
    }

    [Test]
    public function resolving_an_implementation():void {
        adapter.specifyConstructorInjectableProtocolAsImplementationForResolver(IResolverSpecProtocol);
        assertResolverWasInjected(IResolverSpecProtocol);
    }

    [Test]
    public function resolving_a_type_with_inline_constructor_injection():void{
        adapter.specifyInlineConstructorInjectableProtocolForResolver();
        assertResolverWasInjected(IResolverSpecProtocol);
    }

    private function assertResolverWasInjected(definition:Class):void {
        assertThat(IResolverSpecProtocol(resolver.get(definition)).resolver, strictlyEqualTo(resolver));
    }

}
}
