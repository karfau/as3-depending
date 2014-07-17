package as3.depending.provider {
import as3.depending.Provider;
import as3.depending.Resolver;

/**
 * This provider invokes the given method with the given parameters on each invoke.
 *
 * When the factory method takes one argument and no params are provided,
 * the resolver given to provide() will be used as single parameter.
 *
 * That means methods with a signature similar to Provider.provide will be supported
 * without setting a resolver instance at construction time.
 */
public class FactoryProvider implements Provider {

    private var factory:Function;
    private var params:Array;

    public function FactoryProvider(factory:Function, params:Array = null) {
        this.factory = factory;
        this.params = params;
    }

    public function provide(resolver:Resolver = null):Object {
        var value:Object;
        if(factory.length == 1 && (params == null || params.length == 0)){
            value = factory(resolver);
        }else{
            value = factory.apply(null, params);
        }
        return value;
    }

}
}
