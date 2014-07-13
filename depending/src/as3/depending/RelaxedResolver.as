package as3.depending {
public interface RelaxedResolver extends Resolver{
    /**
     * Resolves an instance of the given Class if defined, return undefined if not.
     *
     * Can return null or undefined if defined or implemented that way.
     *
     * @param clazz the type of the dependency to resolve.
     *
     */
    function optionally(clazz:Class):*;
}
}
