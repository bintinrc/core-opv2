package co.nvqa.operator_v2.model;

import co.nvqa.commons.model.DataEntity;
import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class DpUser extends DataEntity<DpUser>
{
    private Long id;
    private String clientId;
    private String clientSecret;
    private String firstName;
    private String lastName;
    private String contactNo;
    private String emailId;

    public DpUser()
    {
    }

    public DpUser(Map<String, ?> data)
    {
        fromMap(data);
    }

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

    public String getClientId()
    {
        return clientId;
    }

    public void setClientId(String clientId)
    {
        if ("generated".equalsIgnoreCase(clientId))
        {
            clientId = "DP-User-" + TestUtils.generateDateUniqueString();
        }
        this.clientId = clientId;
    }

    public String getClientSecret()
    {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret)
    {
        if ("generated".equalsIgnoreCase(clientSecret))
        {
            clientSecret = TestUtils.generateDateUniqueString();
        }
        this.clientSecret = clientSecret;
    }

    public String getEmailId()
    {
        return emailId;
    }

    public void setEmailId(String emailId)
    {
        if ("generated".equalsIgnoreCase(emailId))
        {
            emailId = TestUtils.generateDateUniqueString() + "@gmail.com";
        }
        this.emailId = emailId;
    }

    public String getFirstName()
    {
        return firstName;
    }

    public void setFirstName(String firstName)
    {
        this.firstName = firstName;
    }

    public String getLastName()
    {
        return lastName;
    }

    public void setLastName(String lastName)
    {
        this.lastName = lastName;
    }

    public String getContactNo()
    {
        return contactNo;
    }

    public void setContactNo(String contactNo)
    {
        if ("generated".equalsIgnoreCase(contactNo))
        {
            contactNo = TestUtils.generatePhoneNumber();
        }
        this.contactNo = contactNo;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setClientId(getValueIfIndexExists(values, 0));
        setFirstName(getValueIfIndexExists(values, 1));
        setLastName(getValueIfIndexExists(values, 2));
        setEmailId(getValueIfIndexExists(values, 3));
        setContactNo(getValueIfIndexExists(values, 4));
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this)
                .append("id", id)
                .append("clientId", clientId)
                .append("clientSecret", clientSecret)
                .append("firstName", firstName)
                .append("lastName", lastName)
                .append("contactNo", contactNo)
                .append("emailId", emailId)
                .toString();
    }
}
