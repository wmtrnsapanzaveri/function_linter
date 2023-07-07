Add `lint` as dependency to your pubspec.yaml

```yaml
dev_dependencies:
  function_linter: ^1.0.1
```

Add a `analysis_options.yaml` to the root of you project.

```yaml

# Not happy with the default? Customize the rules depending on your needs. 
# Here are some examples:
analyzer:
  plugins:
    - custom_lint
```

Hit save and see the `dartanalyzer` executing the lint checks in you favorite editor.