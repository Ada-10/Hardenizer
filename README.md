# Hardenizer

## Whats this

A tool for hardening windows 10 IPC using Siemens Guidelines.

Will create a pipeline to generate the unattender.xml to use with the file

## TODO:
- [ ] Understand all the registry key changed during the manual installation
- [ ] Add all tests
- [x] Separate User Registries and System registries, might not be needed but i think its good to do.
- [x] Make the test suite easier to write. PS1 file should just be the output of the program. Formatting it is better than hardcoding everything. 
- [ ] Understand if HTML encoding is needed on the script (xml.........)