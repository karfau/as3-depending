package as3.depending.scope {
import as3.depending.*;

/**
 * This implementation of Resolver offers the possibility to configure the decisions about how to resolve dependencies at runtime,
 * using a fluid API similar to the one from Guice.
 *
 * It only contains a list of the decisions that have been made, the Mappings.
 */
public class Scope extends BaseRelaxedResolver {

    public function Scope() {
        mappings = {};
    }

    private var mappings:Object;

    override protected function doResolve(clazz:Class):* {
        var mapping:Mapping = getMapping(clazz);
        if (mapping == null) {
            throw new Error("Scope can not resolve " + clazz);
        }
        return mapping.getValue();
//        mapping = createMapping(clazz);
//        var value:Object = mapping.getValue();
//        setMapping(clazz, mapping);
//        return value;
    }

    public function hasMapping(type:Class):Boolean {
        return getMapping(type) != null;
    }

    public function map(type:Class):Mapping {
        var mapping:Mapping = getMapping(type);
        if (mapping == null) {
            mapping = createMapping(type);
            setMapping(type, mapping);
        }
        return mapping;
    }



    public function specify(identity:Object, ...specification):void {
        var value:Object = specification.length == 1 ? specification[0] : identity;

        var mapping:Mapping = map(Class(identity));
        if (value is Class) {
            mapping.toType(Class(value));
        } else if (value is Provider) {
            mapping.toProvider(Provider(value));
        } else  if (value is Function) {
            var f:Function = value as Function;//hard cast to Function is not allowed, throws runtime error
            mapping.toFactory(f);
        } else {
            mapping.toInstance(value);
        }
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
