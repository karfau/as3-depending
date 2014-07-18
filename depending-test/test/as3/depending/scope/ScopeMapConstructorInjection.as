package as3.depending.scope {
import as3.depending.spec.RelaxedResolverConstructorInjection;
import as3.depending.spec.ResolverAdapter;

public class ScopeMapConstructorInjection extends RelaxedResolverConstructorInjection {


    override protected function createAdapter():ResolverAdapter {
        return new ScopeMapAdapter();
    }

    [Test]
    public function forceInheritedTests():void {
        //if a class has no testMethod it will not execute the inherited tests
    }
}
}
