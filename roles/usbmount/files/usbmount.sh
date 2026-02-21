#!/bin/bash

set -euo pipefail
# set -exuo pipefail
export PS4='${LINENO}: - [${SHLVL},${BASH_SUBSHELL},$?] $ '

[[ $EUID -ne 0 ]] && echo "Not running as root. Execute 'sudo -i' before running!" && exit 1

partitions=()
names=()
types=()
sizes=()
mounteds=()

while IFS= read -r line; do
    part=$(echo "$line" | awk '{print $NF}')
    if [[ "$part" =~ ^disk[4-9]+s[0-9]+$ ]]; then
        partitions+=("$part")

        diskinfo=$(diskutil info "$part")
        name=$(awk -F'[[:space:]]*:[[:space:]]*' '/Volume Name/ {print $2}' <<<"$diskinfo")
        type=$(awk -F'[[:space:]]*:[[:space:]]*' '/Type \(Bundle\)/ {print $2}' <<<"$diskinfo")
        size=$(awk -F'[[:space:]]*[:\(][[:space:]]*' '/^ *Disk Size:/ {print $2}' <<<"$diskinfo")
        mounted=$(awk -F'[[:space:]]*:[[:space:]]*' '/Mounted:/ {print $2}' <<<"$diskinfo")

        [[ -z "$name" ]] && name="$part"
        names+=("$name")
        types+=("$type")
        sizes+=("$size")
        mounteds+=("$mounted")
        # echo "Name: $name"
        # echo "Type: $type"
        # echo "Size: $size"
    fi
done < <(diskutil list)

# Check if any partitions were found
if [[ ${#partitions[@]} -eq 0 ]]; then
    echo "No mountable partitions found."
    exit 1
fi

# Display the list
echo "Available partitions:"
echo
for i in "${!partitions[@]}"; do
    echo "$((i+1)). /dev/${partitions[$i]} [${sizes[$i]}] [${types[$i]}] (${names[$i]}) [🗻 ${mounteds[$i]}]"
done

echo 
read -rp "Enter the number of the partition you want to mount: " index
index=$((index - 1))

if [[ $index -lt 0 || $index -ge ${#partitions[@]} ]]; then
    echo "Invalid selection." >&2
    exit 1
fi

partition="${partitions[$index]}"
volname="${names[$index]}"
type="${types[$index]}"
size="${sizes[$index]}"
is_mounted="${mounteds[$index]}"

mount_point="/Volumes/$volname"

# Create mount point if it doesn't exist
if [[ ! -d "$mount_point" ]]; then
    echo 
    echo "Creating mount point at $mount_point"
    mkdir -p "$mount_point"
fi

# Mount the partition
echo "Mounting /dev/$partition to $mount_point"

echo "Mounting partition /dev/$partition of type $type... $size"
mount -t $type "/dev/$partition" "$mount_point"
echo Ok
open "$mount_point"
