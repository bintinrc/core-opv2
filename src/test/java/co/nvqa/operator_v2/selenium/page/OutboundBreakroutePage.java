package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class OutboundBreakroutePage extends OperatorV2SimplePage
{
    private ParcelsNotInOutboundScansBox parcelsNotInOutboundScansBox;

    public OutboundBreakroutePage(WebDriver webDriver)
    {
        super(webDriver);
        parcelsNotInOutboundScansBox = new ParcelsNotInOutboundScansBox(webDriver);
    }

    public void waitUntilElementDisplayed()
    {
        parcelsNotInOutboundScansBox.waitUntilElementDisplayed();
    }

    public void pullOrderFromRoute(String trackingId)
    {
        parcelsNotInOutboundScansBox.pullOrderFromRoute(trackingId);
    }

    public static class ParcelsNotInOutboundScansBox extends OperatorV2SimplePage
    {
        @SuppressWarnings("unused")
        public static class RowTable
        {
            private String trackingId;
            private String info;
            private WebElement pullBtnWe;

            public RowTable(String trackingId, String info, WebElement pullBtnWe)
            {
                this.trackingId = trackingId;
                this.info = info;
                this.pullBtnWe = pullBtnWe;
            }

            public String getTrackingId()
            {
                return trackingId;
            }

            public void setTrackingId(String trackingId)
            {
                this.trackingId = trackingId;
            }

            public String getInfo()
            {
                return info;
            }

            public void setInfo(String info)
            {
                this.info = info;
            }

            public WebElement getPullBtnWe()
            {
                return pullBtnWe;
            }

            public void setPullBtnWe(WebElement pullBtnWe)
            {
                this.pullBtnWe = pullBtnWe;
            }
        }

        public ParcelsNotInOutboundScansBox(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void waitUntilElementDisplayed()
        {
            waitUntilVisibilityOfElementLocated("//h4[contains(text(), 'Parcels not in Outbound Scans')]");
        }

        public List<RowTable> getListOfRowTable()
        {
            List<RowTable> listOfRowTable = new ArrayList<>();

            List<WebElement> listOfTrs = findElementsByXpath("//tr[@ng-repeat='order in ctrl.missingOutbounds']");

            for(WebElement trWe : listOfTrs)
            {
                WebElement trackingIdWe = trWe.findElement(By.xpath("./td[contains(@class, 'tracking-id')]"));
                WebElement infoWe = trWe.findElement(By.xpath("./td[contains(@class, 'info')]"));
                WebElement pullBtnWe = trWe.findElement(By.xpath("./td[contains(@class, 'action')]/nv-icon-text-button"));

                String trackingId = getText(trackingIdWe);
                String info = getText(infoWe);

                listOfRowTable.add(new RowTable(trackingId, info, pullBtnWe));
            }

            return listOfRowTable;
        }

        public void pullOrderFromRoute(String trackingId)
        {
            List<RowTable> listOfRowTable = getListOfRowTable();
            boolean trackingIdFound = false;

            for(RowTable rowTable : listOfRowTable)
            {
                if(trackingId.equals(rowTable.getTrackingId()))
                {
                    rowTable.getPullBtnWe().click();
                    clickButtonOnMdDialogByAriaLabel("Pull Out");
                    waitUntilInvisibilityOfToast("Success pullout tracking id "+trackingId);
                    trackingIdFound = true;
                    break;
                }
            }

            if(!trackingIdFound)
            {
                throw new NvTestRuntimeException(String.format("Button 'Pull' for Tracking ID = '%s' not found.", trackingId));
            }
        }
    }
}
