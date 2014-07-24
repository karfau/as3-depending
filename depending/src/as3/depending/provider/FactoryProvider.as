package as3.depending.provider {
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
public class FactoryProvider implements ProviderExpecting {

    internal static function argumentList(resolver:Resolver, parameters:Array, parameterMapper:Function):Array {
        if(parameters != null && parameters.length > 0){
            const result:Array = new Array(parameters.length);
            for (var i:int = 0; i < parameters.length; i++) {
                result[i] = parameterMapper(resolver, parameters[i]);
            }
            return result;
        }
        return parameters
    }

    private var factory:Function;
    private var params:Array;

    public function FactoryProvider(factory:Function, parameters:Array = null) {
        if(factory == null){
            throw new ArgumentError('expected Function but was null');
        }
        if(factory.length == 1 && (parameters == null || parameters.length == 0)){
            parameters = [Resolver];
        }
        var num:uint = parameters == null?0:parameters.length;
        if(factory.length > 0 && factory.length != num){
            throw new ArgumentError('factory expects '+factory.length+' arguments but received '+num+' parameters.');
        }
        this.factory = factory;
        this.params = parameters;
    }

    public function provide(resolver:Resolver):Object {
        return factory.apply(null, argumentList(resolver, params, resolveArgument));
    }

    protected function resolveArgument(resolver:Resolver, identifier:*):*{
        var type:Class = identifier as Class;
        return (type && resolver is type) ? resolver : identifier;
    }

}
}
