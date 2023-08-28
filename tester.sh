#!/bin/bash
set -eu

test_all() {
    echo "Running tests ..."
    for problem in */ ; do
        problem=${problem:0:-1}
        test_problem "${problem}" 0
    done
}

test_problem() {
    local problem="${1}"
    local -i indent_count=${2}

    local indent
    indent=$(create_indentation ${indent_count})
    echo "${indent}Testing ${problem} ..."

    cd "${problem}"
    for solution in solution.* ; do
        test_language "${solution}" "((${indent_count}+1))"
    done
    cd ..

    echo "${indent}Testing ${problem} Completed"
}

test_language() {
    local solution="${1}"
    local -i indent_count=${2}

    local indent
    indent=$(create_indentation ${indent_count})
    local next_indent
    next_indent=$(create_indentation "((${indent_count}+1))")

    local language_name
    local runner
    if [[ ${solution} == "solution.py" ]] ; then
        language_name="Python"
        runner="python"
    fi
    
    echo "${indent}Testing ${language_name} ..."

    local -i total=0
    local -i fails=0
    for input in tests/*.in ; do
        total+=1
        local index="${input/.in/}"
        index=$(basename "${index}")
        
        local input="tests/${index}.in"
        local output="tests/${index}.out"
        local output_tmp="tests/tmp-${index}.out"

        ${runner} "${solution}" < "${input}" > "${output_tmp}"
        if diff "${output}" "${output_tmp}" ; then
            echo "${next_indent}Test ${index} SUCCEEDED"
        else
            echo "${next_indent}Test ${index} FAILED"
            fails+=1
        fi
        
        rm "${output_tmp}"

    done

    echo "${indent}Testing Python Completed, TOTAL ${total} tests, FAILED ${fails}"
}

create_indentation() {
    local -i indent_count=${1}
    local indent=""
    for _ in $(seq ${indent_count}) ; do
        indent="${indent}\t"
    done
    echo -e "${indent}"
}

test_all
