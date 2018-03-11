## Vendored code in mydots

Vendored projects are each given their own directory here. In that directory go:
- `get.sh` saves the latest version of a project to the supplied path
- The `latest` subdirectory (which is the usual path arguent to `get.sh`)
- The `reviewed` subdirectory (which is referenced in dotfiles)

[check_latest.sh](check_latest.sh) iterates over project directories, and for each project:
- Uses `get.sh` to replace `latest` with the latest
- Diffs against `reviewed` and outputs any diff
- If there's a diff, prompts for one of 3 responses:
  + `y` Vendor latest by moving it to `reviewed`
  + `n` Don't vendor at this time, continue to next project
  + `q` Don't vendor at this time, quit reviewing
