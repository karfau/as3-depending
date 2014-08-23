package as3.depending.scope {
import as3.depending.*;
import as3.depending.provider.DefaultProviderStrategy;
import as3.depending.provider.ProviderStrategy;

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
public class Scope implements RelaxedResolver {

//noinspection SpellCheckingInspection
    private var _specifies:IdentifierMap;

    public function isSpecified(identifier:*):Boolean {
        return _specifies.has(identifier);
    }

    private var _resolver:IdentifierMapResolver;

    public function get resolver():RelaxedResolver {
        return _resolver;
    }

    public function get(identifier:Object):* {
        return _resolver.get(identifier);
    }

    public function optionally(identifier:Object):* {
        return _resolver.optionally(identifier);
    }

    public function set implicitResolving(value:ProviderStrategy):void {
        _resolver.implicitResolving = value;
    }

/*
    public function get implicitResolving():ProviderStrategy {
        return _resolver.implicitResolving;
    }
*/

    public function Scope(implicitResolving:ProviderStrategy = null) {
        _specifies = new IdentifierMap();
        _resolver = new IdentifierMapResolver(_specifies);
        _resolver.implicitResolving = implicitResolving;
        mappings = {};
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
