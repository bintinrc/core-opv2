package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.model.shipper_support.AggregatedOrder;
import co.nvqa.commons.model.shipper_support.PricedOrder;
import co.nvqa.commons.support.DateUtil;
import co.nvqa.commons.util.GmailClient;
import co.nvqa.commons.util.NvLogger;
import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.util.TestConstants;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.WebDriver;

import java.io.*;
import java.math.BigDecimal;
import java.net.URL;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
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

    public static final String SHIPPER_BILLING_REPORT = "Shipper Billing Report";
    public static final String SCRIPT_BILLING_REPORT = "Script Billing Report";
    public static final String AGGREGATED_BILLING_REPORT = "Aggregated Billing Report";

    private final List<AggregatedOrder> csvRowsInAggregatedReport = new ArrayList<>();
    private String csvRowForOrderInShipperReport;
    private String headerLineInShipperReport;


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

    public int getNoOfFilesInZipAttachment(String attachmentUrl, String startDate, String endDate)
    {
        try (ZipInputStream zipIs = new ZipInputStream(new URL(attachmentUrl).openStream()))
        {
            int filesNumber = 0;
            ZipEntry zEntry;

            while ((zEntry = zipIs.getNextEntry()) != null)
            {
                String fileName = zEntry.getName();
                String assertMessage = f("One of the files in Success Billings zip is wrong. Expected to have: startDate = %s, endDate = %s, extension = %s. But was %s", startDate, endDate, REPORT_ATTACHMENT_FILE_EXTENSION, fileName);
                assertTrue(assertMessage, fileName.contains(startDate) && fileName.contains(endDate) && fileName.endsWith(REPORT_ATTACHMENT_FILE_EXTENSION));
                filesNumber++;
            }
            NvLogger.infof("Total number of files in Success Billings - %s", filesNumber);
            return filesNumber;
        } catch (IOException ex)
        {
            NvLogger.errorf("Could not read file from %s. Cause: %s", attachmentUrl, ex);
            throw new NvTestRuntimeException(ex.getMessage());
        }
    }

    public void markGmailMessageAsRead()
    {
        GmailClient gmailClient = new GmailClient();
        gmailClient.markUnreadMessagesAsRead();
    }


    public String getOrderBillingAttachmentFromEmail()
    {
        pause10s();

        GmailClient gmailClient = new GmailClient();
        AtomicBoolean isFound = new AtomicBoolean();

        List<String> attachmentUrlList = new ArrayList<>();
        gmailClient.readUnseenMessage(message ->
        {
            String subject = message.getSubject();
            if (subject.equals(REPORT_EMAIL_SUBJECT) && !isFound.get())
            {
                String body = gmailClient.getSimpleContentBody(message);

                Pattern pattern = Pattern.compile(REPORT_ATTACHMENT_NAME_PATTERN);
                Matcher matcher = pattern.matcher(body);

                String attachmentUrl;

                if (matcher.find())
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

    public void readOrderBillingCsvAttachment(String attachmentUrl, PricedOrder pricedOrder, String reportName)
    {
        boolean isBodyFound = false;
        String zipName = "order_billing.zip";
        String pathToZip = TestConstants.TEMP_DIR + "order_billing_" + DateUtil.getTimestamp() + "/";
        try
        {
            FileUtils.copyURLToFile(new URL(attachmentUrl), new File(pathToZip + zipName));
        } catch (IOException ex)
        {
            throw new NvTestRuntimeException("Could not get file from " + attachmentUrl, ex);
        }

        try (ZipFile zipFile = new ZipFile(pathToZip + zipName))
        {
            Enumeration<? extends ZipEntry> entries = zipFile.entries();

            while (entries.hasMoreElements())
            {
                ZipEntry entry = entries.nextElement();
                InputStream is = zipFile.getInputStream(entry);
                BufferedReader reader = new BufferedReader(new InputStreamReader(is));
                boolean isFirstLine = true;
                while (reader.ready())
                {
                    String line = reader.readLine();
                    if (isFirstLine)
                    {
                        if (line.startsWith("\"Shipper ID"))
                        {
                            saveHeaderInCSv(line);
                        } else
                        {
                            fail(f("Header line is not found in CSV received in email (%s)", attachmentUrl));
                        }
                        isFirstLine = false;
                    } else
                    {
                        isBodyFound = true;
                        saveBodyInCsv(pricedOrder, reportName, line);
                    }
                }
            }
        } catch (IOException ex)
        {
            throw new NvTestRuntimeException("Could not read from file " + attachmentUrl, ex);
        }
        assertTrue(f("Body is not found in CSV received in email (%s)", attachmentUrl), isBodyFound);
    }

    private void saveBodyInCsv(PricedOrder pricedOrder, String reportName, String line)
    {
        if (Arrays.asList(SHIPPER_BILLING_REPORT, SCRIPT_BILLING_REPORT).contains(reportName) && line.contains(pricedOrder.getTrackingId()))
        {
            csvRowForOrderInShipperReport = line;
        }
        if (reportName.equals(AGGREGATED_BILLING_REPORT))
        {
            List<String> orderDetailList = Arrays.asList(line.replaceAll("\"", "").split(","));
            AggregatedOrder aggregatedOrder = new AggregatedOrder();
            aggregatedOrder.setShipperId(orderDetailList.get(0));
            aggregatedOrder.setShipperName(orderDetailList.get(1));
            aggregatedOrder.setShipperBillingName(orderDetailList.get(2));
            aggregatedOrder.setDeliveryTypeName(orderDetailList.get(3));
            aggregatedOrder.setDeliveryTypeId(orderDetailList.get(4));
            aggregatedOrder.setParcelSize(orderDetailList.get(5));
            aggregatedOrder.setParcelWeight(orderDetailList.get(6));
            aggregatedOrder.setCount(orderDetailList.get(7));
            aggregatedOrder.setCost(orderDetailList.get(8));
            csvRowsInAggregatedReport.add(aggregatedOrder);
        }
    }

    private void saveHeaderInCSv(String headerLine)
    {
        headerLineInShipperReport = headerLine;
    }

    public PricedOrder pricedOrderCsv(String line)
    {
        List<String> columnArray = Arrays.stream(line.replaceAll("\"", "").split(","))
                .map((value) -> value.equals("") ? null : value)
                .collect(Collectors.toList());

        PricedOrder pricedOrderInCsv = new PricedOrder();
        pricedOrderInCsv.setShipperId(integerValue(columnArray.get(0)));
        pricedOrderInCsv.setShipperName(columnArray.get(1));
        pricedOrderInCsv.setBillingName(columnArray.get(2));
        pricedOrderInCsv.setTrackingId(columnArray.get(3));
        pricedOrderInCsv.setShipperOrderRef(columnArray.get(4));
        pricedOrderInCsv.setGranularStatus(columnArray.get(5));
        pricedOrderInCsv.setCustomerName(columnArray.get(6));
        pricedOrderInCsv.setDeliveryTypeName(columnArray.get(7));
        pricedOrderInCsv.setDeliveryTypeId(integerValue(columnArray.get(8)));
        pricedOrderInCsv.setParcelSizeId(columnArray.get(9));
        pricedOrderInCsv.setParcelWeight(Double.valueOf(columnArray.get(10)));
        pricedOrderInCsv.setCreatedTime(columnArray.get(11));
        pricedOrderInCsv.setDeliveryDate(columnArray.get(12));
        pricedOrderInCsv.setFromCity(columnArray.get(13));
        pricedOrderInCsv.setFromBillingZone(columnArray.get(14));
        pricedOrderInCsv.setOriginHub(columnArray.get(15));
        pricedOrderInCsv.setL1Name(columnArray.get(16));
        pricedOrderInCsv.setL2Name(columnArray.get(17));
        pricedOrderInCsv.setL3Name(columnArray.get(18));
        pricedOrderInCsv.setToAddress(columnArray.get(19));
        pricedOrderInCsv.setToPostcode(columnArray.get(20));
        pricedOrderInCsv.setToBillingZone(columnArray.get(21));
        pricedOrderInCsv.setDestinationHub(columnArray.get(22));
        pricedOrderInCsv.setDeliveryFee(bigDecimalValue(columnArray.get(23)));
        pricedOrderInCsv.setCodCollected(bigDecimalValue(columnArray.get(24)));
        pricedOrderInCsv.setCodFee(bigDecimalValue(columnArray.get(25)));
        pricedOrderInCsv.setInsuredValue(bigDecimalValue(columnArray.get(26)));
        pricedOrderInCsv.setInsuredFee(bigDecimalValue(columnArray.get(27)));
        pricedOrderInCsv.setHandlingFee(bigDecimalValue(columnArray.get(28)));
        pricedOrderInCsv.setGst(bigDecimalValue(columnArray.get(29)));
        pricedOrderInCsv.setTotal(bigDecimalValue(columnArray.get(30)));
        pricedOrderInCsv.setScriptId(integerValue(columnArray.get(31)));
        pricedOrderInCsv.setScriptVersion(columnArray.get(32));
        pricedOrderInCsv.setLastCalculatedDate(columnArray.get(33));
        return pricedOrderInCsv;
    }

    public List<AggregatedOrder> getAggregatedOrdersFromCsv()
    {
        return csvRowsInAggregatedReport;
    }

    public String getOrderFromCsv()
    {
        return csvRowForOrderInShipperReport;
    }

    public String getHeaderLine()
    {
        return headerLineInShipperReport;
    }

    private BigDecimal bigDecimalValue(String value)
    {
        return (value != null && !value.equals("")) ? new BigDecimal(value) : null;
    }

    private Integer integerValue(String value)
    {
        return (value != null && !value.equals("")) ? Integer.valueOf(value) : null;
    }
}
