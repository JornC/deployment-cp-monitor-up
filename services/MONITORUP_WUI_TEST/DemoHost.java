package nl.overheid.aerius.wui;

import nl.overheid.aerius.wui.ServiceEndPoint;

public class DemoHost extends ServiceEndPoint {
  @Override
  public String get() {
    return "http://{{cp.testserver.host}}";
  }

  public String getUser() {
    return "{{cp.testserver.user}}";
  }

  public String getPassword() {
    return "{{cp.testserver.password}}";
  }
}
