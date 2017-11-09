package co.nvqa.operator_v2.support;

import cucumber.runtime.java.guice.ScenarioScoped;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class ScenarioStorage
{
    public static final String KEY_SHIPMENT_ID = "shipment-id";
    public static final String KEY_TRACKING_ID = "tracking-id";

    private Map<String, Object> mapOfData = new HashMap<>();

    public ScenarioStorage()
    {
    }

    public void put(String key, Object value)
    {
        mapOfData.put(key, value);
    }

    @SuppressWarnings("unchecked")
    public void putInList(String key, Object value)
    {
        List listOfValue = get(key);

        if(listOfValue==null)
        {
            listOfValue = new ArrayList();
            mapOfData.put(key, listOfValue);
        }

        listOfValue.add(value);
    }

    @SuppressWarnings("unchecked")
    public <T> T get(String key)
    {
        return (T) mapOfData.get(key);
    }

    public boolean containsKey(String key)
    {
        return mapOfData.containsKey(key);
    }
}
