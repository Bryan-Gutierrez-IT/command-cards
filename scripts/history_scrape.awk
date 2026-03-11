{
    line = $0
    cmd = $1

    count[cmd]++

    args = NF - 1
    total_args[cmd] += args

    redir = 0
    if (line ~ />/ || line ~ /</ || line ~ /\|/) redir = 1
    total_redir[cmd] += redir

    last[cmd] = line

    total_exec++
    seen[cmd] = 1
    grand_args += args
    grand_redir += redir
}

END {
    for (c in count) {
        avg_args = total_args[c] / count[c]
        redir_rate = total_redir[c] / count[c]
        printf "%s,%d,%.2f,%.2f,%s\n", c, count[c], avg_args, redir_rate, last[c]
    }

    unique = 0
    for (c in seen) unique++
    printf "%d,%d,%d,%d\n", total_exec, unique, grand_args, grand_redir > "/dev/stderr"
}
