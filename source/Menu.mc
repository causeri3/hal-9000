import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

  function initialize() {
    Menu2.initialize({ :title => "Settings"});
    add_items();
  }

  function add_items() {     
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Field1, // label
            Settings.getFieldString(Settings.SettingField1), // sublabel
            "Field1", // id
            {} // options
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Field2,
            Settings.getFieldString(Settings.SettingField2),
            "Field2",
            {}
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Field3, 
            Settings.getFieldString(Settings.SettingField3), 
            "Field3", 
            {} 
        )
    );

    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Arc1,
            Settings.getFieldString(Settings.SettingArc1),
            "Arc1", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Arc2,
            Settings.getFieldString(Settings.SettingArc2),
            "Arc2", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.Arc3,
            Settings.getFieldString(Settings.SettingArc3),
            "Arc3", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.RefField,
            Settings.getFieldString(Settings.SettingRefField),
            "RefField", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.stressThreshold, 
            Settings.stressScoreSetting.toString(), 
            "stressThreshold", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.caloriesGoal, 
            Settings.caloriesGoal.toString(),
            "caloriesGoal", 
            {} 
        )
    );
     Menu2.addItem(                                                                                                   
         new MenuItem(                                                                                                
             Rez.Strings.animationSetting,                                                              
             Settings.animationSetting ? Rez.Strings.on : Rez.Strings.off,                     
             "animationSetting",                                                                                      
             {}                                                                                                       
         )                                                                                                            
     ); 
  }                                                                                                       
}

class MenuDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    var id = item.getId();
    var arcKeys = [0, 2, 6, 8, 9, 11]; // only none, stress, body battery, % calories, % steps, battery level  
    var refKeys = [0, 6, 8, 9, 11]; // only none, body battery, % calories, % steps, battery level    
  
    if (id.equals("Field1")) {
      cycleFields(Settings.SettingField1, item, id, null);
    }
    else if (id.equals("Field2")) {
      cycleFields(Settings.SettingField2, item, id, null);
    }
    else if (id.equals("Field3")) {
      cycleFields(Settings.SettingField3, item, id, null);
    }
    if (id.equals("Arc1")) {
      cycleFields(Settings.SettingArc1, item, id, arcKeys);
    }
    if (id.equals("Arc2")) {
      cycleFields(Settings.SettingArc2, item, id, arcKeys);
    }
    if (id.equals("Arc3")) {
      cycleFields(Settings.SettingArc3, item, id, arcKeys);
    }
    if (id.equals("RefField")) {
      cycleFields(Settings.SettingRefField, item, id, refKeys);
    }
    else if (id.equals("stressThreshold")) {                                                                      
       cycleNumbers(Settings.stressScoreSetting, item, id, 10, 110);                                                                             
     }
    else if (id.equals("caloriesGoal")) {                                                                      
       cycleNumbers(Settings.caloriesGoal, item, id, 100, 10100);                                                                     
     }
    else if (id.equals("animationSetting")) {                                                                        
       toggleAnimation(item);                                                                                         
     }  
  }

//var validKeys as Null or Array<Number> = null;

  hidden function cycleFields(setting, item, fieldId, validKeys){
    if (validKeys == null) {                                                 
           validKeys = Settings.fieldsMap.keys();                               
    }     
    var currentIndex = validKeys.indexOf(setting);
    var nextIndex = (currentIndex + 1) % validKeys.size();
    // make compiler happy by giving container type
    var keys = validKeys as Array<Number>;
    setting = keys[nextIndex]; 
    item.setSubLabel(Settings.getFieldString(setting));
    Application.Properties.setValue(fieldId, setting);
    Settings.getProperties();
  }

  hidden function cycleNumbers(setting, item, fieldId, step, max){                                                            
     var currentValue = setting;                                                           
     var nextValue = (currentValue + step) % max;
     item.setSubLabel(nextValue.toString());                                                                   
     Application.Properties.setValue(fieldId, nextValue);                                                      
     Settings.getProperties();                                                                                     
   } 

  hidden function toggleAnimation(item){                                                                             
     Settings.animationSetting = !Settings.animationSetting;                                                                
     item.setSubLabel(Settings.animationSetting ? Rez.Strings.on : Rez.Strings.off);                                     
     Application.Properties.setValue("animationSetting", Settings.animationSetting);                                        
     Settings.getProperties();
     }

}
