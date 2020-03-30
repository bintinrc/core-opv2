package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.model.DpTagging;
import co.nvqa.operator_v2.selenium.elements.nv.NvApiTextButton;
import co.nvqa.operator_v2.selenium.elements.nv.NvButtonFilePicker;
import co.nvqa.operator_v2.util.TestUtils;
import com.google.common.collect.ImmutableMap;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Daniel Joi Partogi Hutapea
 */
@SuppressWarnings("WeakerAccess")
public class DpTaggingPage extends OperatorV2SimplePage
{
    public DpTaggingTable dpTaggingTable;

    @FindBy(name = "container.dp-tagging.assign-all")
    public NvApiTextButton assignAll;

    @FindBy(name = "container.dp-tagging.untag-all")
    public NvApiTextButton untagAll;

    @FindBy(css = "nv-button-file-picker[label='Select File']")
    public NvButtonFilePicker selectFile;

    public DpTaggingPage(WebDriver webDriver)
    {
        super(webDriver);
        dpTaggingTable = new DpTaggingTable(webDriver);
    }

    public void uploadDpTaggingCsv(List<DpTagging> listOfDpTagging)
    {
        pause2s();
        File dpTaggingCsv = buildCsv(listOfDpTagging);
        selectFile.setValue(dpTaggingCsv);
        waitUntilInvisibilityOfToast("File successfully uploaded");
    }

    public void uploadInvalidDpTaggingCsv()
    {
        File dpTaggingCsv = buildInvalidCsv();
        selectFile.setValue(dpTaggingCsv);
    }

    public void verifyDpTaggingCsvIsUploadedSuccessfully(List<DpTagging> listOfDpTagging)
    {
        List<String> actualTracingIds = dpTaggingTable.readAllEntities().stream()
                .map(DpTagging::getTrackingId)
                .collect(Collectors.toList());

        for (DpTagging dpTagging : listOfDpTagging)
        {
            assertThat("Tracking ID is not listed on table.", dpTagging.getTrackingId(), isIn(actualTracingIds));
        }
    }

    public void verifyInvalidDpTaggingCsvIsNotUploadedSuccessfully()
    {
        String expectedErrorMessageOnToast = "No order data to process, please check the file";
        String actualMessage = getText("//div[@id='toast-container']/div/div/div/div[@class='toast-top']/div");
        assertEquals("Error Message", expectedErrorMessageOnToast, actualMessage);
        waitUntilInvisibilityOfToast(expectedErrorMessageOnToast, false);
    }

    private File buildCsv(List<DpTagging> listOfDpTagging)
    {
        StringBuilder contentAsSb = new StringBuilder();

        for (DpTagging dpTagging : listOfDpTagging)
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
        } catch (IOException ex)
        {
            throw new NvTestRuntimeException(ex);
        }
    }

    public void checkAndAssignAll(boolean isMultipleOrders)
    {
        dpTaggingTable.selectAllShown();
        assignAll.click();

        if (isMultipleOrders)
        {
            waitUntilInvisibilityOfToast("DP tagging performed successfully");
        } else
        {
            waitUntilInvisibilityOfToast("tagged successfully");
        }
    }

    public void untagAll()
    {
        dpTaggingTable.selectAllShown();
        untagAll.click();
    }

    /**
     * Accessor for DP Tagging Tickets table
     */
    public static class DpTaggingTable extends MdVirtualRepeatTable<DpTagging>
    {
        public static final String COLUMN_TRACKING_ID = "trackingId";

        public DpTaggingTable(WebDriver webDriver)
        {
            super(webDriver);
            setColumnLocators(ImmutableMap.<String, String>builder()
                    .put(COLUMN_TRACKING_ID, "tracking-id")
                    .build()
            );
            setEntityClass(DpTagging.class);
            setMdVirtualRepeat("order in getTableData()");
        }
    }
}