package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class ThirdPartyShipper
{
    private Integer id;
    private String code;
    private String name;
    private String url;

    public ThirdPartyShipper()
    {
    }

    public Integer getId()
    {
        return id;
    }

    public void setId(Integer id)
    {
        this.id = id;
    }

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getUrl()
    {
        return url;
    }

    public void setUrl(String url)
    {
        this.url = url;
    }
}
