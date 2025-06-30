# Helper Scripts Collection

This repository contains a collection of self-written helper scripts designed to simplify and automate common tasks. Each script is tailored for specific use cases and can be easily customized to fit your needs.

## Scripts Overview

### 1. `menuselect.sh`
- **Description**: Provides an interactive terminal menu for selecting options. Users can navigate using the arrow keys and select an option with Enter.
- **Features**:
  - Real-time menu updates with highlighted selection.
  - Graceful exit with an "Exit" option or by pressing `q`.
  - Customizable menu options passed as arguments.

### 2. `git-recent`
- **Description**: A helper script to quickly list and checkout recently used Git branches.
- **Features**:
  - Displays a menu of recent branches using `menuselect.sh`.
  - Includes error handling for failed `git checkout` operations.
  - Simplifies branch navigation in Git repositories.

---

Feel free to explore, modify, and use these scripts to streamline your workflows!