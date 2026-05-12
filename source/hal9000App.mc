import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Time;

class hal9000App extends Application.AppBase {
    var analytics = new Analytics();

    function initialize() {
        AppBase.initialize();
        //Log.debug("AppBase initialized");

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        var settings = System.getDeviceSettings();
        Storage.setValue("deviceId", settings.uniqueIdentifier);
        Storage.setValue("partNumber", settings.partNumber);
        // fire every six hours, to check if this day was used, also send settings changes, if stored
        Background.registerForTemporalEvent(new Time.Duration(6*6*60));
    }


    function onAppInstall() as Void {
        analytics.track("install", null);
        Background.exit(null);
    }

    function onAppUpdate() as Void {
        analytics.track("update", null);
        Background.exit(null);
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new hal9000View() ];
    }
    
    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void{
        Settings.getProperties();
        analytics.trackSettings(Settings.getPropertiesAsDict());
        WatchUi.requestUpdate();
    }

  function getSettingsView() {
    return [new Menu(), new MenuDelegate()];
  }

  function getServiceDelegate() {
    return [new AnalyticsBackground()];
  }

}