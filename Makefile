setup:
	@docker build . -t ceph-standalone --progress=plain

up:
	@docker run --rm --name ceph-standalone \
        -v /sys/fs/cgroup/ceph-standalone:/sys/fs/cgroup:rw \
        --env-file .env \
        ceph-standalone

down:
	-@docker stop ceph-standalone

shell:
	@docker exec -it ceph-standalone /bin/sh
