package as3.depending.scope.impl {
import as3.depending.examples.tests.*;
import as3.depending.Depending;
import as3.depending.Resolver;

public class DependingDefinitionMock implements IDefinition, Depending {

    public static var invokes:Invokes;

    public static var lastInstance:DependingDefinitionMock;


    public function DependingDefinitionMock() {
        lastInstance = this;
    }

    public function fetchDependencies(resolver:Resolver):void {
        invokes.invoke(fetchDependencies, resolver);
    }

}
}
