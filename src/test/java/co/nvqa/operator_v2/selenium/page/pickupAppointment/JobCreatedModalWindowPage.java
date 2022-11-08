package co.nvqa.operator_v2.selenium.page.pickupAppointment;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class JobCreatedModalWindowPage extends PageElement {
    @FindBy(xpath = "//div[span[text()='Shipper name:']]//following-sibling::span")
    public TextBox shipperName;

    @FindBy(xpath = "//div[span[text()='Shipper address:']]//following-sibling::span")
    public TextBox shipperAddress;

    @FindBy(xpath = "//div[span[text()='Ready by:']]//following-sibling::span")
    public TextBox startTime;

    @FindBy(xpath = "//div[span[text()='Latest by:']]//following-sibling::span")
    public TextBox endTime;

    @FindBy(xpath = "//span[span[text()='Jobs created for the following dates:']]//following-sibling::span")
    public TextBox dates;

    @FindBy(css = "div.ant-modal-footer button")
    public Button okButton;

    public JobCreatedModalWindowPage(WebDriver webDriver, WebElement webElement) {
        super(webDriver, webElement);
        PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public String getShipperNameString() {
        return shipperName.getText();
    }

    public String getShipperAddressString() {
        return shipperAddress.getText();
    }

    public String getStartTimeString() {
        return startTime.getText();
    }

    public String getEndTimeString() {
        return endTime.getText();
    }

    public String getDatesString() {
        return dates.getText();
    }

    public void clickOnOKButton() {
        okButton.click();
    }
}
