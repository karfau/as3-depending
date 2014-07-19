package as3.depending.examples.tests {

public class NotConstructableProtocol implements IProtocol {
    public function NotConstructableProtocol() {
        throw new Error('my purpose is to fail');
    }
}
}
