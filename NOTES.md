# Notes

Use this file to capture your decisions and reflections as you work through the sprint.

# Query 3 
1. Everytime subquery runs, the average may differ, so the tracks shown in the table above the average will change automatically. This may be confusing for another person who looks at the table after some time.

# Query 4
1. If the data changes, it takes more time for the 'NOT IN' because it checks all the NULLS even if there are no NULLS in the data. NOT EXISTS is quicker.