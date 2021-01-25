package co.nvqa.operator_v2.selenium.page;

import co.nvqa.commons.util.NvTestRuntimeException;
import co.nvqa.operator_v2.selenium.elements.CustomFieldDecorator;
import co.nvqa.operator_v2.selenium.elements.PageElement;
import co.nvqa.operator_v2.selenium.elements.TextBox;
import co.nvqa.operator_v2.selenium.page.ViewSortStructurePage.TreeNode.NodeType;
import java.util.List;
import java.util.stream.Collectors;
import org.apache.commons.lang3.StringUtils;
import org.openqa.selenium.SearchContext;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

/**
 * @author Sergey Mishanin
 */
@SuppressWarnings("WeakerAccess")
public class ViewSortStructurePage extends OperatorV2SimplePage {

  @FindBy(tagName = "iframe")
  private PageElement pageFrame;

  @FindBy(css = ".ant-spin-dot")
  public PageElement spinner;

  @FindBy(css = "span[aria-label='loading']")
  public PageElement refreshSpinner;

  @FindBy(css = "g[id]")
  public List<TreeNode> nodes;

  @FindBy(css = "svg > g")
  public PageElement canvas;

  @FindBy(css = "input[placeholder='Search Hub / Middle Tier / Zone']")
  public TextBox search;

  public ViewSortStructurePage(WebDriver webDriver) {
    super(webDriver);
  }

  public void switchTo() {
    getWebDriver().switchTo().frame(pageFrame.getWebElement());
  }

  public void waitUntilLoaded() {
    if (spinner.waitUntilVisible(5)) {
      spinner.waitUntilInvisible();
    }
    if (refreshSpinner.waitUntilVisible(5)) {
      refreshSpinner.waitUntilInvisible();
    }
  }

  public List<String> getNodeLabelsByType(NodeType type) {
    return nodes.stream()
        .filter(node -> node.getType() == type)
        .map(TreeNode::getLabel)
        .collect(Collectors.toList());
  }

  public List<String> getDuplicatedNodes() {
    return nodes.stream()
        .filter(TreeNode::isDuplicate)
        .map(TreeNode::getLabel)
        .collect(Collectors.toList());
  }

  public List<String> getNodeLabels() {
    return nodes.stream()
        .map(TreeNode::getLabel)
        .collect(Collectors.toList());
  }

  public TreeNode findNodeByLabel(String label) {
    return nodes.stream()
        .filter(node -> StringUtils.equalsIgnoreCase(node.getLabel(), label))
        .findFirst()
        .orElseThrow(() -> new IllegalArgumentException("Node [" + label + "] was not found"));
  }

  public void adjustCanvasScale() {
    String transform = canvas.getAttribute("transform");
    String[] transformParts = transform.split(" ");
    double scale = 0.9;
    List<String> nodeLabels = getNodeLabels();
    while (nodeLabels.contains("")) {
      transform = transformParts[0] + " scale(" + scale + ")";
      canvas.executeScript("arguments[0].setAttribute('transform','" + transform + "')");
      nodeLabels = getNodeLabels();
      scale = scale - 0.1;
    }
  }

  public static class TreeNode extends PageElement {

    public enum NodeType {
      HUB, MIDDLE_TIER, ZONE
    }

    public TreeNode(WebDriver webDriver, WebElement webElement) {
      super(webDriver, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    public TreeNode(WebDriver webDriver, SearchContext searchContext, WebElement webElement) {
      super(webDriver, searchContext, webElement);
      PageFactory.initElements(new CustomFieldDecorator(webDriver, webElement), this);
    }

    @FindBy(css = "g.label")
    public PageElement label;

    @FindBy(css = "circle")
    public PageElement circle;

    public String getLabel() {
      return label.getText();
    }

    public boolean isDuplicate() {
      return circle.getAttribute("class").contains("duplicate");
    }

    public NodeType getType() {
      String classes = circle.getAttribute("class");
      if (classes.contains("hub")) {
        return NodeType.HUB;
      } else if (classes.contains("middle_tier")) {
        return NodeType.MIDDLE_TIER;
      } else if (classes.contains("zone")) {
        return NodeType.ZONE;
      } else {
        throw new NvTestRuntimeException("Unknown type of a node");
      }
    }
  }

}