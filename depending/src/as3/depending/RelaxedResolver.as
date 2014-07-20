package as3.depending {
public interface RelaxedResolver extends Resolver{
    /**
     * Resolves a value for a given identifier if specified, returns undefined if not.
     *
     * Can return null or undefined if specified or implemented that way.
     *
     * @param identifier the identifier of the dependency to resolve.
     *
     */
    function optionally(identifier:Object):*;
}
}
