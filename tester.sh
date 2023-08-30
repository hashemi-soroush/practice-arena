#!/bin/bash
set -eu

test_problems() {
    echo "Running tests ..."
    for problem in */ ; do
        problem=${problem:0:-1}
        test_problem "${problem}" 0
        echo "----------------------------------------------------------------------------------------------------"
    done
}

test_problem() {
    local problem="${1}"
    local -i indent_count=${2}

    local indent
    indent=$(create_indentation ${indent_count})
    
    echo "${indent}Testing ${problem} ..."
    cd "${problem}"
    test_solutions "${indent_count}"
    cd ..
    echo "${indent}Testing ${problem} Completed"
}

test_solutions() {
    local -i indent_count=${1}

    for solution in solutions/* ; do
        [[ -e "${solution}" ]] || continue
        test_solution "${solution}" "((${indent_count}+1))"
    done
}

test_solution() {
    local solution="${1}"
    local -i indent_count=${2}

    local indent
    indent=$(create_indentation ${indent_count})
    local next_indent
    next_indent=$(create_indentation "((${indent_count}+1))")

    local runner
    runner=$(generate_runner "${solution}")
    
    local solution_name=${solution/*\//}
    echo "${indent}Testing ${solution_name} ..."

    local -i total=0
    local -i fails=0
    for input in tests/*.in ; do
        [[ -e "${input}" ]] || continue
        
        total+=1

        local index="${input/.in/}"
        index=$(basename "${index}")

        if run_single_test "${index}" "${runner}"; then
            echo "${next_indent}Test ${index} SUCCEEDED"
        else
            echo "${next_indent}Test ${index} FAILED"
            fails+=1
        fi
    done

    local result="SUCCEEDED"
    if [[ ${fails} -gt 0 ]]; then
        result="FAILED"
    fi
    echo "${indent}Testing ${solution_name} ${result}, TOTAL ${total} tests, FAILED ${fails}"
    
    return ${fails}
}

generate_runner() {
    local solution="${1}"

    local runner
    if [[ ${solution} == *.py ]] ; then
        runner="python ${solution}"
    else
        echo "Unknown programming language for ${solution}"
        return 1
    fi

    echo "${runner}"
    return 0
}

run_single_test() {
    local index="${1}"
    local runner="${2}"

    local input="tests/${index}.in"
    local output="tests/${index}.out"
    local output_tmp="tests/tmp-${index}.out"

    ${runner} < "${input}" > "${output_tmp}"
    diff "${output}" "${output_tmp}" > /dev/null
    local ret=$?
    
    rm "${output_tmp}"
    
    return ${ret}
}

create_indentation() {
    local -i indent_count=${1}
    local indent=""
    for _ in $(seq ${indent_count}) ; do
        indent="${indent}\t"
    done
    echo -e "${indent}"
}

test_problems
