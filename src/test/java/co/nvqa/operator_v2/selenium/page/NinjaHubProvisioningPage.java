package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class NinjaHubProvisioningPage extends OperatorV2SimplePage {

  @FindBy(xpath = "//iframe[contains(@src,'provisioning')]")
  private PageElement pageFrame;

  public NinjaHubProvisioningPage(WebDriver webDriver) {
    super(webDriver);
  }

  public File saveQrCodeAsPngFile() {
    return saveCanvasAsPngFile("//canvas[@id='react-qrcode-logo']");
  }

  public void verifyTheQrCodeTextIsEqualWithTheLinkText(File qrCodeFile) {
    String qrCodeText = TestUtils.getTextFromQrCodeImage(qrCodeFile);
    String linkText = getText("//div[@class='qrcode-holder']/p");
    assertEquals("QR Code Text & Link Text is different.", qrCodeText, linkText);
  }

  public void switchToIframe() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }
}
