package co.nvqa.operator_v2.model;

import co.nvqa.operator_v2.util.TestUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;

import java.util.Map;

/**
 * @author Sergey Mishanin
 */
public class DpUser extends DataEntity<DpUser>
{
    private Long id;
    private String username;
    private String password;
    private String firstName;
    private String lastName;
    private String contactNo;
    private String email;

    public DpUser() {}

    public DpUser(Map<String, ?> data){
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

    public String getUsername()
    {
        return username;
    }

    public void setUsername(String username)
    {
        if ("generated".equalsIgnoreCase(username))
        {
            username = "DP-User-" + TestUtils.generateDateUniqueString();
        }
        this.username = username;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
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

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        if ("generated".equalsIgnoreCase(email))
        {
            email = TestUtils.generateDateUniqueString() + "@gmail.com";
        }
        this.email = email;
    }

    @Override
    public void fromCsvLine(String csvLine)
    {
        String[] values = splitCsvLine(csvLine);
        setUsername(getValueIfIndexExists(values, 0));
        setFirstName(getValueIfIndexExists(values, 1));
        setLastName(getValueIfIndexExists(values, 2));
        setEmail(getValueIfIndexExists(values, 3));
        setContactNo(getValueIfIndexExists(values, 4));
    }

    @Override
    public String toString()
    {
        return new ToStringBuilder(this)
                .append("id", id)
                .append("username", username)
                .append("password", password)
                .append("firstName", firstName)
                .append("lastName", lastName)
                .append("contactNo", contactNo)
                .append("email", email)
                .toString();
    }
}
