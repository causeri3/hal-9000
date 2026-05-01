import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;


module Dimensions {
    var width, height, cx;

    function init(dc as Dc){
        width = dc.getWidth();
        height = dc.getHeight(); 
        cx = width / 2;
    }
}

class Fields{
    private var font_size; 
    private var r; 
    private var angles; 
    private var fonts;
    
    function init(dc as Dc){

        //Log.debug("Init Fields: Load Fonts");
        font_size = Dimensions.width*.07;
        r = Dimensions.cx - (font_size * 1.3);


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

        //Log.debug("Before Load Fonts");
        //Log.showMemoryUsage();
        fonts = [
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
        //Log.debug("After Load Fonts");
        //Log.showMemoryUsage();

        Settings.getProperties();
    }


    function padLeft(input, targetLength as Number, padChar as String) as String {
        input = reformatToString(input);
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
            value1 += "|";
            }
        if ((value2.length() > 0) && (value3.length() > 0)){
            value2 += "|";
        }
        if ((value1.length() > 0) && (value2.length() == 0) && (value3.length() > 0)){
            value1 += "|";
        }
        return value1 + value2 + value3;
    }


    function extendString(fieldsString as String) as String {
        var missingChars = 17 - fieldsString.length();
        if (missingChars == 0){
            return fieldsString;
            }
        var spaces = "";
        for (var i = 0; i < (missingChars/2); i += 1) {
            spaces += " ";
            }
        return spaces + fieldsString + spaces;
        }


