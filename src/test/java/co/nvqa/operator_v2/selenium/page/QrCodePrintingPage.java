package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class QrCodePrintingPage extends SimplePage
{
    public QrCodePrintingPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void generateQrCode(String text)
    {
        sendKeysById("container.qrcode-printing.input-text", text);
        pause1s(); //Give time from JS QR Code library to generate the QR Code
    }

    public void verifyGeneratedQrCodeIsContainsCorrectText(String text)
    {
        File qrCodeFile = saveCanvasAsPngFile("//canvas[@class='qrcode']");
        String qrCodeText = TestUtils.getTextFromQrCodeImage(qrCodeFile);
        String linkText = getText("//nv-qrcode//div[@class='text']");
        Assert.assertEquals("QR Code text does not equal with expected text.", text, qrCodeText);
        Assert.assertEquals("QR Code Text & Link Text is different.", qrCodeText, linkText);
    }
}
