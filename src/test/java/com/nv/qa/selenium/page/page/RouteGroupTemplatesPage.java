package com.nv.qa.selenium.page.page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

/**
 *
 * @author Daniel Joi Partogi Hutapea
 */
public class RouteGroupTemplatesPage extends SimplePage
{
    public RouteGroupTemplatesPage(WebDriver driver)
    {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public void createRouteGroupTemplate(String routeGroupTemplateName, String filterQuery)
    {
        clickButton("//button[@aria-label='Add Template']");
        setRouteGroupNameValue(routeGroupTemplateName);
        setFilterQuery(filterQuery);
        clickSubmitOnAddTag();
    }

    public void setRouteGroupNameValue(String value)
    {
        sendKeys("//input[@aria-label='Route Group Template Name']", value);
    }

    public void setFilterQuery(String value)
    {
        sendKeys("//textarea[@aria-label='Filter Query']", value);
    }

    public void clickSubmitOnAddTag()
    {
        clickButton("//button[@aria-label='Save Button']");
    }
}
