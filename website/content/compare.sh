OUTPUT_DIR="./outdated"

# Make an output directory
if [[ ! -e $OUTPUT_DIR ]]; then
    mkdir $OUTPUT_DIR
    #echo "${L10N_INFO_JSON}" > ${OUTPUT_DIR}/L10N_INFO.json
elif [[ ! -d $OUTPUT_DIR ]]; then
    echo "$OUTPUT_DIR already exists but is not a directory" 1>&2
fi

LATEST_BRANCH=env-sus-changes #${GITHUB_REF#refs/}
echo "(DEBUG) LATEST_BRANCH: ${LATEST_BRANCH}"

# Get the old branch from 'github.base_ref' 
# The old branch can be 'upstream/dev-ko'
OLD_BRANCH=main #"origin/${{github.base_ref}}"
echo "(DEBUG) OLD_BRANCH: ${OLD_BRANCH}"
    
compare () {
        # Set output directory
    FILE=$1
    echo "comparing "$FILE
    #sleep 3
    # Actually compare between the old and latest English content and log diff in the file
    if [[ -f "${FILE}" ]]; then
        # File exists
        # Check changes
        echo "running diff"
        echo "${OLD_BRANCH}..${LATEST_BRANCH} -- ${FILE}"
        git diff ${OLD_BRANCH}..${LATEST_BRANCH} -- ${FILE} > temp.diff
        #sleep 2
        if [[ -s "temp.diff" ]]; then
            echo "(DEBUG) ${FILE} is outdated."
            #sleep 2
            mv temp.diff ${OUTPUT_DIR}/${FILE}
        fi
    else
        echo "(DEBUG) ${FILE} does not exist."
        # File dose not exist (e.g, changed, renamed or removed)
        #echo "Could not find ${FILE} in website/content/en/" > ${OUTPUT_DIR}/${FILE_PATH}
        #echo "Need to check if it has been changed, renamed or removed" >> ${OUTPUT_DIR}/${FILE_PATH}
    fi
    read
}

find en -iname "*.md" > files.txt

INFILE=files.txt

while read -r FILE
do
    sleep 0.5
    compare $FILE
done < "$INFILE"



 
