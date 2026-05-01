# Garmin Watch Face: [Hal-6000](https://apps.garmin.com/en-US/apps/46e9c768-4eb1-470c-93a8-29dd11219b61) 


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/805addd2-ff7c-4af6-9a2c-40bb43df8cc0" width="800"/></td>
    <td><em>HAL 9000</em> from 2001: A Space Odyssey. Minimalistic Sci-Fi watch face with rounded writing. Completly operational and all circuits are functioning perfectly.
        HAL gets gets animated once your stress levels reach above 50%.</td>
  </tr>
</table>




---
<img src="https://github.com/user-attachments/assets/166517d9-1c4c-4871-ab6d-e0b241cfd13f" width="900"/>

#

<img src="https://github.com/user-attachments/assets/bd1456e1-f7ce-407d-8cc3-c16841f8a3c6" width="900"/>




---
### Settings

---

| Field          | Digital Fields | Arc Fields | Battery Icons |
| -------------- | -------------- | ---------- | ------------- |
| Date           | ✓              |            |               |
| Time           | ✓              |            |               |
| Heart Rate     | ✓              |            |               |
| Stress Level   | ✓              | ✓          |               |
| Body Battery   | ✓              | ✓          | ✓             |
| Calories       | ✓              |            |               |
| % Calories     | ✓              | ✓          | ✓             |
| Steps          | ✓              |            |               |
| % Steps        | ✓              | ✓          | ✓             |
| Active Minutes | ✓              |            |               |
| Battery Level  | ✓              | ✓          | ✓             |
| None           | ✓              |   ✓           |        ✓         |



You can also:
* turn the animation off
* set the threshold for the stress level animation
* set your calorie goal
* set your steps goal



## Set-up
### Installations

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) - follow the steps in the link for your operating system
- *VS Code* or *Curser* with the *Monkey C Extension*
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html)



### Build & Run
---
* Set-up variables

    Fill in your set-up variables in `properties.mk`

* Build with debug logs
   ```sh
   make build
   ```
* Run on simulator
   ```sh
   make run.settings
   ```
* Deploy on device
    1. Enable *Developer Mode* on your Garmin watch. 
    2. Copy the compiled `.prg` file from the `bin` into the `/GARMIN/APPS/` directory on your watch. (For Mac I used [Android File Transfer](https://android.p2hp.com/filetransfer/index.html))


If you want to test the settings on your comupter you can go in the Simulator either
* Trigger App Settings & click on the buttons in the simulator
or
* File > Edit Persistent Storage > Edit Application.Properties data


---

Contributions are more than welcome, if you give me time to test them, I might release it and publish to Connect IQ.

---

#### License
This project is licensed under GPLv3
