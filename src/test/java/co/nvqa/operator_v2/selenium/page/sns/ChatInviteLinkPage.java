package co.nvqa.operator_v2.selenium.page.sns;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.page.SimpleReactPage;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

public class ChatInviteLinkPage extends SimpleReactPage<ChatInviteLinkPage> {
    @FindBy(xpath = "(//input[@data-testid='shipper-id-phone-number-input'])[1]")
    public PageElement legacyShipperIdInputElement;
    @FindBy(xpath = "(//button[@data-testid='generate-link-button'])[1]")
    public Button generateALinkButtonForShipperElement;
    @FindBy(xpath = "//span[text()='Shipper Name']//following-sibling::span")
    public PageElement shipperNameElement;
    @FindBy(xpath = "//span[text()='Phone Number']//following-sibling::span")
    public PageElement shipperPhoneNumberElement;
    @FindBy(xpath = "//input[@data-testid='generated-link-form']")
    public PageElement inviteLinkFieldElement;
    @FindBy(xpath = "//div[@id='___gatsby']")
    public PageElement ninjaChatPage;
    @FindBy(xpath = "//div[text()='Consignee Link']")
    public PageElement consigneeLinkTabElement;
    @FindBy(xpath = "(//input[@data-testid='shipper-id-phone-number-input'])[2]")
    public PageElement consigneePhoneNumberElement;
    @FindBy(xpath = "(//button[@data-testid='generate-link-button'])[2]")
    public PageElement generateALinkButtonForConsigneeElement;


    public ChatInviteLinkPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void operatorGeneratorLinkForShipperUsingShipperLegacyId(String shipperLegacyId) {
        legacyShipperIdInputElement.waitUntilVisible();
        legacyShipperIdInputElement.sendKeys(shipperLegacyId);
        generateALinkButtonForShipperElement.click();
    }

    public void verifyShipperNameAndPhoneNumber(String shipperName, String shipperPhoneNumber) {
        shipperNameElement.waitUntilVisible();
        String actualShipperName = shipperNameElement.getText();
        shipperPhoneNumberElement.waitUntilVisible();
        String actualShipperPhoneNumber = shipperPhoneNumberElement.getText();

        Assertions.assertThat(actualShipperName).as("Verify shipper name on chat invite link").isEqualTo(shipperName);
        Assertions.assertThat(actualShipperPhoneNumber).as("Verify shipper phone number on chat invite link").isEqualTo(shipperPhoneNumber);
    }

    public String getGeneratedInviteLink() {
        inviteLinkFieldElement.waitUntilVisible();
        return inviteLinkFieldElement.getAttribute("value");
    }

    public void operatorGeneratorLinkForConsigneeUsingPhoneNumber(String phoneNumber) {
        consigneeLinkTabElement.waitUntilVisible();
        consigneeLinkTabElement.click();
        consigneePhoneNumberElement.waitUntilVisible();
        consigneePhoneNumberElement.sendKeys(phoneNumber);
        generateALinkButtonForConsigneeElement.click();
    }
}
