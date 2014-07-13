package as3.depending.examples.tests {

public class NotConstructable implements IDefinition {
    public function NotConstructable() {
        throw new Error('my purpose is to fail');
    }
}
}
