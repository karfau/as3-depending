package as3.depending.scope {
import as3.depending.*;
import as3.depending.provider.DefaultProviderStrategy;
import as3.depending.provider.ProviderStrategy;

/**
 * This implementation of Resolver offers the possibility to configure the decisions about how to resolve dependencies at runtime,
 * using a fluid API similar to the one from Guice.
 *
 * It only contains a list of the decisions that have been made, the Mappings.
 */
public class Scope extends BaseRelaxedResolver {

    public var implicitResolving:ProviderStrategy;

    public function Scope(implicitResolving:ProviderStrategy = null) {
        this.implicitResolving = implicitResolving;
        mappings = {};
    }

    private var mappings:Object;

    override protected function doResolve(clazz:Class):* {
        if (specifies[clazz] is Provider) {
            return Provider(specifies[clazz]).provide(this);
        }
        var mapping:Mapping = getMapping(clazz);
        if (mapping == null) {
            if(implicitResolving){
                var provider:Provider = implicitResolving.providerFor(clazz);
                if(provider){
                    var value:Object = provider.provide(this);
                }
                return value;
            }
            throw new Error("Scope can not resolve " + clazz);
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
            setMapping(type, mapping);
        }
        return mapping;
    }

    private var strategy:DefaultProviderStrategy;
    //noinspection SpellCheckingInspection
    private const specifies:Object = {};

    public function specify(identity:Object, ...specification):Specified {
        if(strategy == null){
            strategy = new DefaultProviderStrategy();
        }

        var value:Object = specification.length == 1 ? specification[0] : identity;
        const provider:Provider = strategy.providerFor(value);
        specifies[identity] = provider;
        if (value != null && identity === value){
            specifies[value.constructor] = provider
        }
        return new Specified(this);
    }

    protected function createMapping(type:Class):Mapping {
        return new Mapping(type, this);
    }

    private function getMapping(type:Class):Mapping {
        var mapping:Mapping = Mapping(mappings[type]);
        return mapping;
    }

    private function setMapping(type:Class, mapping:Mapping):void {
        mappings[type] = mapping;
    }
}
}
