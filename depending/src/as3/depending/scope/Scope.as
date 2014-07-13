package as3.depending.scope {
import as3.depending.*;
import as3.depending.errors.UnresolvedDependencyError;

import flash.utils.getQualifiedClassName;

/**
 * This implementation of Resolver offers the possibility to configure the decisions about how to resolve dependencies at runtime,
 * using a fluid API similar to the one from Guice.
 *
 * It only contains a list of the decisions that have been made, the Mappings.
 */
public class Scope extends BaseResolver{

    private var mappings:Object;

    private function getMapping(type:Class):Mapping {
        var mapping:Mapping = Mapping(mappings[type]);
        return mapping;
    }

    public function Scope() {
        mappings = {};
    }

    public function map(type:Class):Mapping {
        var mapping:Mapping = getMapping(type);
        if (mapping == null) {
            mapping = createMapping(type);
            setMapping(type, mapping);
        }
        return mapping;
    }

    private function setMapping(type:Class, mapping:Mapping):void {
        mappings[type] = mapping;
    }

    internal function createMapping(type:Class):Mapping {
        return new Mapping(type, this);
    }

    override protected function doResolve(clazz:Class):* {
        var mapping:Mapping = getMapping(clazz);
        if (mapping != null) {
            return mapping.getValue();
        }
        mapping = createMapping(clazz);
        var value:Object = mapping.getValue();
        setMapping(clazz, mapping);
        return value;
    }
}
}