    function drawFieldsString(dc as Dc) as Void {
        var font;
        var fieldsString = getFieldsString();
        var x;
        var y;
        //Log.debug(fieldsString);

        dc.setColor(0xff0000, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < angles.size(); i += 1) {
            var angle = angles[i];
            var radians = angle * Math.PI / 180.0;

            // reverse string
            var char = fieldsString.substring(fieldsString.length() - 1 - i, fieldsString.length() - i);
            x = Dimensions.cx + r * Math.sin(radians);
            // smidge offset
            y = (Dimensions.cx * 0.97) + r * Math.cos(radians);
            
            if (char.equals(" ")){
                font = Graphics.FONT_SMALL;
            }

            else{
                font = fonts[i];
            }
            dc.drawText(x, y, font, char, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }


    function drawCurvedArc(dc as Dc, 
                          x as Number, 
                          y as Number, 
                          r as Number, 
                          percentage as Number, 
                          colour as Number) {
        if (percentage == null || percentage == 0) { return; }
        var span = 360.0 * ((100-percentage) / 100.0);
        var startAngle = 270 - (span / 2);
        var endAngle = 270 + (span / 2);

        dc.setColor(colour, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, r, Graphics.ARC_CLOCKWISE, startAngle, endAngle);
    }


    function drawOuterArch(dc as Dc) as Void{

        var arc3SettingString = Settings.getFieldString(Settings.SettingArc3);
        if (arc3SettingString.equals("None")) {return;}
        var value = choose_field(arc3SettingString, false);

        dc.setPenWidth(Dimensions.width*.01);
        var r = .485*Dimensions.width;
        var x =  .5*Dimensions.width;
        var y = .5*Dimensions.width;
        var colour = Graphics.COLOR_WHITE;
        
        drawCurvedArc(dc, x, y, r, value, colour);

    }

    function drawMiddleArch(dc as Dc) as Void{

        var arc2SettingString = Settings.getFieldString(Settings.SettingArc2);
        if (arc2SettingString.equals("None")) {return;}
        var value = choose_field(arc2SettingString, false);
        if (value == null) {return;}
        dc.setPenWidth(Dimensions.width*.0155);
        var r = .465*Dimensions.width;
        var x =  .5*Dimensions.width;
        var y = .5*Dimensions.width;
        var colour = 0xaaaaaa;
        
        drawCurvedArc(dc, x, y, r, value, colour);

    }

    function drawInnerArch(dc as Dc) as Void{

        var arc1SettingString = Settings.getFieldString(Settings.SettingArc1);
        if (arc1SettingString.equals("None")) {return;}
        var value = choose_field(arc1SettingString, false);
        if (value == null) {return;}


        dc.setPenWidth(Dimensions.width*.005);
        var r = .45*Dimensions.width;
        var x = .5*Dimensions.width;
        var y = .5*Dimensions.width;
        var colour = 0x55aaff;
        drawCurvedArc(dc, x, y, r, value, colour);

    }

    function drawBatteryRight(dc as Dc) as Void {
        drawBattery(dc, .75*Dimensions.width, Settings.SettingRefField);
    }

    // function drawBatteryLeft(dc as Dc) as Void {
    //     drawBattery(dc, .122*Dimensions.width, Settings.SettingRefField);
    // }


    function drawBattery(dc as Dc, x, SettingRefField) as Void {
        var batterySettingString = Settings.getFieldString(SettingRefField);
        if (batterySettingString.equals("None")) {return;}
        var batteryValue = choose_field(batterySettingString, false);
        if (batteryValue == null) {return;}

        dc.setPenWidth(1);
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var y = .45*Dimensions.height;
        var w_body = .12*Dimensions.width;
        var h_body = .02*Dimensions.height;
        var w_tip = .008*Dimensions.width;
        dc.fillRectangle(x + w_body, y, w_tip, h_body);    // end of battery space
    
        // battery level in red when under 20%
        if (batteryValue <= 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        var fillWidth = (batteryValue / 100.0) * w_body;
        dc.fillRectangle(x, y, fillWidth, h_body);
    }
    

    function getFieldsString() {
        var field1SettingString = Settings.getFieldString(Settings.SettingField1);
        var field1Value = choose_field(field1SettingString, true);
        var field2SettingString = Settings.getFieldString(Settings.SettingField2);
        var field2Value = choose_field(field2SettingString, true);
        var field3SettingString = Settings.getFieldString(Settings.SettingField3);
        var field3Value = choose_field(field3SettingString, true);
        var fieldsString = extendString(addSeperator(field1Value, field2Value, field3Value));
        return fieldsString;
    }
        
    function choose_field(settingString as String, typeString as Boolean) {
        var config = {
            "Calories" => [getCalories(), 5, "0"],
            "Steps"  => [getSteps(), 5, "0"],
            "Active Minutes This Week" => [getActiveMinutes(), 3, "0"],
            "Stress Level" => [getStressLevel(), 3, "0"],
            "Body Battery" => [getBodyBattery(), 3, "0"],
            "Battery Level" => [getBatteryLevel(), 3, "0"],
            "Calories Percentage" => [getCaloriesProgress(), 3, "0"],
            "Steps Percentage" => [getStepsProgress(), 3, "0"],
            "Date" => [getDate(), 5, "0"],
            "Time" => [getTime(), 5, "0"],
            "Heart Rate" => [getHeartRate(), 3, "0"],
            "None" => [null, 0, "0"]
        };

        var cfg = config[settingString] as Array;

        if (settingString == "None") {
            return typeString ? "" : 0;
        }

        var rawValue = cfg[0];

        if (typeString) {
            return padLeft(rawValue, cfg[1], cfg[2]);
        } else {
            return rawValue;
        }
    }

    function update_fields(dc as Dc) as Void{
        drawFieldsString(dc); 
        drawBatteryRight(dc);
        //drawBatteryLeft(dc);
        drawOuterArch(dc);
        drawMiddleArch(dc);
        drawInnerArch(dc);
    }
}



module HAL{
    var colours as Array<Number>?;
    var circle_distances as Array<Array<Number>>?;
    function init(){
        colours = [
        0x000000, 0x550000, 
        0xAA0000, 0xFF0000, 
        0xFF5500, 0xFFFFFF, 
        0xFFAA00, 0xFFAA55, 
        0xFFFFAA, 0xFFFFFF
        ];
        var dist_0 = [168, 75, 15, 50, 30, 3, 30, 15, 25, 10];
        var dist_1 = [168, 60, 15, 60, 35, 3, 30, 15, 25, 10];
        var dist_2 = [168, 35, 25, 70, 40, 3, 30, 15, 25, 10];
        var dist_3 = [118, 60, 35, 80, 45, 3, 30, 15, 25, 10];
        circle_distances = [dist_0, dist_1, dist_2, dist_3];
    }


function drawReflections(dc as Dc) as Void {

    var rOuter = Dimensions.width * .85;
    var cyOuter =  Dimensions.width;
    var cyInner =  Dimensions.width * .6;
    var rInner = Dimensions.width * .25;

    
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(Dimensions.width*.06);
    dc.drawArc(Dimensions.cx, cyOuter, rOuter, Graphics.ARC_COUNTER_CLOCKWISE, 60, 75);
    dc.setPenWidth(Dimensions.width*.055);
    dc.drawArc(Dimensions.cx, cyOuter, rOuter, Graphics.ARC_COUNTER_CLOCKWISE, 80, 100);
    dc.setPenWidth(Dimensions.width*.05);
    dc.drawArc(Dimensions.cx, cyOuter, rOuter, Graphics.ARC_COUNTER_CLOCKWISE, 105, 120);

    dc.setPenWidth(Dimensions.width*.02);   
    dc.drawArc(Dimensions.cx, cyInner, rInner, Graphics.ARC_COUNTER_CLOCKWISE, 50, 60);
    dc.drawArc(Dimensions.cx, cyInner, rInner, Graphics.ARC_COUNTER_CLOCKWISE, 70, 110);
    dc.drawArc(Dimensions.cx, cyInner, rInner, Graphics.ARC_COUNTER_CLOCKWISE, 120, 130);

    // cut off refelctions by black ring
    dc.setPenWidth(Dimensions.width*.1);
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(Dimensions.cx,  Dimensions.cx, .5*Dimensions.width, Graphics.ARC_CLOCKWISE, 180, 360);
    // draw grey ring, for square watches
    dc.setPenWidth(Dimensions.width*.005);
    dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(Dimensions.cx,  Dimensions.cx, .49*Dimensions.width, Graphics.ARC_COUNTER_CLOCKWISE, 360, 0);
}

    
    function draw_hal(dc as Dc, index as Number){
        // black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        //Log.debug("Before drawing HAL");
        //Log.showMemoryUsage();
        dc.clear();
        var dist = circle_distances[index];

        var sumDist = 427; //(sum of dist)

        var scale  = (Dimensions.width * 0.5 / sumDist);
        var r = (sumDist * scale);

        // Draw from outside to inside
        for (var i = 0; i < colours.size() && i < dist.size(); i += 1) {
            var col = colours[i] as Number;
            var shrink = (dist[i] * scale);
            dc.setColor(col, Graphics.COLOR_BLACK);
            if (r > 0) {
                dc.fillCircle(Dimensions.cx, Dimensions.cx, r);
            }

            r -= shrink;
            if (r <= 0) {
                break;
            }
        //Log.debug("After drawing HAL");
        //Log.showMemoryUsage();
        }
        drawReflections(dc);
    }
    }
