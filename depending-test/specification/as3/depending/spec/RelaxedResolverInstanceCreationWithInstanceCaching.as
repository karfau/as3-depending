package as3.depending.spec {
import org.flexunit.assertThat;
import org.hamcrest.object.strictlyEqualTo;

public class RelaxedResolverInstanceCreationWithInstanceCaching extends RelaxedResolverInstanceCreation {


    override protected function additionalSetUp():void {
        super.additionalSetUp();
        adapter.usingInstanceCaching(true);
    }

    override protected function extendedAsserts(identifier:Class):void {
        assertThat(resolver.get(identifier), strictlyEqualTo(resolver.get(identifier)));
    }

}
}
