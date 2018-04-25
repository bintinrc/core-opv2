package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.utils.NvTestRuntimeException;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class CodReportPage extends OperatorV2SimplePage
{
    private static final String CSV_FILENAME_PATTERN = "cod-report";

    private static final String NG_REPEAT = "cod in $data";
    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking_id";
    public static final String COLUMN_CLASS_DATA_GRANULAR_STATUS = "granular_status";
    public static final String COLUMN_CLASS_DATA_SHIPPER_NAME = "shipper_name";
    public static final String COLUMN_CLASS_DATA_GOODS_AMOUNT = "goods_amount";

    public CodReportPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void filterCodReportBy(String mode, Date date)
    {
        clickToggleButton("ctrl.reportMode", mode);
        setMdDatepicker("ctrl.date", date);
        waitUntilInvisibilityOfElementLocated("//md-card-content[contains(@ng-if, 'waiting')]/md-progress-circular");
    }

    public void verifyOrderIsExistWithCorrectInfo(Order order)
    {
        int indexOfOrderInTable = findOrderRowIndexInTable(order.getTrackingId());
        moveToElementWithXpath(String.format("//tr[@ng-repeat='%s'][%d]", NG_REPEAT, indexOfOrderInTable));

        String actualTrackingId = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_TRACKING_ID);
        String actualGranularStatus = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_GRANULAR_STATUS);
        String actualShipperName = getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_SHIPPER_NAME);
        Double actualGoodsAmount = Double.parseDouble(getTextOnTable(indexOfOrderInTable, COLUMN_CLASS_DATA_GOODS_AMOUNT));

        Assert.assertEquals("Tracking ID", order.getTrackingId(), actualTrackingId);
        Assert.assertThat("Granular Status", actualGranularStatus, Matchers.equalToIgnoringCase(order.getGranularStatus().replace("_", " ")));
        Assert.assertEquals("Shipper Name", order.getShipper().getName(), actualShipperName);
        Assert.assertEquals("COD Amount", order.getCod().getGoodsAmount(), actualGoodsAmount);
    }

    private int findOrderRowIndexInTable(String trackingId)
    {
        List<WebElement> listOfTrackingIdsWe = findElementsByXpath(String.format("//tr[@ng-repeat='%s']/td[contains(@class,'%s')]", NG_REPEAT, COLUMN_CLASS_DATA_TRACKING_ID));
        int indexResult = 0;
        int indexCounter = 0;

        for(WebElement we : listOfTrackingIdsWe)
        {
            indexCounter++;
            String weTrackingId = we.getText().trim();

            if(trackingId.equals(weTrackingId))
            {
                indexResult = indexCounter;
                break;
            }
        }

        if(indexResult==0)
        {
            throw new NvTestRuntimeException(String.format("Tracking ID = '%s' not found on table.", trackingId));
        }

        return indexResult;
    }

    public void downloadCsvFile()
    {
        clickNvApiTextButtonByName("Download CSV File");
    }

    public void verifyCsvFileDownloadedSuccessfullyAndContainsCorrectInfo(Order order)
    {
        String trackingId = order.getTrackingId();
        String granularStatus = order.getGranularStatus().replace("_", " ").toLowerCase();
        String shipperName = order.getShipper().getName();
        String codAmount = NO_TRAILING_ZERO_DF.format(order.getCod().getGoodsAmount());
        String expectedText = String.format("\"%s\",\"%s\",\"%s\",%s", trackingId, granularStatus, shipperName, codAmount);
        verifyFileDownloadedSuccessfully(getLatestDownloadedFilename(CSV_FILENAME_PATTERN), expectedText, true);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
}
