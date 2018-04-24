package co.nvqa.operator_v2.selenium.page;

import org.openqa.selenium.WebDriver;

/**
 *
 * @author Lanang Jati
 */
public class PaymentProcessingPage extends OperatorV2SimplePage
{
    private static final String ADD_FILTER_INPUT = "//md-autocomplete-wrap/input[@aria-label='Select Filter']";

    public PaymentProcessingPage(WebDriver webDriver)
    {
        super(webDriver);
    }

    private String getFilterInput(String filterName)
    {
        return String.format("//nv-autocomplete[@item-types='%s']/div/label/md-autocomplete/md-autocomplete-wrap/input", filterName);
    }
}
