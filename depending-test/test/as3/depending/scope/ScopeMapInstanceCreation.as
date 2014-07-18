package as3.depending.scope {
import as3.depending.spec.RelaxedResolverInstanceCreation;
import as3.depending.spec.ResolverAdapter;

public class ScopeMapInstanceCreation extends RelaxedResolverInstanceCreation {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeMapAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
