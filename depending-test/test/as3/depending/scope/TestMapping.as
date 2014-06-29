package as3.depending.scope {
import org.flexunit.assertThat;
import org.hamcrest.core.allOf;
import org.hamcrest.core.isA;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;

public class TestMapping {

    private var mapping:Mapping;


    [Before]
    public function setUp():void {
        mapping = new Mapping();
    }


    [Test]
    public function toType_on_getValue_returns_new_instance_each_time():void {
        mapping.toType(DefinitionImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                isA(DefinitionImpl),
                not(equalTo(mapping.getValue()))
        ));
    }
}
}
