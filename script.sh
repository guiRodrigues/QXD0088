#!/bin/bash

rootFolder="atividades"
levelOneFolder="atividade2"
professorsFolder="professores"
classesFolder="disciplinas"
historicFolder="historico"

clearProject() {
    rm -rf $rootFolder
}

# Create initial folder structure
createInitialStructure() {
    levelTwoFolders=("professores" "disciplinas" "historico")

    mkdir "$rootFolder"
    mkdir "$rootFolder/$levelOneFolder"

    for folder in "${levelTwoFolders[@]}"; do
        mkdir "$rootFolder/$levelOneFolder/$folder"
    done
}

createProfessors() {
    professorsURL="https://www.quixada.ufc.br/docente/"

    curl -s $professorsURL > docentes.html

    # Extract professor names using grep and sed from an HTML file
    professor_names=$(grep -o '<a href="https://www\.quixada\.ufc\.br/docente/[^"]*" class="btn btn-info btn-xs">' docentes.html |
        sed -r 's_^<a href="https://www\.quixada\.ufc\.br/docente/([^"]*)/" class="btn btn-info btn-xs">_\1_')

    # Loop through professor names and display them
    for name in $professor_names; do
        touch "$rootFolder/$levelOneFolder/$professorsFolder/$name.txt"
    done

    rm docentes.html
}

createClasses() {
    url="https://gist.githubusercontent.com/guiRodrigues/c5793e3dffe48f4ed6b040d94b15fc6e/raw/8299e01078276e285124b9b4a22893bb042e095d/disciplinas.txt"

    curl -s "$url" |
    while read -r content || [[ -n "$content" ]]; do
        content=$(echo "$content" | sed 's#^/##')

        # Create a folder for each content
        content_dir="$OUTPUT_DIR/$(echo "$content" | tr ' ' '_')"
        
        # Remove the leading '/'
        content=$(echo "$content_dir" | sed 's#^/##')

        # Replace accented characters with non-accented characters
        converted_name=$(echo "$content" | iconv -f UTF-8 -t ASCII//TRANSLIT | tr -d -c '[:alnum:]_')

        # Convert to lowercase and replace underscores with spaces
        directory_name=$(echo "$converted_name" | tr '[:upper:]' '[:lower:]')

        touch "$rootFolder/$levelOneFolder/$classesFolder/$directory_name.txt"
        mkdir "$rootFolder/$levelOneFolder/$historicFolder/$directory_name"
    done
}

createHistory() {
    createProfessorLink() {
        folder="$1"
        
        # Get a list of files in the folder
        files=("$rootFolder/$levelOneFolder/$professorsFolder"/*)

        # Get a random index within the range of file count
        random_index=$((RANDOM % ${#files[@]}))

        # Get the random file name
        random_file="${files[random_index]}"

        # Create a symbolic link to the professor
        ln -s "$random_file" "$folder/professor"
    }

    for folder in "$rootFolder/$levelOneFolder/$historicFolder"/*; do
        if [ -d "$folder" ]; then
            # Extract the folder name
            folder_name=$(basename "$folder")

            # Create a symbolic link to the source txt file in each folder
            ln -s "$rootFolder/$levelOneFolder/$classesFolder/$folder_name.txt" "$folder/programa"

            createProfessorLink $folder
        fi
    done
}

clearProject

createInitialStructure
createProfessors
createClasses
createHistory

tree .