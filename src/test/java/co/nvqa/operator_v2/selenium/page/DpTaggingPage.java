package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.utils.NvTestRuntimeException;
import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.util.TestUtils;
import org.hamcrest.Matchers;
import org.junit.Assert;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class DpTaggingPage extends OperatorV2SimplePage
{
    private static final String NG_REPEAT = "order in ctrl.uploadDeliveryResults";

    public static final String COLUMN_CLASS_TRACKING_ID = "tracking-id";
    public static final String COLUMN_CLASS_CURRENT_DP_ID = "current-dp-id";

    public DpTaggingPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void uploadDpTaggingCsv(List<DpTagging> listOfDpTagging)
    {
        File dpTaggingCsv = buildCsv(listOfDpTagging);
        sendKeysByAriaLabel("Choose", dpTaggingCsv.getAbsolutePath());
        waitUntilInvisibilityOfToast("File successfully uploaded");
    }

    public void uploadInvalidDpTaggingCsv()
    {
        File dpTaggingCsv = buildInvalidCsv();
        sendKeysByAriaLabel("Choose", dpTaggingCsv.getAbsolutePath());
    }

    public void verifyDpTaggingCsvIsUploadedSuccessfully(List<DpTagging> listOfDpTagging)
    {
        List<String> listOfTrackingIdsOnTable = new ArrayList<>();
        int rowCount = getRowCount();

        for(int i=0; i<rowCount; i++)
        {
            listOfTrackingIdsOnTable.add(getTextOnTable(i+1, COLUMN_CLASS_TRACKING_ID));
        }

        for(DpTagging dpTagging : listOfDpTagging)
        {
            Assert.assertThat("Tracking ID is not listed on table.", dpTagging.getTrackingId(), Matchers.isIn(listOfTrackingIdsOnTable));
        }
    }

    public void verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully()
    {
        String expectedErrorMessageOnToast = "No order data to process, please check the file";
        String actualMessage = getText("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
        Assert.assertEquals("Error Message", expectedErrorMessageOnToast, actualMessage);
        waitUntilInvisibilityOfToast(expectedErrorMessageOnToast, false);
    }

    private File buildCsv(List<DpTagging> listOfDpTagging)
    {
        StringBuilder contentAsSb = new StringBuilder();

        for(DpTagging dpTagging : listOfDpTagging)
        {
            contentAsSb.append(dpTagging.getTrackingId()).append(',').append(dpTagging.getDpId()).append(System.lineSeparator());
        }

        return buildCsv(contentAsSb.toString());
    }

    private File buildInvalidCsv()
    {
        return buildCsv("INVALID_TRACKING_ID,1001" + System.lineSeparator());
    }

    private File buildCsv(String content)
    {
        try
        {
            File file = TestUtils.createFileOnTempFolder(String.format("dp-tagging_%s.csv", generateDateUniqueString()));

            PrintWriter pw = new PrintWriter(new FileOutputStream(file));
            pw.write(content);
            pw.close();

            return file;
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }

    public void checkAndAssignAll()
    {
        clickNvIconTextButtonByName("check-all");
        clickNvApiTextButtonByNameAndWaitUntilDone("container.dp-tagging.assign-all");
        waitUntilInvisibilityOfToast("Success assign");
    }

    public void verifyTheOrdersIsTaggedToDpSuccessfully(List<DpTagging> listOfDpTagging)
    {
        int rowIndex = 1;

        for(DpTagging dpTagging : listOfDpTagging)
        {
            String trackingId = getTextOnTable(rowIndex, COLUMN_CLASS_TRACKING_ID);
            String currentDpId = getTextOnTable(rowIndex, COLUMN_CLASS_CURRENT_DP_ID);

            Assert.assertEquals("Tracking ID", dpTagging.getTrackingId(), trackingId);
            Assert.assertEquals("Current DP ID", String.valueOf(dpTagging.getDpId()), currentDpId);

            rowIndex++;
        }
    }

    public int getRowCount()
    {
        return findElementsByXpath(String.format("//tr[@ng-repeat='%s']", NG_REPEAT)).size();
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTableWithNgRepeat(rowNumber, columnDataClass, NG_REPEAT);
    }
}
