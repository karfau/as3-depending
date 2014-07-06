package as3.depending.examples.factory {
import as3.depending.Depending;
import as3.depending.Resolver;
import as3.depending.examples.factory.engine.IEngine;

public class Car implements Depending{

    private var inspectedBy:Inspector;

    private var engine:IEngine;

    public function fetchDependencies(resolver:Resolver):void {
        engine = resolver.get(IEngine);
        inspectedBy = resolver.get(Inspector);
    }

    private var _speed:Number = 0;
    public function get speed():Number {
        return _speed;
    }

    public function accelerate():void {
        _speed += engine.power;
    }

    public function toString():String {
        return "Car{inspectedBy " + String(inspectedBy.name) + "}";
    }

}
}
