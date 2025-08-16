
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;


class BackgroundAnimation {
    private var timer;
    private var halIndex = 0;
    var isAnimating = false;
    var timerTriggered = false;
    private var direction = 1; // 1 forward, -1 backward
    private var hal = new HAL();

    function drawBackground(dc) {
        hal.draw_hal(dc, halIndex);
    }

    function setAnimationTimer() {
       if (timer == null) {
           timer = new Timer.Timer();
       }
        Log.debug("In setAnimationTimer: " + timer.toString());
    }
    function random(min, max) {
        return min + Math.rand() % (max-min);   
    } 

    function restartAnimationTimer() {
        Log.debug("restartAnimationTimer() is being called.");

        if (timer != null) {
            //Log.debug("Timer object: " + timer.toString());
            timer.stop();
            // random intervall felt more organic to me
            var random_intervall = random(400, 600);
            //Log.debug("New random_intervall: " + random_intervall);
            timer.start(method(:switchBackground), random_intervall, false); 
        } else {
            Log.debug("Timer is null in restartAnimationTimer()");
        }
    }

    function updateAnimationState() {
        var stressLevel = getStressLevel();
        // == doesnt work with strings in Monkey c - Java like
        stressLevel = stressLevel == null ? 0 : stressLevel;

        if (stressLevel < Settings.stressScoreSetting) {
            stopAnimation();
            // free the previous image to save memory
            halIndex = 0;
        } else {
            startAnimation();
        }
    }

    function startAnimation() {
        Log.debug("in startAnimation: isAnimating is " + isAnimating.toString());

        if (timer != null && !isAnimating) {
            isAnimating = true;
            restartAnimationTimer();        
            }
    }

    function stopAnimation() {
        Log.debug("in stopAnimation: isAnimating is " + isAnimating.toString());
        Log.debug("timer is null: " + (timer == null).toString());
        if (timer != null && isAnimating) {
            isAnimating = false;
            timer.stop();
            timerTriggered = false;
        }
    }

    function switchBackground() as Void {
        halIndex += direction;

        if (halIndex == 3) {
            direction = -1;
        } else if (halIndex == 0) {
            direction = 1;
        }
        restartAnimationTimer();
        timerTriggered = true;
        WatchUi.requestUpdate(); 
    }
}

