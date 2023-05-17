**This guide shows how to import the demo project into an existing project. The screenshots can look slightly different depending on the version used.**

### Copy source code
Open the demo project and the exiting project side by side. Go to the logical view in both projects.

1. Copy the package “mappRecipe” from the demo project
2. Paste the task into the existing project at the top
3. Assign the new task to the CPU
4. Make sure that the B&R libraries **AsHttp, AsMem, FileIO, ArBrStr, ArBrWStr, AsIODiag, MpCom, MpBase and sys_lib** are in the existing project, 
add the libraries if necessary.

<table>
    <tr>
        <td>
            <img src="./images/import1.png" />
        </td>
    </tr>
</table>

### Copy mappView pages

1.	Open the mappView tree in the demo project and navigate to RecipePage, right click and copy it
2.	In the existing project paste the page onto pages
3.	Assign the new task to the CPU

<table>
    <tr>
        <td>
            <img src="./images/import2.png" />
        </td>
    </tr>
</table>

### Assign pages

1.	Expand the new page and double click on RecipePage.page
2.	Select the default layout for the existing project from the properties window

<table>
    <tr>
        <td>
            <img src="./images/import3.png" />
        </td>
    </tr>
</table>

### Assign layout

1.	Once the default layout is set in the existing project, click on each section and make sure that the correct content is selected
2.	Select **contentRecipe** for the main section
3.	Save the project

<table>
    <tr>
        <td>
            <img src="./images/import4.png" />
        </td>
    </tr>
</table>

### Assign navigation

1.	If the existing project uses a navigation bar, add a new button that points to the new recipe page
2.	Assign the recipe page to the new navigation button

<table>
    <tr>
        <td>
            <img src="./images/import5.png" />
        </td>
    </tr>
</table>

### Configure OPC UA configuration

1.	Switch to the configuration view in the existing project and open the OPC UA configuration
2.	Select the global variable **“Recipe_01”** and **“RecipeData”**, **If the variables does not show up, save and compile the project, then reopen the window**
3.	Enable the variables with the green checkmark
4.	Set “Automatic Enable” to true in the properties window

<table>
    <tr>
        <td>
            <img src="./images/import6.png" />
        </td>
    </tr>
</table>

### Configure OPC UA configuration

1.	Select the variable **Recipe_01.VIS**
2.	Set “Show array elements” to true, make sure that VIS has write access for everyone

<table>
    <tr>
        <td>
            <img src="./images/import7.png" />
        </td>
    </tr>
</table>

### Copy mappView binding files

1.	Expand the section mappView in the existing project and select all files ending with “binding” and “eventbinding”
2.	Right click and copy the files
3.	Paste the files in the existing project under mappView

<table>
    <tr>
        <td>
            <img src="./images/import8.png" />
        </td>
    </tr>
</table>

### Add binding files to vis

1.	In the existing project open the file “Visualizat.vis”
2.	Add the RecipePage in the “Pages” section 
3.	Add the Recipe_binding in the “BindingsSets” section 
4.	Add the Recipe_eventbinding in the “EventBindingsSets“ section 

<table>
    <tr>
        <td>
            <img src="./images/import9.png" />
        </td>
    </tr>
</table>

### Add mappRecipe configuration

1.	Select the mappServices folder in the configuration view, if it does not exist, add the folder from the toolbox 
2.	Select “MpRecipeCsv Default” from the toolbox
3.	Open the configuration and adjust the settings if needed
4.	Rename the MpLink to “gRecipeCsv_01” for CSV

<table>
    <tr>
        <td>
            <img src="./images/import10.png" />
        </td>
    </tr>
</table>

### Adjust PLC configuration

1.	Switch to the physical view and open the CPU configuration
2.	Make sure “Minimum user partition size” is larger than 0.
3.	Define a file device “RECIPE_DEVICE” and point it to the user partition “F:/”
Define a file device “SIM_DEVICE” and point it to the user partition “C:/Temp” or “C:/” for simulation mode.

<table>
    <tr>
        <td>
            <img src="./images/import11.png" />
        </td>
    </tr>
</table>

### Adjust variable configuration

1.	To change the recipe data from the sample values to the “real” data open the RecVariables.var file in the mappRecipe package
2.	Edit the default values for the variable array REC_VAR_LIST.
3.	Replace the sample variables with the “real” data. For local variables add the task name followed by “:”

<table>
    <tr>
        <td>
            <img src="./images/import12.png" />
        </td>
    </tr>
</table>
