import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

module Settings {
    var SettingField1;
    var SettingField2;
    var SettingField3;
    var stressScoreSetting;
    var caloriesGoal;
    var stepsGoal;
    var animationSetting;
    var batterySetting;


    function getOrDefault(key, defaultValue, expectedType) {
        var value = Application.Properties.getValue(key);
        return (value != null && value instanceof expectedType) ? value : defaultValue;
    }
    // default values are workaround for non-reproducable (in the simulator) crash: 
    // Error: Unexpected Type Error\n- **Details**: Failed invoking <symbol>
    // Affected Firmware: 006-B4261-00 (14.15), 006-B3838-00 (5.10), 006-B3704-00 (19.05), 006-B3703-00 (19.05), 006-B3536-00 (8.00), 006-B4532-00 (15.32)
    // in line: var fieldResource = getFieldResource(fieldId);

    function getProperties() {
        SettingField1 = getOrDefault("Field1", 1, Lang.Number);
        SettingField2 = getOrDefault("Field2", 5, Lang.Number);
        SettingField3 = getOrDefault("Field3", 2, Lang.Number);
        stepsGoal = getOrDefault("stepsGoal", 10000, Lang.Number);
        stressScoreSetting = getOrDefault("stressThreshold", 50, Lang.Number);
        caloriesGoal = getOrDefault("caloriesGoal", 2000, Lang.Number);
        animationSetting = getOrDefault("animationSetting", true, Lang.Boolean);
        batterySetting = getOrDefault("batterySetting", true, Lang.Boolean);
    }



    const fieldsMap = {
        0 => Rez.Strings.none,
        1 => Rez.Strings.heart,
        2 => Rez.Strings.stress,
        3 => Rez.Strings.calories,
        4 => Rez.Strings.date,
        5 => Rez.Strings.time,
        6 => Rez.Strings.body,
        7 => Rez.Strings.caloriesPerc,
        8 => Rez.Strings.steps,
        9 => Rez.Strings.stepsPerc,
        10 => Rez.Strings.minutes,
    };

    function getFieldResource(fieldId){
        var fieldResource = fieldsMap.get(fieldId);
        return fieldResource;
    }

    function getFieldString(fieldId) as String{
        Log.debug("getFieldString " + fieldId);
        var fieldResource = getFieldResource(fieldId);
        var fieldString = WatchUi.loadResource(fieldResource);
        return (fieldString != null) ? fieldString : "";
    }

}
