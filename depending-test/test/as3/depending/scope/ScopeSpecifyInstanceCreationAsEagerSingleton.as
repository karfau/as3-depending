package as3.depending.scope {
import as3.depending.spec.*;

public class ScopeSpecifyInstanceCreationAsEagerSingleton extends RelaxedResolverInstanceCreationWithInstanceCaching {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeMapAdapter();
    }


    override protected function additionalSetUp():void {
        super.additionalSetUp();
        ScopeMapAdapter(adapter).useEagerSingleton = true;
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
