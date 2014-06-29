package as3.depending.errors {
public class UnresolvedDependencyError extends Error {
    public function UnresolvedDependencyError(message:* = "", id:* = 0) {
        super(message, id);
    }

    public function toString():String {
        return "UnresolvedDependencyError: " + message;
    }
}
}
