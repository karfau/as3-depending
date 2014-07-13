package as3.depending.spec {
import as3.depending.Resolver;

import flash.utils.getQualifiedClassName;

import org.flexunit.AssertionError;

/**
 * This error gets thrown when the specification test suite recognizes
 * that a resolver provided by a ResolverAdapter doesn't implement some features,
 * which lets the test fail with a clear message.
 *
 * Note: not implementing all <code>define...</code> methods in a ResolverAdapter will also lead to this error,
 * as the test suite can not know how to use your implementation.
 */
public class NotImplementedException extends AssertionError {

    private var impl:String;
    public function NotImplementedException(implementation:Object, feature:String) {
        super(feature);
        impl = getQualifiedClassName(implementation);
    }

    public function toString():String {
        return "<"+impl+"> does not support '"+message+"'";
    }
}
}
