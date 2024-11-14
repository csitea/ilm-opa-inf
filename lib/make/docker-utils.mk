
.PHONY: list-dockers  ## @-> show this help  the default action
list-dockers:
	# @clear
	docker stats --no-stream --format "table {{.Container}}\t{{.Name}}\t{{.MemUsage}}" | awk 'BEGIN {OFS="\t"} NR==1 {$3="RAM (GB)"; print} NR>1 {split($3, a, "/"); $3=sprintf("%.2f GB", a[1]/(1024*1024*1024)); print}'|column -t
