package com.struts.core
{

import flash.events.Event;
import flash.events.EventDispatcher;

public class EventBus extends EventDispatcher
{
    private static var _eventBus:EventBus;

    private static var lock:Boolean = false;

    public function EventBus()
    {
        if (!lock)
        {
            throw new Error("ContainerEventDispatcher can only be defined once!");
        }
    }

    public static function getInstance():EventBus
    {
        if (_eventBus == null)
        {
            lock = true;
            _eventBus = new EventBus();
            lock = false;
        }
        return _eventBus;
    }

    public function dispatch(type:String):Boolean
    {
        return dispatchEvent(new Event(type));
    }
}

}



























