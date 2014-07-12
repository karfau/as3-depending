package as3.depending.scope.impl {
import flash.utils.Dictionary;

import org.flexunit.assertThat;

import org.hamcrest.collection.array;

public class Invokes {

    private const list:Dictionary = new Dictionary(true);

    public function invoke(method:Function, ...parameters):void {
        if(list[method] === undefined){
            list[method] = [];
        }
        if(parameters.length == 1 && parameters[0] is Array){
            parameters = parameters[0];
        }
        list[method].push(parameters);
    }

    public function assertInvokes(method:Function, ...parameters):void {
        assertThat(list[method], array(parameters));
    }
}
}
