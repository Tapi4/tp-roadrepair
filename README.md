# tp-roadrepair
- Road Repair Script
- [QBCORE]


## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-target](https://github.com/qbcore-framework/qb-target)


### Script
- Add the following code to your server.cfg/resouces.cfg
        ensure tp-roadrepair
- Add to qb-inventory image in the images file
- Add to qb-core>shared>items> :
    ["toolbox"] 	 = {["name"] = "toolbox",	["label"] = "Tool Box", 	["weight"] = 5000, 	["type"] = "item", 	 ["image"] = "toolbox.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "Tool Box"},

and enjoy the script !
