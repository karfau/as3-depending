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

    public function specify(...specification):void {
        var mapping:Mapping = map(specification[0]);
        if (specification.length == 2) {
            if (specification[1] is Class) {
                mapping.toType(specification[1]);
            } else if (specification[1] is Provider) {
                mapping.toProvider(specification[1]);
            } else  if (specification[1] is Function) {
                mapping.toFactory(specification[1]);
            } else {
                mapping.toInstance(specification[1]);
            }
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
