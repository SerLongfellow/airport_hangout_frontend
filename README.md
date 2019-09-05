![Build Status](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoidXR6VkpScHFRK0VTZ2dxcW9TRVA4Z0ljdVpvSFpmVFh6M3dVY083eUNuU21YZzZMM2J0Q0wvL20zVmtQc09iZ1QvYjhsYy8yWGhUNld5TEY4VTltdHk4PSIsIml2UGFyYW1ldGVyU3BlYyI6InZ5KzAyT2pzMHhvNVl3ZzgiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# Airport Hangout Frontend

This is still a work in progress. To be the frontend "web" component of the AirportHangout system.

## Dev Environment Setup Steps
1. Install Ruby on your machine - installation steps depend on your OS. For Arch Linux, the command is
    ```bash
    # pacman -S ruby
    ```
1. Once Ruby is installed, use the gem package manager to install the rails framework.
    ```
    $ gem install rails
    ```
1. Clone this repo into your directory of choice:
    ```
    $ git clone https://github.com/SerLongfellow/airport_hangout_frontend.git
    ```
1. Change into the project directory
    ```
    $ cd airport_hangout_frontend
    ```
1. Run 'make init-dev' to install local git hooks and setup other dev environment-related items.
    ```
    $ make init-dev
    ```
