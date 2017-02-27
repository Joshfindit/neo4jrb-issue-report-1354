# Issue
`neo4jrb` will accept data when creating nodes, but that same data can not always be returned.

Example: setting the property of a node to a string, saving the node, then calling `Label.all`


# Steps to reproduce

1. Clone the repo
2. Change `NEO4J_URL` to match your environment
3. Run the script

*The script automatically calls JunkNode.all on each line. The error will come up on it's own part-way through the import*

## Cleanup

* Delete all `JunkNode`s
