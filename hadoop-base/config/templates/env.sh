#!/bin/sh
{{range $type := lsdir "/services/hadoop/conf" }}
	{{range gets (printf "/services/hadoop/conf/%s/*" $type)  }}
	{{ $upperd := base .Key }}{{ $underscore := replace $upperd "_" "__" -1}}{{ $dash := replace $underscore "-" "___" -1}}{{ $dot := replace $dash "." "_" -1}}
export CONF_{{ toUpper $type }}_{{ $dot }}="{{.Value}}"
	{{end}}
{{end}}