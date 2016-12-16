package com.nv.qa.support;

import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ScenarioStorage
{
    private Map<String, Object> mapOfData = new HashMap<>();

    public ScenarioStorage()
    {
    }

    public void put(String key, Object value)
    {
        mapOfData.put(key, value);
    }

    public <T> T get(String key)
    {
        return (T) mapOfData.get(key);
    }

    public boolean containsKey(String key)
    {
        return mapOfData.containsKey(key);
    }
}
