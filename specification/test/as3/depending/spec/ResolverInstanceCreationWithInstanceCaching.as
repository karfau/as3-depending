package as3.depending.spec {
import org.flexunit.assertThat;
import org.hamcrest.object.strictlyEqualTo;

//noinspection JSUnusedGlobalSymbols
public class ResolverInstanceCreationWithInstanceCaching extends ResolverInstanceCreation {


    override protected function additionalSetUp():void {
        super.additionalSetUp();
        adapter.usingInstanceCaching(true);
    }

    override protected function extendedAsserts(identifier:Class):void {
        assertThat(resolver.get(identifier), strictlyEqualTo(resolver.get(identifier)));
    }

}
}
