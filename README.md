# BuildScripts

These scripts simplify some tasks for building Loop and FreeAPS.

### Workspace Build Prep
This script downloads the latest Loop master code (v2.2.9) from LoopWorkspace and patches it to enable xDripClient
which works well with Libre 1 (with MiaoMiao or similar devices) as well as Libre 2 (EU).
The idea is to have a newer release of Loop with the additional xDrip client.

#### To Build Loop
1. Open terminal
2. Copy/Paste this code into terminal: 

*`/bin/bash -c "$(curl -fsSL https://bit.ly/3uFzdyy)"`*

3. Hit Enter
