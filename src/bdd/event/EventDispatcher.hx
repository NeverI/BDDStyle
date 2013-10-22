package bdd.event;

class EventDispatcher
{
    private static var listeners:Map<String, Array<Dynamic->Void>> = new Map<String, Array<Dynamic->Void>>();

    public function new()
    {
    }

    public function unshiftListener(type:String, callback:Dynamic->Void):Void
    {
        this.createEventGroup(type);

        if (this.getExistingListener(type, callback) != null) {
            return;
        }

        EventDispatcher.listeners.get(type).unshift(callback);
    }

    private function createEventGroup(type:String)
    {
        if (!EventDispatcher.listeners.exists(type)) {
            EventDispatcher.listeners.set(type, []);
        }
    }

    public function addListener(type:String, callback:Dynamic->Void):Void
    {
        this.createEventGroup(type);

        if (this.getExistingListener(type, callback) != null) {
            return;
        }

        EventDispatcher.listeners.get(type).push(callback);
    }

    private function getExistingListener(type:String, callback:Dynamic->Void):Dynamic->Void
    {
        for (cb in EventDispatcher.listeners.get(type)) {
            if (Reflect.compareMethods(cb, callback )) {
                return cb;
            }
        }

        return null;
    }

    public function trigger(type:String, event:Dynamic):Void
    {
        if (!EventDispatcher.listeners.exists(type)) {
            return;
        }

        for (callback in EventDispatcher.listeners.get(type)) {
            callback(event);
        }
    }

    public function removeListener(type:String, ?callback:Dynamic->Void):Void
    {
        if (!EventDispatcher.listeners.exists(type)) {
            return;
        }

        if (callback == null) {
            EventDispatcher.listeners.remove(type);
            return;
        }

        EventDispatcher.listeners.get(type).remove(this.getExistingListener(type, callback));
    }

    public static function removeAllListener():Void
    {
        EventDispatcher.listeners = new Map<String, Array<Dynamic->Void>>();
    }
}
