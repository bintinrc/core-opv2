package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import java.io.File;
import org.assertj.core.api.Assertions;
import org.openqa.selenium.WebDriver;

/**
 * @author Daniel Joi Partogi Hutapea
 */
public class QrCodePrintingPage extends OperatorV2SimplePage {

  public QrCodePrintingPage(WebDriver webDriver) {
    super(webDriver);
  }

  public void generateQrCode(String text) {
    sendKeysById("container.qrcode-printing.input-text", text);
    pause1s(); //Give time from JS QR Code library to generate the QR Code
  }

  public void verifyGeneratedQrCodeIsContainsCorrectText(String text) {
    File qrCodeFile = saveCanvasAsPngFile("//canvas[@class='qrcode']");
    String qrCodeText = TestUtils.getTextFromQrCodeImage(qrCodeFile);
    String linkText = getText("//nv-qrcode//div[@class='text']");
    Assertions.assertThat(qrCodeText).as("QR Code text does not equal with expected text.")
        .isEqualTo(text);
    Assertions.assertThat(linkText).as("QR Code Text & Link Text is different.")
        .isEqualTo(qrCodeText);
  }
}
