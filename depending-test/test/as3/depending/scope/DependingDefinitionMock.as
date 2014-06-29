package as3.depending.scope {
import as3.depending.examples.tests.*;
import as3.depending.Depending;
import as3.depending.Resolver;

public class DependingDefinitionMock implements IDefinition, Depending {

    public const callsTo_fetchDependencies:Array = [];

    public function fetchDependencies(resolver:Resolver):void {
        callsTo_fetchDependencies.push([resolver]);
    }

}
}
