package as3.depending.scope {
import as3.depending.*;
import as3.depending.errors.UnresolvedDependencyError;

import avmplus.getQualifiedClassName;

public class Scope implements Resolver {

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
            mapping.resolver = this;
            mappings[type] = mapping;
        }
        return mapping;
    }

    internal function createMapping(type:Class):Mapping {
        return new Mapping(type);
    }

    public function getByType(type:Class, required:Boolean = true):* {
        var mapping:Mapping = getMapping(type);
        if (mapping == null) {
            if (required)
                throw new UnresolvedDependencyError("couldn't find a mapping for class <" + getQualifiedClassName(type) + ">");
            else
                return undefined;
        }
        return mapping.getValue();
    }

}
}
