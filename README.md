Testing DAS-5 action to log in and create job

## Usage

- Create a OVPN configuration file from eduVPN to access DAS-5.
- Pass that file through a base64 encoder (can be done [online](base64encode.org)).
- Go to GitHub secrets for actions add create the following secrets:
  - HOST - with the name of the host machine
  - USERNAME - with **your** username
  - PASSWORD - with **your** password
  - OVPN_FILE - with the encoded OVPN file.
- Adjust .github/script.sh as needed
- The file `ci4gpu/ci4gpu.log` will be created or updated with the run information.