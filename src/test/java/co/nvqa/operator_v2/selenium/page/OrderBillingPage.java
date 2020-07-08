package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.core.Order;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.WebDriver;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;

/**
 * @author Kateryna Skakunova
 */
public class OrderBillingPage extends OperatorV2SimplePage
{
    private static final String REPORT_ATTACHMENT_FILE_EXTENSION = ".csv";
    private static final String REPORT_ATTACHMENT_NAME_PATTERN = "https://.*ninjavan.*billing.*zip";
    private static final String REPORT_EMAIL_SUBJECT = "Success Billings CSV";

    private static final String FILTER_START_DATE_MDDATEPICKERNGMODEL = "ctrl.data.startDate";
    private static final String FILTER_END_DATE_MDDATEPICKERNGMODEL = "ctrl.data.endDate";
    private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES = "Shipper";
    private static final String FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL = "Selected Shippers";
    private static final String FILTER_GENERATE_FILE_CHECKBOX_PATTERN = "//md-input-container[@label = '%s']/md-checkbox";

    public OrderBillingPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void selectStartDate(Date startDate)
    {
        setMdDatepicker(FILTER_START_DATE_MDDATEPICKERNGMODEL, startDate);
    }

    public void selectEndDate(Date endDate)
    {
        setMdDatepicker(FILTER_END_DATE_MDDATEPICKERNGMODEL, endDate);
    }

    public void setSpecificShipper(String shipper)
    {
        clickButtonByAriaLabelAndWaitUntilDone(FILTER_SHIPPER_SELECTED_SHIPPERS_BUTTON_ARIA_LABEL);
        selectValueFromNvAutocompleteByItemTypes(FILTER_SHIPPER_SELECTED_SHIPPERS_NVAUTOCOMPLETE_ITEMTYPES, shipper);
    }

    public void tickGenerateTheseFilesOption(String option)
    {
        click(f(FILTER_GENERATE_FILE_CHECKBOX_PATTERN, option));
    }

    public void setEmailAddress(String emailAddress)
    {
        sendKeysAndEnterByAriaLabel("Email", emailAddress);
    }

    public void clickGenerateSuccessBillingsButton()
    {
        clickButtonByAriaLabelAndWaitUntilDone("Generate Success Billings");
    }

    public void verifyOrderBillingZipAttachment(String startDate, String endDate)
    {
        String attachmentUrl = getOrderBillingAttachmentFromEmail();
        verifyListOfFilesInZip(attachmentUrl, startDate, endDate);
    }

    public void markGmailMessageAsRead()
    {
        GmailClient gmailClient = new GmailClient();
        gmailClient.markUnreadMessagesAsRead();
    }

    public void verifyOrderBillingCsvAttachment(Order order)
    {
        String attachmentUrl = getOrderBillingAttachmentFromEmail();
        verifyCsvFileInZip(attachmentUrl, order);
    }

    private String getOrderBillingAttachmentFromEmail()
    {
        pause7s();

        GmailClient gmailClient = new GmailClient();
        AtomicBoolean isFound = new AtomicBoolean();

        List<String> attachmentUrlList = new ArrayList<>();
        gmailClient.readUnseenMessage(message ->
        {
            String subject = message.getSubject();
            if (subject.equals(REPORT_EMAIL_SUBJECT) && !isFound.get()) {
                String body = gmailClient.getSimpleContentBody(message);

                Pattern pattern = Pattern.compile(REPORT_ATTACHMENT_NAME_PATTERN);
                Matcher matcher = pattern.matcher(body);

                String attachmentUrl;

                if(matcher.find())
                {
                    attachmentUrl = matcher.group();
                    NvLogger.infof("Success Billings file received in mail - %s", attachmentUrl);
                    attachmentUrlList.add(attachmentUrl);

                    isFound.set(Boolean.TRUE);
                }
            }
        });

        assertTrue(f("No email with '%s' subject in the mailbox", REPORT_EMAIL_SUBJECT), isFound.get());

        return attachmentUrlList.stream()
                                      .filter(urlItem -> urlItem.endsWith(".zip"))
                                      .findFirst()
                                      .orElseThrow(() -> new IllegalArgumentException("No Zip file in attachment"));
    }

    private void verifyListOfFilesInZip(String url, String startDate, String endDate)
    {
        try(ZipInputStream zipIs = new ZipInputStream(new URL(url).openStream()))
        {
            int filesNumber = 0;
            ZipEntry zEntry;

            while((zEntry=zipIs.getNextEntry())!=null)
            {
                String fileName = zEntry.getName();
                String assertMessage = f("One of the files in Success Billings zip is wrong. Expected to have: startDate = %s, endDate = %s, extension = %s. But was %s", startDate, endDate, REPORT_ATTACHMENT_FILE_EXTENSION, fileName);
                assertTrue(assertMessage, fileName.contains(startDate) && fileName.contains(endDate) && fileName.endsWith(REPORT_ATTACHMENT_FILE_EXTENSION));
                filesNumber++;
            }
            NvLogger.infof("Total number of files in Success Billings - %s", filesNumber);
        }
        catch(IOException ex)
        {
            NvLogger.errorf("Could not read file from %s. Cause: %s", url, ex);
            throw new NvTestRuntimeException(ex.getMessage());
        }
    }

    private void verifyCsvFileInZip(String url, Order order)
    {
        boolean isOrderFound = false;
        String zipName = "order_billing.zip";
        String pathToZip = TestConstants.TEMP_DIR + "order_billing_" + DateUtil.getTimestamp() + "/";

        try
        {
            FileUtils.copyURLToFile(new URL(url), new File(pathToZip + zipName));
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException("Could not get file from " + url, ex);
        }

        try(ZipFile zipFile = new ZipFile(pathToZip + zipName))
        {
            Enumeration<? extends ZipEntry> entries = zipFile.entries();

            while (entries.hasMoreElements())
            {
                ZipEntry entry = entries.nextElement();
                InputStream is = zipFile.getInputStream(entry);
                BufferedReader reader = new BufferedReader(new InputStreamReader(is));

                while(reader.ready())
                {
                    String line = reader.readLine();
                    isOrderFound = isLineFoundAndValidatedInCsv(line, order);
                    if(isOrderFound)
                    {
                        break;
                    }
                }
            }
        }
        catch(IOException ex)
        {
            throw new NvTestRuntimeException("Could not read from file " + url, ex);
        }
        assertTrue(f("Order with %s trackingId is not found in CSV received in email (%s)", order.getTrackingId(), url), isOrderFound);
    }

    private boolean isLineFoundAndValidatedInCsv(String line, Order order)
    {
        String trackingId = order.getTrackingId();
        if(!line.startsWith("\"Shipper ID") && line.contains(trackingId))
        {
            String shipperOrderRefNo = order.getShipperOrderRefNo();
            String toName = order.getToName();
            String toAddress = order.getToAddress1() + " " + order.getToCountry() + " " + order.getToPostcode();
            String toPostcode = order.getToPostcode();
            assertThat("Success Billings Csv file does not contains expected information", line, containsString(f("\"%s\",", toName)));
            assertThat("Success Billings Csv file does not contains expected information", line, containsString(f("\"%s\",", shipperOrderRefNo)));
            assertThat("Success Billings Csv file does not contains expected information", line, containsString(f("\"%s\",\"%s\",", toAddress, toPostcode)));
            return true;
        }
        else
        {
            return false;
        }
    }
}
