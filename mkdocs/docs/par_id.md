The sample consists of two main components. The sample page is used to operate the recipe management. The task Recipe_01 drives the recipe management. Ideally this task should not be changed to make future updates easier. All additional code should be added to 'YourTask'. The following functions are currently supported.

* Load and Save recipes
* View recipes
* Create new recipes
* Delete recipes
* Rename recipes
* Download and upload recipes

Recipes can be downloaded directly from the web client. To support this function the recipes must be loaded into memory. A buffer of the size REC_UPLOAD_DOWNLOAD_SIZE is used to hold the data into the memory. If the recipes exceed REC_UPLOAD_DOWNLOAD_SIZE the constant must be increased. Recipe upload is supported for ASCII recipe mode (REC_USE_UNICODE=false).

Up to 3 web clients can connect at the same time. While the task itself can only execute one command at a time the commands are executed so fast that this should not be an issue. The init command may take longer but the response data is distributed to all sessions. 

## Command structure

The task uses a variable structure to communicate with the outside world that can also be used to interact with other tasks. The structure *Recipe_01* looks as follows:

<table>
    <tr>
        <th width=100>Level 1</td>
        <th>Level 2</td>
        <th>Level Description</td>
    </tr>
    <tr ">
        <td>CMD</td>
    <td colspan=" 3">Used to trigger commands like load, save, delete, ... A command is triggered by setting it to
        true, when the command is finished the task will reset the command. This indicates that the command is finished.
        Do not change any parameters or set another command until the previous command is finished.</td>
    </tr>
    <tr>
        <td></td>
        <td>Init</td>
        <td colspan="3">Initializes the recipe management and reads the names of all recipes.</td>
    </tr>
    <tr>
        <td></td>
        <td>New</td>
        <td colspan="3">Create a new recipe, triggers an error message if the recipe name already exists.</td>
    </tr>
    <tr>
        <td></td>
        <td>Load</td>
        <td colspan="3">Loads the recipe data.</td>
    </tr>
    <tr>
        <td></td>
        <td>Save</td>
        <td colspan="3">Saves the recipe data.</td>
    </tr>
    <td></td>
    <td>View</td>
    <td colspan="3">View selected recipe.</td>
    </tr>
    <tr>
        <td></td>
        <td>Rename</td>
        <td colspan="3">Renames the selected recipe.</td>
    </tr>
    <tr>
        <td></td>
        <td>Delete</td>
        <td colspan="3">Deletes the selected recipe.</td>
    </tr>
    <td></td>
    <td>Download</td>
    <td colspan="3">Download selected recipe.</td>
    </tr>
    <tr>
        <td></td>
        <td>Upload</td>
        <td colspan="3">Upload a recipe via web browser to the taret.</td>
    </tr>
    <tr>
        <td></td>
        <td>ErrorReset</td>
        <td colspan="3">Resets pending errors.</td>
    </tr>
        <td> PAR </td>
    <td colspan="3">Parameters like recipe name, file path, ...</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeName</td>
        <td colspan="3">The name of the recipe used with the current command.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeNameNew</td>
        <td colspan="3">New name used with the command rename.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeID</td>
        <td colspan="3">File name of the recipe. With standard strings this equal the recipe name. Increasing numbers
            are used for Unicode recipe names. The recipe name is then stored as Unicode inside the recipe itself.</td>
    </tr>
    <tr>
        <td></td>
        <td>Initialized</td>
        <td colspan="3">Shows that the recipe management was initialized correct.</td>
    </tr>
    <td></td>
    <td>VisuSlotID</td>
    <td colspan="3">This is the session ID for the current command. This is used to identify where to send response
        messages.</td>
    </tr>
    <tr>
        <td></td>
        <td>VisuEnableCommand</td>
        <td colspan="3">Enable or disable commands when number of recipes is 0 or command is running.</td>
    </tr>
    <tr>
        <td> DAT </td>
        <td colspan="3">Recipe lists as well as status information.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeNames</td>
        <td colspan="3">List with all recipe names.</td>
    </tr>
    <td></td>
    <td>RecipeIDs</td>
    <td colspan="3">File names for the corresponding recipe name.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeNum</td>
        <td colspan="3">Number of recipes in the list.</td>
    </tr>
    <tr>
        <td> VIS </td>
        <td colspan="3">Data specific for the visualization. The structure is an array, one for each client session.
        </td>
    <tr>
        <td></td>
        <td>RecipeNames</td>
        <td colspan="3">List with all recipes formatted as data provider for the mappView listbox.</td>
    </tr>
    <tr>
    </tr>
    <tr>
        <td></td>
        <td>RecipeNum</td>
        <td colspan="3">Number of visible recipes in the list. Depending on the filter this number can be lower than the
            total number of recipes stored under DAT.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeFilter</td>
        <td colspan="3">Only show recipes that contain this string pattern.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeSelect</td>
        <td colspan="3">Used to select the recipe name after command new or rename.</td>
    </tr>
    <tr>
        <td></td>
        <td>DownloadFileUrl</td>
        <td colspan="3">Url containing the file name that is downloaded.</td>
    </tr>
    <tr>
        <td></td>
        <td>UploadOverwriteRequest</td>
        <td colspan="3">Show message box to overwrite file.</td>
    </tr>
    <tr>
        <td></td>
        <td>UploadOverwriteResponse</td>
        <td colspan="3">Response from message box overwrite file.</td>
    </tr>
    <tr>
        <td></td>
        <td>ReloadUpload</td>
        <td colspan="3">Reload upload button.</td>
    </tr>
    <tr>
        <td></td>
        <td>RecipeDoubleClick</td>
        <td colspan="3">Helper variable to detect a double click on a record. When a double click is detected, the
            recipe is opened.</td>
    </tr>
    <tr>
        <td></td>
        <td>ViewFilePath</td>
        <td colspan="3">File path used for the web widget that shows the file content.</td>
    </tr>
    <tr>
        <td></td>
        <td>ViewFile</td>
        <td colspan="3">Trigger to open the fly out window and view the file content.</td>
    </tr>
    <tr>
        <td></td>
        <td>ShowMessageBoxError</td>
        <td colspan="3">Show a message box when command was not successful.</td>
    </tr>
    <tr>
        <td> ERR </td>
        <td colspan="3">Information about errors.</td>
    </tr>
    <tr>
        <td></td>
        <td>State</td>
        <td colspan="3">State where the error occurred.</td>
    </tr>
    <tr>
        <td></td>
        <td>Text</td>
        <td colspan="3">Error text.</td>
    </tr>
    <tr>
        <td>StatusText</td>
        <td colspan="3">Shows the result for the last command.</td>
    </tr>
    <tr>
        <td>StatusNo</td>
        <td colspan="3">Shows the status as number</td>
    </tr>
