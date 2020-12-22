package co.nvqa.operator_v2.selenium.elements;

import com.google.common.reflect.TypeToken;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Proxy;
import java.lang.reflect.Type;
import java.util.List;
import java.util.stream.Collectors;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindAll;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.FindBys;
import org.openqa.selenium.support.pagefactory.DefaultElementLocatorFactory;
import org.openqa.selenium.support.pagefactory.DefaultFieldDecorator;
import org.openqa.selenium.support.pagefactory.ElementLocator;

public class CustomFieldDecorator extends DefaultFieldDecorator {

  private WebDriver webDriver;
  private SearchContext searchContext;
  private Class<?> genericType;

  public CustomFieldDecorator(WebDriver webDriver) {
    super(new DefaultElementLocatorFactory(webDriver));
    this.webDriver = webDriver;
  }

  public CustomFieldDecorator(WebDriver webDriver, Class<?> genericType) {
    this(webDriver);
    this.genericType = genericType;
  }

  public CustomFieldDecorator(WebDriver webDriver, SearchContext searchContext) {
    super(new DefaultElementLocatorFactory(searchContext));
    this.webDriver = webDriver;
    this.searchContext = searchContext;
  }

  public CustomFieldDecorator(WebDriver webDriver, SearchContext searchContext,
      Class<?> genericType) {
    this(webDriver, searchContext);
    this.genericType = genericType;
  }

  @Override
  public Object decorate(ClassLoader loader, Field field) {
    if (field.getAnnotation(FindBy.class) == null &&
        field.getAnnotation(FindBys.class) == null &&
        field.getAnnotation(FindAll.class) == null) {
      return null;
    }

    if (isDecoratableClass(field.getType())) {
      ElementLocator locator = factory.createLocator(field);
      if (locator == null) {
        return null;
      }
      return createElement(loader, locator, field);
    }
    Class<?> clazz = getDecoratableClassForList(field);
    if (clazz != null) {
      ElementLocator locator = factory.createLocator(field);
      if (locator == null) {
        return null;
      }
      return createElements(loader, locator, clazz);
    }
    return null;
  }

  protected Class<?> getDecoratableClassForList(Field field) {
    if (!List.class.isAssignableFrom(field.getType())) {
      return null;
    }

    Type genericType = field.getGenericType();
    if (!(genericType instanceof ParameterizedType)) {
      return null;
    }

    Type listType = ((ParameterizedType) genericType).getActualTypeArguments()[0];
    Class<?> clazz =
        this.genericType != null ? this.genericType : TypeToken.of(listType).getRawType();

    return isDecoratableClass(clazz) ? clazz : null;
  }

  private boolean isDecoratableClass(Class<?> clazz) {
    try {
      clazz.getConstructor(WebDriver.class, WebElement.class);
    } catch (Exception e) {
      try {
        clazz.getConstructor(WebDriver.class, SearchContext.class, WebElement.class);
      } catch (Exception ex) {
        return false;
      }
    }

    return true;
  }

  @SuppressWarnings("unchecked")
  protected <T> T createElement(ClassLoader loader, ElementLocator locator, Field field) {
    WebElement proxy = proxyForLocator(loader, locator);
    Class<T> clazz = (Class<T>) field.getType();
    Type type = field.getGenericType();
    if (type instanceof ParameterizedType) {
      Type listType = ((ParameterizedType) type).getActualTypeArguments()[0];
      return createInstance(clazz, proxy, TypeToken.of(listType).getRawType());
    } else {
      return createInstance(clazz, proxy, null);
    }
  }

  protected <T> List<T> createElements(ClassLoader loader, ElementLocator locator, Class<T> clazz) {
    return proxyForListElements(loader, locator, clazz);
  }

  @SuppressWarnings("unchecked")
  protected <T> List<T> proxyForListElements(ClassLoader loader, ElementLocator locator,
      Class<T> clazz) {
    InvocationHandler handler = new LocatingElementListHandler(locator, clazz);
    return (List<T>) Proxy.newProxyInstance(
        loader, new Class[]{List.class}, handler);
  }

  private <T> T createInstance(Class<T> clazz, WebElement element, Class<?> genericType) {
    try {
      if (searchContext != null) {
        return clazz.getConstructor(WebDriver.class, SearchContext.class, WebElement.class)
            .newInstance(webDriver, searchContext, element);
      } else if (genericType != null) {
        return clazz.getConstructor(WebDriver.class, WebElement.class, Class.class)
            .newInstance(webDriver, element, genericType);
      } else {
        return clazz.getConstructor(WebDriver.class, WebElement.class)
            .newInstance(webDriver, element);
      }
    } catch (Exception e) {
      throw new AssertionError("WebElement can't be represented as " + clazz, e);
    }
  }

  public class LocatingElementListHandler implements InvocationHandler {

    private final ElementLocator locator;
    private final Class<?> clazz;

    public LocatingElementListHandler(ElementLocator locator, Class<?> clazz) {
      this.locator = locator;
      this.clazz = clazz;
    }

    public Object invoke(Object object, Method method, Object[] objects) throws Throwable {
      List<WebElement> elements = locator.findElements();
      List<Object> decoratedElements = elements.stream()
          .map(element -> createInstance(clazz, element, null))
          .collect(Collectors.toList());

      try {
        return method.invoke(decoratedElements, objects);
      } catch (InvocationTargetException e) {
        // Unwrap the underlying exception
        throw e.getCause();
      }
    }
  }
}
