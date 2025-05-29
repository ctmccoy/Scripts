#!/usr/bin/zsh

# STEP 1
# Show current OS version

current_version=$(lsb_release -r)
echo "You are currently running version: $current_version"



# STEP 2
# Asking to continue and checking available updates

echo "Do you want to continue? The next step is: checking for updates? (yes/no)"
read update_input

    if [[ ! "$update_input" =~ ^[Yy](es)?$ ]]; then
        echo "Update CANCELLED!"
        exit 0
    fi

echo "Checking for updates..."
if ! sudo apt update -q; then
	echo "Error: Failed to update"
	exit 1
fi

# Here is where I want it to prompt for package upgrades
# List upgradeable packages
upgradeable=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)

if (( upgradeable == 0 )); then
	echo "Your system is up-to-date"
	exit 0
else
	echo "There are $upgradeable packages available"
	echo "Do you want to upgrade? (yes/no)"
	read upgrade_input

	if [[ "$upgrade_input" =~ ^[Yy](es)?$ ]]; then
	    echo "Starting Upgrade..."
	    sudo apt upgrade -y
	    echo "Upgrade COMPLETE!"
        else
	    echo "Upgrade CANCELLED!"
	    exit 0
	fi
fi


# STEP 3

# STEP 4

# STEP 5

# STEP 6

# STEP 7

# STEP 8
