package as3.depending.scope {
import as3.depending.examples.tests.*;

import org.flexunit.assertThat;
import org.hamcrest.core.*;
import org.hamcrest.object.*;

public class TestMapping {

    private var mapping:Mapping;


    [Before]
    public function setUp():void {
        mapping = new Mapping(IDefinition);
    }


    [Test]
    public function getValue_returns_new_instance_of_mapped_type():void {
        mapping = new Mapping(DefinitionImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                isA(DefinitionImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toType_on_getValue_returns_new_instance():void {
        mapping.toType(DefinitionImpl);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                isA(DefinitionImpl),
                not(equalTo(mapping.getValue()))
        ));
    }

    [Test]
    public function toInstance_on_getValue_returns_instance():void {
        const singleton:IDefinition = new DefinitionImpl();
        mapping.toInstance(singleton);

        var first:Object = mapping.getValue();
        assertThat(first, allOf(
                strictlyEqualTo(singleton),
                strictlyEqualTo(mapping.getValue())
        ));
    }


}
}