</table>

## Pre-Configuration

The task communicates with the outside world via the global structure 'Recipe_01'. If more than one recipe management is needed the complete package 'mappRecipe' should be duplicated. It is important that the new task name and new global structure use the same name. 

After importing the sample go to the package 'mappRecipe' and edit the file 'RecVariables.var'. The variable array 'REC_VAR_LIST' contains the name of the variables that contain the recipe data. The default variable has a few sample values. After importing the task these can be replaced with "real" variables that should be saved. The variables can be standard type but also arrays or structures.

The following constants can be adjusted if necessary.

| Constant | Default | Text |
|---|---|---|
| REC_USE_UNICODE | TRUE | When set the to false the recipe name equals the file name. Use this setting for better performance when no special characters are needed. When set to true an increasing number is used for the file name instead. The recipe name is then stored as Unicode inside the recipe itself. Execute a clean configuration and rebuilt the project after changing this value. When set to to TRUE recipe upload is not supported. |
| REC_SORT_NUMERIC | FALSE | Sort recipe names as numeric values instead of alphabetic. |
| REC_RECIPE_TYPE | typeCSV | Select typeCSV for recipes in CSV file format or select typeXML for XML format. Execute a clean configuration and rebuilt the project after changing this value. |
| REC_MPLINK | gRecipeCsv_01 | mappRecipe link name from configuration view. Use gRecipeCsv_01 for CSV and gRecipeXml_01 for XML in this demo. |
| REC_DEVICE | RECIPE_DEVICE | Device name for the recipe data defined under File Devices in the CPU configuration. |
| REC_DIRECTORY | Recipe_01 | Directory where the recipes are stored. |
| REC_THIS_TASK | Recipe_01 | Name of this task and the global variable's structure. |
| REC_REC_NUM | 100 | Maximum number of recipes. |
| REC_VAR_NUM | 10 | Maximum number of variables that can be registered. |
| REC_NAME_LENGTH | 40 | Maximum length for a recipe name. |
| REC_UPLOAD_DOWNLOAD_SIZE | 100000 | Maximum size of files that can be uploaded or downloaded |
| REC_VIS_LENGTH  | 120 | Make this REC_NAME_LENGTH x 3. |
| REC_MAX_CLIENTS_ID | 2 | Maximum number of concurrent web client connections. Do not change this number. |
| REC_VIEW_FILTER | csv, xml | File extensions that can be used with the view command. The filter is case sensitive. |
| REC_VAR_LIST | | List of variables to be included in a recipe. |

