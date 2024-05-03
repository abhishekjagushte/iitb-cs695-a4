import random

def generate_random_cpp_program():
    program = "#include <iostream>\n\nint main() {\n"
    num_statements = random.randint(5, 10)
    
    for _ in range(num_statements):
        if random.random() < 0.5:
            program += "    std::cout << "
            if random.random() < 0.5:
                program += "\"Hello, world!\""
            else:
                program += "42"
            program += " << std::endl;\n"
        else:
            loop_type = random.choice(["for", "while"])
            loop_var = random.choice(["i", "j", "k"])
            loop_start = random.randint(0, 5)
            loop_end = random.randint(6, 10)
            program += f"    for (int {loop_var} = {loop_start}; {loop_var} < {loop_end}; {loop_var}++) {{\n"
            program += f"        std::cout << \"{loop_var}: \" << {loop_var} << std::endl;\n"
            program += "    }\n"
    

    # Add malloc statement to allocate about 100MB of space
    program += "    void* ptr = malloc(100 * 1024 * 1024);\n"


    program += "    return 0;\n}"
    
    return program

if __name__ == "__main__":
    n = int(input())
    for _ in range(n):
        with open("random_program" + str(_) + ".cpp", "w") as file:
                file.write(generate_random_cpp_program())
