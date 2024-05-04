# Compile and execute all C++ programs in the current directory
find . -maxdepth 1 -type f -name "*.cpp" | xargs -n 1 -P 50 -I {} sh -c '
    file="$1"
    output="${file%.cpp}.out"
    output_txt="${file%.cpp}_output.txt"
    echo "Compiling $file to $output"
    g++ "$file" -o "$output"
' _ {}
