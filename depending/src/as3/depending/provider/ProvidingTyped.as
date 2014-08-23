package as3.depending.provider {
import as3.depending.Providing;

public interface ProvidingTyped extends Providing {
    function get type():Class;
}
}
