package nl.overheid.aerius.wui;

import nl.overheid.aerius.wui.ServiceEndPoint;

public class MockHost extends ServiceEndPoint {
  @Override
  public String get() {
    return "http://{{cp.pr.id}}.mock.{{cp.deployment.host}}/";
  }
}
