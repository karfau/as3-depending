package as3.depending.provider {
import as3.depending.Providing;

public class DefaultProviderStrategy implements ProviderStrategy {

    public var strategies:Vector.<ProviderStrategy>;

    public var staticTypeFactoryConvention:String = "create";

    public function providerFor(value:*):Providing {
        if (value is Providing) {
            return value;
        }
        var result:Providing;
        for each (var strategy:ProviderStrategy in strategies) {
            if(strategy){
                result = strategy.providerFor(value);
                if(result){
                    return result;
                }
            }
        }
        if (value is Class) {
            if(value.hasOwnProperty(staticTypeFactoryConvention)){
                var factory:Function = value[staticTypeFactoryConvention] as Function;
                if(factory != null){
                    return forFactory(factory);
                }
            }
            return forClass(value);
        }
        if (value is Function) {
            return forFactory(value);
        }
        return forValue(value);
    }

    protected function forValue(value:*):ValueProvider {
        return new ValueProvider(value);
    }

    protected function forFactory(value:Function):FactoryProvider {
        return new FactoryProvider(value);
    }

    protected function forClass(value:Class):TypeProvider {
        return new TypeProvider(value);
    }

    public function add(addition:ProviderStrategy):void {
        if(strategies == null){
            strategies = new Vector.<ProviderStrategy>();
        }
        strategies.push(addition);
    }
}
}
