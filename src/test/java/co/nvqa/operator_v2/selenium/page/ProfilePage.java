package co.nvqa.operator_v2.selenium.page;

import co.nvqa.operator_v2.selenium.elements.Button;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.md.MdSelect;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.FindBy;

/**
 * @author Lanang Jati
 */
@SuppressWarnings("WeakerAccess")
public class ProfilePage extends OperatorV2SimplePage
{
    @FindBy(css = "button[aria-label='Profile']")
    public Button profileButton;
    @FindBy(css = "md-select[ng-model='domain.current']")
    public MdSelect countrySelect;
    @FindBy(css = "app-sidenav")
    public PageElement appSidenav;

    public ProfilePage(WebDriver webDriver)
    {
        super(webDriver);
    }

    public void clickProfileButton()
    {
        profileButton.moveAndClick();
    }

    public void closeProfile()
    {
        appSidenav.moveAndClick();
    }

    public void pickCountry(String country)
    {
        countrySelect.selectValue(country);
    }

    public String getCurrentCountry()
    {
        return countrySelect.getValue();
    }

    public void changeCountry(String newCountry)
    {
        String currentCountry = getCurrentCountry();

        if (currentCountry.equalsIgnoreCase(newCountry))
        {
            closeProfile();
        } else
        {
            pickCountry(newCountry);
        }
    }

    public void currentCountryIs(String country)
    {
        clickProfileButton();
        String currentCountry = getCurrentCountry();
        closeProfile();
        assertTrue(f("Current country is %s not %s", currentCountry, country), currentCountry.equalsIgnoreCase(country));
    }
}
