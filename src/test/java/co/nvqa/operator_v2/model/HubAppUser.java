package co.nvqa.operator_v2.model;

/**
 *
 * @author Tristania Siagian
 */

public class HubAppUser
{
    private String firstName;
    private String lastName;
    private String contact;
    private String username;
    private String password;
    private String employmentType;
    private String employmentStartDate;
    private String hub;
    private String warehouseTeamFormation;
    private String position;
    private String comments;

    public HubAppUser()
    {
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmploymentType() {
        return employmentType;
    }

    public void setEmploymentType(String employmentType) {
        this.employmentType = employmentType;
    }

    public String getEmploymentStartDate() {
        return employmentStartDate;
    }

    public void setEmploymentStartDate(String employmentStartDate) {
        this.employmentStartDate = employmentStartDate;
    }

    public String getHub() {
        return hub;
    }

    public void setHub(String hub) {
        this.hub = hub;
    }

    public String getWarehouseTeamFormation() {
        return warehouseTeamFormation;
    }

    public void setWarehouseTeamFormation(String warehouseTeamFormation) {
        this.warehouseTeamFormation = warehouseTeamFormation;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
}
