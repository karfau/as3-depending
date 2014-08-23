package as3.depending.scope {
import as3.depending.*;
import as3.depending.provider.DefaultProviderStrategy;
import as3.depending.provider.ProviderStrategy;
import as3.depending.provider.invokeProvider;

/**
 * This implementation of Resolver offers the possibility to specify the decisions about how to resolve dependencies at runtime.
 *
 * At the moment there are two ways to specify things:
 * - map() is the fluid one that is all about being explicit and type safe
 * - specify() which has the goal to offer as much flexibility as possible
 *
 * It is no problem to use both methods on one instance,
 * when used with the same identifier the one that is executed last wins.
 *
 * For an example of how to use them:
 * @see https://github.com/karfau/as3-depending/blob/master/depending-test/test/as3/depending/scope/ScopeMapAdapter.as
 * @see https://github.com/karfau/as3-depending/blob/master/depending-test/test/as3/depending/scope/ScopeSpecifyAdapter.as
 *
 */
public class Scope extends BaseRelaxedResolver {

//noinspection SpellCheckingInspection
    private var _specifies:IdentifierMap;

    public var implicitResolving:ProviderStrategy;

    public function Scope(implicitResolving:ProviderStrategy = null) {
        this.implicitResolving = implicitResolving;
        _specifies = new IdentifierMap();
        mappings = {};
    }

    override protected function doResolve(identifier:Object):* {
        if(_specifies.has(identifier)){
            return invokeProvider(_specifies.get(identifier), this);
        }
        if(implicitResolving){
            var provider:Providing = implicitResolving.providerFor(identifier);
            if(provider){
                var value:Object = invokeProvider(provider, this);
            }
            return value;
        }
        throw new Error("Scope can not resolve " + identifier);
    }

    public function isSpecified(identifier:*):Boolean {
        return _specifies.has(identifier);
    }

    private var mappings:Object;

    protected function createMapping(type:Class):Mapping {
        return new Mapping(type, this);
    }

    private function getMapping(type:Class):Mapping {
        var mapping:Mapping = Mapping(mappings[type]);
        return mapping;
    }

    public function map(type:Class):Mapping {
        var mapping:Mapping = getMapping(type);
        if (mapping == null) {
            mapping = createMapping(type);
            mappings[type] = mapping;
        }
        return mapping;
    }

    private var _providerStrategy:DefaultProviderStrategy;
    public function get providerStrategy():DefaultProviderStrategy {
        if(_providerStrategy == null){
            _providerStrategy = new DefaultProviderStrategy();
        }
        return _providerStrategy;
    }

    public function specify(identifier:Object, value:* = undefined):Specified {
        if(value === undefined){
            value = identifier;
        }
        const providing:Providing = providerStrategy.providerFor(value);
        var specified:Specified = _specifies.get(identifier) as Specified;
        if(specified == null){
            specified = new Specified(this);
            _specifies.set(identifier, specified);
        }
        specified.setProviding(providing);
        if (identifier === value && value != null && !(value is Providing)) {
            _specifies.set(value.constructor, providing/*new FactoryProvider(specified.provide)*/);
        }
        return specified;
    }

}
}
