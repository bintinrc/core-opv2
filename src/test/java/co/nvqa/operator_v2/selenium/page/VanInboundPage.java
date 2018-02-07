package co.nvqa.operator_v2.selenium.page;

import org.junit.Assert;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;

/**
 *
 * @author Tristania Siagian
 */
public class VanInboundPage extends OperatorV2SimplePage
{
    public VanInboundPage(WebDriver webDriver) {
        super(webDriver);
    }

    public void fillRouteIdOnVanInboundPage(String routeId) {
        sendKeysById("route-id", routeId);
        clickNvApiTextButtonByNameAndWaitUntilDone("container.van-inbound.fetch");
    }

    public void fillTrackingIdOnVanInboundPage(String trackingId) {
        sendKeysById("tracking-id-scan", trackingId + Keys.RETURN);
        pause1s();
    }

    public void verifyVanInboundSucceed() {
        String actualMessage = getText("//div[contains(@class,\"status-box\")]/h1");
        Assert.assertEquals("Tracking ID is invalid", "SUCCESS", actualMessage);
    }

    public void startRoute(String trackingId) {
        sendKeysById("tracking-id-scan", trackingId);
        pause1s();
        clickButtonByAriaLabelAndWaitUntilDone("Route Start");
        waitUntilVisibilityOfElementLocated("//md-dialog-content[contains( @class, 'md-dialog-content')]");
        clickButtonOnMdDialogByAriaLabel("Close");
    }

    public void verifyInvalidTrackingId(String trackingId) {
        String expectedTrackingId = findElementByXpath("//tr[@ng-repeat='trackingId in ctrl.invalidTrackingIds track by $index'][1]/td").getText().trim();
        Assert.assertEquals("Tracking ID is valid", trackingId, expectedTrackingId);
    }

    public void verifyTrackingIdEmpty() {
        String actualMessage = getText("//div[contains(@class,\"status-box\")]/h1");
        Assert.assertEquals("Tracking ID is invalid","EMPTY", actualMessage);
    }
}
