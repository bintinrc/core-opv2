package co.nvqa.operator_v2.model;

import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.Arrays;
import java.util.List;

/**
 * @author Sergey Mishanin
 */
public class HubsGroup extends DataEntity<HubsGroup>
{
    private Long id;
    private String name;
    private List<String> hubs;

    public Long getId()
    {
        return id;
    }

    public HubsGroup setId(Long id)
    {
        this.id = id;
        return this;
    }

    public HubsGroup setId(String id)
    {
        return setId(Long.valueOf(id));
    }

    public String getName()
    {
        return name;
    }

    public HubsGroup setName(String name)
    {
        if ("GENERATED".equalsIgnoreCase(name))
        {
            name = "TA-" + TestUtils.generateDateUniqueString();
        }
        this.name = name;
        return this;
    }

    public List<String> getHubs()
    {
        return hubs;
    }

    public HubsGroup setHubs(List<String> hubs)
    {
        this.hubs = hubs;
        this.hubs.sort(String::compareTo);
        return this;
    }

    public HubsGroup setHubs(String[] hubs)
    {
        setHubs(Arrays.asList(hubs));
        return this;
    }

    public HubsGroup setHubs(String hubs)
    {
        setHubs(hubs.split(","));
        return this;
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this)
                .append("id", id)
                .append("name", name)
                .append("hubs", hubs)
                .toString();
    }
}
