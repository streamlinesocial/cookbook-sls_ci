0.1.0
=====

- remove initial git config template, not needed or is overwritten when actual config happens anyway
- remove reload call on each chef run
- add node recipe to configure build node, add reload call to jenkins process in server
- added not_if to skip lengenthy pear checks if package already installed
- add depends for ark,ant build tools
- initial version, setup to configure jenkins server, and php / vagrant test nodes
