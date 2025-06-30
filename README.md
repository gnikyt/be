# BE

A BASH-powered extendable template engine.

**Why?** Because I felt like it! Plus, I needed something for my blog which is also powered by BASH.

It is nothing fancy, but it does the job. It simply loops every character of the template and tracks current positions, open/close statuses, etc. Then, runs through several built-in functions to produce a result.

## Example

```bash
#!/bin/bash

. ./be

be_bold() {
  local input
  input=$(cat -)
  echo "<strong>${input}</strong>"
}

be_replace() {
  local input
  input=$(cat -)
  echo "${input//$1/$2}"
}

be_capitalize() {
  local input
  input=$(cat -)
  echo "${input^}"
}

NAME="Joe"
LIKES="hockey,soccer"
TPL=$(cat <<EOF
  Well, well, hello {{NAME}}!
  {{#LIKES}}
    So {{NAME|REPLACE e ey|BOLD}}, I heard you like:
    {{@FOREACH LIKES ,}}
      {{KEY1}}) {{VALUE|CAPITALIZE}}{{^LAST}}; and {{/LAST}}
    {{/FOREACH LIKES ,}}
    {{@RAW}}Won't be processed: {{NAME}}{{/RAW}}
  {{/LIKES}}
EOF
)

echo "$TPL" | be
```

Output:

```
  Well, well, hello Joe!
  
    So <strong>Joey</strong>, I heard you like:
    1) Hockey; and 
    2) Soccer
```

## Built-ins

### Varaibles

`{{VAR}}`

Will replace with the value of `VAR`.

Piping: `{{VAR|UPPERCASE|REPLACE X Y}}`

Will replace `VAR` with the value of `VAR`, then run it through a custom function `UPPERCASE`, then run it througha custom function `REPLACE` where it has the arguments of `X` and `Y` (replace `X` with `Y`).

### If

`{{#VAR}}Works!{{/VAR}}`

Will show `Works!` if `VAR` is defined.

### Unless

`{{^VAR}}Works!{{/VAR}}`

Will only show `Works!` if `VAR` is not defined.

### Foreach

`{{@FOREACH VAR DEL}}{{KEY}}:{{VALUE}}{{^LAST}}, {{/LAST}}{{/FOREACH VAR DEL}}`

Will accept a variable to loop `VAR` with optional delimiter `DEL`. If `DEL` is not provided, it will simply loop by space.

The following special variables are usable inside a loop:

* `KEY` - Current key index
* `KEY0` - Current key index, zero-based
* `KEY1` - Current key index + 1
* `VALUE` - Value for current key
* `FIRST` - If this is the first iteration
* `LAST` - If this is the last iteration

### Partials

`{{>templates/_partial}}`

Will include and process the file `templates/_partial`.

### Raw

`{{@RAW}}Will be skipped {{NAME}}{{/RAW}}`

Will skip over anything defined inside.

### Custom functions

Simply define your own function with a prefix of `be_`. The subject and arguments will be passed in to work with.

The subject is subjective to the type. If it is a block, then the subject is the block content. If it is a pipe in a variable, then the subject is the parsed variable (thus far).

```bash
# Pipe example.
be_bold() {
  local input
  input=$(cat -)
  echo "<strong>${input}</strong>"
}

NAME="Joe"
echo "{{NAME|BOLD}}" | be
# Output: "<strong>Joe</strong>"
```

```bash
# Pipe example #2.
be_bold() {
  local input
  input=$(cat -)
  echo "<$1>${input}</$1>"
}

NAME="Joe"
echo "{{NAME|BOLD em}}" | be
# Output: "<em>Joe</em>"
```

```bash
# Function example.
be_bold() {
  local input
  input=$(cat -)
  echo "<strong>${input}</strong>"
}

NAME="Joe"
echo "{{@BOLD}}{{NAME}}{{/BOLD}}" | be
# Output: "<strong>Joe</strong>"
```

# TODO

Handle string quoting. Example: `{{VAR|REPLACE "X M" "Y"}}` would be parsed as:

* Variable: `VAR`
* Pipe Method: `REPLACE`
* Arg 1: `"X`
* Arg 2: `M"`
* Arg 3: `"Y"`

Ideally:

* Variable: `VAR`
* Pipe Method: `REPLACE`
* Arg 1: `X M`
* Arg 2: `Y`

## LICENSE

This project is released under the MIT [license](https://github.com/gnikyt/be/blob/master/LICENSE).
