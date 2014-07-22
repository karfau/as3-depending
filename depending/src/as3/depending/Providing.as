package as3.depending {
/**
 * The contract of this interface is that is has a method with the name <code>provide<code/>,
 * that is a <b>provider</b> according to the specification.
 *
 * The method is not defined in this interface because the specification requires
 * that a <b>provider</b> either expects expects a resolver or it doesn't,
 * which is the opposite of what a method with an optional argument would allow.
 *
 * To handle this in an object oriented way there are two interfaces extending this one:
 *
 * @see as3.depending.provider.ProviderZero
 * @see as3.depending.provider.ProviderExpecting
 *
 * @see http://github.com/karfau/as3-depending/tree/master/specification#4-provider
 *
 */
public interface Providing {

}
}
