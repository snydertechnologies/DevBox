source ~/.zlogin

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Break the $PATH into an array by ":" delimeter
# Iterate through the path array, using an exception list to match by substring
# Iterate through the remaining path array, removing by blacklist
# Merge the resulting arrays into one and export $PATH anew

########
# echo "\n\n============= BEFORE================:\n\n $PATH"
#####

# Check if a path contains any of the exception substrings
is_exception_substring() {
    local path="$1"
    for exception in "${exceptions[@]}"; do
        if [[ $path == *"$exception"* ]]; then
            # echo "[INFO] Found exception by substring match: $path"
            return 0 # True: it is an exception
        fi
    done
    return 1 # False: it's not an exception
}

# Check if a path should be removed based on our remove substrings
should_remove() {
    local path="$1"
    for remove in "${remove_strings[@]}"; do
        if [[ $path == *"$remove"* ]]; then
            # echo "[INFO] Marked for removal by substring match: $path"
            return 0 # True: should remove
        fi
    done
    return 1 # False: shouldn't remove
}

cleanPATH() {
    # Define the array of unwanted substrings
    local remove_strings=(
        "ProgramData"
        "AppData/Local/"
        "/mnt/c/Program Files"
        )

    # Define the array of exception substrings
    local exceptions=(
        "Docker/Docker"
        "Microsoft VS Code"
        "starship"
        )

    # Split the PATH into an array using ':' as delimiter
    local path_array=(${(s/:/)PATH})

    # Arrays for the final path, exceptions, and non-exceptions
    local final_path=()
    local exception_paths=()
    local non_exception_paths=()  # Introduced this array

    # First loop: Extract exception paths and non-exception paths
    for path in "${path_array[@]}"; do
        if is_exception_substring "$path"; then
            exception_paths+=($path)
        else
            non_exception_paths+=($path)
        fi
    done

    # Second iteration: Process ONLY non_exception_paths based on remove_strings
    for path in "${non_exception_paths[@]}"; do
        if ! should_remove "$path"; then
            final_path+=($path)
        fi
    done

    # Merge exceptions at the beginning of the final path
    final_path=("${exception_paths[@]}" "${final_path[@]}")

    # Sort paths alphabetically
    final_path=(${(o)final_path})

    # Separate /mnt/c/ paths and others
    local mnt_c_paths=(${(M)final_path:#/mnt/c/*})
    local other_paths=(${final_path:|mnt_c_paths})

    # Merge the arrays such that /mnt/c/ paths come first
    final_path=("${mnt_c_paths[@]}" "${other_paths[@]}")

    # Convert array to PATH string and set it
    export PATH="${(j/:/)final_path}"
    # echo "\n\n============= AFTER ================:\n\n $PATH"
}

# To execute the function, simply call:
cleanPATH
