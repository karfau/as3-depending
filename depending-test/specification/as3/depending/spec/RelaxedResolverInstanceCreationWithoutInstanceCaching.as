package as3.depending.spec {
import org.flexunit.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;

public class RelaxedResolverInstanceCreationWithoutInstanceCaching extends RelaxedResolverInstanceCreation {


    override protected function additionalSetUp():void {
        super.additionalSetUp();
        adapter.usingInstanceCaching(false);
    }

    override protected function extendedAsserts(identifier:Class):void {
        assertThat(resolver.get(identifier), not(equalTo(resolver.get(identifier))));
    }

}
}
