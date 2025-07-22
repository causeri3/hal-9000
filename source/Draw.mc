import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
// import Toybox.System;
// import Toybox.WatchUi.View;



class Fields{

    private var font_size; 
    private var width;
    private var height;
    private var cx; 
    private var cy; 
    private var r; 
    private var angles; 
    private var angle_step_size = 8.4375;
    private var fonts = [
            WatchUi.loadResource(Rez.Fonts.font0),
            WatchUi.loadResource(Rez.Fonts.font1),
            WatchUi.loadResource(Rez.Fonts.font2),
            WatchUi.loadResource(Rez.Fonts.font3),
            WatchUi.loadResource(Rez.Fonts.font4),
            WatchUi.loadResource(Rez.Fonts.font5),
            WatchUi.loadResource(Rez.Fonts.font6),
            WatchUi.loadResource(Rez.Fonts.font7),
            WatchUi.loadResource(Rez.Fonts.font8),
            WatchUi.loadResource(Rez.Fonts.font9),
            WatchUi.loadResource(Rez.Fonts.font10),
            WatchUi.loadResource(Rez.Fonts.font11),
            WatchUi.loadResource(Rez.Fonts.font12),
            WatchUi.loadResource(Rez.Fonts.font13),
            WatchUi.loadResource(Rez.Fonts.font14),
            WatchUi.loadResource(Rez.Fonts.font15),
            WatchUi.loadResource(Rez.Fonts.font16)
    ];
    
    function init(dc as Dc){
        width = dc.getWidth();
        height = dc.getHeight(); 
        font_size = dc.getWidth()*0.08;
        cx = width / 2;
        r = cx - (font_size);

        angles = [
            67.5, 
            59.0625, 
            50.625, 
            42.1875, 
            33.75, 
            25.3125, 
            16.875, 
            8.4375, 
            360, 
            351.5625, 
            343.125, 
            334.6875, 
            326.25, 
            317.8125, 
            309.375, 
            300.9375, 
            292.5];
        Settings.getProperties();
    }

    function padLeft(input as String, targetLength as Number, padChar as String) as String {
        var paddingNeeded = targetLength - input.length();
        if (paddingNeeded <= 0) {
            return input;
        }
        var padding = "";
        for (var i = 0; i < paddingNeeded; i += 1) {
            padding += padChar;
        }
        return padding + input;
    }

    function addSeperator(value1 as String, value2 as String, value3 as String) as String {
        if ((value1.length() > 0) && (value2.length() > 0)){
            value1 += "•";
            }
        if ((value2.length() > 0) && (value3.length() > 0)){
            value2 += "•";
        }
        if ((value1.length() > 0) && (value2.length() == 0) && (value3.length() > 0)){
            value1 += "•";
        }
        return value1 + value2 + value3;
    }


    function drawTest(dc as Dc) as Void {
        dc.setColor(0xff0000, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < angles.size(); i += 1) {
            // correcting for fact that letters are not being positioned on teh middel, but top, which doesnt work nicely with rotation
            var mirrored_i = i <= 8 ? i : (16 - i);
            var correction = mirrored_i * (angle_step_size * (font_size / 180));
            var angle = angles[i];
            var radians = angle * Math.PI / 180.0;
            var x = cx + (r-correction) * Math.sin(radians);
            var y = cx + (r-correction) * Math.cos(radians);
            if(angle == 360){
                dc.drawText(x, y, Graphics.FONT_TINY, "•", Graphics.TEXT_JUSTIFY_CENTER);
            }
            else{dc.drawText(x, y, fonts[i], "4", Graphics.TEXT_JUSTIFY_CENTER);}

        }

    }

    // function drawHeart(dc as Dc) as Void {

    //     var heartRate = getHeartRate();
    //     var heartSettingString = Settings.getFieldString(Settings.heartSetting);
    //     var heartValue = choose_field(heartSettingString);
    //     if (heartValue.equals("")) {
    //     } 
    //     else {
    //     dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(.46*x, .55*y, TIFFontSmall, "♥", Graphics.TEXT_JUSTIFY_RIGHT);
    //     dc.drawText(.48*x, .6*y, TIFFontSmall, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);
    //     }

