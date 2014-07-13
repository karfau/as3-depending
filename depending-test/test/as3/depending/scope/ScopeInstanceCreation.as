package as3.depending.scope {
import as3.depending.spec.ResolverAdapter;
import as3.depending.spec.ResolverInstanceCreation;

public class ScopeInstanceCreation extends ResolverInstanceCreation {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
