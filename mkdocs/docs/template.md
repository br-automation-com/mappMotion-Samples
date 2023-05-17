The brake sample provides an easy interface to control the brake parameters and function. Also see Automation Studio help (00ef9572-f1d5-43b5-9815-90e510eaeb7f)

## Repo Link
[Here](https://github.com/br-automation-com/mappMotion-Samples/tree/brake) is the link to the repository.

## Command structure

The sample uses a variable structure to communicate with the outside world that can also be used to interact with other tasks. The structure looks as follows:

| Command | Function |
|---|---|---|
| CmdClose | Close brake |
| CmdOpen | Open brake |
| CmdSetPar | Set brake parameter |
| MpLink | The axis reference establishes the connection between the function block and an axis |
| ParBrake | Configuration parameters |
| StaBrake | Configuration parameters |
| ErrId | Error ID |

## Revision

Version 1
- First release


