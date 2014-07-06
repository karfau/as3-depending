package as3.depending.scope {
import as3.depending.*;
import as3.depending.errors.UnresolvedDependencyError;

import flash.utils.getQualifiedClassName;


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
            setMapping(type, mapping);
        }
        return mapping;
    }

    private function setMapping(type:Class, mapping:Mapping):void {
        mappings[type] = mapping;
    }

    internal function createMapping(type:Class):Mapping {
        return new Mapping(type);
    }

    public function get(type:Class, required:Boolean = true):* {
        var mapping:Mapping = getMapping(type);
        if (mapping == null) {
            try {
                mapping = createMapping(type);
                mapping.resolver = this;
                var value:Object = mapping.getValue();
                setMapping(type, mapping);
                return value;
            } catch (error:Error) {
            }
            if (required)
                throw new UnresolvedDependencyError("couldn't find a mapping for class <" + getQualifiedClassName(type) + ">");
            else
                return undefined;
        }
        return mapping.getValue();
    }

}
}
