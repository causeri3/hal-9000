import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;


class Fields{
    //private var font_width; 
    private var font_size; 
    private var width;
    private var height;
    private var cx; 
    private var cy; 
    private var r; 
    private var angles; 
    //private var angle_step_size = 8.4375;
    private var fonts;
    
    function init(dc as Dc){
        width = dc.getWidth();
        height = dc.getHeight(); 
        //font_width = dc.getWidth()*.054;
        font_size = dc.getWidth()*.07;
        cx = width / 2;
        cy = cx - (font_size/2);
        r = cy - (font_size * 1.15);

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
        Log.debug(fieldsString);

        dc.setColor(0xff0000, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < angles.size(); i += 1) {
            var angle = angles[i];
            var radians = angle * Math.PI / 180.0;

            // reverse string
            var char = fieldsString.substring(fieldsString.length() - 1 - i, fieldsString.length() - i);

            if (char.equals(" ") || char.equals("•")){
                font = Graphics.FONT_SMALL;
                y = cy + (r-(font_size/5)) * Math.cos(radians);
                x = cx + (r-(font_size/5)) * Math.sin(radians);
            }
            else{
                font = fonts[i];
                x = cx + r * Math.sin(radians);
                y = cy + r * Math.cos(radians);
            }
            dc.drawText(x, y, font, char, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }


    function drawCurvedArc(dc as Dc, 
                          x as Number, 
                          y as Number, 
                          r as Number, 
                          percentage as Number, 
                          colour as Number) {
        if (percentage == 0){return;}
        var span = 360.0 * ((100-percentage) / 100.0);
        var startAngle = 270 - (span / 2);
        var endAngle = 270 + (span / 2);

        dc.setColor(colour, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, r, Graphics.ARC_CLOCKWISE, startAngle, endAngle);
    }


    function drawOuterArch(dc as Dc) as Void{
        //var bodyBattery = getBodyBattery();
        //bodyBattery = bodyBattery.equals("") ? 0 as Number : bodyBattery.toNumber();
        //var value = 50;

        var arc3SettingString = Settings.getFieldString(Settings.SettingArc3);
        if (arc3SettingString.equals("None")) {return;}
        var value = choose_field(arc3SettingString, false);

        dc.setPenWidth(width*.01);
        var r = .485*width;
        var x =  .5*width;
        var y = .5*width;
        var colour = Graphics.COLOR_WHITE;
        
        drawCurvedArc(dc, x, y, r, value, colour);

    }

    function drawMiddleArch(dc as Dc) as Void{
        //var bodyBattery = getBodyBattery();
        //bodyBattery = bodyBattery.equals("") ? 0 as Number : bodyBattery.toNumber();
        //var value = 50;
        var arc2SettingString = Settings.getFieldString(Settings.SettingArc2);
        if (arc2SettingString.equals("None")) {return;}
        var value = choose_field(arc2SettingString, false);
        if (value == null) {return;}
        dc.setPenWidth(width*.0155);
        var r = .45*width;
        var x =  .5*width;
        var y = .5*width;
        var colour = 0xaaaaaa;
        
        drawCurvedArc(dc, x, y, r, value, colour);

    }

    function drawInnerArch(dc as Dc) as Void{
        //var bodyBattery = getBodyBattery();
        //bodyBattery = bodyBattery.equals("") ? 0 as Number : bodyBattery.toNumber();
        //var value = 50;
        var arc1SettingString = Settings.getFieldString(Settings.SettingArc1);
        if (arc1SettingString.equals("None")) {return;}
        var value = choose_field(arc1SettingString, false);
        if (value == null) {return;}


        dc.setPenWidth(width*.005);
        var r = .435*width;
        var x =  .5*width;
        var y = .5*width;
        var colour = 0x55aaff;
        //var colour = Graphics.COLOR_WHITE;
        drawCurvedArc(dc, x, y, r, value, colour);

    }


    function drawBattery(dc as Dc) as Void {
        var batterySettingString = Settings.getFieldString(Settings.SettingRefField);
        if (batterySettingString.equals("None")) {return;}
        var batteryValue = choose_field(batterySettingString, false);
        if (batteryValue == null) {return;}

        dc.setPenWidth(1);
        //var stats = System.getSystemStats();
        //var battery = stats.battery;
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
        var _x = .75*width;
        var _y = .45*height;
        var w_body = .12*width;
        var h_body = .02*height;
        var w_tip = .008*width;
        dc.fillRectangle(_x + w_body, _y, w_tip, h_body);    // end of battery space
    
        // battery level in red when under 20%
        if (batteryValue <= 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        var fillWidth = (batteryValue / 100.0) * w_body;
        dc.fillRectangle(_x, _y, fillWidth, h_body);
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
    // Dictionary: "fieldName" => [ function, padLength, padChar ]
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

    var cfg = config[settingString];

    // If not found, act like "None"
    if (cfg == null) {
        return typeString ? "" : 0;
    }

    // Handle "None" specially
    if (settingString == "None") {
        return typeString ? "" : 0;
    }

    // Call the function in the first array slot
    var rawValue = cfg[0];

    if (typeString) {
        return padLeft(rawValue, cfg[1], cfg[2]);
    } else {
        Log.debug("settingString " + settingString);
        Log.debug("rawValue " + rawValue);
        return rawValue;
    }
}


    function update_fields(dc as Dc) as Void{
        drawFieldsString(dc); 
        drawBattery(dc);
        drawOuterArch(dc);
        drawMiddleArch(dc);
        drawInnerArch(dc);
    }
}


// to do:
// draw hal with monkey c & integrate in animation
// upload reflections bitmap
// make trigger fied choosable
// make threshold number input more variable

