# sidekiq.chart.sh by codl <codl@codl.fr>
#
# put this in /usr/libexec/netdata/charts.d
# chown root:netdata and chmod +x

sidekiq_update_every=5
sidekiq_priority=9000

sidekiq_check() {
    redis-cli get 'stat:processed' > /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then
        error "Could not find sidekiq data in redis"
        return 1
    fi

    return 0
}

sidekiq_create() {
    cat <<EOF

CHART sidekiq.processed '' "sidekiq processed jobs" "jobs" sidekiq sidekiq stacked $((sidekiq_priority + 0)) $sidekiq_update_every
DIMENSION processed successful incremental 1 1
DIMENSION failed failed incremental 1 1

CHART sidekiq.busy '' 'sidekiq busy jobs' jobs sidekiq sidekiq area $((sidekiq_priority + 1)) $sidekiq_update_every
DIMENSION busy busy absolute 1 1

CHART sidekiq.queue '' 'sidekiq enqueued jobs' jobs sidekiq sidekiq area $((sidekiq_priority + 2)) $sidekiq_update_every
DIMENSION enqueued enqueued absolute 1 1

CHART sidekiq.retry '' 'sidekiq retry jobs' jobs sidekiq sidekiq stacked $((sidekiq_priority + 3)) $sidekiq_update_every
DIMENSION retry retry absolute 1 1
DIMENSION dead dead absolute 1 1

EOF
}


sidekiq_update() {
    redis-cli --raw << EOF |
get stat:processed
get stat:failed
zcard retry
zcard dead
smembers queues
EOF
    {
        read -d '' processed failed retry dead queues
        enqueued=0
        for queue in $queues; do
            enqueued=$[$enqueued + $(redis-cli --raw llen "queue:$queue")]
        done
        processes=$(redis-cli --raw smembers processes)
        busy=0
        for process in $processes; do
            busy=$[$busy + $(redis-cli --raw hget $process busy)]
        done

        cat << EOF
BEGIN sidekiq.processed $1
SET processed = $processed
SET failed = $failed
END
BEGIN sidekiq.busy
SET busy = $busy
END
BEGIN sidekiq.queue $1
SET enqueued = $enqueued
END
BEGIN sidekiq.retry $1
SET retry = $retry
SET dead $dead
END
EOF
    }

}
