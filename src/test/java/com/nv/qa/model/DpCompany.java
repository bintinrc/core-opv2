package com.nv.qa.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompany
{
    private Long id;
    private String name;
    private String email;
    private String contact;
    private String dropOffWebhookUrl;
    private String collectWebhookUrl;
    private boolean integrated;

    public DpCompany()
    {
    }

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getName()
    {
        return name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getContact()
    {
        return contact;
    }

    public void setContact(String contact)
    {
        this.contact = contact;
    }

    public String getDropOffWebhookUrl()
    {
        return dropOffWebhookUrl;
    }

    public void setDropOffWebhookUrl(String dropOffWebhookUrl)
    {
        this.dropOffWebhookUrl = dropOffWebhookUrl;
    }

    public String getCollectWebhookUrl()
    {
        return collectWebhookUrl;
    }

    public void setCollectWebhookUrl(String collectWebhookUrl)
    {
        this.collectWebhookUrl = collectWebhookUrl;
    }

    public boolean isIntegrated()
    {
        return integrated;
    }

    public void setIntegrated(boolean integrated)
    {
        this.integrated = integrated;
    }
}
