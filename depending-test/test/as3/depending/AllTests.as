package as3.depending {
import as3.depending.provider.*;
import as3.depending.scope._ScopeSuite;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AllTests {

    public var provider:_ProviderSuite;
    public var scope:_ScopeSuite;
    public var _TestBaseRelaxedResolver:TestBaseRelaxedResolver;
}
}
