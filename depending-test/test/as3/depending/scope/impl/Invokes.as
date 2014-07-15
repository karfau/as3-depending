package as3.depending.scope.impl {
import flash.utils.Dictionary;

import org.flexunit.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.collection.arrayWithSize;
import org.hamcrest.object.nullValue;

public class Invokes {

    private const list:Dictionary = new Dictionary(true);

    public function invoke(method:Function, ...parameters):void {
        if (list[method] === undefined) {
            list[method] = [];
        }
        if (parameters.length == 1 && parameters[0] is Array) {
            parameters = parameters[0];
        }
        list[method].push(parameters);
    }

    public function assertNoInvokes(method:Function):void {
        assertThat(list[method], nullValue());
    }

    public function assertInvokes(method:Function, times:uint):void {
        assertThat(list[method], arrayWithSize(times));
    }

    public function assertWasInvokedWith(method:Function, ...parameters):void {
        const list:Array = list[method];
        assertThat(list, array(parameters));
    }

    public function noParameters():* {
        invoke(noParameters);
        return undefined;
    }

    public function oneParameter(one:Object):* {
        invoke(oneParameter, one);
        return one;
    }

    public function variableParameters(...parameters):* {
        invoke(variableParameters, parameters);
        return parameters;
    }


}
}
