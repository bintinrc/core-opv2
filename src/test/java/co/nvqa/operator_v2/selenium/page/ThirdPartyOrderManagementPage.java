package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ThirdPartyOrderManagementPage extends OperatorV2SimplePage
{
    private static final String MD_VIRTUAL_REPEAT = "order in getTableData()";

    public static final String COLUMN_CLASS_DATA_TRACKING_ID = "tracking-id";
    public static final String COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID = "third-party-order-third-party-tracking-id";
    public static final String COLUMN_CLASS_DATA_SHIPPER_NAME = "third-party-order-third-party-shipper-name";

    public static final String BUTTON_UPLOAD_SINGLE_NAME = "container.third-party-order.create-single-mapping";
    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";

    public UploadSingleMappingPage uploadSingleMappingPage;
    public EditMappingPage editMappingPage;
    public UploadResultsPage uploadResultsPage;

    public ThirdPartyOrderManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        uploadSingleMappingPage = new UploadSingleMappingPage(webDriver);
        editMappingPage = new EditMappingPage(webDriver);
        uploadResultsPage = new UploadResultsPage(webDriver);
    }

    public void uploadSingleMapping(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        clickNvIconTextButtonByName(BUTTON_UPLOAD_SINGLE_NAME);
        uploadSingleMappingPage.fillTheForm(thirdPartyOrderMapping);
        uploadSingleMappingPage.submitForm();
    }

    public void verifyOrderMappingCreatedSuccessfully(ThirdPartyOrderMapping expectedOrderMapping)
    {
        uploadResultsPage.verifyUploadResultsData(expectedOrderMapping);
        uploadResultsPage.closeDialog();
        verifyOrderMappingRecord(expectedOrderMapping);
    }

    public void verifyOrderMappingRecord(ThirdPartyOrderMapping expectedOrderMapping)
    {
        searchTableByTrackingId(expectedOrderMapping.getTrackingId());
        Assert.assertEquals("Third Party Order Tracking ID", expectedOrderMapping.getTrackingId(), getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID));
        Assert.assertEquals("Third Party Order 3PL Tracking ID", expectedOrderMapping.getThirdPlTrackingId(), getTextOnTable(1, COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID));
        Assert.assertEquals("Third Party Order 3PL Provider", expectedOrderMapping.getShipperName(), getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME));
    }

    public void editOrderMapping(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
        clickActionButtonOnTable(1, ACTION_BUTTON_EDIT);
        editMappingPage.fillTheForm(thirdPartyOrderMapping);
        editMappingPage.submitForm();
        String toastMessage = String.format("%s mapped to %s(%s)!", thirdPartyOrderMapping.getTrackingId(), thirdPartyOrderMapping.getThirdPlTrackingId(), thirdPartyOrderMapping.getShipperName());
        waitUntilInvisibilityOfToast(toastMessage);
        waitUntilInvisibilityOfElementLocated(toastMessage);
    }

    public void deleteThirdPartyOrderMapping(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
        clickActionButtonOnTable(1, ACTION_BUTTON_DELETE);
        pause100ms();
        clickButtonOnMdDialogByAriaLabel("Confirm");
        waitUntilInvisibilityOfToast("Third Party Order Deleted");
        waitUntilInvisibilityOfElementLocated("Third Party Order Deleted");
    }

    public void verifyThirdPartyOrderMappingIsDeletedSuccessfully(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
        boolean isTableEmpty = isTableEmpty();
        Assert.assertTrue(String.format("Third Party Order Mapping still exist in table. Fail to delete Third Party Order Mapping (Tracking ID = %s).", thirdPartyOrderMapping.getTrackingId()), isTableEmpty);
    }

    public void searchTableByTrackingId(String trackingId)
    {
        searchTableCustom1(COLUMN_CLASS_DATA_TRACKING_ID, trackingId);
    }

    public String getTextOnTable(int rowNumber, String columnDataClass)
    {
        return getTextOnTable(rowNumber, columnDataClass, MD_VIRTUAL_REPEAT);
    }

    public void clickActionButtonOnTable(int rowNumber, String actionButtonName)
    {
        clickActionButtonOnTableWithMdVirtualRepeat(rowNumber, actionButtonName, MD_VIRTUAL_REPEAT);
    }

    public static class UploadSingleMappingPage extends OperatorV2SimplePage
    {
        private static final String FIELD_TRACKING_ID_ID = "commons.model.tracking-id";
        private static final String FIELD_3PL_TRACKING_ID_ID = "commons.model.third-party-tracking-id";
        private static final String FIELD_SHIPPER_ID_ID = "commons.id";
        private static final String BUTTON_SUBMIT_NAME = "Submit";

        public UploadSingleMappingPage(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(ThirdPartyOrderMapping thirdPartyOrderMapping)
        {
            String value = thirdPartyOrderMapping.getTrackingId();
            if (value != null) {
                sendKeysById(FIELD_TRACKING_ID_ID, value);
            }
            value = thirdPartyOrderMapping.getThirdPlTrackingId();
            if (value != null) {
                sendKeysById(FIELD_3PL_TRACKING_ID_ID, value);
            }
            value = thirdPartyOrderMapping.getShipperName();
            if (value != null) {
                selectValueFromMdSelectById(FIELD_SHIPPER_ID_ID, value);
            } else {
                thirdPartyOrderMapping.setShipperName(getMdSelectValueById(FIELD_SHIPPER_ID_ID));
            }
        }

        public void submitForm()
        {
            clickNvButtonSaveByName(BUTTON_SUBMIT_NAME);
        }
    }

    public static class EditMappingPage extends OperatorV2SimplePage
    {
        private static final String FIELD_3PL_TRACKING_ID_ID = "commons.model.third-party-tracking-id";
        private static final String FIELD_SHIPPER_ID_ID = "commons.id";
        private static final String BUTTON_SUBMIT_NAME = "Submit Changes";

        public EditMappingPage(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(ThirdPartyOrderMapping thirdPartyOrderMapping)
        {
            String value = thirdPartyOrderMapping.getThirdPlTrackingId();
            if (value != null) {
                sendKeysById(FIELD_3PL_TRACKING_ID_ID, value);
            }
            value = thirdPartyOrderMapping.getShipperName();
            if (value != null) {
                selectValueFromMdSelectById(FIELD_SHIPPER_ID_ID, value);
            } else {
                thirdPartyOrderMapping.setShipperName(getMdSelectValueById(FIELD_SHIPPER_ID_ID));
            }
        }

        public void submitForm()
        {
            clickNvButtonSaveByName(BUTTON_SUBMIT_NAME);
        }
    }

    public static class UploadResultsPage extends OperatorV2SimplePage
    {
        private static final String DIALOG_LOCATOR = "//md-dialog[contains(@class,'third-party-order-add-result')]";
        private static final String BUTTON_CLOSE_NAME = "Cancel";

        public UploadResultsPage(WebDriver webDriver)
        {
            super(webDriver);
        }

        public List<ThirdPartyOrderMapping> readMappingUploadResults()
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
            String xpathForCounting = DIALOG_LOCATOR + "//table/tbody/tr[not(@class='ng-hide')]";
            String cellLocatorTemplate = xpathForCounting + "[%d]/td[%d]";
            int recordsCount = getElementsCount(By.xpath(xpathForCounting));
            List<ThirdPartyOrderMapping> orderMappings = new ArrayList<>();

            for (int rowIndex=1; rowIndex<=recordsCount; rowIndex++)
            {
                ThirdPartyOrderMapping orderMapping = new ThirdPartyOrderMapping();
                String locator = String.format(cellLocatorTemplate, rowIndex, 1);
                orderMapping.setTrackingId(getText(locator));
                locator = String.format(cellLocatorTemplate, rowIndex, 2);
                orderMapping.setShipperId(Integer.parseInt(getText(locator)));
                locator = String.format(cellLocatorTemplate, rowIndex, 3);
                orderMapping.setThirdPlTrackingId(getText(locator));
                locator = String.format(cellLocatorTemplate, rowIndex, 4);
                orderMapping.setStatus(getText(locator));
                orderMappings.add(orderMapping);
            }

            return orderMappings;
        }

        public void verifyUploadResultsData(ThirdPartyOrderMapping expectedOrderMapping)
        {
            List<ThirdPartyOrderMapping> orderMappings = readMappingUploadResults();
            Assert.assertEquals("Unexpected number of created order mappings", 1, orderMappings.size());
            ThirdPartyOrderMapping actualOrderMapping = orderMappings.get(0);
            Assert.assertEquals("Upload Results dialog: Third Party Order Tracking ID", expectedOrderMapping.getTrackingId(), actualOrderMapping.getTrackingId());
            Assert.assertEquals("Upload Results dialog: Third Party Order 3PL Tracking ID", expectedOrderMapping.getThirdPlTrackingId(), actualOrderMapping.getThirdPlTrackingId());
            Assert.assertEquals("Upload Results dialog: Third Party Order Upload Status", expectedOrderMapping.getStatus(), actualOrderMapping.getStatus());
        }

        public void closeDialog()
        {
            clickNvIconButtonByName(BUTTON_CLOSE_NAME);
        }
    }
}
