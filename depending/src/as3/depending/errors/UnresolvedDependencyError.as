package as3.depending.errors {
public class UnresolvedDependencyError extends Error {

    private var _caught:Error;
    public function get caught():Error {
        return _caught;
    }

    public function UnresolvedDependencyError(message:String, caught:Error) {
        super(message);
        _caught = caught;
    }

    public function toString():String {
        return "UnresolvedDependencyError: " + message + (_caught? " ("+_caught+")":'');
    }
}
}
