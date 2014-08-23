package as3.depending.scope {
import as3.depending.Providing;

public class IdentifierMap {

    private const map:Object = {};

    public function has(identifier:Object):Boolean {
        return map[identifier] !== undefined;
    }

    public function hasSpecified(identifier:Object):Boolean {
        return map[identifier] is Specified;
    }

    public function set(identifier:Object, providing:Providing):void {
        map[identifier] = providing;
    }

    public function get(identifier:Object):Providing {
        return Providing(map[identifier]);
    }

}
}
