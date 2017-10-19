package com.nv.qa.model;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpCompanyAgent
{
    private Long id;
    private String name;
    private String email;
    private String contact;
    private String unlockCode;

    public DpCompanyAgent()
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

    public String getUnlockCode()
    {
        return unlockCode;
    }

    public void setUnlockCode(String unlockCode)
    {
        this.unlockCode = unlockCode;
    }
}
