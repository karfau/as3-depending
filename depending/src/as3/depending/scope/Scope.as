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

    public var implicitResolving:ProviderStrategy;

    public function Scope(implicitResolving:ProviderStrategy = null) {
        this.implicitResolving = implicitResolving;
        mappings = {};
    }

    private var mappings:Object;

    override protected function doResolve(identifier:Object):* {
        if (specifies[identifier] is Providing) {
            return invokeProvider(specifies[identifier], this);
        }
        if (specifies[identifier] is Specified) {
            return Specified(specifies[identifier]).provide();
        }
        var mapping:Mapping = identifier is Class ? getMapping(Class(identifier)) : null;
        if (mapping == null) {
            if(implicitResolving){
                var provider:Providing = implicitResolving.providerFor(identifier);
                if(provider){
                    var value:Object = invokeProvider(provider, this);
                }
                return value;
            }
            throw new Error("Scope can not resolve " + identifier);
        }
        return mapping.getValue();
    }

    public function isSpecified(type:*):Boolean {
        return specifies[type] || getMapping(type) != null;
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

//noinspection SpellCheckingInspection
    private const specifies:Object = {};

    public function specify(identifier:Object, ...specification):Specified {
        var value:Object = specification.length == 1 ? specification[0] : identifier;
        const provider:Providing = providerStrategy.providerFor(value);
        var specified:Specified = specifies[identifier] as Specified;
        if(specified == null){
            specified = new Specified(this);
            specifies[identifier] = specified;
        }
        specified.setProviding(provider);
        if (value != null && identifier === value){
            specifies[value.constructor] = provider
        }
        return specified;
    }

    protected function createMapping(type:Class):Mapping {
        return new Mapping(type, this);
    }

    private function getMapping(type:Class):Mapping {
        var mapping:Mapping = Mapping(mappings[type]);
        return mapping;
    }

}
}
