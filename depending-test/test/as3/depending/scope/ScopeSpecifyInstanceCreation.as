package as3.depending.scope {
import as3.depending.spec.RelaxedResolverInstanceCreation;
import as3.depending.spec.ResolverAdapter;

public class ScopeSpecifyInstanceCreation extends RelaxedResolverInstanceCreation {


    override protected function createAdapter():ResolverAdapter {
       return new ScopeSpecifyAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