    // }

    // function drawCup(dc as Dc) as Void {
    //     var cupSettingString = Settings.getFieldString(Settings.cupSetting);
    //     var cupValue = choose_field(cupSettingString);
    //     dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //     dc.drawText(.76*x, .58*y, TIFFontSmall, cupValue, Graphics.TEXT_JUSTIFY_CENTER);
    // }


    function drawBattery(dc as Dc) as Void {
        var stats = System.getSystemStats();
        var battery = stats.battery;
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
        var _x = .75*width;
        var _y = .45*height;
        var w_body = .08*width;
        var h_body = .04*height;
        var w_tip = .008*width;
        var h_tip = .025*height;
        dc.drawRectangle(_x, _y, w_body, h_body);  // battery body
        dc.drawRectangle(_x + w_body, _y + w_tip, w_tip, h_tip);    // battery tip
    
        // Fill battery level in different color
        if (battery <= 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        var fillWidth = (battery / 100.0) * 18;  // Scale battery level to fit
        dc.fillRectangle(_x + 1, _y + 1, fillWidth, h_body - 2);
    }
    
    function getFieldsString(dc as Dc) {
        var field1SettingString = Settings.getFieldString(Settings.SettingField1);
        var field1Value = choose_field(field1SettingString);
        var field2SettingString = Settings.getFieldString(Settings.SettingField2);
        var field2Value = choose_field(field2SettingString);
        var field3SettingString = Settings.getFieldString(Settings.SettingField3);
        var field3Value = choose_field(field3SettingString);

        var fieldsString = addSeperator(field1Value, field2Value, field3Value);
        //dc.drawText(0.55*width, .045*height, Graphics.FONT_TINY, fieldsString, Graphics.TEXT_JUSTIFY_CENTER);
    }
        

    // function drawSmoke(dc as Dc) as Void {
    //     var smokeSettingString = Settings.getFieldString(Settings.smokeSetting);
    //     var smokeValue = choose_field(smokeSettingString);
    //     dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    //     if (smokeValue.equals("This is Fine")) {
    //         dc.drawText(0.55*x, .045*y, TIFFontTiny, smokeValue, Graphics.TEXT_JUSTIFY_CENTER);
    //     }
    //     else {
    //         dc.drawText(0.5*x, .025*y, TIFFontSmall, smokeValue, Graphics.TEXT_JUSTIFY_CENTER);
    //     }

    // }

    function choose_field(settingString) as String{
        var settingValue;
        
        if (settingString.equals("Calories")) {
            settingValue =  padLeft(getCalories().toString(), 5, "0");
        } 
        else if (settingString.equals("Stress Level")) {
            settingValue = padLeft(getStressLevel(), 3, "0");
        }
        else if (settingString.equals("Body Battery")) {
            settingValue = padLeft(getBodyBattery(), 3, "0");
        }
        else if (settingString.equals("Calories Percentage")) {
            settingValue = padLeft(getCaloriesProgress(), 3, "0");
        }
        else if (settingString.equals("Date")) {
            settingValue = padLeft(getDate(), 5, "0");
        }
        else if (settingString.equals("Time")) {
            settingValue = padLeft(getTime(), 5, "0");
        }
        else if (settingString.equals("Heart Rate")) {
            settingValue = padLeft(getHeartRate(), 3, "0");
        }
        else if (settingString.equals("None")) {
            settingValue = "";
        }
        else {
            settingValue = "";
        }
        return settingValue;
    }

    function update_fields(dc as Dc) as Void{
        drawTest(dc);
        getFieldsString(dc);
        // drawSmoke(dc);
        // drawHeart(dc);
        // drawCup(dc);
        if (Settings.batterySetting) { 
            drawBattery(dc);
        }
    }
}



/// todo
// pad total string, back and front
// if statement with fonts for bulletpoint and empty space
// loop over filed strings