## Performance

When calling the init command the task needs some time to generate the list of recipe names. On a X20CP1583 running the task in a 10ms task class the init command needs about 20ms per recipe plus 150ms. So for 100 recipes the task needs 2.15 seconds to read all recipe names when using standard strings.

When using Unicode strings the task needs 70ms per recipe name plus 200ms. So for 100 recipes the task needs 7.20 seconds to read all recipe names when using Unicode strings.

## Error handling

The task generates the following list of error messages. All other error numbers are generated from included libraries that can be found in the Automation Studio help.

| No | Constant | Text |
|---|---|---|
| 50010 | ERR_REC_TOO_MANY_CLIENTS  | More than 3 clients try to connect to user management |
| 50100 | ERR_REC_NAME_EMPTY  | Recipe name is empty  |
| 50101 | ERR_REC_NAME_EXISTS  | Recipe name already exists  |
| 50102 | ERR_REC_NAME_LOST  | Recipe name was not found  |
| 50103 | ERR_REC_NAME_LENGTH  | One or more recipe names exceeds maximum length  |
| 50110 | ERR_REC_DEV_NAME_EMPTY  | Device name is empty  |
| 50120 | ERR_REC_VAR_NAME_EMPTY  | Variable name is empty  |
| 50130 | ERR_REC_NOT_INITIALIZED  | Recipe management is not initialized  |
| 50140 | ERR_REC_MAX_NUM  | Maximum number of recipes reached | Increase value of REC_MAX_NUM |
| 50150 | ERR_REC_TASK_NAME  | Task name is incorrect. Make sure task name and global variable structure share the same name and that the string "this" is correct in the init task.  |
| 50300 | ERR_MEM_ALLOC | Memory allocation for file upload and download failed | |	
| 50310 | ERR_MEM_DOWNLOAD | Size of download file exceeds maximum | Increase value of REC_UPLOAD_DOWNLOAD_SIZE |	
| 50320 | ERR_TIMEOUT_DOWNLOAD | Download response timed out | This error occurs with Microsoft Edge and Internet Explorer. Use Chrome or Firefox instead |	
| 50330 | ERR_DIR_DOWNLOAD | Directories cannot be downloaded | Directory download is not supported |
| 50400 | ERR_SIZE_NAME_UPLOAD | Cannot find filename in upload response | Create an issue and attach file |	
| 50401 | ERR_POS_NAME_UPLOAD | Cannot determine end of filename in upload response | Create an issue and attach file |	
| 50402 | ERR_LEN_NAME_UPLOAD | Filename is too long in upload response | Reduce file name to 100 characters |	
| 50403 | ERR_POS_DATA_UPLOAD | Cannot find data in upload response | Create an issue and attach file |	
| 50404 | ERR_SIZE_DATA_UPLOAD | Cannot determine end of data in upload response | Create an issue and attach file |	
| 50410 | ERR_MEM_UPLOAD | Size of upload file exceeds maximum size | Increase constant REC_UPLOAD_DOWNLOAD_SIZE |	
| 50420 | ERR_UNICODE_UPLOAD | Upload is not supported when Unicode is used | Set constant REC_USE_UNICODE to false |	

## Limitations

* Viewing a recipe only works for CSV files.
* Downloading and uploading currently does not work for Unicode recipes.


