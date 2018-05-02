package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.model.ThirdPartyOrderMapping;
import com.google.common.collect.ImmutableList;
import org.apache.commons.lang3.StringUtils;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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
    public static final String BUTTON_UPLOAD_BULK_NAME = "container.third-party-order.create-multiple-mapping";
    public static final String ACTION_BUTTON_EDIT = "commons.edit";
    public static final String ACTION_BUTTON_DELETE = "commons.delete";
    public static final String ACTION_BUTTON_COMPLETE = "container.third-party-order.complete-order";
    public static final String CONFIRM_BUTTON_ARIA_LABEL = "Confirm";

    public UploadSingleMappingPage uploadSingleMappingPage;
    public UploadBulkMappingPage uploadBulkMappingPage;
    public EditMappingPage editMappingPage;
    public UploadResultsPage uploadResultsPage;

    public ThirdPartyOrderManagementPage(WebDriver webDriver)
    {
        super(webDriver);
        uploadSingleMappingPage = new UploadSingleMappingPage(webDriver);
        uploadBulkMappingPage = new UploadBulkMappingPage(webDriver);
        editMappingPage = new EditMappingPage(webDriver);
        uploadResultsPage = new UploadResultsPage(webDriver);
    }

    public void uploadSingleMapping(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        clickNvIconTextButtonByName(BUTTON_UPLOAD_SINGLE_NAME);
        uploadSingleMappingPage.fillTheForm(thirdPartyOrderMapping);
        uploadSingleMappingPage.submitForm();
    }

    public void adjustAvailableThirdPartyShipperData(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        clickNvIconTextButtonByName(BUTTON_UPLOAD_SINGLE_NAME);
        uploadSingleMappingPage.adjustSelectedShipperInfo(thirdPartyOrderMapping);
        uploadSingleMappingPage.closeDialog();
    }

    public void uploadBulkMapping(List<ThirdPartyOrderMapping> thirdPartyOrderMappings)
    {
        clickNvIconTextButtonByName(BUTTON_UPLOAD_BULK_NAME);
        uploadBulkMappingPage.fillTheForm(thirdPartyOrderMappings);
        uploadBulkMappingPage.submitForm();
    }

    public void verifyOrderMappingCreatedSuccessfully(ThirdPartyOrderMapping expectedOrderMapping)
    {
        uploadResultsPage.verifyUploadResultsData(expectedOrderMapping);
        uploadResultsPage.closeDialog();
        verifyOrderMappingRecord(expectedOrderMapping);
    }

    public void verifyMultipleOrderMappingCreatedSuccessfully(List<ThirdPartyOrderMapping> expectedOrderMappings)
    {
        uploadResultsPage.verifyUploadResultsData(expectedOrderMappings);
        uploadResultsPage.closeDialog();
        verifyOrderMappingRecords(expectedOrderMappings);
    }

    public void verifyOrderMappingRecord(ThirdPartyOrderMapping expectedOrderMapping)
    {
        searchTableByTrackingId(expectedOrderMapping.getTrackingId());
        Assert.assertEquals("Third Party Order Tracking ID", expectedOrderMapping.getTrackingId(), getTextOnTable(1, COLUMN_CLASS_DATA_TRACKING_ID));
        Assert.assertEquals("Third Party Order 3PL Tracking ID", expectedOrderMapping.getThirdPlTrackingId(), getTextOnTable(1, COLUMN_CLASS_DATA_THIRD_PARTY_TRACKING_ID));
        Assert.assertEquals("Third Party Order 3PL Provider", expectedOrderMapping.getShipperName(), getTextOnTable(1, COLUMN_CLASS_DATA_SHIPPER_NAME));
    }

    public void verifyOrderMappingRecords(List<ThirdPartyOrderMapping> expectedOrderMappings)
    {
        expectedOrderMappings.forEach(this::verifyOrderMappingRecord);
    }

    public void editOrderMapping(ThirdPartyOrderMapping thirdPartyOrderMapping){
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
        clickButtonOnMdDialogByAriaLabel(CONFIRM_BUTTON_ARIA_LABEL);
        String toastMessage = "Third Party Order Deleted";
        waitUntilInvisibilityOfToast(toastMessage);
        waitUntilInvisibilityOfElementLocated(toastMessage);
    }

    public void completeThirdPartyOrder(ThirdPartyOrderMapping thirdPartyOrderMapping)
    {
        searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
        clickActionButtonOnTable(1, ACTION_BUTTON_COMPLETE);
        pause100ms();
        clickButtonOnMdDialogByAriaLabel(CONFIRM_BUTTON_ARIA_LABEL);
        String toastMessage = "Completed Order";
        waitUntilInvisibilityOfToast(toastMessage);
        waitUntilInvisibilityOfElementLocated(toastMessage);
    }

    public void verifyThirdPartyOrderMappingWasRemoved(ThirdPartyOrderMapping thirdPartyOrderMapping, String message)
    {
        searchTableByTrackingId(thirdPartyOrderMapping.getTrackingId());
        boolean isTableEmpty = isTableEmpty();
        message = "Third Party Order Mapping still exist in table. " + message;
        Assert.assertTrue(message, isTableEmpty);
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
        private static final String DIALOG_LOCATOR = "//md-dialog//h4[text()='Upload Single Mapping']";
        private static final String FIELD_TRACKING_ID_ID = "commons.model.tracking-id";
        private static final String FIELD_3PL_TRACKING_ID_ID = "commons.model.third-party-tracking-id";
        private static final String FIELD_SHIPPER_ID_ID = "commons.id";
        private static final String BUTTON_SUBMIT_NAME = "Submit";
        private static final String BUTTON_CLOSE_NAME = "Cancel";

        public UploadSingleMappingPage(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(ThirdPartyOrderMapping thirdPartyOrderMapping)
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);
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
                thirdPartyOrderMapping.setShipperId(Integer.parseInt(getMdSelectedItemValueAttributeById(FIELD_SHIPPER_ID_ID)));
            } else {
                adjustSelectedShipperInfo(thirdPartyOrderMapping);
            }
        }

        public void adjustSelectedShipperInfo(ThirdPartyOrderMapping thirdPartyOrderMapping){
            thirdPartyOrderMapping.setShipperName(getMdSelectValueById(FIELD_SHIPPER_ID_ID));
            thirdPartyOrderMapping.setShipperId(Integer.parseInt(getMdSelectedItemValueAttributeById(FIELD_SHIPPER_ID_ID)));
        }

        public void submitForm()
        {
            clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_NAME);
            waitUntilInvisibilityOfElementLocated(DIALOG_LOCATOR);
        }

        public void closeDialog(){
            clickNvIconButtonByName(BUTTON_CLOSE_NAME);
            waitUntilInvisibilityOfElementLocated(DIALOG_LOCATOR);
        }
    }

    public static class UploadBulkMappingPage extends OperatorV2SimplePage
    {
        private static final String DIALOG_LOCATOR = "//md-dialog//h4[text()='Upload Bulk Mapping CSV']";
        private static final String BUTTON_CHOOSE_NAME = "Choose";
        private static final String BUTTON_SUBMIT_NAME = "Submit";
        private static final String BUTTON_CLOSE_NAME = "Cancel";

        public UploadBulkMappingPage(WebDriver webDriver)
        {
            super(webDriver);
        }

        public void fillTheForm(List<ThirdPartyOrderMapping> thirdPartyOrderMappings)
        {
            waitUntilVisibilityOfElementLocated(DIALOG_LOCATOR);

            String csvContents = thirdPartyOrderMappings.stream().map(ThirdPartyOrderMapping::toCsvLine).collect(Collectors.joining(System.lineSeparator(), "", System.lineSeparator()));
            File csvFile = createFile(String.format("third-party-order-mappings-with-csv_%s.csv", generateDateUniqueString()), csvContents);

            sendKeysByAriaLabel(BUTTON_CHOOSE_NAME, csvFile.getAbsolutePath());
            waitUntilVisibilityOfElementLocated(String.format("//span[contains(text(), '%s')]", csvFile.getName()));
        }

        public void submitForm(){
            clickNvButtonSaveByNameAndWaitUntilDone(BUTTON_SUBMIT_NAME);
            waitUntilInvisibilityOfElementLocated(DIALOG_LOCATOR);
        }

        public void closeDialog(){
            clickNvIconButtonByName(BUTTON_CLOSE_NAME);
            waitUntilInvisibilityOfElementLocated(DIALOG_LOCATOR);
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

        public void submitForm(){
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
            verifyUploadResultsData(ImmutableList.of(expectedOrderMapping));
        }

        public void verifyUploadResultsData(List<ThirdPartyOrderMapping> expectedOrderMappings)
        {
            List<ThirdPartyOrderMapping> orderMappings = readMappingUploadResults();
            Assert.assertEquals("Unexpected number of created order mappings", expectedOrderMappings.size(), orderMappings.size());
            for (int i=0; i<expectedOrderMappings.size(); i++) {
                ThirdPartyOrderMapping expectedOrderMapping = expectedOrderMappings.get(i);
                ThirdPartyOrderMapping actualOrderMapping = orderMappings.get(i);
                Assert.assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] Tracking ID", expectedOrderMapping.getTrackingId(), actualOrderMapping.getTrackingId());
                Assert.assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] 3PL Tracking ID", expectedOrderMapping.getThirdPlTrackingId(), actualOrderMapping.getThirdPlTrackingId());
                Assert.assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] 3PL Shipper ID", expectedOrderMapping.getShipperId(), actualOrderMapping.getShipperId());
                Assert.assertEquals("Upload Results dialog: Third Party Order [" + i + 1 + "] Upload Status", expectedOrderMapping.getStatus(), actualOrderMapping.getStatus());
            }
        }

        public void closeDialog()
        {
            clickNvIconButtonByName(BUTTON_CLOSE_NAME);
        }
    }
}
