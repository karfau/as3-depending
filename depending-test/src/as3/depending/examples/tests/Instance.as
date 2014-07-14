package as3.depending.examples.tests {
public class Instance {

    public static var instances:uint = 0;
    public static var last:Instance;

    private var id:uint;

    public function Instance() {
        id = ++instances;
        last = this;
    }

    public function toString():String {
        return "Instance{id=" + String(id) + "}";
    }
}
}
