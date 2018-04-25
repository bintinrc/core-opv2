package co.nvqa.operator_v2.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class PrinterSettings
{
    private String name;
    private String ipAddress;
    private String version;
    private boolean defaultPrinter;

    public PrinterSettings()
    {
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getIpAddress()
    {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress)
    {
        this.ipAddress = ipAddress;
    }

    public String getVersion()
    {
        return version;
    }

    public void setVersion(String version)
    {
        this.version = version;
    }

    public boolean isDefaultPrinter()
    {
        return defaultPrinter;
    }

    public void setDefaultPrinter(boolean defaultPrinter)
    {
        this.defaultPrinter = defaultPrinter;
    }
}
