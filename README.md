# json2yaml.cr

A small command-line tool to convert between JSON and YAML. This is my first
program written in [Crystal]. I have wanted to experiment with Crystal for a
while.

## Usage

Build:

```shell
crystal build src/json2yaml.cr
```

Run:

```shell
# Convert list of files
json2yaml file1.json file2.json
json2yaml file1.yaml file2.yaml

# Glob
json2yaml *.json
json2yaml *.yaml

# Read from stdin and write to stdout
cat file.json | json2yaml
cat file.yaml | json2yaml --yaml
```

```
$ json2yaml --help
Usage: json2yaml [OPTION]... [FILE]...
    -h, --help                       Show this help
    -i INDENT, --indent INDENT       Number of spaces to indent for JSON
    -j, --json                       Set input format to JSON (stdin only)
    -o DIR, --output DIR             Output directory
    -u, --ugly                       Turn off pretty printing (JSON only)
    -s, --silent                     Silent (no output)
    -y, --yaml                       Set input format to YAML (stdin only)
```


[Crystal]: https://crystal-lang.org/
