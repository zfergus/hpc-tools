export FORMAT_LENGTHS="[8, 10, 30, 6, 7, 10, 10, 5, 16]"

update_white_space_margin() {
    LINE_LEN=$(python -c "print(sum(${FORMAT_LENGTHS}) + 3 * len(${FORMAT_LENGTHS}) + 1)")
    export WHITE_SPACE_MARGIN=$(python -c "print(' ' * (($(tput cols) - ${LINE_LEN})//2))")
}

print_hline (){
    echo "$(python -c "print('$1' + '$2'.join('─' * (cat_len + 2) for i, cat_len in enumerate(${FORMAT_LENGTHS})) + '$3')")"
}

pad_lines_white_space(){
    while read line; do echo "${WHITE_SPACE_MARGIN}${line}"; done
}

pad_lines(){
    while read line; do echo "│ ${line} │"; done | pad_lines_white_space
}

print_queue (){
    update_white_space_margin

    SQUEUE_FORMAT="%8i │ %10P │ %30j │ %6u │ %7T │ %.10M │ %.10l │ %.5D │ %.16R"
    NUM_LINES_TAKEN="10"
    COMPLETE_QUEUE=$(squeue --format="${SQUEUE_FORMAT}" --me)
    NUM_TOTAL=$(echo "$COMPLETE_QUEUE" | wc -l)
    NUM_RUNNING=$(echo "$COMPLETE_QUEUE" | grep "RUNNING" | wc -l)
    NUM_PENDING=$(python -c "print($NUM_TOTAL - $NUM_RUNNING - 1)")
    NUM_RUNNING_NOT_SHOWN=$(python -c "print(max($NUM_RUNNING - $(tput lines) + ${NUM_LINES_TAKEN}, 0))")

    python -c "print('\n' * (($(tput lines) - ${NUM_RUNNING} - ${NUM_LINES_TAKEN}) // 2))"
    print_hline '┌' '┬' '┐' | pad_lines_white_space
    echo "${COMPLETE_QUEUE}" | head -n 1 | pad_lines
    print_hline '│' '┼' '│' | pad_lines_white_space
    squeue --format="${SQUEUE_FORMAT}" --me --sort=+i \
        | grep "RUNNING" \
        | head -n $(python -c "print($(tput lines) - ${NUM_LINES_TAKEN})") \
        | pad_lines
    print_hline '└' '┴' '┘' | pad_lines_white_space

    printf "\n${WHITE_SPACE_MARGIN}+$NUM_RUNNING_NOT_SHOWN running jobs + $NUM_PENDING pending jobs\n"
    # sleep 1
}
#done
export -f update_white_space_margin
export -f print_hline
export -f pad_lines_white_space
export -f pad_lines
export -f print_queue
watch -n 0.1 -c print_queue
