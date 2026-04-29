
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class hal9000View extends WatchUi.WatchFace{
    private var fields as Fields;
    private var animation as BackgroundAnimation;
    private var sleep;

    function initialize() {
        WatchFace.initialize();
        fields = new Fields();
        animation = new BackgroundAnimation();
        sleep = false;

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //Log.debug("onLayout");
        //Log.debug("Before init Dimensions");
        //Log.showMemoryUsage();
        Dimensions.init(dc);
        //Log.debug("Before init fields");
        //Log.showMemoryUsage();
        fields.init(dc);
        //Log.debug("After init fields");
        //Log.showMemoryUsage();
        HAL.init();
        //setLayout(Rez.Layouts.WatchFace(dc));
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        Log.debug("onShow");
        // bugfix, if onShow and in sleep: timer.start() leads to 
        // Error: Permission Required
        // Details: "Symbol 'start' not available to 'Watch Face'"
        if (sleep != true) {
            animation.setAnimationTimer();
            animation.updateAnimationState();
        }
    }


    function onUpdate(dc as Dc) as Void {
        //Log.debug("onUpdate");
        //Log.showMemoryUsage();
        if (Settings.animationSetting) { 
            //Log.debug("Animation is set on ON");
            ifAnimationOn(dc);
        }
        else{
            //Log.debug("Animation is set on OFF");
            if (animation.isAnimating) {
                animation.stopAnimation();
            }
            basicUpdate(dc);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    // In Simulator trigger by:  Settings > Force onHide and Settings > Force onShow
    // or juts by caling the menu Settings > Trigger App Settings (here you can see that nothing is being updated)
    function onHide() as Void {
        Log.debug("In onHide");
        // needs to be stopped, becuase not triggered by update, but timer
        animation.stopAnimation();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    // In Simulator trigger by: Settings > Disply Mode > Always on > Toggle Power Mode (ooff and on)
    function onExitSleep() as Void {
        Log.debug("onExitSleep");
        sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        Log.debug("onEnterSleep");
        sleep = true;
        animation.stopAnimation();
    }

    hidden function ifAnimationOn(dc) as Void {
        if (!sleep){
            animation.updateAnimationState();
        }
        // I thought I would be smart by only drawing the background if the timer doesnt do it, 
        // but it led to a black screen for mome milliseconds on the forerunner, fenix and enduro models
        // appearently they clear the screen no matter what on update
        basicUpdate(dc);
    }

    hidden function basicUpdate(dc) as Void {
        HAL.draw_hal(dc, animation.halIndex);
        fields.update_fields(dc);
        //Log.debug("Regular Update - No Animation");
    }

}



