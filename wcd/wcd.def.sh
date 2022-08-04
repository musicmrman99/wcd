wcd__mount_dir='/mnt'

# cd, translating backslash to forward slash and drive letters to mount points, plus mounting any needed drives
function wcd {
  local location drive_letter mount_point

  location="$(tr '\\' '/' <<< $1)"

  # Help text
  if [ "$location" = "" ]; then
    printf '%s\n' "cd with Windows paths/drives" "Usage: cdm [<drive_letter>:<slash>]<location>" "<slash> may be forward slash or backslash"
    return 0
  fi

  # Translate drive letter
  if [[ "${location:0:2}" =~ [A-Z]: ]]  && [[ "${location:2:3}" =~ [/\\] ]]; then
    drive_letter="${location:0:1}"
    # upper->lower from: https://stackoverflow.com/a/12487465
    mount_point="$wcd__mount_dir/$(tr '[:upper:]' '[:lower:]' <<< $drive_letter)"
    location="${location:2}" # Strip "<letter>:"

    # Check for the mount point, and try creating it if missing
    if [ ! -d "$mount_point" ]; then
      printf '%s\n' "Creating $drive_letter: mount point mount_point ..."
      sudo mkdir -p "$mount_point"

      # Check the mount point again, just in case the user canceled the sudo/mkdir.
      if [ ! -d "$mount_point" ]; then
        printf 'Error: %s\n' "$drive_letter: mount failed - mountpoint ($mount_point) not created"
        return 1 # Error
      fi
    fi

    # If drive not mounted (ie. if empty).
    if [ "$(findmnt --source "$drive_letter:\\")" = "" ]; then
      printf '%s\n' "Mounting $drive_letter: drive ..."
      sudo mount -t drvfs "$drive_letter:\\" "$mount_point"

      if [ "$(findmnt --source "$drive_letter:\\")" = "" ]; then
        printf 'Error %s\n' "$drive_letter: mount failed"
        return 1 # Error
      fi
    fi

    # location must start with a \ or /
    cd "$mount_point$location"
    return 0
  fi

  # If no drive letter match, cd to wherever was given
  cd "$location"
}
