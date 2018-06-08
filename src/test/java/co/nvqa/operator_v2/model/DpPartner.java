package co.nvqa.operator_v2.model;

import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class DpPartner extends DataEntity<DpPartner>
{
    private Long id;
    private String name;
    private String pocName;
    private String pocTel;
    private String pocEmail;
    private String restrictions;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public void setId(String id)
    {
        setId(Long.parseLong(id));
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        if ("generated".equalsIgnoreCase(name))
        {
            name = "DP-Partner-" + TestUtils.generateDateUniqueString();
        }
        this.name = name;
    }

    public String getPocName()
    {
        return pocName;
    }

    public void setPocName(String pocName)
    {
        this.pocName = pocName;
    }

    public String getPocTel()
    {
        return pocTel;
    }

    public void setPocTel(String pocTel)
    {
        if ("generated".equalsIgnoreCase(pocTel))
        {
            pocTel = TestUtils.generatePhoneNumber();
        }
        this.pocTel = pocTel;
    }

    public String getPocEmail()
    {
        return pocEmail;
    }

    public void setPocEmail(String pocEmail)
    {
        if ("generated".equalsIgnoreCase(pocEmail))
        {
            pocEmail = TestUtils.generateDateUniqueString() + "@gmail.com";
        }
        this.pocEmail = pocEmail;
    }

    public String getRestrictions()
    {
        return restrictions;
    }

    public void setRestrictions(String restrictions)
    {
        this.restrictions = restrictions;
    }

    public DpPartner()
    {
    }

    public DpPartner(Map<String, ?> dataMap)
    {
        fromMap(dataMap);
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setId(getValueIfIndexExists(values, 0));
        setName(getValueIfIndexExists(values, 1));
        setPocName(getValueIfIndexExists(values, 2));
        setPocTel(getValueIfIndexExists(values, 3));
        setPocEmail(getValueIfIndexExists(values, 4));
        setRestrictions(getValueIfIndexExists(values, 5));
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this)
                .append("id", id)
                .append("name", name)
                .append("pocName", pocName)
                .append("pocTel", pocTel)
                .append("pocEmail", pocEmail)
                .append("restrictions", restrictions)
                .toString();
    }
}
