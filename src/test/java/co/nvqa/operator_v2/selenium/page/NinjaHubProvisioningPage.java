package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.util.TestUtils;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class NinjaHubProvisioningPage extends SimplePage
{
    public NinjaHubProvisioningPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public File saveQrCodeAsPngFile()
    {
        return saveCanvasAsPngFile("//canvas[@class='qrcode']");
    }

    public void verifyTheQrCodeTextIsEqualWithTheLinkText(File qrCodeFile)
    {
        String qrCodeText = TestUtils.getTextFromQrCodeImage(qrCodeFile);
        String linkText = getText("//nv-qrcode//div[@class='text']");
        Assert.assertEquals("QR Code Text & Link Text is different.", qrCodeText, linkText);
    }
}
