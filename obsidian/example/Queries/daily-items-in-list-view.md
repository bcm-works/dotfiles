```dataview
table without id
	file.link as Entry,
	file.ctime as Created
from "Planning/Daily"
sort file.ctime desc
```