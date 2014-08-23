package as3.depending.provider {
public class SameInstanceProviderMock implements ProvidingSameInstance, ProviderZero{

    public function provide():Object {
        return null;
    }

    public function get type():Class {
        return null;
    }
}
}
