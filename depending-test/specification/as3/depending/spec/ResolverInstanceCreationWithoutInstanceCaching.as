package as3.depending.spec {
import as3.depending.examples.tests.Instance;

import org.flexunit.assertThat;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;

//noinspection JSUnusedGlobalSymbols
public class ResolverInstanceCreationWithoutInstanceCaching extends ResolverInstanceCreation {


    override protected function additionalSetUp():void {
        super.additionalSetUp();
        adapter.usingInstanceCaching(false);
    }

    override protected function extendedAsserts(identifier:Class):void {
        assertThat(resolver.get(Instance), not(equalTo(resolver.get(Instance))));
    }

}
}
