import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.System;

var _alert_displayed as Boolean = false;

//! The data field alert
class DataFieldAlertView extends WatchUi.DataFieldAlert {
    //! Constructor
    public function initialize() {
        DataFieldAlert.initialize();
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, Graphics.FONT_LARGE, "Time to Refuel!", Graphics.TEXT_JUSTIFY_CENTER);
    }

    public function onHide() {
        System.println("should hide alert");
        $._alert_displayed = false;
    }
}

// TODO: Have the cycle actually be a cycle. Ex. every x time add time eaten and show alert
// TODO: Be able to dismiss alert and show another one in the future - done
// TODO: Use ALERT_DISPLAY_DELAY
// TODO: Settings page :)
// TODO: Have everything reset after x amount of minutes paused/stopped
// TODO: Repeat for water and just timer
// TODO: RELEASE!

class refuel_data_fieldView extends WatchUi.SimpleDataField {
    private const FUELING_INTERVAL = 0.5; // min
    // private const ALERT_DISPLAY_DELAY = 30; // sec - negative values will alert early
    private const MILLISECONDS_TO_SECONDS = 0.001;
    private const MINUTES_TO_SECONDS = 60;
    private const START_FEED_COUNT_FROM_1 = true;

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Times Fueled";
    }

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        var timer_seconds = (info.timerTime * MILLISECONDS_TO_SECONDS).toNumber();

        var amount_of_times_eaten = (timer_seconds / (FUELING_INTERVAL * MINUTES_TO_SECONDS)).toNumber();
        if (START_FEED_COUNT_FROM_1) {
            amount_of_times_eaten += 1;
        }

        if ((WatchUi.DataField has :showAlert) and (timer_seconds > 1)
            and !$._alert_displayed and !we_showed_the_alert_dummy) {
            System.println("should show alert");
            WatchUi.DataField.showAlert(new $.DataFieldAlertView());
            $._alert_displayed = true;
        }

        return amount_of_times_eaten;
    }

}