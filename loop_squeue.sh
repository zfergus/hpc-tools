#while : ; do
#    clear
print_hline (){
    echo "$(python -c "print('$1' + '$2'.join('─' * (cat_len + 2) for i, cat_len in enumerate([12, 10, 30, 6, 7, 10, 10, 5, 16])) + '$3')")"
}
pad_line(){
    while read line; do echo "│ ${line} │"; done
}
print_queue (){
    FORMAT="%12i │ %10P │ %30j │ %6u │ %7T │ %.10M │ %.10l │ %.5D │ %.16R"
    COMPLETE_QUEUE=$(squeue --format="${FORMAT}" --me)
    NUM_TOTAL=$(echo "$COMPLETE_QUEUE" | wc -l)
    NUM_RUNNING=$(echo "$COMPLETE_QUEUE" | grep "RUNNING" | wc -l)
    NUM_PENDING=$(python -c "print($NUM_TOTAL - $NUM_RUNNING - 1)")

    RUNNING=$(squeue --format="${FORMAT}" --me | grep "RUNNING" | head -n $(python -c "print($(tput lines) - 5)"))

    print_hline '┌' '┬' '┐'
    echo "${COMPLETE_QUEUE}" | head -n 1 | pad_line
    print_hline '│' '┼' '│'
    squeue --format="${FORMAT}" --me \
        | grep "RUNNING" \
        | head -n $(python -c "print($(tput lines) - 5)") \
        | pad_line
    print_hline '└' '┴' '┘'

    NUM_RUNNING_NOT_SHOWN=$(python -c "print(max($NUM_RUNNING - $(tput lines) + 5, 0))")
    printf "\n\t+ $NUM_RUNNING_NOT_SHOWN running jobs + $NUM_PENDING pending jobs\n"
    # sleep 1
}
#done
export -f print_hline
export -f pad_line
export -f print_queue
watch -n 0.1 -c print_queue
