package as3.depending.examples.tests {
import as3.depending.Resolver;

/**
 * The purpose of this interface is to let the specification test if the resolver it tests,
 * can be handed over to the created instance.
 *
 * This is helpful for external configuration cases, as it avoids actually using a resolver implementation,
 * which could be done differently if the actual implementation of the resolver is e.g. functional.
 */
public interface IResolverSpecDefinition extends IDefinition{
    function get resolver():Resolver;
}
}
