package co.nvqa.operator_v2.cucumber.glue;

import co.nvqa.operator_v2.selenium.page.QrCodePrintingPage;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import cucumber.runtime.java.guice.ScenarioScoped;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@ScenarioScoped
public class QrCodePrintingSteps extends AbstractSteps {

  private QrCodePrintingPage qrCodePrintingPage;

  public QrCodePrintingSteps() {
  }

  @Override
  public void init() {
    qrCodePrintingPage = new QrCodePrintingPage(getWebDriver());
  }

  @When("^Operator create QR Code from random text on QRCode Printing page$")
  public void operatorCreateQrCodeFromRandomTextOnQrCodePrintingPage() {
    String qrCodeText = "AUTOM" + generateDateUniqueString();
    qrCodePrintingPage.generateQrCode(qrCodeText);
    put("qrCodeText", qrCodeText);
  }

  @Then("^Operator verify the created QR Code is correct$")
  public void operatorVerifyTheCreatedQrCodeIsCorrect() {
    String qrCodeText = get("qrCodeText");
    qrCodePrintingPage.verifyGeneratedQrCodeIsContainsCorrectText(qrCodeText);
  }
}
