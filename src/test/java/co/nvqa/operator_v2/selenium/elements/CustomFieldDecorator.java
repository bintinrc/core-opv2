package co.nvqa.operator_v2.selenium.elements;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.pagefactory.DefaultElementLocatorFactory;
import org.openqa.selenium.support.pagefactory.DefaultFieldDecorator;
import org.openqa.selenium.support.pagefactory.ElementLocator;

import java.lang.reflect.Field;

public class CustomFieldDecorator extends DefaultFieldDecorator
{
    private WebDriver webDriver;

    public CustomFieldDecorator(WebDriver webDriver)
    {
        super(new DefaultElementLocatorFactory(webDriver));
        this.webDriver = webDriver;
    }

    @Override
    public Object decorate(ClassLoader loader, Field field)
    {
        Class<?> decoratableClass = decoratableClass(field);
        if (decoratableClass != null)
        {
            ElementLocator locator = factory.createLocator(field);
            if (locator == null)
            {
                return null;
            }

            return createElement(loader, locator, decoratableClass);
        }
        return null;
    }

    private Class<?> decoratableClass(Field field)
    {

        Class<?> clazz = field.getType();

        try
        {
            clazz.getConstructor(WebDriver.class, WebElement.class);
        } catch (Exception e)
        {
            return null;
        }

        return clazz;
    }

    protected <T> T createElement(ClassLoader loader,
                                  ElementLocator locator, Class<T> clazz)
    {
        WebElement proxy = proxyForLocator(loader, locator);
        return createInstance(clazz, proxy);
    }

    private <T> T createInstance(Class<T> clazz, WebElement element)
    {
        try
        {
            return clazz.getConstructor(WebDriver.class, WebElement.class).newInstance(webDriver, element);
        } catch (Exception e)
        {
            throw new AssertionError("WebElement can't be represented as " + clazz, e);
        }
    }
}
